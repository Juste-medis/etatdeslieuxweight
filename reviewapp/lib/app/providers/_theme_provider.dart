// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/_user_model.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/widgets/toasts/mytoast.dart';
import 'package:jatai_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:go_router/go_router.dart';

class AppThemeProvider extends ChangeNotifier {
  // --- État thématique ---
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkTheme => _themeMode == ThemeMode.dark;
  User currentUser = User();

  void toggleTheme(bool value) {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    appStore.setDarkMode(value);
    notifyListeners();
  }

  // --- Gestion authentification ---
  String? get token {
    final userId = getStringAsync("IID");
    final token = getStringAsync(TOKEN);
    return userId.isNotEmpty && token.isNotEmpty ? token : null;
  }

  Future<void> isAuthenticated() async {
    await Future.delayed(const Duration(seconds: 2));
    if (token == null) {
      Jks.context!.go("/authentication/signin");
      return;
    }

    try {
      final res = await getUser(userId: getStringAsync("IID"));
      if (res.firstName != null) {
        currentUser = res;
        Jks.currentUser = res;
        await saveUserData(res);
        Jks.context!.go("/dashboard");
      }
    } catch (e) {
      if (token != null) {
        currentUser = User(
            firstName: appStore.userFirstName,
            lastName: appStore.userLastName,
            email: appStore.userEmail,
            iid: appStore.iid,
            lastOnline: DateTime(DateTime.now().millisecondsSinceEpoch),
            imageUrl: appStore.imageUrl,
            phoneNumber: appStore.phoneNumber,
            gender: appStore.gender,
            meta: appStore.meta,
            about: appStore.about,
            level: appStore.level,
            favorites: appStore.favorites,
            images: appStore.images,
            placeOfBirth: appStore.placeOfBirth);
      }
      print('Erreur lors de la récupération des l\'utilisateur: $e');
    }
  }

  Future<void> updateUserProfile() async {
    setloading(true);
    var payload = {
      ...User(
              firstName: formValues['user_firstName'] ?? currentUser.firstName,
              lastName: formValues['user_lastName'] ?? currentUser.lastName,
              email: formValues['user_email'] ?? currentUser.email,
              phoneNumber: formValues['user_phone'] ?? currentUser.phoneNumber,
              address: formValues['user_address'] ?? currentUser.address,
              dob: formValues['user_birthDate'] ?? currentUser.dob,
              imageUrl: formValues['user_imageUrl'] ?? currentUser.imageUrl,
              placeOfBirth:
                  formValues['user_placeOfBirth'] ?? currentUser.placeOfBirth)
          .toJson(),
      "password": formValues['user_currentPassword'] ?? "",
      "user_newPassword": formValues['user_newPassword'] ?? "",
      "user_confirmPassword": formValues['user_confirmPassword'] ?? ""
    };

    if (payload['password'] != null && payload['password'] != "") {
      if (payload['user_newPassword'] == null ||
          payload['user_newPassword'] == "" ||
          payload['user_confirmPassword'] == null ||
          payload['user_confirmPassword'] == "") {
        show_common_toast(
            "Veuillez saisir les nouveaux mot de passe actuel", Jks.context!);
        setloading(false);
        return;
      }
      if (payload['user_newPassword'] != payload['user_confirmPassword']) {
        show_common_toast(
            "Les mots de passe ne correspondent pas", Jks.context!);
        setloading(false);
        return;
      }

      if (payload['user_newPassword']!.length < 6) {
        show_common_toast("Le mot de passe doit contenir au moins 6 caractères",
            Jks.context!);
        setloading(false);
        return;
      }
    }

    await edituser({
      ...payload,
    }).then((res) async {
      if (res.status == true) {
        currentUser = res.data!;
        Jks.currentUser = currentUser;
        await saveUserData(currentUser);
        formValues.clear();
        notifyListeners();
        AwfulToast.show(
          context: Jks.context!,
          message: "Profil mis à jour avec succès",
          toastType: ToastType.success,
          duration: const Duration(seconds: 2),
        );
      }
    }).catchError((e) {
      my_inspect(e);
      // toast(e.toString());
    });
    setloading(false);
  }

  // --- Gestion du formulaire wizard ---
  final Map<String, dynamic> formValues = {};

  List<InventoryAuthor> inventoryProprietaires = [];
  List<InventoryAuthor> inventoryLocatairesEntrants = [];
  List<InventoryAuthor> inventoryLocatairesSortant = [];
  InventoryAuthor? mandataire;
  List<InventoryPiece> inventoryofPieces = [];
  Domaine domaine = Domaine(
      pieces: [],
      proprietaires: [],
      locataires: [],
      compteurs: [],
      clesDePorte: []);
  List<Review> reviews = [];
  bool isMandated = false;
  bool loading = false;
  bool edited = false;
  String? reviewType;
  WizardStep currentStep = WizardStep.reviewInfos;
  Map<WizardStep, GlobalKey<FormState>> formKeys = {};
  final Map<WizardStep, bool> _stepValidity = {
    for (var step in WizardStep.values) step: false
  };
  bool get canGoNext => _stepValidity[currentStep] ?? false;
  void initialiseReview(String type) {
    // final _lang = l.S.of(Jks.context!);

    for (var step in WizardStep.values) {
      formKeys[step] = GlobalKey<FormState>();
    }
    reviewType = type;
    inventoryProprietaires.clear();
    inventoryLocatairesSortant.clear();
    inventoryLocatairesEntrants.clear();
    mandataire = InventoryAuthor();
    inventoryofPieces.clear();
    inventoryProprietaires.add(InventoryAuthor(
      order: 1,
      id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
    ));
    inventoryLocatairesSortant.add(InventoryAuthor(
      order: 1,
      id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
    ));
    inventoryLocatairesEntrants.add(InventoryAuthor(
      order: 1,
      id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
    ));

    inventoryofPieces.addAll(defaultroooms.entries.map((entry) => InventoryPiece(
        name: entry.value["name"],
        count: 1,
        area: 1,
        comment: "",
        things: List.from(basethings),
        id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
        type: entry.key,
        photos: defaultphotos["piece"],
        order: inventoryofPieces.length + 1,
        meta: {'icon': entry.value['icon']})));

    isMandated = false;
    formValues.clear();

    formValues["property_address"] = "";
    formValues["property_furnitured"] = false;
    formValues["security_smoke"] = "no";

    _stepValidity.updateAll((_, __) => false);

    domaine = Domaine(
      name: "",
      type: type,
      proprietaires: [],
      pieces: [],
      locataires: [],
      things: List.from(basethings),
      clesDePorte: [...defaulcles.entries]
          .map((e) => CleDePorte(
                name: e.value,
                type: e.key,
                order: defaulcles.keys.toList().indexOf(e.key) + 1,
              ))
          .toList(),
      compteurs: defaulcompteurs.entries
          .map((e) => Compteur(
                name: e.value["name"],
                type: e.key,
                count: 1,
                order: defaulcompteurs.keys.toList().indexOf(e.key) + 1,
              ))
          .toList(),
    );
    currentStep = WizardStep.reviewInfos;
    notifyListeners();
  }

  void initialiseProcuration(String type) {
    initialiseReview(type);
    // inventoryLocatairesEntrants.clear();

    // inventoryLocatairesEntrants.add(InventoryLocataire(
    //     order: 1, id: DateTime.now().millisecondsSinceEpoch));
    notifyListeners();
  }

  void updateFormValue(String key, dynamic value) {
    if (Jks.canEditReview != "canEditReview") {
      show_common_toast(
          "Vous ne pouvez pas modifier cette information", Jks.context!);
      return;
    }
    edited = true;

    if (key.startsWith("exittenant")) {
      final regex = RegExp(r'exittenant(\d+)');
      final match = regex.firstMatch(key);

      if (match != null) {
        final number = int.parse(match.group(1)!);
        if (number <= inventoryLocatairesSortant.length) {
          final parts = key.split(match.group(1)!);
          if (parts.length > 1) {
            final fieldKey = parts[1];
            if (fieldKey == '_firstname') {
              inventoryLocatairesSortant[number] =
                  inventoryLocatairesSortant[number].copyWith(firstname: value);
            } else if (fieldKey == '_lastname') {
              inventoryLocatairesSortant[number] =
                  inventoryLocatairesSortant[number].copyWith(lastName: value);
            } else if (fieldKey == '_dob') {
              inventoryLocatairesSortant[number] =
                  inventoryLocatairesSortant[number].copyWith(dob: value);
            } else if (fieldKey == '_placeofbirth') {
              inventoryLocatairesSortant[number] =
                  inventoryLocatairesSortant[number]
                      .copyWith(placeOfBirth: value);
            } else if (fieldKey == '_address') {
              inventoryLocatairesSortant[number] =
                  inventoryLocatairesSortant[number].copyWith(address: value);
            } else if (fieldKey == '_email') {
              inventoryLocatairesSortant[number] =
                  inventoryLocatairesSortant[number].copyWith(email: value);
            }
          }
        }
      }
    }
    if (key.startsWith("entranttenant")) {
      final regex = RegExp(r'tenant(\d+)');
      final match = regex.firstMatch(key);
      if (match != null) {
        final number = int.parse(match.group(1)!);
        if (number <= inventoryLocatairesEntrants.length) {
          final parts = key.split(match.group(1)!);
          if (parts.length > 1) {
            final fieldKey = parts[1];
            if (fieldKey == '_firstname') {
              inventoryLocatairesEntrants[number] =
                  inventoryLocatairesEntrants[number]
                      .copyWith(firstname: value);
            } else if (fieldKey == '_lastname') {
              inventoryLocatairesEntrants[number] =
                  inventoryLocatairesEntrants[number].copyWith(lastName: value);
            } else if (fieldKey == '_dob') {
              inventoryLocatairesEntrants[number] =
                  inventoryLocatairesEntrants[number].copyWith(dob: value);
            } else if (fieldKey == '_placeofbirth') {
              inventoryLocatairesEntrants[number] =
                  inventoryLocatairesEntrants[number]
                      .copyWith(placeOfBirth: value);
            } else if (fieldKey == '_address') {
              inventoryLocatairesEntrants[number] =
                  inventoryLocatairesEntrants[number].copyWith(address: value);
            } else if (fieldKey == '_email') {
              inventoryLocatairesEntrants[number] =
                  inventoryLocatairesEntrants[number].copyWith(email: value);
            }
          }
        }
      }
    }

    formValues[key] = value;
    _autoValidateStep();
    notifyListeners();
  }

  void updateInventory(
      {List<InventoryAuthor>? proprietaires,
      List<InventoryAuthor>? locataires,
      List<InventoryAuthor>? locatairesentry,
      List<InventoryPiece>? iop,
      InventoryAuthor? mandattairel,
      Domaine? domaine,
      bool? mandated,
      WizardStep? step,
      bool liveupdate = true}) {
    if (Jks.canEditReview != "canEditReview") {
      show_common_toast(
          "Vous ne pouvez pas modifier cette information", Jks.context!);
      return;
    }
    edited = true;
    if (proprietaires != null) inventoryProprietaires = proprietaires;
    if (locataires != null) inventoryLocatairesSortant = locataires;
    if (locatairesentry != null) inventoryLocatairesEntrants = locatairesentry;
    if (mandated != null) {
      if (mandated && mandattairel == null) {
        mandattairel = InventoryAuthor();
      }
      isMandated = mandated;
    }
    if (iop != null) inventoryofPieces = iop;
    if (step != null) currentStep = step;
    if (mandattairel != null) {
      mandataire = mandattairel;
    }
    if (domaine != null) {
      this.domaine = domaine;
    }
    if (liveupdate) {
      _autoValidateStep();
      notifyListeners();
    }
  }

  void prefillReview(
    Review review,
  ) {
    edited = false;

    inventoryofPieces.clear();
    inventoryProprietaires.clear();
    inventoryLocatairesSortant.clear();
    inventoryLocatairesEntrants.clear();
    mandataire = null;
    reviewType = review.reviewType;
    for (var step in WizardStep.values) {
      formKeys[step] = GlobalKey<FormState>();
    }
    domaine = Domaine(
        pieces: [],
        proprietaires: [],
        locataires: [],
        compteurs: review.compteurs
                ?.map((piece) => Compteur.fromJson(piece.toJson()))
                .toList() ??
            [],
        clesDePorte: review.cledeportes
                ?.map((piece) => CleDePorte.fromJson(piece.toJson()))
                .toList() ??
            []);

    formValues["property_address"] = review.propertyDetails?.address ?? "";
    formValues["property_furnitured"] =
        review.propertyDetails?.furnitured ?? false;
    formValues["document_address"] = review.documentAddress ?? false;
    inventoryofPieces.addAll(
      review.pieces
              ?.map((piece) => InventoryPiece.fromJson(piece.toJson()))
              .toList() ??
          [],
    );

    inventoryProprietaires.addAll(
      review.owners
              ?.map((author) =>
                  InventoryAuthor.fromJson(author.toJson(), review: review))
              .toList() ??
          [],
    );

    inventoryLocatairesSortant.addAll(
      review.exitenants?.map((author) {
            return InventoryAuthor.fromJson(author.toJson(), review: review);
          }).toList() ??
          [],
    );
    inventoryLocatairesEntrants.addAll(
      review.entrantenants
              ?.map((author) =>
                  InventoryAuthor.fromJson(author.toJson(), review: review))
              .toList() ??
          [],
    );
    isMandated = review.mandataire != null;
    if (isMandated) {
      formValues["mandataire_type"] = review.mandataire?.type ?? "";
      formValues["mandataire_denomination"] =
          review.mandataire?.denomination ?? "";
      formValues["mandataire_lastname"] = review.mandataire?.lastName ?? "";
      formValues["mandataire_firstname"] = review.mandataire?.firstname ?? "";
      formValues["mandataire_phone"] = review.mandataire?.phone ?? "";
      formValues["mandataire_dob"] = review.mandataire?.dob ?? "";
      formValues["mandataire_placeofbirth"] =
          review.mandataire?.placeOfBirth ?? "";
      formValues["mandataire_address"] = review.mandataire?.address ?? "";
      formValues["mandataire_email"] = review.mandataire?.email ?? "";

      mandataire = InventoryAuthor(
        id: review.mandataire?.id ??
            "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
        type: review.mandataire?.type ?? "",
        denomination: review.mandataire?.denomination ?? "",
        lastName: review.mandataire?.lastName ?? "",
        firstname: review.mandataire?.firstname ?? "",
        phone: review.mandataire?.phone ?? "",
        dob: review.mandataire?.dob,
        placeOfBirth: review.mandataire?.placeOfBirth ?? "",
        address: review.mandataire?.address ?? "",
        email: review.mandataire?.email ?? "",
        representant: review.mandataire?.representant,
        photos: review.meta != null
            ? List<String>.from(
                (review.meta?[review.id ?? 'photos']?["photos"]) ?? [])
            : null,
      );
    }

    formValues["tenant_new_address"] = review.meta?['tenant_new_address'] ?? "";
    formValues["tenant_entry_date"] = review.meta?['tenant_entry_date'];
    formValues["comments"] = review.meta?['comments'] ?? "";

    formValues["security_smoke"] = review.meta?['security_smoke'] ?? "";
    formValues["security_smoke_functioning"] =
        review.meta?['security_smoke_functioning'] ?? "";

    notifyListeners();
  }

  void _autoValidateStep() {
    final formKey = formKeys[currentStep];
    if (formKey == null) return;

    _stepValidity[currentStep] = formKey.currentState?.validate() ?? false;
    if (_stepValidity[currentStep]!) {
      formKey.currentState?.save();
    }
  }

//=================================================================
  void setloading(bool l) {
    loading = l;
    notifyListeners();
  }
}

enum WizardStep {
  reviewInfos,
  tenants,
  theGood,
  complementary,
  inventoryOfRooms,

  inventoryOfKeysCounters,
  locataireSortantAddress,
  signatures,
  pdfOffSummary,
  confirmation,
}

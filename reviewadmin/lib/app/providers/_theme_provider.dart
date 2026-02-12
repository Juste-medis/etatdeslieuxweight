// 🐦 Flutter imports:
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/models/_user_model.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/widgets/toasts/mytoast.dart';
import 'package:jatai_etadmin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:go_router/go_router.dart';

class AppThemeProvider extends ChangeNotifier {
  // --- État thématique ---

  ThemeMode _themeMode =
      getBoolAsync(IS_DARK_MODE) ? ThemeMode.dark : ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkTheme => _themeMode == ThemeMode.dark;
  User currentUser = User();
  bool relaseMode = kReleaseMode;
  //=======================================
  InventoryPiece magicSelectedPiece = InventoryPiece(
    id: "",
    name: "",
    type: "",
    order: 0,
    things: [],
    photos: [],
  );
  //=======================================

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
        await saveUserData(res);
        Jks.context!.go("/dashboard");
      }
    } catch (e) {
      if (token != null) {
        await logout(Jks.context!).whenComplete(() {});

        myprint2('Erreur lors de la récupération des l\'utilisateur: $e');
      }
    }
    try {
      final setting = await getappsettings();
      if (setting.status == true) {
        Jks.appSettings = setting.data ?? {};
        await appStore.setSettings(setting.data);
      }
    } catch (e) {
      myprint2(
          'Erreur lors de la récupération des paramètres de l\'application: $e');
    }
  }

  void updateMagicSelectedPiece(InventoryPiece piece) {
    magicSelectedPiece = piece;
    notifyListeners();
  }

  void initMagicSelectedPiece() {
    magicSelectedPiece = InventoryPiece(
      id: "",
      name: "",
      type: "",
      order: 0,
      things: [],
      photos: [],
    );
  }

  Future<void> pickImage(
      {Review? review, required BuildContext context}) async {
    sourceSelect(
        context: context,
        callback: (croppedFile) async {
          await uploadFile(croppedFile, thing: review, cb: (photolist) {
            magicSelectedPiece.photos!.add(photolist);
            notifyListeners();
          });
        });
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
  void initialiseReview(datas) {
    // final _lang = l.S.of(Jks.context!);

    for (var step in WizardStep.values) {
      formKeys[step] = GlobalKey<FormState>();
    }
    reviewType = datas["type"] ?? "procuration";
    inventoryProprietaires.clear();
    inventoryLocatairesSortant.clear();
    inventoryLocatairesEntrants.clear();
    mandataire = InventoryAuthor();
    inventoryofPieces.clear();
    loading = false;
    if (datas["reviewId"] != null) {
      // If reviewId is provided, we should fetch the review data
      // and prefill the form with existing data.

      Review? review = [...Jks.reviewState.reviews].firstWhereOrNull(
        (r) => r.id == datas["reviewId"],
      );
      formValues["copyOptions"] = {
        "reviewId": review?.id ?? "",
        "copyOptions": datas["copyOptions"] ?? false
      };

      prefillReviewDuplicate(review!);
      return;
    } else {
      var owner = InventoryAuthor(
          order: 1,
          id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
          photos: []);
      if (reviewType == "procuration") {
        owner.type = "physique";
        owner.denomination = "";
        owner.lastName = currentUser.lastName;
        owner.firstname = currentUser.firstName;
        owner.phone = currentUser.phoneNumber;
        owner.dob = currentUser.dob;
        owner.placeOfBirth = currentUser.placeOfBirth;
        owner.address = currentUser.address;
        owner.email = currentUser.email;
      }

      inventoryProprietaires.add(owner);

      // Add another fake owner if not in release mode
      if (!relaseMode) {
        inventoryProprietaires.add(InventoryAuthor(
          order: 2,
          id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
          type: "physique",
          denomination: "",
          lastName: "FakeOwner2",
          firstname: "SecondOwner",
          phone: "0987654321",
          dob: DateTime(1980, 5, 15),
          placeOfBirth: "Paris",
          address: "456 Fake Street",
          email: "mucoper@gmail.com",
          photos: [],
        ));
      }

      var tempid =
          "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}";

      inventoryLocatairesSortant.add(InventoryAuthor(
        order: 1,
        id: tempid,
        firstname: relaseMode ? "" : "sortpren1",
        lastName: relaseMode ? "" : "sortnom1",
        phone: relaseMode ? "" : "0123456789",
        email: relaseMode ? "" : "mangelleadido@gmail.com",
        placeOfBirth: relaseMode ? "" : "1 rue du sortant",
        dob: relaseMode ? null : DateTime(2000, 1, 1),
        address: relaseMode ? "" : "address 1 rue du sortant",
      ));
      inventoryLocatairesEntrants.add(InventoryAuthor(
        order: 1,
        id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
        firstname: relaseMode ? "" : "entpren1",
        lastName: relaseMode ? "" : "entnom1",
        phone: relaseMode ? "" : "0123456789",
        email: relaseMode ? "" : "mangilleadido@gmail.com",
        placeOfBirth: relaseMode ? "" : "1 rue du entrant",
        dob: relaseMode ? null : DateTime(1990, 1, 1),
        address: relaseMode ? "" : "address 1 rue du entrant",
      ));

      isMandated = false;
      formValues.clear();

      _stepValidity.updateAll((_, __) => false);

      formValues["security_smoke"] = "no";

      if (!relaseMode) {
        formValues["document_address"] = "13 rue du Mars 2000";
        formValues["doccument_city"] = "Rio de Janeiro";
        formValues["tenant_new_address"] = "14 rue du Mars 2000";
        formValues["tenant_entry_date"] = "2023-10-01";
        formValues["review_estimed_date"] = DateTime(2026, 1, 1);
        formValues["accesgivenTo"] = tempid;
      }

      domaine = Domaine(
        name: "",
        type: datas["type"] ?? "procuration",
        proprietaires: [],
        pieces: [],
        locataires: [],
        things: List.from(basethings),
        clesDePorte: [],
        compteurs: [],
        address: relaseMode ? "" : "1 rue de la propriété",
        complement: relaseMode ? "" : "complement de l'adresse",
        floor: relaseMode ? "" : "1er étage",
        surface: relaseMode ? "0" : "100",
        roomCount: relaseMode ? 0 : 3,
        box: relaseMode ? "" : "box 1",
        cellar: relaseMode ? "" : "cave 1",
        garage: relaseMode ? "" : "garage 1",
        parking: relaseMode ? "" : "parking 1",
        heatingType: relaseMode ? "" : "gas",
        heatingMode: relaseMode ? "" : "individual",
        hotWaterType: relaseMode ? "" : "oil",
        hotWaterMode: relaseMode ? "" : "not_applicable",
      );
    }

    currentStep = WizardStep.reviewInfos;

    notifyListeners();
  }

  void initialiseProcuration(String type) {
    initialiseReview({
      "type": type,
    });
    notifyListeners();
  }

  void updateFormValue(String key, dynamic value) {
    if (!mrv()) {
      show_common_toast(
          "Vous ne pouvez pas modifier cette information", Jks.context!);
      return;
    }
    edited = true;

    formValues[key] = value;
    _autoValidateStep();
    notifyListeners();
    Jks.savereviewStep();
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
      bool liveupdate = true,
      bool force = false}) {
    if (!force && !mrv()) {
      show_common_toast(
          "Vous ne pouvez plus modifier cette information", Jks.context!);
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
    if (mandattairel != null) {
      mandataire = mandattairel;
    }
    if (iop != null) {
      inventoryofPieces = iop;
    }
    if (step != null) currentStep = step;

    if (domaine != null) {
      this.domaine = domaine;
    }
    if (liveupdate) {
      _autoValidateStep();
      notifyListeners();
      Jks.savereviewStep();
    }
  }

  void prefillReviewDuplicate(
    Review review,
  ) {
    edited = false;

    inventoryofPieces.clear();
    inventoryProprietaires.clear();
    inventoryLocatairesSortant.clear();
    inventoryLocatairesEntrants.clear();
    mandataire = null;
    for (var step in WizardStep.values) {
      formKeys[step] = GlobalKey<FormState>();
    }

    inventoryProprietaires.addAll(
      review.owners
              ?.map((author) => InventoryAuthor.fromJson(author.toJson(),
                  review: review, source: "prorio"))
              .toList() ??
          [],
    );

    if (formValues["copyOptions"]?["copyOptions"]?.contains("tenants") ??
        false) {
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
    }
    domaine = Domaine(
      pieces: [],
      proprietaires: inventoryProprietaires,
      locataires: inventoryLocatairesSortant,
      compteurs: review.compteurs
              ?.map((piece) => Compteur.fromJson(piece.toJson()))
              .toList() ??
          [],
      clesDePorte: review.cledeportes
              ?.map((piece) => CleDePorte.fromJson(piece.toJson()))
              .toList() ??
          [],
    );
    domaine.setPropertyDetails(review);
    formValues["document_address"] = review.documentAddress ?? false;
    inventoryofPieces.addAll(
      review.pieces
              ?.map((piece) => InventoryPiece.fromJson(piece.toJson()))
              .toList() ??
          [],
    );

    isMandated = review.mandataire != null;
    if (isMandated) {
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

  void prefillReview(Review review, {bool? quietly = false}) {
    edited = false;

    inventoryofPieces.clear();
    inventoryProprietaires.clear();
    inventoryLocatairesSortant.clear();
    inventoryLocatairesEntrants.clear();
    mandataire = null;
    reviewType = review.reviewType;
    if (quietly != true) {
      for (var step in WizardStep.values) {
        formKeys[step] = GlobalKey<FormState>();
      }
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
          [],
    );
    domaine.setPropertyDetails(review);

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

      mandataire = InventoryAuthor.fromJson(
        review.mandataire?.toJson() ?? {},
        review: review,
      );
    }

    formValues["tenant_new_address"] = review.meta?['tenant_new_address'] ?? "";
    formValues["tenant_entry_date"] = review.meta?['tenant_entry_date'];
    formValues["comments"] = review.meta?['comments'] ?? "";

    formValues["security_smoke"] = review.meta?['security_smoke'] ?? "";
    formValues["security_smoke_functioning"] =
        review.meta?['security_smoke_functioning'] ?? "";

    if (quietly != true) {
      notifyListeners();
    }
  }

  void prefillProccuration(
    Procuration proccuration, {
    bool quietly = false,
  }) {
    edited = false;

    inventoryofPieces.clear();
    inventoryProprietaires.clear();
    inventoryLocatairesSortant.clear();
    inventoryLocatairesEntrants.clear();
    mandataire = null;
    reviewType = "procuration";
    if (!quietly) {
      for (var step in WizardStep.values) {
        formKeys[step] = GlobalKey<FormState>();
      }
    }

    domaine = Domaine(
      pieces: [],
      proprietaires: [],
      locataires: [],
    );
    domaine.setPropertyDetails(
        Review().copyWith(propertyDetails: proccuration.propertyDetails));

    formValues["document_address"] = proccuration.documentAddress ?? false;

    inventoryProprietaires.addAll(
      proccuration.owners
              ?.map((author) => InventoryAuthor.fromJson(author.toJson(),
                  procuration: proccuration))
              .toList() ??
          [],
    );

    inventoryLocatairesSortant.addAll(
      proccuration.exitenants?.map((author) {
            return InventoryAuthor.fromJson(author.toJson(),
                procuration: proccuration);
          }).toList() ??
          [],
    );
    inventoryLocatairesEntrants.addAll(
      proccuration.entrantenants
              ?.map((author) => InventoryAuthor.fromJson(author.toJson(),
                  procuration: proccuration))
              .toList() ??
          [],
    );

    isMandated = true;
    if (isMandated) {
      mandataire = InventoryAuthor.fromJson(
        proccuration.accesgivenTo != null &&
                proccuration.accesgivenTo!.isNotEmpty
            ? proccuration.accesgivenTo![0].toJson()
            : {},
        procuration: proccuration,
      );
    }

    formValues["tenant_new_address"] =
        proccuration.meta?['tenant_new_address'] ?? "";
    formValues["tenant_entry_date"] = proccuration.meta?['tenant_entry_date'];
    formValues["doccument_city"] = proccuration.documentAddress;
    formValues["comments"] = proccuration.meta?['comments'] ?? "";
    formValues["review_estimed_date"] = proccuration.estimatedDateOfReview;

    formValues["accesgivenTo"] = proccuration.accesgivenTo != null &&
            proccuration.accesgivenTo!.isNotEmpty
        ? proccuration.accesgivenTo![0].id
        : "";

    formValues["security_smoke"] = proccuration.meta?['security_smoke'] ?? "";
    formValues["security_smoke_functioning"] =
        proccuration.meta?['security_smoke_functioning'] ?? "";

    if (!quietly) {
      notifyListeners();
    }
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

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etadmin/app/providers/_theme_provider.dart';

class ProccurationProvider extends ChangeNotifier {
  //=================================================================
  void setloading(bool l) {
    _isLoading = l;
    notifyListeners();
  }

//Review editing modifiers
  void seteditingAuthor(InventoryAuthor l) {
    editingAuthor = l;
    notifyListeners();
  }

  void seteditingProcuration(Procuration? l,
      {bool quiet = false, String? source}) {
    editingProccuration = l;

    if (!quiet) {
      notifyListeners();
    }
  }

  List<Procuration> _proccurations = [];
  InventoryAuthor editingAuthor = InventoryAuthor(
    id: "new",
    email: '',
    address: '',
  );
  Procuration? editingProccuration;
  //=================================================================
  String accessCode = "";

  int currentPage = 1;
  int totalPages = 1;
  bool _isLoading = false;
  Map data = {};
  Map? filtering;

  List<Procuration> get proccurations => _proccurations;
  bool get isLoading => _isLoading;
  MagicStep currentStep = MagicStep.presentation;

  Future<void> fetchProccurations(
      {bool refresh = false, String type = "", int page = 1}) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    if (refresh) {
      currentPage = 1;
      filtering = null;
      notifyListeners();
    } else {
      currentPage = page;
    }
    filtering = {"status": type.isNotEmpty ? type : "all", ...?filtering};

    try {
      final response = await getproccurations(
          page: currentPage, limit: "10", filter: filtering);
      _proccurations.clear();
      if (response.status == true) {
        _proccurations.addAll(response.list);
        currentPage = response.currentPage;
        totalPages = response.totalPages;
      }
    } catch (err) {
      debugPrint('Error fetching reviews: $err');
      my_inspect(err);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> addProccurationToProccurations(Procuration rere) async {
    _proccurations.add(rere);
    notifyListeners();
  }

  Future<Procuration> updateTheproccuration(
    Procuration proccuration,
    String section, {
    InventoryAuthor? updateAuthor,
    canModifyMandataire = false,
    required AppThemeProvider wizardState, // Add this parameter
  }) async {
    if (!mrv()) {
      show_common_toast(
          "Vous ne pouvez pas modifier cette information", Jks.context!);
      return proccuration;
    }
    var formData = wizardState.formValues;
    _isLoading = true;

    notifyListeners();

    // Create your final payload
    Map<String, dynamic> payload = {
      "proccurationId": proccuration.id ?? "",
      "isMandated": wizardState.isMandated,
      "section": section,
    };
    if (section == "the_good" || section == "complementary") {
      payload["propertyDetails"] = wizardState.domaine.propertyDetails();
    }
    if (section == "commentsection") {
      payload = {
        ...payload,
        'complementaryDetails': {
          'comments': formData['comments'],
          'security_smoke': formData['security_smoke'],
          'security_smoke_functioning': formData['security_smoke_functioning'],
          'doccument_city': formData['doccument_city'],
          'tenant_new_address': formData['tenant_new_address'],
          'tenant_entry_date': formData['tenant_entry_date'] != null
              ? "${formData['tenant_entry_date']}"
              : null,
        }
      };
    }
    if (section == "sendToAutors") {
      payload = {
        ...payload,
        "date": DateTime.now().toString(),
      };
    }
    if (section == "accesssection") {
      payload = {
        ...payload,
        'documentDetails': {
          'doccument_city': formData['doccument_city'],
          "accesgivenTo": formData['accesgivenTo'],
          'review_estimed_date': formData['review_estimed_date'] != null
              ? "${formData['review_estimed_date']}"
              : null,
        }
      };
    }
    if (updateAuthor != null) {
      payload["author"] = updateAuthor.toJson();
    }
    var propro = Procuration();

    try {
      var raw = await updateprocurarion("${proccuration.id}", payload);
      if (raw.status == true) {
        // fetchProccurations(refresh: true);
        propro = Procuration.fromJson(raw.data);
        int index = _proccurations
            .indexWhere((element) => element.id == proccuration.id);

        if (index != -1) {
          _proccurations[index] = propro;
          seteditingProcuration(propro);
          wizardState.prefillProccuration(propro, quietly: true);

          if (Jks.quietsavereview == false) {
            Jks.context!.popRoute();
            Jks.quietsavereview = null;
          }
        }
      }
    } catch (e) {
      my_inspect(e);
    }
    _isLoading = false;
    notifyListeners();
    return propro.id != null ? propro : proccuration;
  }

  Future<bool> deleteTheproccuration(Procuration proccuration) async {
    _isLoading = true;
    Map<String, dynamic> payload = {
      "proccurationId": proccuration.id ?? "",
    };
    var propro = Procuration();

    try {
      var raw = await removeProcuration("${proccuration.id}", payload);
      if (raw.status == true) {
        if (_proccurations.isNotEmpty) {
          int index = _proccurations
              .indexWhere((element) => element.id == proccuration.id);

          if (index != -1) {
            _proccurations.removeAt(index);
          }
        }

        seteditingProcuration(null);
        _isLoading = false;
      }
    } catch (e) {
      my_inspect(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<void> previewTheProcuration(Procuration proc) async {
    _isLoading = true;

    notifyListeners();
    var payload = {
      "proccurationId": proc.id ?? "",
      "section": "preview",
    };
    await proviwage(proc.id, payload).then((res) async {
      if (res.status == true) {
        var myposition = "owner";
        var mainurl =
            "${myposition == "owner" ? ownerpositions[0] : myposition}_pdfPath";

        var secondurl =
            "${myposition == "owner" ? ownerpositions[1] : myposition}_pdfPath";

        data[mainurl] = res.data[mainurl];
        data[secondurl] = res.data[secondurl];
      }
    }).catchError((e) {
      my_inspect(e);
      // toast(e.toString());
    });
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setFilter(Map? query) async {
    if (query == null) {
      filtering = null;
    } else {
      filtering = {...(filtering ?? {}), ...(query)};
    }
    currentPage = 1;
    await fetchProccurations();
  }
}

enum MagicStep { presentation, magicer, result }

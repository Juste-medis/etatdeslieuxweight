// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etadmin/app/providers/_theme_provider.dart';

class ReviewProvider extends ChangeNotifier {
  //=================================================================
  void setloading(bool l) {
    _isLoading = l;
    notifyListeners();
  }

//Review editing modifiers
  void seteditingAuthor(InventoryAuthor l, {bool liveupdate = true}) {
    editingAuthor = l;
    if (liveupdate) {
      notifyListeners();
    }
  }

  void seteditingReview(Review? l, {bool quiet = false, source = ""}) {
    editingReview = l;
    if (!quiet) {
      notifyListeners();
    }
  }

  List<Review> _reviews = [];
  InventoryAuthor editingAuthor = InventoryAuthor(
    id: "new",
    email: '',
    address: '',
  );
  Review? editingReview;
  //=================================================================
  String accessCode = "";

  int currentPage = 1;
  int totalPages = 1;
  bool _isLoading = false;
  Map data = {};
  Map? filtering;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  MagicStep currentStep = MagicStep.presentation;

  Future<void> fetchReviews(
      {bool refresh = false, String type = "", int page = 1}) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    notifyListeners();
    if (refresh) {
      currentPage = 1;
      filtering = null;
    } else {
      currentPage = page;
    }

    filtering = {"status": type.isNotEmpty ? type : "all", ...?filtering};

    try {
      final response =
          await getreviews(page: currentPage, limit: "10", filter: filtering);
      _reviews.clear();

      if (response.status == true) {
        _reviews.addAll(response.list);
        currentPage = response.currentPage;
        totalPages = response.totalPages;
      }
    } catch (err) {
      debugPrint('Error fetching reviews: $err');
      my_inspect(err);
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> addReviewToReviews(Review rere) async {
    _reviews.add(rere);
    notifyListeners();
  }

  Future<Review> updateThereview(
    Review review,
    String section, {
    InventoryAuthor? updateAuthor,
    canModifyMandataire = false,
    required AppThemeProvider wizardState, // Add this parameter
  }) async {
    if (!mrv()) {
      show_common_toast(
          "Vous ne pouvez pas modifier cette information", Jks.context!);
      return review;
    }
    var formData = wizardState.formValues;
    _isLoading = true;

    notifyListeners();

    // Create your final payload
    Map<String, dynamic> payload = {
      "reviewId": review.id ?? "",
      "isMandated": wizardState.isMandated,
      "section": section,
    };
    if (section == "the_good" || section == "complementary") {
      payload["propertyDetails"] = wizardState.domaine.propertyDetails();
      payload['complementaryDetails'] = {
        'tenant_new_address': formData['tenant_new_address'],
        'tenant_entry_date': formData['tenant_entry_date'] != null
            ? "${formData['tenant_entry_date']}"
            : null,
        'document_address': formData['document_address'],
      };
    }
    if (section == "pieces") {
      payload["inventoryPieces"] =
          wizardState.inventoryofPieces.map((piece) => piece.toJson()).toList();
    }

    if (section == "compteurs") {
      payload = {
        ...payload,
        'compteurs': wizardState.domaine.compteurs
            .map((piece) => piece.toJson())
            .toList(),
      };
    }
    if (section == "commentsection") {
      payload = {
        ...payload,
        'complementaryDetails': {
          'comments': formData['comments'],
          'security_smoke': formData['security_smoke'],
          'security_smoke_functioning': formData['security_smoke_functioning'],
          'tenant_new_address': formData['tenant_new_address'],
          'tenant_entry_date': formData['tenant_entry_date'] != null
              ? "${formData['tenant_entry_date']}"
              : null,
        }
      };
    }
    if (section == "cledeportes") {
      payload = {
        ...payload,
        'cledeportes': wizardState.domaine.clesDePorte
            .map((piece) => piece.toJson())
            .toList(),
      };
    }
    payload["canModifyMandataire"] = canModifyMandataire;

    if (updateAuthor != null) {
      payload["author"] = updateAuthor.toJson();
      if (wizardState.isMandated == true && canModifyMandataire == true) {
        payload["mandataire"] = {
          "_id": wizardState.mandataire?.id,
          ...(wizardState.mandataire?.toJson() ?? {}),
        };
        if (wizardState.mandataire?.type == "morale") {
          payload["mandataire"]["representant"] = {
            ...?wizardState.mandataire?.representant?.toJson(),
            "_id": wizardState.mandataire?.representant?.id
          };
        }
      }
    }
    var rere = Review();

    try {
      var raw = await updatereview(review.id, payload);
      if (raw.status == true) {
        // fetchReviews(refresh: true);
        rere = Review.fromJson(raw.data);
        int index = _reviews.indexWhere((element) => element.id == review.id);

        if (index != -1) {
          _reviews[index] = rere;
          seteditingReview(rere, quiet: true);
          wizardState.prefillReview(rere, quietly: true);

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
    // notifyListeners();
    return rere.id != null ? rere : review;
  }

  Future<bool> deleteTheReview(Review proccuration) async {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> payload = {
      "proccurationId": proccuration.id ?? "",
    };
    try {
      var raw = await removeReview("${proccuration.id}", payload);
      if (raw.status == true) {
        if (reviews.isNotEmpty) {
          int index =
              reviews.indexWhere((element) => element.id == proccuration.id);

          if (index != -1) {
            reviews.removeAt(index);
          }
        }

        seteditingReview(null);
        _isLoading = false;
      }
    } catch (e) {
      my_inspect(e);
      return false;
    }
    _isLoading = false;

    notifyListeners();
    return true;
  }

  Future<Map> previewThereview(Review review) async {
    _isLoading = true;
    Map resultData = {};

    notifyListeners();
    var payload = {
      "reviewId": review.id ?? "",
      "section": "preview",
    };
    await previwage(review.id, payload).then((res) async {
      if (res.status == true) {
        if (res.data != null) {
          data["${getReviewExplicitName(review.reviewType!)}_pdfPath"] =
              res.data["${getReviewExplicitName(review.reviewType!)}_pdfPath"];
          data[
              "${getReviewExplicitName(review.reviewType!, reverse: true)}_pdfPath"] = res
                  .data[
              "${getReviewExplicitName(review.reviewType!, reverse: true)}_pdfPath"];

          resultData = data;
        }
      }
      return resultData;
    }).catchError((e) {
      my_inspect(e);
      return {};
      // toast(e.toString());
    });
    _isLoading = false;
    notifyListeners();
    return resultData;
  }

  void updateInventory({MagicStep? step, bool liveupdate = true}) {
    if (step != null) currentStep = step;
    if (liveupdate) {
      notifyListeners();
    }
  }

  Future<void> setFilter(Map? query) async {
    if (query == null) {
      filtering = null;
    } else {
      filtering = {...(filtering ?? {}), ...(query)};
    }
    currentPage = 1;
    await fetchReviews();
  }
}

enum MagicStep { presentation, magicer, analyzing, result }

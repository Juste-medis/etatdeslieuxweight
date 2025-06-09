// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etatsdeslieux/app/providers/_theme_provider.dart';

class ReviewProvider extends ChangeNotifier {
  //=================================================================
  void setloading(bool l) {
    _isLoading = l;
    notifyListeners();
  }

//Review editing modifiers
  void seteditingAuthor(InventoryAuthor l) {
    if (Jks.canEditReview != "canEditReview") {
      show_common_toast(
          "Vous ne pouvez pas modifier cette information", Jks.context!);
      return;
    }
    editingAuthor = l;
    notifyListeners();
  }

  void seteditingReview(Review? l, {bool quiet = false}) {
    editingReview = l;
    if (!quiet) {
      notifyListeners();
    }
  }

  List<Review> _reviews = [];
  InventoryAuthor editingAuthor = InventoryAuthor(
    id: "0",
    email: '',
    address: '',
  );
  Review? editingReview;
  //=================================================================
  String accessCode = "";

  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  Map data = {};
  Map? filtering;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchReviews({bool refresh = false}) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    if (refresh) {
      _currentPage = 1;
      _reviews = [];
      notifyListeners();
    }

    try {
      final response =
          await getreviews(page: _currentPage, limit: "10", filter: filtering);

      if (response.status == true) {
        _reviews.addAll(response.list);
        _currentPage = response.currentPage;
        _totalPages = response.totalPages;
        notifyListeners();

        _hasMore = _currentPage < _totalPages;
      }
    } catch (err) {
      debugPrint('Error fetching reviews: $err');
      my_inspect(err);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReviewToReviews(Review rere) async {
    if (Jks.canEditReview != "canEditReview") {
      show_common_toast(
          "Vous ne pouvez pas modifier cette information", Jks.context!);
      return;
    }
    _reviews.add(rere);
    notifyListeners();
  }

  Future<Review> updateThereview(
    Review review,
    String section, {
    InventoryAuthor? updateAuthor,
    required AppThemeProvider wizardState, // Add this parameter
  }) async {
    if (Jks.canEditReview != "canEditReview") {
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
    if (section == "the_good") {
      payload["propertyDetails"] = {
        "_id": review.propertyDetails?.id,
        'address': formData['property_address'],
        'complement': formData['property_complement'],
        'floor': formData['property_floor'],
        'surface': formData['property_surface'],
        'roomCount': formData['property_roomCount'],
        'furnitured': formData['property_furnitured'],
        'box': formData['property_box'],
        'cellar': formData['property_cellar'],
        'garage': formData['property_garage'],
        'parking': formData['property_parking'],
      };
    }
    if (section == "complementary") {
      payload["complementaryDetails"] = {
        'heatingType': formData['complementary_heatingType'],
        'heatingMode': formData['complementary_heatingMode'],
        'hotWaterType': formData['complementary_hotWaterType'],
        'hotWaterMode': formData['complementary_hotWaterMode'],
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

    if (updateAuthor != null) {
      payload["author"] = updateAuthor.toJson();
      if (wizardState.isMandated) {
        payload["mandataire"] = {
          "_id": review.mandataire?.id,
          ...(wizardState.mandataire?.toJson() ?? {}),
        };
        if (formData["mandataire_type"] == "morale") {
          payload["mandataire"]["representant"] = {
            ...payload["mandataire"],
            "_id": review.mandataire?.representant?.id,
          };
        }
      }
    }
    var rere = Review();

    try {
      var raw = await updatereview(review.id, payload);
      if (raw.status == true) {
        fetchReviews();
        rere = Review.fromJson(raw.data);
        int index = _reviews.indexWhere((element) => element.id == review.id);

        if (index != -1) {
          _reviews[index] = rere;
          seteditingReview(rere);
          wizardState.prefillReview(rere);

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
    return rere;
  }

  Future<void> previewThereview(Review review) async {
    _isLoading = true;

    notifyListeners();
    var payload = {
      "reviewId": review.id ?? "",
      "section": "preview",
    };
    await previwage(review.id, payload).then((res) async {
      if (res.status == true) {
        data["${getReviewExplicitName(review.reviewType!)}_pdfPath"] =
            res.data["${getReviewExplicitName(review.reviewType!)}_pdfPath"];
        data[
            "${getReviewExplicitName(review.reviewType!, reverse: true)}_review"] = res
                .data[
            "${getReviewExplicitName(review.reviewType!, reverse: true)}_pdfPath"];
      }
    }).catchError((e) {
      my_inspect(e);
      // toast(e.toString());
    });
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_hasMore && !_isLoading) {
      _currentPage++;
      await fetchReviews();
    }
  }

  Future<void> setFilter(Map? query) async {
    filtering = {...(filtering ?? {}), ...(query ?? {})};
    await fetchReviews(refresh: true);
  }
}

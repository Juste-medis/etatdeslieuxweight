// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/htmlcontent.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/services/offlineStorage.dart';
import 'package:mon_etatsdeslieux/app/core/services/pdfgenerator.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:mon_etatsdeslieux/app/providers/_theme_provider.dart';

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

  final List<Review> _reviews = [];
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

  Future<void> fetchReviews({
    bool refresh = false,
    String type = "",
    int page = 1,
  }) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    notifyListeners();
    if (refresh) {
      currentPage = 1;
      filtering = null;
    } else {
      currentPage = page;
    }

    if (type.isNotEmpty) {
      filtering = {"status": type};
    }

    try {
      final response = await getreviews(
        page: currentPage,
        limit: "10",
        filter: filtering,
      );
      _reviews.clear();

      if (response.status == true) {
        _reviews.addAll(response.list);
        currentPage = response.currentPage;
        totalPages = response.totalPages;
      }
      if (refresh) {
        OfflineStorageService.saveOfflineReviews(_reviews);
      }
    } catch (err) {
      if (err.toString() == "no_internet") {
        final offlineReviews = await OfflineStorageService.getOfflineReviews();
        //sort by date descending
        offlineReviews.sort(
          (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
            a.createdAt ?? DateTime.now(),
          ),
        );
        _reviews.clear();
        _reviews.addAll(offlineReviews.map((e) => e).toList());
        // show_common_toast("", Jks.context!);
        notifyListeners();
        return;
      }
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
    required AppThemeProvider wizardState,
    bool force = false, // Add this parameter
  }) async {
    // if (Jks.isSyncingOfflineDatas == true) {
    //   show_common_toast(
    //       "Veuillez patienter pendant la synchronisation des données hors ligne",
    //       Jks.context!);
    //   return review;
    // }

    if (!mrv() && !force) {
      show_common_toast(
        "Vous ne pouvez pas modifier cette information",
        Jks.context!,
      );
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
        'tenant_entry_date': formData['tenant_entry_date'] != null
            ? "${formData['tenant_entry_date']}"
            : null,
        'document_address': formData['document_address'],
      };
    }
    if (section == "pieces") {
      payload["inventoryPieces"] = wizardState.inventoryofPieces
          .map((piece) => piece.toJson())
          .toList();
    }

    if (section == "compteurs") {
      payload = {
        ...payload,
        'compteurs': wizardState.domaine.compteurs
            .map((piece) => piece.toJson())
            .toList(),
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
    if (section == "commentsection") {
      payload = {
        ...payload,
        'complementaryDetails': {
          'comments': formData['comments'],
          'security_smoke': formData['security_smoke'],
          'security_smoke_functioning': formData['security_smoke_functioning'],
          'tenant_entry_date': formData['tenant_entry_date'] != null
              ? "${formData['tenant_entry_date']}"
              : null,
          for (final l in wizardState.inventoryLocatairesSortant)
            "new_address_${l.email}": l.meta?["new_address"],
        },
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
            "_id": wizardState.mandataire?.representant?.id,
          };
        }
      }
    }
    var rere = Review();

    try {
      rere = await OfflineStorageService.saveOfflineReview(
        editingReview!,
        wizardState,
      );
      var raw = await updatereview(review.id, payload);
      if (raw.status == true) {
        rere = Review.fromJson(raw.data);
      }
    } catch (e) {
      if (e.toString() == "no_internet") {
        if (review.id != null && review.id!.contains("review_")) {
        } else {
          OfflineStorageService.journalize(review.id!, payload).then((value) {
            // show_common_toast(
            //     "Modifications enregistrées en mode hors ligne", Jks.context!);
          });
        }
      } else {
        my_inspect(e);
        show_common_toast(e.toString(), Jks.context!);
      }
    }

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
    _isLoading = false;
    // notifyListeners();
    return rere.id != null ? rere : review;
  }

  Future<bool> deleteTheReview(Review thereview) async {
    if (thereview.procuration != null) {
      Jks.languageState.showAppNotification(
        message:
            "Impossible de supprimer un état des lieux lié à une procuration en cours.",
        title: "Erreur",
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> payload = {"proccurationId": thereview.id ?? ""};
    try {
      var raw = await removeReview("${thereview.id}", payload);
      if (raw.status == true) {
        if (reviews.isNotEmpty) {
          int index = reviews.indexWhere(
            (element) => element.id == thereview.id,
          );

          if (index != -1) {
            reviews.removeAt(index);
          }
        }
        OfflineStorageService.deleteOfflineReview(thereview.id!);

        seteditingReview(null);
        _isLoading = false;
      }
    } catch (e) {
      if (e.toString() == "no_internet") {
        if (thereview.id != null && thereview.id!.contains("review_")) {
          OfflineStorageService.deleteOfflineReview(thereview.id!);
          if (reviews.isNotEmpty) {
            int index = reviews.indexWhere(
              (element) => element.id == thereview.id,
            );

            if (index != -1) {
              reviews.removeAt(index);
            }
          }
          seteditingReview(null);
        } else {
          Jks.languageState.showAppNotification(
            message:
                "Aucune connexion Internet. Impossible de supprimer l'état des lieux hors ligne.",
            title: "Erreur",
          );
        }
        simulateRightCenterTap(Jks.context!);
      }
      _isLoading = false;
      notifyListeners();
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
    var payload = {"reviewId": review.id ?? "", "section": "preview"};
    await previwage(review.id, payload)
        .then((res) async {
          if (res.status == true) {
            if (res.data != null) {
              data["${getReviewExplicitName(review.reviewType!)}_pdfPath"] = res
                  .data["${getReviewExplicitName(review.reviewType!)}_pdfPath"];
              data["${getReviewExplicitName(review.reviewType!, reverse: true)}_pdfPath"] =
                  res.data["${getReviewExplicitName(review.reviewType!, reverse: true)}_pdfPath"];

              resultData = data;
            }
          }
          _isLoading = false;
          notifyListeners();
          return resultData;
        })
        .catchError((e) async {
          if (e.toString() == "no_internet") {
            PdfGenerator.generateAndSavePdf(review).then((gdata) {
              data["${getReviewExplicitName(review.reviewType!)}_pdfPath"] =
                  gdata["${getReviewExplicitName(review.reviewType!)}_pdfPath"];
              data["${getReviewExplicitName(review.reviewType!, reverse: true)}_pdfPath"] =
                  gdata["${getReviewExplicitName(review.reviewType!, reverse: true)}_pdfPath"];

              resultData = data;

              _isLoading = false;
              notifyListeners();
              return resultData;
            });
          } else {
            my_inspect(e);
            return {};
          }

          // toast(e.toString());
        });
    return resultData;
  }

  void updateInventory({MagicStep? step, bool liveupdate = true}) {
    if (step != null) currentStep = step;
    if (liveupdate) {
      notifyListeners();
    }
  }

  Future<void> setFilter(Map? query) async {
    filtering = {...(filtering ?? {}), ...(query ?? {})};
    await fetchReviews(refresh: true);
  }
}

enum MagicStep { presentation, magicer, analyzing, result }

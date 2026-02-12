import 'package:flutter/foundation.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';
import 'package:mon_etatsdeslieux/app/models/models.dart';
import 'package:mon_etatsdeslieux/main.dart';

class Procuration {
  String? id;
  dynamic author; // Peut être String ou InventoryAuthor
  List<InventoryAuthor>? owners;
  List<InventoryAuthor>? accesgivenTo; // Mandataires
  List<InventoryAuthor>? exitenants;
  List<InventoryAuthor>? entrantenants;
  Domaine? propertyDetails;
  DateTime? dateOfProcuration;
  DateTime? estimatedDateOfReview;
  String? documentAddress;
  String? reviewType;
  String? status;
  String? entranDocumentId;
  String? sortantDocumentId;
  Map<String, dynamic>? meta;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Review>? reviews;
  String? source;
  bool credited = false;
  bool completedreview = false;

  Procuration({
    this.id,
    this.author,
    this.owners,
    this.accesgivenTo,
    this.exitenants,
    this.entrantenants,
    this.propertyDetails,
    this.dateOfProcuration,
    this.estimatedDateOfReview,
    this.documentAddress,
    this.reviewType,
    this.entranDocumentId,
    this.status,
    this.sortantDocumentId,
    this.meta,
    this.createdAt,
    this.updatedAt,
    this.reviews,
    this.source = 'normal',
    this.credited = false,
    this.completedreview = false,
  });

  @override
  String toString() {
    return '''Procuration: {
      id: $id,
      author: ${author?.toString()},
      owners: ${owners?.map((e) => e.toString()).toList()},
      accesgivenTo: ${accesgivenTo?.map((e) => e.toString()).toList()},
      exitenants: ${exitenants?.map((e) => e.toString()).toList()},
      entrantenants: ${entrantenants?.map((e) => e.toString()).toList()},
      propertyDetails: ${propertyDetails?.toString()},
      dateOfProcuration: ${dateOfProcuration?.toIso8601String()},
      estimatedDateOfReview: ${estimatedDateOfReview?.toIso8601String()},
      documentAddress: $documentAddress,
      reviewType: $reviewType,
      entranDocumentId: $entranDocumentId,
      sortantDocumentId: $sortantDocumentId,
      status: $status,
      reviews: ${reviews?.map((e) => e.toString()).toList()},
      credited: $credited,
      completedreview: $completedreview,
      meta: $meta,
      createdAt: ${createdAt?.toIso8601String()},
      updatedAt: ${updatedAt?.toIso8601String()}
    }''';
  }

  bool isTheAutor() {
    if (author == null) return false;
    if (author is String) {
      return author == appStore.iid;
    } else if (author is InventoryAuthor) {
      return (author as InventoryAuthor).id == appStore.iid;
    } else if (author is User) {
      return (author as User).iid == appStore.iid;
    }

    return false;
  }

  InventoryAuthor me() {
    var me = [...owners!, ...exitenants!, ...entrantenants!].firstWhere((
      signatory,
    ) {
      return signatory.email == Jks.currentUser?.email;
    });
    return me;
  }

  String? myposition({bool reverse = false}) {
    // Check in owners list
    if (owners != null) {
      for (var owner in owners!) {
        if (owner.email == Jks.currentUser?.email) {
          return 'owner';
        }
      }
    }

    // Check in exitenants list
    if (exitenants != null) {
      for (var exitenant in exitenants!) {
        if (exitenant.email == Jks.currentUser?.email) {
          return reverse ? 'entrant' : 'sortant';
        }
      }
    }
    // Check in entrantenants list
    if (entrantenants != null) {
      for (var entrantenant in entrantenants!) {
        if (entrantenant.email == Jks.currentUser?.email) {
          return reverse ? 'sortant' : 'entrant';
        }
      }
    }

    // If not found in any list
    return "";
  }

  bool haveSigned({InventoryAuthor? author}) {
    bool result = false;

    if (meta?["signatures"] != null &&
        meta!["signatures"].isNotEmpty &&
        meta!["signatures"].containsKey((author ?? me()).id)) {
      result = true;
    }
    return result;
  }

  void setCredited(String value) {
    credited = value == "true" || value == "done";
  }

  void setSource(String value) {
    source = value;
  }

  bool anySigned() {
    bool result = false;

    if (meta?["signatures"] != null && meta!["signatures"].isNotEmpty) {
      result = true;
    }
    return result;
  }

  factory Procuration.fromJson(Map<String, dynamic> json, {init = false}) {
    final procReviews = json['reviews'] != null
        ? (json['reviews'] as List).map((e) => Review.fromJson(e)).toList()
        : null;
    final anyReviewCompleted = procReviews != null
        ? procReviews.any((review) => review.status == 'completed')
        : false;

    return Procuration(
      id: json['_id']?.toString(),
      author: json['author'] != null
          ? json['author'] is String
                ? json['author']
                : User.fromJson(json['author'])
          : null,
      exitenants: json['exitenants'] != null
          ? (json['exitenants'] as List)
                .map(
                  (e) => e is String
                      ? InventoryAuthor(id: e)
                      : InventoryAuthor.fromJson(e),
                )
                .toList()
          : null,
      entrantenants: json['entrantenants'] != null
          ? (json['entrantenants'] as List)
                .map(
                  (e) => e is String
                      ? InventoryAuthor(id: e)
                      : InventoryAuthor.fromJson(e),
                )
                .toList()
          : null,
      owners: json['owners'] != null
          ? (json['owners'] as List)
                .map(
                  (e) => e is String
                      ? InventoryAuthor(id: e)
                      : InventoryAuthor.fromJson(
                          e,
                          procuration: init
                              ? Procuration(id: json['_id']?.toString())
                              : null,
                        ),
                )
                .toList()
          : null,
      accesgivenTo: json['accesgivenTo'] != null
          ? (json['accesgivenTo'] as List)
                .map(
                  (e) => e is String
                      ? InventoryAuthor(id: e)
                      : InventoryAuthor.fromJson(e),
                )
                .toList()
          : null,
      propertyDetails: json['propertyDetails'] != null
          ? json['propertyDetails'] is String
                ? Domaine(
                    id: json['propertyDetails'],
                    pieces: [],
                    proprietaires: [],
                    locataires: [],
                  )
                : json['propertyDetails'] is String
                ? Domaine(
                    id: json['propertyDetails'].toString(),
                    pieces: [],
                    proprietaires: [],
                    locataires: [],
                  )
                : Domaine.fromJson(json['propertyDetails'])
          : null,
      dateOfProcuration: json['dateOfProcuration'] != null
          ? DateTime.parse(json['dateOfProcuration'])
          : null,
      estimatedDateOfReview: json['estimatedDateOfReview'] != null
          ? DateTime.parse(json['estimatedDateOfReview'])
          : null,
      status: json['status']?.toString(),
      documentAddress: json['document_address']?.toString(),
      reviewType: json['review_type']?.toString(),
      entranDocumentId: json['entranDocumentId']?.toString(),
      sortantDocumentId: json['sortantDocumentId']?.toString(),
      meta: json['meta'] as Map<String, dynamic>?,
      reviews: procReviews,
      credited: json['credited'] ?? false,
      completedreview: anyReviewCompleted,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
  factory Procuration.fromReview(Review review, {init = false}) {
    return Procuration(
      id: review.id,
      owners: review.owners,
      exitenants: review.exitenants,
      entrantenants: review.entrantenants,
      propertyDetails: review.propertyDetails,
      dateOfProcuration: review.createdAt,
      estimatedDateOfReview: review.updatedAt,
      documentAddress: review.documentAddress,
      reviewType: review.reviewType,
      entranDocumentId: review.entranDocumentId,
      sortantDocumentId: review.sortantDocumentId,
      meta: review.meta,
      credited: review.credited,
      status: review.status,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['_id'] = id;
    if (author != null) {
      data['author'] = author is String ? author : (author as User).toJson();
    }
    if (owners != null) {
      data['owners'] = owners!.map((e) => e.toJson()).toList();
    }
    if (accesgivenTo != null) {
      data['accesgivenTo'] = accesgivenTo!.map((e) => e.toJson()).toList();
    }
    if (exitenants != null) {
      data['exitenants'] = exitenants!.map((e) => e.toJson()).toList();
    }
    if (entrantenants != null) {
      data['entrantenants'] = entrantenants!.map((e) => e.toJson()).toList();
    }
    if (propertyDetails != null) {
      data['propertyDetails'] = propertyDetails!.toJson();
    }
    if (dateOfProcuration != null) {
      data['dateOfProcuration'] = dateOfProcuration!.toIso8601String();
    }
    if (estimatedDateOfReview != null) {
      data['estimatedDateOfReview'] = estimatedDateOfReview!.toIso8601String();
    }
    if (documentAddress != null) data['document_address'] = documentAddress;
    if (reviewType != null) data['review_type'] = reviewType;
    if (entranDocumentId != null) data['entranDocumentId'] = entranDocumentId;
    if (sortantDocumentId != null) {
      data['sortantDocumentId'] = sortantDocumentId;
    }
    if (meta != null) data['meta'] = meta;
    if (status != null) data['status'] = status;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    if (reviews != null) {
      data['reviews'] = reviews!.map((e) => e.toJson()).toList();
    }

    data['credited'] = credited;
    return data;
  }

  Procuration copyWith({
    String? id,
    dynamic author,
    List<InventoryAuthor>? owners,
    List<InventoryAuthor>? accesgivenTo,
    List<InventoryAuthor>? exitenants,
    List<InventoryAuthor>? entrantenants,
    Domaine? propertyDetails,
    DateTime? dateOfProcuration,
    DateTime? estimatedDateOfReview,
    String? documentAddress,
    String? reviewType,
    String? entranDocumentId,
    String? sortantDocumentId,
    Map<String, dynamic>? meta,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Review>? reviews,
    String? status,
    String? source,
    bool? credited,
  }) {
    return Procuration(
      id: id ?? this.id,
      author: author ?? this.author,
      owners: owners ?? this.owners,
      accesgivenTo: accesgivenTo ?? this.accesgivenTo,
      exitenants: exitenants ?? this.exitenants,
      entrantenants: entrantenants ?? this.entrantenants,
      propertyDetails: propertyDetails ?? this.propertyDetails,
      dateOfProcuration: dateOfProcuration ?? this.dateOfProcuration,
      estimatedDateOfReview:
          estimatedDateOfReview ?? this.estimatedDateOfReview,
      documentAddress: documentAddress ?? this.documentAddress,
      reviewType: reviewType ?? this.reviewType,
      entranDocumentId: entranDocumentId ?? this.entranDocumentId,
      sortantDocumentId: sortantDocumentId ?? this.sortantDocumentId,
      meta: meta ?? this.meta,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reviews: reviews ?? this.reviews,
      status: status ?? this.status,
      source: source ?? this.source,
      credited: credited ?? this.credited,
    );
  }
}

class Review {
  String? id;
  dynamic author;
  List<InventoryAuthor>? owners;
  List<InventoryAuthor>? exitenants;
  List<InventoryAuthor>? entrantenants;
  List<InventoryPiece>? pieces;
  List<CleDePorte>? cledeportes;
  List<Compteur>? compteurs;
  List<String>? photos;
  Domaine? propertyDetails;
  String? documentAddress;
  String? reviewType;
  String? entranDocumentId;
  String? sortantDocumentId;
  Procuration? procuration;
  String? status;
  Map<String, dynamic>? meta;
  DateTime? createdAt;
  DateTime? updatedAt;
  InventoryAuthor? mandataire;
  bool credited = false;
  String? source;
  String? localId;

  Review({
    this.id,
    this.author,
    this.owners,
    this.exitenants,
    this.entrantenants,
    this.pieces,
    this.cledeportes,
    this.compteurs,
    this.photos,
    this.propertyDetails,
    this.documentAddress,
    this.reviewType,
    this.entranDocumentId,
    this.sortantDocumentId,
    this.procuration,
    this.status,
    this.meta,
    this.createdAt,
    this.updatedAt,
    this.source = 'normal',
    this.mandataire,
    this.credited = false,
    this.localId,
  });

  @override
  String toString() {
    return '''Review: {
      id: $id,
      localId: $localId,
      author: ${author?.toString()},
      owners: ${owners?.map((e) => e.toString()).toList()},
      exitenants: ${exitenants?.map((e) => e.toString()).toList()},
      entrantenants: ${entrantenants?.map((e) => e.toString()).toList()},
      pieces: ${pieces?.map((e) => e.toString()).toList()},
      cledeportes: ${cledeportes?.map((e) => e.toString()).toList()},
      compteurs: ${compteurs?.map((e) => e.toString()).toList()},
      photos: $photos,
      propertyDetails: ${propertyDetails?.toString()},
      documentAddress: $documentAddress,
      reviewType: $reviewType,
      entranDocumentId: $entranDocumentId,
      status: $status,
      sortantDocumentId: $sortantDocumentId,
      proccurarion: $procuration,
      meta: $meta,
      mandataire: ${mandataire?.toString()},
      createdAt: ${createdAt?.toIso8601String()},
      credited: $credited,
      updatedAt: ${updatedAt?.toIso8601String()}
    }''';
  }

  bool isThegrantedAcces() {
    if (procuration == null) return false;
    var firstAccess = procuration?.accesgivenTo?.firstOrNull;

    return (firstAccess != null &&
        firstAccess.email != null &&
        firstAccess.email == appStore.userEmail);
  }

  InventoryAuthor me() {
    var me = [...owners!, ...exitenants!, ...entrantenants!].firstWhere((
      signatory,
    ) {
      return signatory.email == Jks.currentUser?.email;
    });
    return me;
  }

  bool isTheAutor() {
    if (author == null) return false;
    if (author is String) {
      return author == appStore.iid;
    } else if (author is InventoryAuthor) {
      return (author as InventoryAuthor).id == appStore.iid;
    }
    return false;
  }

  bool canModify() {
    return isTheAutor() || isThegrantedAcces();
  }

  void setCredited(String value) {
    credited = value == "true" || value == "done";
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? copyOptions;

    if (json['copyOptions'] != null &&
        json['copyOptions'] != false &&
        "${json['_id']}".contains('review')) {
      copyOptions = json['copyOptions'] as Map<String, dynamic>;
    }
    Review result = Review(
      id: json['_id']?.toString(),
      localId: json['localId']?.toString(),
      author: json['author'] != null
          ? json['author'] is String
                ? json['author']
                : InventoryAuthor.fromJson(json['author'])
          : null,
      owners: json['owners'] != null
          ? (json['owners'] as List)
                .map(
                  (e) => e is String
                      ? InventoryAuthor(id: e)
                      : e is InventoryAuthor
                      ? e
                      : InventoryAuthor.fromJson(e),
                )
                .toList()
          : null,
      exitenants: json['exitenants'] != null
          ? (json['exitenants'] as List)
                .map(
                  (e) => e is String
                      ? InventoryAuthor(id: e)
                      : e is InventoryAuthor
                      ? e
                      : InventoryAuthor.fromJson(e),
                )
                .toList()
          : null,
      entrantenants: json['entrantenants'] != null
          ? (json['entrantenants'] as List)
                .map(
                  (e) => e is String
                      ? InventoryAuthor(id: e)
                      : e is InventoryAuthor
                      ? e
                      : InventoryAuthor.fromJson(e),
                )
                .toList()
          : null,
      pieces: json['pieces'] != null
          ? (json['pieces'] as List)
                .map(
                  (e) => InventoryPiece.fromJson(e, copyOptions: copyOptions),
                )
                .toList()
          : null,
      cledeportes: json['cledeportes'] != null
          ? (json['cledeportes'] as List)
                .map((e) => CleDePorte.fromJson(e))
                .toList()
          : null,
      compteurs: json['compteurs'] != null
          ? (json['compteurs'] as List)
                .map((e) => Compteur.fromJson(e))
                .toList()
          : null,
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      propertyDetails: json['propertyDetails'] != null
          ? json['propertyDetails'] is String
                ? Domaine(
                    id: json['propertyDetails'],
                    pieces: [],
                    proprietaires: [],
                    locataires: [],
                  )
                : json['propertyDetails'] is Map<String, dynamic>
                ? Domaine.fromJson(json['propertyDetails'])
                : Domaine(
                    id: json['propertyDetails'].toString(),
                    pieces: [],
                    proprietaires: [],
                    locataires: [],
                  )
          : null,
      documentAddress: json['document_address']?.toString(),
      reviewType: json['review_type']?.toString(),
      entranDocumentId: json['entranDocumentId']?.toString(),
      sortantDocumentId: json['sortantDocumentId']?.toString(),
      credited: json['credited'] ?? false,
      procuration: json['procuration'] != null
          ? json['procuration'] is Map<String, dynamic>
                ? Procuration.fromJson(json['procuration'])
                : json['procuration'] is String
                ? Procuration(id: json['procuration'])
                : null
          : null,
      status: json['status']?.toString() ?? 'draft',
      meta: json['meta'] as Map<String, dynamic>?,
      mandataire: json['mandataire'] != null
          ? json['mandataire'] is String
                ? InventoryAuthor(id: json['mandataire'])
                : json['mandataire'] is InventoryAuthor
                ? json['mandataire']
                : InventoryAuthor.fromJson(json['mandataire'])
          : null,
      source: json['source']?.toString() ?? 'normal',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );

    return result;
  }
  factory Review.fromPayload(Map<String, dynamic> payload) {
    // const { owners, exitenants, propertyDetails, copyOptions, complementaryDetails, documentDetails: { review_type }, mandataire, isMandated } = req.body;
    //in dart :
    var owners = payload['owners'] != null
        ? (payload['owners'] as List)
              .map(
                (e) => e is String
                    ? InventoryAuthor(id: e)
                    : InventoryAuthor.fromJson(e),
              )
              .toList()
        : [];
    var exitenants = payload['exitenants'] != null
        ? (payload['exitenants'] as List)
              .map(
                (e) => e is String
                    ? InventoryAuthor(id: e)
                    : InventoryAuthor.fromJson(e),
              )
              .toList()
        : [];
    var propertyDetails = payload['propertyDetails'] != null
        ? payload['propertyDetails'] is String
              ? Domaine(
                  id: payload['propertyDetails'],
                  pieces: [],
                  proprietaires: [],
                  locataires: [],
                )
              : payload['propertyDetails'] is Map<String, dynamic>
              ? Domaine.fromJson(payload['propertyDetails'])
              : Domaine(
                  id: payload['propertyDetails'].toString(),
                  pieces: [],
                  proprietaires: [],
                  locataires: [],
                )
        : {};
    var reviewType = payload['documentDetails'] != null
        ? payload['documentDetails']['review_type']?.toString()
        : null;
    var complementaryDetails = payload['complementaryDetails'] != null
        ? payload['complementaryDetails'] as Map<String, dynamic>
        : null;
    var documentDetails = payload['documentDetails'] != null
        ? payload['documentDetails'] as Map<String, dynamic>
        : null;
    var mandataire = payload['mandataire'] != null
        ? payload['mandataire'] is String
              ? InventoryAuthor(id: payload['mandataire'])
              : InventoryAuthor.fromJson(payload['mandataire'])
        : null;
    var isMandated = payload['isMandated'] ?? false;
    try {
      checkUniqueKey(
        [...exitenants, ...owners],
        ["representantemail", "email"],
        "Les emails des auteurs doivent être uniques",
      );
    } catch (err) {
      myprint("Error in Review.fromPayload: $err");
    }
    if (isMandated && mandataire == null) {
      throw Exception("Le mandataire est requis");
    } else if (isMandated && mandataire != null) {
      validateAutor(mandataire);
    }

    return Review(
      author: payload['author'] != null
          ? payload['author'] is String
                ? payload['author']
                : InventoryAuthor.fromJson(payload['author'])
          : null,
      owners: owners as List<InventoryAuthor>,
      exitenants: exitenants as List<InventoryAuthor>,
      propertyDetails: propertyDetails as Domaine,
      documentAddress: documentDetails != null
          ? documentDetails['document_address']?.toString()
          : null,
      reviewType: reviewType,
      entranDocumentId: documentDetails != null
          ? documentDetails['entranDocumentId']?.toString()
          : null,
      sortantDocumentId: documentDetails != null
          ? documentDetails['sortantDocumentId']?.toString()
          : null,
      mandataire: mandataire,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      meta: {
        "signatures": {},
        "fillingPercentage": 42.85, // + newReviewData.incPerc,
        ...?complementaryDetails,
      },
      status: "draft",
    );
  }

  factory Review.fromProccuration(Procuration proc, {init = false}) {
    return Review(
      author: proc.author,
      id: proc.id,
      owners: proc.owners,
      exitenants: proc.exitenants,
      entrantenants: proc.entrantenants,
      propertyDetails: proc.propertyDetails,
      documentAddress: proc.documentAddress,
      reviewType: proc.reviewType,
      entranDocumentId: proc.entranDocumentId,
      sortantDocumentId: proc.sortantDocumentId,
      meta: proc.meta,
      credited: proc.credited,
      status: proc.status,
      source: proc.source,
      procuration: proc,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['_id'] = id;
    if (author != null) data['author'] = author!.toJson();
    if (owners != null) {
      data['owners'] = owners!.map((e) => e.toJson()).toList();
    }

    if (exitenants != null) {
      data['exitenants'] = exitenants!.map((e) => e.toJson()).toList();
    }
    if (entrantenants != null) {
      data['entrantenants'] = entrantenants!.map((e) => e.toJson()).toList();
    }
    if (pieces != null) {
      data['pieces'] = pieces!.map((e) => e.toJson()).toList();
    }
    if (cledeportes != null) {
      data['cledeportes'] = cledeportes!.map((e) => e.toJson()).toList();
    }
    if (compteurs != null) {
      data['compteurs'] = compteurs!.map((e) => e.toJson()).toList();
    }
    if (photos != null) data['photos'] = photos;
    if (propertyDetails != null) {
      data['propertyDetails'] = propertyDetails!.toJson();
    }
    if (documentAddress != null) data['document_address'] = documentAddress;
    if (reviewType != null) data['review_type'] = reviewType;
    if (entranDocumentId != null) data['entranDocumentId'] = entranDocumentId;
    if (sortantDocumentId != null) {
      data['sortantDocumentId'] = sortantDocumentId;
    }
    if (meta != null) data['meta'] = meta;
    if (mandataire != null) data['mandataire'] = mandataire!.toJson();
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    if (status != null) data['status'] = status;

    if (source != null) data['source'] = source;

    data['credited'] = credited;

    if (procuration != null) {
      data['procuration'] = procuration!.toJson();
    }

    return data;
  }

  Review copyWith({
    String? id,
    InventoryAuthor? author,
    List<InventoryAuthor>? owners,
    List<InventoryAuthor>? exitenants,
    List<InventoryAuthor>? entrantenants,
    List<InventoryPiece>? pieces,
    List<CleDePorte>? cledeportes,
    List<Compteur>? compteurs,
    List<String>? photos,
    bool? credited,
    Domaine? propertyDetails,
    String? documentAddress,
    String? reviewType,
    String? entranDocumentId,
    String? sortantDocumentId,
    Procuration? proccurarion,
    Map<String, dynamic>? meta,
    DateTime? createdAt,
    DateTime? updatedAt,
    InventoryAuthor? mandataire,
    String? source,
    String? status,
  }) {
    return Review(
      id: id ?? this.id,
      author: author ?? this.author,
      owners: owners ?? this.owners,
      exitenants: exitenants ?? this.exitenants,
      entrantenants: entrantenants ?? this.entrantenants,
      pieces: pieces ?? this.pieces,
      cledeportes: cledeportes ?? this.cledeportes,
      compteurs: compteurs ?? this.compteurs,
      photos: photos ?? this.photos,
      propertyDetails: propertyDetails ?? this.propertyDetails,
      documentAddress: documentAddress ?? this.documentAddress,
      reviewType: reviewType ?? this.reviewType,
      entranDocumentId: entranDocumentId ?? this.entranDocumentId,
      sortantDocumentId: sortantDocumentId ?? this.sortantDocumentId,
      procuration: proccurarion ?? procuration,
      meta: meta ?? this.meta,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mandataire: mandataire ?? this.mandataire,
      credited: credited ?? this.credited,
      source: source ?? this.source,
      status: status ?? this.status,
    );
  }
}

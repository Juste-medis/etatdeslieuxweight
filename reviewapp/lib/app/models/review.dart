import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/models.dart';
import 'package:jatai_etatsdeslieux/main.dart';

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
  String? entranDocumentId;
  String? sortantDocumentId;
  Map<String, dynamic>? meta;
  DateTime? createdAt;
  DateTime? updatedAt;

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
    this.sortantDocumentId,
    this.meta,
    this.createdAt,
    this.updatedAt,
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
      meta: $meta,
      createdAt: ${createdAt?.toIso8601String()},
      updatedAt: ${updatedAt?.toIso8601String()}
    }''';
  }

  factory Procuration.fromJson(Map<String, dynamic> json) {
    return Procuration(
      id: json['_id']?.toString(),
      author: json['author'] != null
          ? json['author'] is String
              ? json['author']
              : User.fromJson(json['author'])
          : null,
      owners: json['owners'] != null
          ? (json['owners'] as List).map((e) => InventoryAuthor(id: e)).toList()
          : null,
      accesgivenTo: json['accesgivenTo'] != null
          ? (json['accesgivenTo'] as List)
              .map((e) => InventoryAuthor.fromJson(e))
              .toList()
          : null,
      exitenants: json['exitenants'] != null
          ? (json['exitenants'] as List)
              .map((e) => InventoryAuthor(id: e))
              .toList()
          : null,
      entrantenants: json['entrantenants'] != null
          ? (json['entrantenants'] as List)
              .map((e) => InventoryAuthor(id: e))
              .toList()
          : null,
      // propertyDetails: json['propertyDetails'] != null
      //     ? Domaine.fromJson(json['propertyDetails'])
      //     : null,
      dateOfProcuration: json['dateOfProcuration'] != null
          ? DateTime.parse(json['dateOfProcuration'])
          : null,
      estimatedDateOfReview: json['estimatedDateOfReview'] != null
          ? DateTime.parse(json['estimatedDateOfReview'])
          : null,
      documentAddress: json['document_address']?.toString(),
      reviewType: json['review_type']?.toString(),
      entranDocumentId: json['entranDocumentId']?.toString(),
      sortantDocumentId: json['sortantDocumentId']?.toString(),
      meta: json['meta'] as Map<String, dynamic>?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['_id'] = id;
    if (author != null) {
      data['author'] =
          author is String ? author : (author as InventoryAuthor).toJson();
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
    if (sortantDocumentId != null)
      data['sortantDocumentId'] = sortantDocumentId;
    if (meta != null) data['meta'] = meta;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

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
    this.mandataire,
  });

  @override
  String toString() {
    return '''Review: {
      id: $id,
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

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id']?.toString(),
      author: json['author'] != null
          ? json['author'] is String
              ? json['author']
              : InventoryAuthor.fromJson(json['author'])
          : null,
      owners: json['owners'] != null
          ? (json['owners'] as List)
              .map((e) => InventoryAuthor.fromJson(e))
              .toList()
          : null,
      exitenants: json['exitenants'] != null
          ? (json['exitenants'] as List)
              .map((e) => InventoryAuthor.fromJson(e))
              .toList()
          : null,
      entrantenants: json['entrantenants'] != null
          ? (json['entrantenants'] as List)
              .map((e) => InventoryAuthor.fromJson(e))
              .toList()
          : null,
      pieces: json['pieces'] != null
          ? (json['pieces'] as List)
              .map((e) => InventoryPiece.fromJson(e))
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
          ? Domaine.fromJson(json['propertyDetails'])
          : null,
      documentAddress: json['document_address']?.toString(),
      reviewType: json['review_type']?.toString(),
      entranDocumentId: json['entranDocumentId']?.toString(),
      sortantDocumentId: json['sortantDocumentId']?.toString(),
      procuration: json['procuration'] != null
          ? json['procuration'] is Map<String, dynamic>
              ? Procuration.fromJson(json['procuration'])
              : json['procuration'] is String
                  ? Procuration(id: json['procuration'])
                  : null
          : null,
      status: json['status']?.toString(),
      meta: json['meta'] as Map<String, dynamic>?,
      mandataire: json['mandataire'] != null
          ? InventoryAuthor.fromJson(json['mandataire'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
    if (sortantDocumentId != null)
      data['sortantDocumentId'] = sortantDocumentId;
    if (procuration != null) data['procuration'] = procuration;
    if (meta != null) data['meta'] = meta;
    if (mandataire != null) data['mandataire'] = mandataire!.toJson();
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

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
    );
  }
}

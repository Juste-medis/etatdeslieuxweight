import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';

class Domaine {
  String? id;
  String? name;
  String? type; // Type de domaine (résidentiel, commercial, etc.)
  String? address;
  String? city;
  String? postalCode;
  String? country;
  String? complement; // Added complement
  String? floor; // Added floor
  String? surface; // Added surface
  int? roomCount; // Nombre total de pièces
  bool? furnitured; // Added furnitured
  String? box; // Added box
  String? cellar; // Added cellar
  String? garage; // Added garage
  String? parking; // Added parking
  String? heatingType; // Added heatingType
  String? heatingMode; // Added heatingMode
  String? hotWaterType; // Added hotWaterType
  String? hotWaterMode; // Added hotWaterMode
  double? surfaceArea; // Surface totale en m²
  List<InventoryPiece> pieces; // Liste des pièces
  List<InventoryAuthor> proprietaires; // Liste des bailleurs
  List<InventoryAuthor> locataires;
  List<Compteur> compteurs;
  List<CleDePorte> clesDePorte;
  Map<String, dynamic>? meta;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<InventoryOfThing>? things;

  Domaine({
    this.id,
    this.name,
    this.type,
    this.address,
    this.city,
    this.postalCode,
    this.country,
    this.complement = '', // Added complement with default value
    this.floor = '', // Added floor with default value
    this.surface, // Added surface
    this.roomCount,
    this.furnitured = false, // Added furnitured with default value
    this.box = '', // Added box with default value
    this.cellar = '', // Added cellar with default value
    this.garage = '', // Added garage with default value
    this.parking = '', // Added parking with default value
    this.heatingType = 'gas', // Added heatingType with default value
    this.heatingMode = 'individual', // Added heatingMode with default value
    this.hotWaterType = 'electric', // Added hotWaterType with default value
    this.hotWaterMode = 'individual', // Added hotWaterMode with default value
    this.things,
    this.compteurs = const [],
    this.clesDePorte = const [],
    this.surfaceArea,
    required this.pieces,
    required this.proprietaires,
    required this.locataires,
    this.meta,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return '''Domaine: {
      id: $id,
      name: $name,
      type: $type,
      address: $address,
      city: $city,
      postalCode: $postalCode,
      country: $country,
      complement: $complement,
      floor: $floor,
      surface: $surface,
      roomCount: $roomCount,
      furnitured: $furnitured,
      box: $box,
      cellar: $cellar,
      garage: $garage,
      parking: $parking,
      heatingType: $heatingType,
      heatingMode: $heatingMode,
      hotWaterType: $hotWaterType,
      hotWaterMode: $hotWaterMode,
      surfaceArea: $surfaceArea,
      pieces: ${pieces.length} pièces,      
      things: ${things != null ? things.toString() : 'null'},
      proprietaires: ${proprietaires.length} bailleurs,
      locataires: ${locataires.length} locataires,
      meta: ${meta?.toString()},
      createdAt: ${createdAt?.toIso8601String()},
      updatedAt: ${updatedAt?.toIso8601String()}
    }''';
  }

  factory Domaine.fromJson(Map<String, dynamic> json) {
    return Domaine(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      postalCode: json['postalCode']?.toString(),
      country: json['country']?.toString(),
      complement: json['complement']?.toString() ?? '', // Added complement
      floor: json['floor']?.toString() ?? '', // Added floor
      surface: json['surface']?.toString(), // Added surface
      roomCount: json['roomCount'] as int?,
      furnitured: json['furnitured'] as bool? ?? false, // Added furnitured
      box: json['box']?.toString() ?? '', // Added box
      cellar: json['cellar']?.toString() ?? '', // Added cellar
      garage: json['garage']?.toString() ?? '', // Added garage
      parking: json['parking']?.toString() ?? '', // Added parking
      heatingType:
          json['heatingType']?.toString() ?? 'gas', // Added heatingType
      heatingMode:
          json['heatingMode']?.toString() ?? 'individual', // Added heatingMode
      hotWaterType:
          json['hotWaterType']?.toString() ?? 'electric', // Added hotWaterType
      hotWaterMode: json['hotWaterMode']?.toString() ??
          'individual', // Added hotWaterMode
      surfaceArea: json['surfaceArea']?.toDouble(),
      compteurs: (json['compteurs'] as List<dynamic>?)
              ?.map((e) => Compteur.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      clesDePorte: (json['clesDePorte'] as List<dynamic>?)
              ?.map((e) => CleDePorte.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      things: json['things'] != null
          ? (json['things'] as List)
              .map((item) => InventoryOfThing.fromJson(item))
              .toList()
          : null,
      pieces: (json['pieces'] as List<dynamic>?)
              ?.map((e) => InventoryPiece.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      proprietaires: (json['proprietaires'] as List<dynamic>?)
              ?.map((e) => InventoryAuthor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      locataires: (json['locataires'] as List<dynamic>?)
              ?.map((e) => InventoryAuthor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: json['meta'] as Map<String, dynamic>?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (id != null) data['_id'] = id;
    if (name != null) data['name'] = name;
    if (type != null) data['type'] = type;
    if (address != null) data['address'] = address;
    if (city != null) data['city'] = city;
    if (postalCode != null) data['postalCode'] = postalCode;
    if (country != null) data['country'] = country;
    if (complement != null) data['complement'] = complement; // Added complement
    if (floor != null) data['floor'] = floor; // Added floor
    if (surface != null) data['surface'] = surface; // Added surface
    if (roomCount != null) data['roomCount'] = roomCount;
    if (furnitured != null) data['furnitured'] = furnitured; // Added furnitured
    if (box != null) data['box'] = box; // Added box
    if (cellar != null) data['cellar'] = cellar; // Added cellar
    if (garage != null) data['garage'] = garage; // Added garage
    if (parking != null) data['parking'] = parking; // Added parking
    if (heatingType != null)
      data['heatingType'] = heatingType; // Added heatingType
    if (heatingMode != null)
      data['heatingMode'] = heatingMode; // Added heatingMode
    if (hotWaterType != null)
      data['hotWaterType'] = hotWaterType; // Added hotWaterType
    if (hotWaterMode != null)
      data['hotWaterMode'] = hotWaterMode; // Added hotWaterMode
    if (surfaceArea != null) data['surfaceArea'] = surfaceArea;
    data['pieces'] = pieces.map((piece) => piece.toJson()).toList();
    data['proprietaires'] = proprietaires.map((p) => p.toJson()).toList();
    data['locataires'] = locataires.map((l) => l.toJson()).toList();
    if (meta != null) data['meta'] = meta;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();
    if (things != null) {
      data['things'] = things!.map((item) => item.toJson()).toList();
    }
    if (compteurs.isNotEmpty) {
      data['compteurs'] = compteurs.map((c) => c.toJson()).toList();
    }
    if (clesDePorte.isNotEmpty) {
      data['clesDePorte'] = clesDePorte.map((c) => c.toJson()).toList();
    }
    return data;
  }

  // Méthode utilitaire pour calculer la surface totale
  double calculateTotalSurface() {
    return pieces.fold(0.0, (sum, piece) => sum + (piece.area ?? 0));
  }
}

class InventoryAuthor {
  String? id;
  int? order;
  String? firstname;
  String? lastName; // Added lastName
  String? denomination; // Added denomination
  String? email;
  String? phone; // Added phone
  InventoryAuthor? representant;
  String? address;
  String? type; // Added type
  DateTime? dob; // Added dob
  String? placeOfBirth; // Added placeOfBirth
  List<String>? photos; // Added photos
  Map? meta = {};

  DateTime? createdAt;
  DateTime? updatedAt;

  InventoryAuthor({
    this.id,
    this.order,
    this.email,
    this.phone, // Added phone
    this.firstname,
    this.representant,
    this.lastName, // Added lastName
    this.denomination, // Added denomination
    this.address,
    this.type, // Added type
    this.dob, // Added dob
    this.placeOfBirth, // Added placeOfBirth
    this.photos = const [], // Added photos
    this.meta,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return '''User: { 
      id: $id, 
      order: $order, 
      name: $firstname, 
      representant: $representant, 
      lastName: $lastName, // Added lastName
      denomination: $denomination, // Added denomination
      email: $email,
      phone: $phone, // Added phone 
      address: $address, 
      type: $type, // Added type
      dob: ${dob?.toIso8601String()}, // Added dob
      placeOfBirth: $placeOfBirth, // Added placeOfBirth
      photos: ${photos != null ? photos.toString() : 'null'}, // Added photos
      meta: ${meta != null ? meta.toString() : 'null'}, 
      createdAt: ${createdAt?.toIso8601String()}, 
      updatedAt: ${updatedAt?.toIso8601String()} 
    }''';
  }

  factory InventoryAuthor.fromJson(Map<String, dynamic> doc, {Review? review}) {
    return InventoryAuthor(
      id: doc['_id'] ?? "0",
      email: doc['email'] ?? '',
      phone: doc['phone'] ?? '', // Added phone
      representant: doc['representant'] != null
          ? InventoryAuthor.fromJson(doc['representant'])
          : InventoryAuthor(),
      order: doc['order'] ?? 1,
      firstname: doc['firstname'] ?? doc['firstName'] ?? '',
      lastName: doc['lastname'] ?? '', // Added lastName
      denomination: doc['denomination'] ?? '', // Added denomination
      address: doc['address'] ?? '',
      type: doc['type'] ?? 'physique', // Added type
      dob: doc['dob'] != null ? DateTime.parse(doc['dob']) : null, // Added dob
      placeOfBirth: doc['placeofbirth'] ?? '', // Added placeOfBirth
      photos: doc['meta'] != null
          ? List<String>.from(
              (doc['meta']?[review?.id ?? 'photos']?["photos"]) ?? [])
          : null, // Added photos
      meta: doc['meta'] ?? {},
      createdAt:
          doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : null,
      updatedAt:
          doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : null,
    );
  }

  List<String> getPhotos() {
    if (meta != null && meta!.containsKey('photos')) {
      return List<String>.from(meta!['photos']);
    }
    return photos ?? [];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    if (id != null) data['_id'] = id;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone; // Added phone
    if (order != null) data['order'] = order;
    if (firstname != null) data['firstname'] = firstname;
    if (lastName != null) data['lastname'] = lastName; // Added lastName
    if (denomination != null)
      data['denomination'] = denomination; // Added denomination
    if (address != null) data['address'] = address;
    if (type != null) data['type'] = type; // Added type
    if (dob != null) data['dob'] = dob!.toIso8601String(); // Added dob
    if (placeOfBirth != null)
      data['placeofbirth'] = placeOfBirth; // Added placeOfBirth
    if (meta != null) data['meta'] = meta;
    if (representant != null) {
      data['representant'] = representant!.toJson();
    }
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }

  InventoryAuthor copyWith({
    String? id,
    int? order,
    String? firstname,
    String? lastName,
    String? denomination,
    String? email,
    String? phone, // Added phone
    InventoryAuthor? representant,
    String? address,
    String? type,
    DateTime? dob,
    String? placeOfBirth,
    List<String>? photos, // Added photos
    Map? meta,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryAuthor(
      id: id ?? this.id,
      order: order ?? this.order,
      firstname: firstname ?? this.firstname,
      lastName: lastName ?? this.lastName,
      denomination: denomination ?? this.denomination,
      email: email ?? this.email,
      phone: phone ?? this.phone, // Added phone
      representant: representant ?? this.representant,
      address: address ?? this.address,
      type: type ?? this.type,
      dob: dob ?? this.dob,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      photos: photos ?? this.photos, // Added photos
      meta: meta ?? this.meta,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class InventoryPiece {
  String? id;
  String? name;
  String? type; // Type of the piece (e.g., bedroom, kitchen, etc.)
  double? area; // Area of the piece in square meters
  int? count; // Number of pieces of this type
  int? order; // Order of the piece
  Map? meta = {};
  List<InventoryOfThing>? things;
  List<String>? photos;
  String? comment;

  DateTime? createdAt;
  DateTime? updatedAt;

  InventoryPiece({
    this.id,
    this.name,
    this.type,
    this.area,
    this.count,
    this.order,
    this.meta,
    this.things,
    this.photos = const [], // Added photos
    this.comment, // Added comment
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return '''Piece: { 
      id: $id, 
      name: $name, 
      type: $type, 
      area: $area, 
      count: $count, 
      order: $order, // Added order
      meta: ${meta != null ? meta.toString() : 'null'}, 
      things: ${things != null ? things.toString() : 'null'}, // Added list of InventoryOfThings
      photos: ${photos != null ? photos.toString() : 'null'}, // Added photos
      comment: $comment, // Added comment
      createdAt: ${createdAt?.toIso8601String()}, 
      updatedAt: ${updatedAt?.toIso8601String()} 
    }''';
  }

  factory InventoryPiece.fromJson(Map<String, dynamic> doc) {
    return InventoryPiece(
      id: doc['_id'] ?? 0,
      name: doc['name'] ?? '',
      type: doc['type'] ?? '',
      area: doc['area'] != null ? (doc['area'] as num).toDouble() : null,
      count: doc['count'] ?? 0,
      order: doc['order'] ?? 0, // Added order
      meta: doc['meta'] ?? {},
      things: doc['things'] != null
          ? (doc['things'] as List)
              .map((item) => InventoryOfThing.fromJson(item))
              .toList()
          : null,
      photos: doc['photos'] != null ? List<String>.from(doc['photos']) : null,
      comment: doc['comment'] ?? '', // Added comment
      createdAt:
          doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : null,
      updatedAt:
          doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (id != null) data['_id'] = id;
    if (name != null) data['name'] = name;
    if (type != null) data['type'] = type;
    if (area != null) data['area'] = area;
    if (count != null) data['count'] = count;
    if (order != null) data['order'] = order; // Added order
    if (meta != null) data['meta'] = meta;
    if (things != null) {
      data['things'] = things!.map((item) => item.toJson()).toList();
    }
    if (photos != null) {
      data['photos'] = photos; // Added photos
    }
    if (comment != null) {
      data['comment'] = comment; // Added comment
    }
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }
}

class InventoryOfThing {
  String? id;
  String? name;
  String? type; // Type of the thing (e.g., furniture, appliance, etc.)
  String? brand; // Brand of the thing
  String? model; // Model of the thing
  String? serialNumber; // Serial number of the thing
  String? condition;
  String? location; // Location of the thing in the property
  String? testingStage; // Value of the thing
  String? comment; // Description of the thing
  List<String>? photos;
  String? warranty; // Warranty information of the thing
  String? notes; // Additional notes about the thing
  int? order; // Order of the thing
  int? count; // Order of the thing
  DateTime? dateAcquired; // Date when the thing was acquired
  Map? meta = {};

  InventoryOfThing({
    this.id,
    this.name,
    this.type,
    this.meta,
    this.brand,
    this.model,
    this.serialNumber,
    this.condition = "ok",
    this.location,
    this.testingStage,
    this.count,
    this.comment,
    this.photos = const [], // Added photos
    this.warranty,
    this.notes,
    this.order, // Added order
    this.dateAcquired,
  });

  @override
  String toString() {
    return '''Thing: { 
      id: $id, 
      name: $name, 
      type: $type, 
      brand: $brand, 
      model: $model, 
      serialNumber: $serialNumber, 
      condition: $condition, 
      location: $location, 
      value: $testingStage,       meta: ${meta != null ? meta.toString() : 'null'}, 

      description: $comment, 
      count: $count, 
      photos: ${photos != null ? photos.toString() : 'null'}, // Added photos
      warranty: $warranty, 
      notes: $notes, 
      order: $order, // Added order
      dateAcquired: ${dateAcquired?.toIso8601String()}, 
     
    }''';
  }

  factory InventoryOfThing.fromJson(Map<String, dynamic> doc) {
    return InventoryOfThing(
      id: doc['_id'] ?? 0,
      name: doc['name'] ?? '',
      type: doc['type'] ?? '',
      brand: doc['brand'] ?? '',
      model: doc['model'] ?? '',
      serialNumber: doc['serialNumber'] ?? '',
      condition: doc['condition'] ?? '',
      location: doc['location'] ?? '',
      count: doc['count'] ?? '',
      testingStage: doc['testingStage'] ?? '',
      comment: doc['comment'] ?? '',
      photos: doc['photos'] != null ? List<String>.from(doc['photos']) : null,
      warranty: doc['warranty'] ?? '',
      notes: doc['notes'] ?? '',
      order: doc['order'] ?? 0, // Added order
      dateAcquired: doc['dateAcquired'] != null
          ? DateTime.parse(doc['dateAcquired'])
          : null,
      meta: doc['meta'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (id != null) data['_id'] = id;
    if (name != null) data['name'] = name;
    if (type != null) data['type'] = type;
    if (brand != null) data['brand'] = brand;
    if (count != null) data['count'] = count;
    if (model != null) data['model'] = model;
    if (serialNumber != null) data['serialNumber'] = serialNumber;
    if (condition != null) data['condition'] = condition;
    if (location != null) data['location'] = location;
    if (testingStage != null) data['testingStage'] = testingStage;
    if (comment != null) data['comment'] = comment;
    if (photos != null) {
      data['photos'] = photos; // Added photos
    }
    if (meta != null) data['meta'] = meta;

    if (warranty != null) data['warranty'] = warranty;
    if (notes != null) data['notes'] = notes;
    if (order != null) data['order'] = order; // Added order
    if (dateAcquired != null) {
      data['dateAcquired'] = dateAcquired!.toIso8601String();
    }

    return data;
  }

  InventoryOfThing copyWith({
    String? id,
    String? name,
    String? type,
    String? brand,
    String? model,
    String? serialNumber,
    String? condition,
    String? location,
    String? testingStage,
    String? description,
    List<String>? photos,
    String? warranty,
    String? notes,
    int? order,
    int? count,
    DateTime? dateAcquired,
    DateTime? dateDisposed,
    DateTime? dateInspected,
    DateTime? dateRepaired,
    DateTime? dateServiced,
    DateTime? dateMaintained,
    DateTime? dateReplaced,
    DateTime? dateUpgraded,
    DateTime? dateDowngraded,
    DateTime? dateRecalled,
  }) {
    return InventoryOfThing(
      id: id ?? this.id,
      count: count ?? this.count,
      name: name ?? this.name,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      condition: condition ?? this.condition,
      location: location ?? this.location,
      testingStage: testingStage ?? this.testingStage,
      comment: description ?? this.comment,
      photos: photos ?? this.photos,
      warranty: warranty ?? this.warranty,
      notes: notes ?? this.notes,
      order: order ?? this.order,
      dateAcquired: dateAcquired ?? this.dateAcquired,
    );
  }
}

class Compteur {
  String? id;
  String? name;
  String? type;
  String? serialNumber;
  String? comment;
  double? initialReading;
  double? currentReading;
  double? initialReadingHp; // Added
  double? initialReadingHc; // Added
  double? currentReadingHp; // Added
  double? currentReadingHc; // Added
  String? unit;
  int? count;
  int? order;
  DateTime? lastChecked;
  Map<String, dynamic>? meta;
  List<String>? photos;

  Compteur({
    this.id,
    this.name,
    this.type,
    this.serialNumber,
    this.comment,
    this.initialReading,
    this.currentReading,
    this.initialReadingHp, // Added
    this.initialReadingHc, // Added
    this.currentReadingHp, // Added
    this.currentReadingHc, // Added
    this.unit,
    this.count,
    this.order,
    this.lastChecked,
    this.meta,
    this.photos = const [],
  });

  @override
  String toString() {
    return '''Compteur: {
      id: $id,
      name: $name,
      type: $type,
      serialNumber: $serialNumber,
      location: $comment,
      initialReading: $initialReading,
      currentReading: $currentReading,
      initialReadingHp: $initialReadingHp,
      initialReadingHc: $initialReadingHc,
      currentReadingHp: $currentReadingHp, 
      currentReadingHc: $currentReadingHc,
      unit: $unit,
      count: $count,
      order: $order,
      lastChecked: ${lastChecked?.toIso8601String()},
      meta: ${meta?.toString()},
      photos: ${photos != null ? photos.toString() : 'null'}
    }''';
  }

  factory Compteur.fromJson(Map<String, dynamic> json) {
    return Compteur(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      serialNumber: json['serialNumber']?.toString(),
      comment: json['comment']?.toString(),
      initialReading: json['initialReading']?.toDouble(),
      currentReading: json['currentReading']?.toDouble(),
      initialReadingHp: json['initialReadingHp']?.toDouble(), // Added
      initialReadingHc: json['initialReadingHc']?.toDouble(), // Added
      currentReadingHp: json['currentReadingHp']?.toDouble(), // Added
      currentReadingHc: json['currentReadingHc']?.toDouble(), // Added
      unit: json['unit']?.toString(),
      count: json['count'] as int?,
      order: json['order'] as int?,
      lastChecked: json['lastChecked'] != null
          ? DateTime.parse(json['lastChecked'])
          : null,
      meta: json['meta'] as Map<String, dynamic>?,
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (id != null) data['_id'] = id;
    if (name != null) data['name'] = name;
    if (type != null) data['type'] = type;
    if (serialNumber != null) data['serialNumber'] = serialNumber;
    if (comment != null) data['comment'] = comment;
    if (initialReading != null) data['initialReading'] = initialReading;
    if (currentReading != null) data['currentReading'] = currentReading;
    if (initialReadingHp != null)
      data['initialReadingHp'] = initialReadingHp; // Added
    if (initialReadingHc != null)
      data['initialReadingHc'] = initialReadingHc; // Added
    if (currentReadingHp != null)
      data['currentReadingHp'] = currentReadingHp; // Added
    if (currentReadingHc != null)
      data['currentReadingHc'] = currentReadingHc; // Added
    if (unit != null) data['unit'] = unit;
    if (count != null) data['count'] = count;
    if (order != null) data['order'] = order;
    if (lastChecked != null) {
      data['lastChecked'] = lastChecked!.toIso8601String();
    }
    if (meta != null) data['meta'] = meta;
    if (photos != null) data['photos'] = photos;

    return data;
  }

  Compteur copyWith({
    String? id,
    String? name,
    String? type,
    String? serialNumber,
    String? comment,
    double? initialReading,
    double? currentReading,
    double? initialReadingHp, // Added
    double? initialReadingHc, // Added
    double? currentReadingHp, // Added
    double? currentReadingHc, // Added
    String? unit,
    int? count,
    int? order,
    DateTime? lastChecked,
    Map<String, dynamic>? meta,
    List<String>? photos,
  }) {
    return Compteur(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      serialNumber: serialNumber ?? this.serialNumber,
      comment: comment ?? this.comment,
      initialReading: initialReading ?? this.initialReading,
      currentReading: currentReading ?? this.currentReading,
      initialReadingHp: initialReadingHp ?? this.initialReadingHp, // Added
      initialReadingHc: initialReadingHc ?? this.initialReadingHc, // Added
      currentReadingHp: currentReadingHp ?? this.currentReadingHp, // Added
      currentReadingHc: currentReadingHc ?? this.currentReadingHc, // Added
      unit: unit ?? this.unit,
      count: count ?? this.count,
      order: order ?? this.order,
      lastChecked: lastChecked ?? this.lastChecked,
      meta: meta ?? this.meta,
      photos: photos ?? this.photos,
    );
  }
}

class CleDePorte {
  String? id;
  String? name;
  String? type; // Type of the key (e.g., main door, garage, etc.)
  String? description; // Description of the key
  String? location; // Location where the key is used
  String? serialNumber; // Serial number of the key
  int? count; // Count of the keys
  int? order; // Order of the key
  DateTime? dateCreated; // Date when the key was created
  DateTime? dateUpdated; // Date when the key was last updated
  Map<String, dynamic>? meta;
  String? comment; // Added comment field
  List<String>? photos; // Added photos

  CleDePorte({
    this.id,
    this.name, // Added name
    this.type,
    this.description,
    this.location,
    this.serialNumber,
    this.count, // Added count
    this.order, // Added order
    this.dateCreated,
    this.dateUpdated,
    this.meta,
    this.comment, // Added comment
    this.photos = const [], // Added photos
  });

  @override
  String toString() {
    return '''CleDePorte: {
      id: $id,
      name: $name, // Added name
      type: $type,
      description: $description,
      location: $location,
      serialNumber: $serialNumber,
      count: $count, // Added count
      order: $order, // Added order
      dateCreated: ${dateCreated?.toIso8601String()},
      dateUpdated: ${dateUpdated?.toIso8601String()},
      meta: ${meta?.toString()},
      comment: $comment, // Added comment
      photos: ${photos != null ? photos.toString() : 'null'} // Added photos
    }''';
  }

  factory CleDePorte.fromJson(Map<String, dynamic> json) {
    return CleDePorte(
      id: json['_id']?.toString(),
      name: json['name']?.toString(), // Added name
      type: json['type']?.toString(),
      description: json['description']?.toString(),
      location: json['location']?.toString(),
      serialNumber: json['serialNumber']?.toString(),
      count: json['count'] as int?, // Added count
      order: json['order'] as int?, // Added order
      dateCreated: json['dateCreated'] != null
          ? DateTime.parse(json['dateCreated'])
          : null,
      dateUpdated: json['dateUpdated'] != null
          ? DateTime.parse(json['dateUpdated'])
          : null,
      meta: json['meta'] as Map<String, dynamic>?,
      comment: json['comment']?.toString(), // Added comment
      photos: json['photos'] != null
          ? List<String>.from(json['photos'])
          : null, // Added photos
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (id != null) data['_id'] = id;
    if (name != null) data['name'] = name; // Added name
    if (type != null) data['type'] = type;
    if (description != null) data['description'] = description;
    if (location != null) data['location'] = location;
    if (serialNumber != null) data['serialNumber'] = serialNumber;
    if (count != null) data['count'] = count; // Added count
    if (order != null) data['order'] = order; // Added order
    if (dateCreated != null) {
      data['dateCreated'] = dateCreated!.toIso8601String();
    }
    if (dateUpdated != null) {
      data['dateUpdated'] = dateUpdated!.toIso8601String();
    }
    if (meta != null) data['meta'] = meta;
    if (comment != null) data['comment'] = comment; // Added comment
    if (photos != null) data['photos'] = photos; // Added photos

    return data;
  }

  CleDePorte copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    String? location,
    String? serialNumber,
    int? count,
    int? order, // Added order
    DateTime? dateCreated,
    DateTime? dateUpdated,
    Map<String, dynamic>? meta,
    String? comment, // Added comment
    List<String>? photos, // Added photos
  }) {
    return CleDePorte(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      location: location ?? this.location,
      serialNumber: serialNumber ?? this.serialNumber,
      count: count ?? this.count,
      order: order ?? this.order, // Added order
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      meta: meta ?? this.meta,
      comment: comment ?? this.comment, // Added comment
      photos: photos ?? this.photos, // Added photos
    );
  }
}

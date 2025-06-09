class User {
  final int? id;
  final String? iid;
  final String? name;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? level;
  final DateTime? lastOnline;

  final bool? isBlocked;
  String? address;
  String? countryCode;
  final String? gender;
  final DateTime? dob;
  final DateTime? verifiedAt;
  final String? phoneNumber;
  int? lastmsg;
  Map? meta = {};
  final String? about;
  String? imageUrl = "avatar.png";
  List<String>? images = [];
  List<String>? favorites = [];
  final String? type;
  final String? placeOfBirth;
  final String? avatar;
  final String? country;
  final DateTime? birthdate;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.iid,
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.name,
    this.address,
    this.verifiedAt,
    this.dob,
    this.isBlocked,
    this.imageUrl,
    this.phoneNumber,
    this.lastmsg,
    this.gender,
    this.about,
    this.level,
    this.favorites,
    this.images,
    this.lastOnline,
    this.meta,
    this.type,
    this.placeOfBirth,
    this.avatar,
    this.countryCode,
    this.country,
    this.birthdate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return ''' User: { id: $id, name: $name, email: $email, firstName: $firstName, lastName: $lastName, level: $level, lastOnline: ${lastOnline?.toIso8601String()}, isBlocked: $isBlocked, address: $address, gender: $gender, dob: ${dob?.toIso8601String()}, phoneNumber: $phoneNumber, lastmsg: $lastmsg, about: $about,  images: ${images?.join(', ') ?? 'null'}, favorites: ${favorites?.join(', ') ?? 'null'}, meta: ${meta != null ? meta.toString() : 'null'}, type: $type, placeOfBirth: $placeOfBirth, avatar: $avatar, countryCode: $countryCode, country: $country, birthdate: ${birthdate?.toIso8601String()}, isActive: $isActive, createdAt: ${createdAt?.toIso8601String()}, updatedAt: ${updatedAt?.toIso8601String()} } ''';
  }

  factory User.fromJson(Map<String, dynamic> doc) {
    return User(
      iid: doc['_id'] ?? '',
      id: doc['ID'] ?? 0,
      email: doc['email'] ?? '',
      firstName: doc['firstName'] ?? '',
      lastName: doc['lastName'] ?? '',
      level: doc['level'] ?? 'standard', // Default level
      favorites:
          doc['favorites'] != null ? List<String>.from(doc['favorites']) : [],
      images: doc['images'] != null ? List<String>.from(doc['images']) : [],
      lastOnline: doc['lastOnline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(doc['lastOnline'])
          : null, // Convert timestamp to DateTime
      isBlocked: doc['is_active'] ?? false,
      phoneNumber: doc['phone'] ?? '',
      name: doc['username'] ?? '',
      about: doc['about'] ?? "",
      meta: doc['meta'] ?? {},
      gender: doc['gender'] ?? "woman",
      dob: doc['dob'] != null ? DateTime.parse(doc['dob']) : null,
      verifiedAt:
          doc['verifiedAt'] != null ? DateTime.parse(doc['verifiedAt']) : null,
      address: doc['location']?['address'] ?? '',
      imageUrl: doc['imageUrl'],
      type: doc['type'] ?? 'tenant',
      placeOfBirth: doc['placeOfBirth'] ?? '',
      avatar: doc['avatar'],
      countryCode: doc['country_code'] ?? '33',
      country: doc['country'] ?? 'France',
      createdAt:
          doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : null,
      updatedAt:
          doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['ID'] = id;
    if (email != null) data['email'] = email;
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (name != null) data['username'] = name;
    if (name != null)
      data['fullName'] = '${firstName ?? ""} ${lastName ?? ""}'.trim();
    if (phoneNumber != null) data['phone'] = phoneNumber;
    if (isBlocked != null) data['isBlocked'] = isBlocked;
    if (lastOnline != null) {
      data['lastOnline'] = lastOnline!.millisecondsSinceEpoch;
    }
    if (dob != null) data['dob'] = dob!.toIso8601String();
    if (favorites != null) data['favorites'] = favorites;
    if (images != null) data['images'] = images;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (address != null) data['address'] = address;
    if (gender != null) data['gender'] = gender;
    if (meta != null) data['meta'] = meta;
    if (about != null) data['about'] = about;
    if (type != null) data['type'] = type;
    if (placeOfBirth != null) data['placeOfBirth'] = placeOfBirth;
    if (avatar != null) data['avatar'] = avatar;
    if (countryCode != null) data['country_code'] = countryCode;
    if (country != null) data['country'] = country;
    if (birthdate != null) data['birthdate'] = birthdate!.toIso8601String();
    if (isActive != null) data['is_active'] = isActive;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }
}

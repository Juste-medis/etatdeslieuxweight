import 'package:jatai_etadmin/app/models/_user_balence.dart';

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
  final String? password;
  final String? passwordc;
  final String? country;
  final DateTime? birthdate;
  final bool? isActive;
  bool isSelected;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final UserBalence? balance;

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
    this.balance,
    this.isSelected = false,
    this.password,
    this.passwordc,
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
      isBlocked: doc['isBlocked'] ?? false,
      phoneNumber: doc['phone'] ?? '',
      name: doc['username'] ?? '',
      about: doc['about'] ?? "",
      meta: doc['meta'] ?? {},
      gender: doc['gender'] ?? "woman",
      dob: doc['user_DOB'] != null ? DateTime.parse(doc['user_DOB']) : null,
      verifiedAt:
          doc['verifiedAt'] != null ? DateTime.parse(doc['verifiedAt']) : null,
      address: doc['location']?['address'] ?? doc['address'] ?? '',
      imageUrl: doc['imageUrl'],
      type: doc['type'] ?? 'tenant',
      placeOfBirth: doc['placeOfBirth'] ?? '',
      avatar: doc['avatar'],
      countryCode: doc['country_code'] ?? '33',
      country: doc['country'] ?? 'France',
      isSelected: false,
      password: doc['password'] ?? '',
      passwordc: doc['passwordc'] ?? '',
      isActive: doc['is_active'] ?? true,
      birthdate:
          doc['birthdate'] != null ? DateTime.parse(doc['birthdate']) : null,

      createdAt:
          doc['createdAt'] != null ? DateTime.parse(doc['createdAt']) : null,
      updatedAt:
          doc['updatedAt'] != null ? DateTime.parse(doc['updatedAt']) : null,
      balance: doc['balances'] != null
          ? UserBalence.fromJson(doc['balances'])
          : const UserBalence(),
    );
  }

  User copyWith({
    int? id,
    String? iid,
    String? name,
    String? email,
    String? firstName,
    String? lastName,
    String? level,
    DateTime? lastOnline,
    bool? isBlocked,
    String? address,
    String? countryCode,
    String? gender,
    DateTime? dob,
    DateTime? verifiedAt,
    String? phoneNumber,
    int? lastmsg,
    Map? meta,
    String? about,
    String? imageUrl,
    List<String>? images,
    List<String>? favorites,
    String? type,
    String? placeOfBirth,
    String? avatar,
    String? country,
    DateTime? birthdate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserBalence? balance,
    bool? isSelected,
    String? password,
    String? passwordc,
  }) {
    return User(
      id: id ?? this.id,
      iid: iid ?? this.iid,
      name: name ?? this.name,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      level: level ?? this.level,
      lastOnline: lastOnline ?? this.lastOnline,
      isBlocked: isBlocked ?? this.isBlocked,
      address: address ?? this.address,
      countryCode: countryCode ?? this.countryCode,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lastmsg: lastmsg ?? this.lastmsg,
      meta: meta ?? this.meta,
      about: about ?? this.about,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      favorites: favorites ?? this.favorites,
      type: type ?? this.type,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      avatar: avatar ?? this.avatar,
      country: country ?? this.country,
      birthdate: birthdate ?? this.birthdate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      balance: balance ?? this.balance,
      isSelected: isSelected ?? this.isSelected,
      password: password ?? this.password,
      passwordc: passwordc ?? this.passwordc,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['id'] = iid;
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

    if (balance != null) data['balance'] = balance!.toJson();
    if (password != null) data['password'] = password;
    if (passwordc != null) data['passwordc'] = passwordc;
    return data;
  }
}

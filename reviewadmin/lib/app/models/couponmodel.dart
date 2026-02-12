// couponmodel.dart

class CouponModel {
  final String? id; // Mongo _id
  final String code;
  final double discount;
  final String type;
  final DateTime expiryDate;
  final bool isActive;
  final bool usageunique;
  final String? comments;
  final String createdBy; // user ObjectId
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool isSelected = false;
  double? minimumAmount; // New field for minimum amount

  CouponModel({
    this.id,
    required this.code,
    required this.discount,
    required this.type,
    required this.expiryDate,
    required this.isActive,
    required this.usageunique,
    this.comments,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.isSelected = false,
    this.minimumAmount,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  CouponModel copyWith({
    String? id,
    String? code,
    double? discount,
    String? type,
    DateTime? expiryDate,
    bool? isActive,
    bool? usageunique,
    String? comments,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSelected,
    double? minimumAmount,
  }) {
    return CouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      discount: discount ?? this.discount,
      type: type ?? this.type,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      usageunique: usageunique ?? this.usageunique,
      comments: comments ?? this.comments,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSelected: isSelected ?? this.isSelected,
      minimumAmount: minimumAmount ?? this.minimumAmount,
    );
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      code: (json['code'] ?? '').toString(),
      discount: (json['discount'] is int)
          ? (json['discount'] as int).toDouble()
          : (json['discount'] is String)
              ? double.tryParse(json['discount']) ?? 0
              : (json['discount'] ?? 0.0) as double,
      type: json['type']?.toString() ?? 'fixed',
      usageunique:
          json['usageunique'] == null ? false : json['usageunique'] == true,
      minimumAmount: (json['minimumAmount'] is int)
          ? (json['minimumAmount'] as int).toDouble()
          : (json['minimumAmount'] is String)
              ? double.tryParse(json['minimumAmount']) ?? null
              : (json['minimumAmount'] != null)
                  ? (json['minimumAmount'] as double)
                  : null,
      expiryDate: _parseDate(json['expiryDate']),
      isActive: json['isActive'] == null ? true : json['isActive'] == true,
      comments: json['comments']?.toString(),
      createdBy: (json['createdBy'] is Map)
          ? (json['createdBy']['_id']?.toString() ?? '')
          : json['createdBy']?.toString() ?? '',
      createdAt:
          json['createdAt'] != null ? _parseDate(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? _parseDate(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    final map = <String, dynamic>{
      'code': code,
      'discount': discount,
      'type': type,
      if (minimumAmount != null) 'minimumAmount': minimumAmount,
      'expiryDate': expiryDate.toUtc().toIso8601String(),
      'isActive': isActive,
      'usageunique': usageunique,
      if (comments != null && comments!.isNotEmpty) 'comments': comments,
      'createdBy': createdBy,
      if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
    };
    if (id != null) {
      map['_id'] = id;
    }
    return map;
  }

  static DateTime _parseDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is int) {
      // Assume millis since epoch if large, else seconds.
      if (v > 100000000000) {
        return DateTime.fromMillisecondsSinceEpoch(v, isUtc: true).toLocal();
      } else if (v > 1000000000) {
        return DateTime.fromMillisecondsSinceEpoch(v * 1000, isUtc: true)
            .toLocal();
      }
      return DateTime.fromMillisecondsSinceEpoch(v * 1000, isUtc: true)
          .toLocal();
    }
    if (v is String && v.isNotEmpty) {
      return DateTime.parse(v).toLocal();
    }
    return DateTime.now();
  }

  @override
  String toString() {
    return 'CouponModel(id: $id, code: $code, discount: $discount, type: ${(type)}, expiry: $expiryDate, active: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return other is CouponModel &&
        other.id == id &&
        other.code == code &&
        other.discount == discount &&
        other.type == type &&
        other.expiryDate == expiryDate &&
        other.isActive == isActive &&
        other.comments == comments &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      code.hashCode ^
      discount.hashCode ^
      type.hashCode ^
      expiryDate.hashCode ^
      isActive.hashCode ^
      (comments?.hashCode ?? 0) ^
      createdBy.hashCode;
}

import 'package:mon_etatsdeslieux/app/models/_inventory.dart';

class BaseResponseModel {
  String? message;
  var data;
  Map remoteIds;
  bool? status;

  BaseResponseModel({
    this.message,
    this.data,
    this.status,
    this.remoteIds = const {},
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
      message: json['message'],
      data: json['data'],
      status: json['status'] ?? false,
      remoteIds: json['remoteIds'] != null
          ? Map<String, dynamic>.from(json['remoteIds'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}

class PaginateBaseResponseModel<T> {
  final String? message;
  final bool status;
  final List<T> list;
  final int totalItems;
  final int currentPage;
  final dynamic rawData;
  final int totalPages;
  final int itemsPerPage;

  PaginateBaseResponseModel({
    this.message,
    required this.status,
    required this.list,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
    this.rawData,
  });

  factory PaginateBaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginateBaseResponseModel<T>(
      message: json['message'],
      status: json['success'] ?? false,
      totalItems: json['pagination']['totalItems'] ?? 0,
      currentPage: json['pagination']['currentPage'] ?? 1,
      totalPages: json['pagination']['totalPages'] ?? 0,
      itemsPerPage: json['pagination']['itemsPerPage'] ?? 1,
      list: (json['data'] as List<dynamic>? ?? []).map((item) {
        if (json['copyOptions'] != null && json['copyOptions'] != false) {
          json['copyOptions'] = false;
        }
        return fromJsonT(item as Map<String, dynamic>);
      }).toList(),
      rawData: json['data'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'message': message,
      'status': status,
      'total': totalItems,
      'page': currentPage,
      'list': list.map(toJsonT).toList(),
    };
  }
}

class AppSettings {
  String? id;
  String? appName;
  String? appLogo;
  String? appVersion;
  String? supportEmail;
  String? supportPhone;
  String? privacyPolicyUrl;
  String? termsOfServiceUrl;
  String? appUrl;
  Map<String, dynamic>? additionalSettings;

  AppSettings({
    this.id,
    this.appName,
    this.appLogo,
    this.appVersion,
    this.supportEmail,
    this.supportPhone,
    this.privacyPolicyUrl,
    this.termsOfServiceUrl,
    this.additionalSettings,
    this.appUrl,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      id: json['_id'],
      appName: json['appName'],
      appLogo: json['appLogo'],
      appVersion: json['appVersion'],
      supportEmail: json['supportEmail'],
      supportPhone: json['supportPhone'],
      privacyPolicyUrl: json['privacyPolicyUrl'],
      termsOfServiceUrl: json['termsOfServiceUrl'],
      appUrl: json['appUrl'],
      additionalSettings: json['additionalSettings'] != null
          ? Map<String, dynamic>.from(json['additionalSettings'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['_id'] = id;
    if (appUrl != null) data['appUrl'] = appUrl;
    if (appName != null) data['appName'] = appName;
    if (appLogo != null) data['appLogo'] = appLogo;
    if (appVersion != null) data['appVersion'] = appVersion;
    if (supportEmail != null) data['supportEmail'] = supportEmail;
    if (supportPhone != null) data['supportPhone'] = supportPhone;
    if (privacyPolicyUrl != null) data['privacyPolicyUrl'] = privacyPolicyUrl;
    if (termsOfServiceUrl != null) {
      data['termsOfServiceUrl'] = termsOfServiceUrl;
    }
    if (additionalSettings != null) {
      data['additionalSettings'] = additionalSettings;
    }
    return data;
  }
}

class InventoryAuthorParam {
  InventoryAuthor data;
  Future<void> Function(InventoryAuthor data, String? action) cb;
  bool? canModifyMandataire;
  String? from;
  InventoryAuthorParam({
    required this.cb,
    required this.data,
    this.canModifyMandataire,
    this.from,
  });

  // factory TypingRoom.fromJson(Map<String, dynamic> json) {
  //   return TypingRoom(
  //     id: "${json['id']}",
  //     status: json['status'],
  //   );
  // }
}

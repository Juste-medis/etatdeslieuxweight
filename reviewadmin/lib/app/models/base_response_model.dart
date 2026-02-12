import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/models/_message_model.dart';

class BaseResponseModel {
  String? message;
  var data;
  bool? status;

  BaseResponseModel({this.message, this.data, this.status});

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    myprintnet('Request: $json');

    return BaseResponseModel(
      message: json['message'],
      data: json['data'],
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
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
  final Map<String, dynamic>? meta;

  PaginateBaseResponseModel({
    this.message,
    required this.status,
    required this.list,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
    this.rawData,
    this.meta,
  });

  factory PaginateBaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginateBaseResponseModel<T>(
      message: json['message'],
      status: json['success'] ?? false,
      totalItems: json['pagination']?['totalItems'] ?? 0,
      currentPage: json['pagination']?['currentPage'] ?? 1,
      totalPages: json['pagination']?['totalPages'] ?? 0,
      itemsPerPage: json['pagination']?['itemsPerPage'] ?? 1,
      meta: json['pagination']?['meta'] != null
          ? Map<String, dynamic>.from(json['pagination']?['meta'] as Map)
          : null,
      list: (json['data'] as List<dynamic>? ?? [])
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
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

class OnlineUser {
  String? id;
  String? status;

  Message? message;
  Room? room;
  var data;

  OnlineUser({this.id, this.status});

  factory OnlineUser.fromJson(Map<String, dynamic> json) {
    return OnlineUser(
      id: "${json['id']}",
      status: json['status'],
    );
  }
}

class TypingRoom {
  String? id;
  bool? status;

  Message? message;
  Room? room;
  var data;

  TypingRoom({this.id, this.status});

  factory TypingRoom.fromJson(Map<String, dynamic> json) {
    return TypingRoom(
      id: "${json['id']}",
      status: json['status'],
    );
  }
}

class InventoryAuthorParam {
  InventoryAuthor data;
  Future<void> Function(InventoryAuthor data, String? action) cb;
  bool? canModifyMandataire;
  String? from;
  InventoryAuthorParam(
      {required this.cb,
      required this.data,
      this.canModifyMandataire,
      this.from});

  // factory TypingRoom.fromJson(Map<String, dynamic> json) {
  //   return TypingRoom(
  //     id: "${json['id']}",
  //     status: json['status'],
  //   );
  // }
}

import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/_message_model.dart';

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

class MeetingResponse {
  String? id;
  bool? status;

  Message? message;
  Room? room;
  var data;

  MeetingResponse({this.id, this.status});

  factory MeetingResponse.fromJson(Map<String, dynamic> json) {
    return MeetingResponse();
  }
}

class SendMessageResponse {
  Message? message;
  Room? room;
  var data;

  SendMessageResponse({this.message, this.room, this.data});

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message:
          json['message'] != null ? Message.fromJson(json['message']) : null,
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message?.toString();
    data['room'] = this.room?.toString();
    data['data'] = this.data;
    return data;
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
  InventoryAuthorParam(
      {required this.cb, required this.data, this.canModifyMandataire});

  // factory TypingRoom.fromJson(Map<String, dynamic> json) {
  //   return TypingRoom(
  //     id: "${json['id']}",
  //     status: json['status'],
  //   );
  // }
}

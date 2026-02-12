import 'dart:convert';

class NotificationModel {
  final String? id; // MongoDB _id
  final String title;
  final String message;
  final String? recipientUser; // recipient_user (ObjectId as String)
  final String? recipient;
  bool isRead; // is_read
  final String? pushResponse; // push_response (can be "false" or a string)
  final Map<String, dynamic>? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    required this.title,
    required this.message,
    this.recipientUser,
    this.recipient,
    this.isRead = false,
    this.pushResponse,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? recipientUser,
    String? recipient,
    bool? isRead,
    String? pushResponse,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      recipientUser: recipientUser ?? this.recipientUser,
      recipient: recipient ?? this.recipient,
      isRead: isRead ?? this.isRead,
      pushResponse: pushResponse ?? this.pushResponse,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    final map = <String, dynamic>{
      'title': title,
      'message': message,
      'recipient_user': recipientUser,
      'recipient': recipient,
      'is_read': isRead,
      'push_response': pushResponse,
      'data': data ?? {},
    };

    if (includeId && id != null) {
      map['_id'] = id;
    }

    // Typically timestamps are set by the backend; exclude on create/update.
    if (createdAt != null) map['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) map['updatedAt'] = updatedAt!.toIso8601String();

    return map;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    String? _stringifyPushResponse(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;
      return v.toString();
    }

    DateTime? _parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    Map<String, dynamic>? _parseData(dynamic v) {
      if (v == null) return null;
      if (v is Map) return Map<String, dynamic>.from(v);
      return null;
    }

    return NotificationModel(
      id: map['_id']?.toString(),
      title: (map['title'] ?? '').toString(),
      message: (map['message'] ?? '').toString(),
      recipientUser: map['recipient_user']?.toString(),
      recipient: map['recipient']?.toString(),
      isRead: map['is_read'] == true,
      pushResponse: _stringifyPushResponse(map['push_response']),
      data: _parseData(map['data']) ?? {},
      // Mongoose timestamps can be createdAt/updatedAt
      createdAt: _parseDate(map['createdAt'] ?? map['created_at']),
      updatedAt: _parseDate(map['updatedAt'] ?? map['updated_at']),
    );
  }

  String toJson({bool includeId = false}) =>
      json.encode(toMap(includeId: includeId));

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, message: $message, recipientUser: $recipientUser, recipient: $recipient, isRead: $isRead, pushResponse: $pushResponse, data: $data, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        message,
        recipientUser,
        recipient,
        isRead,
        pushResponse,
        data,
        createdAt,
        updatedAt,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel &&
        other.id == id &&
        other.title == title &&
        other.message == message &&
        other.recipientUser == recipientUser &&
        other.recipient == recipient &&
        other.isRead == isRead &&
        other.pushResponse == pushResponse &&
        _mapEquals(other.data, data) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  static bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}

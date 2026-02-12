// lib/app/models/_transaction.dart

import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/models/_user_model.dart';

class TransactionModel {
  final String userId;
  User? author;
  final double totalAmount;
  final double price;
  final String? couponCode;
  final double? couponAmount;
  final double? tax;
  final double? taxAmount;
  final PaymentMethod paymentMethod;
  final PaymentStatus? paymentStatus;
  final String? transactionId;
  final List<Map<String, dynamic>> dispersion;
  final Map<String, dynamic> meta;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  TransactionModel({
    required this.userId,
    required this.totalAmount,
    required this.price,
    required this.paymentMethod,
    this.couponCode,
    this.couponAmount,
    this.tax,
    this.taxAmount,
    this.paymentStatus,
    this.transactionId,
    this.createdAt,
    this.updatedAt,
    this.author,
    List<Map<String, dynamic>>? dispersion,
    Map<String, dynamic>? meta,
  })  : dispersion = dispersion ?? const <Map<String, dynamic>>[],
        meta = meta ?? const <String, dynamic>{};

  TransactionModel copyWith({
    String? userId,
    double? totalAmount,
    double? price,
    String? couponCode,
    double? couponAmount,
    double? tax,
    double? taxAmount,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    String? transactionId,
    List<Map<String, dynamic>>? dispersion,
    Map<String, dynamic>? meta,
  }) {
    return TransactionModel(
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      price: price ?? this.price,
      couponCode: couponCode ?? this.couponCode,
      couponAmount: couponAmount ?? this.couponAmount,
      tax: tax ?? this.tax,
      taxAmount: taxAmount ?? this.taxAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      transactionId: transactionId ?? this.transactionId,
      dispersion: dispersion ?? this.dispersion,
      meta: meta ?? this.meta,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final userId = _readUserId(json['userId'] ?? json['user_id']);
    if (userId == null || userId.trim().isEmpty) {
      throw ArgumentError('userId is required');
    }

    final totalAmount = _toDouble(json['total_amount']);
    if (totalAmount == null) {
      throw ArgumentError('total_amount is required');
    }

    final price = _toDouble(json['price']);
    if (price == null) {
      throw ArgumentError('price is required');
    }

    final method = PaymentMethodX.fromString(json['payment_method']);
    if (method == null) {
      throw ArgumentError('payment_method is required and must be valid');
    }

//  "dispersion": [
//       {
//         "id": "68abb489ac5240298a887669",
//         "dis_quantity": 2,
//         "dis_price": 49.8
//       },
//       {
//         "id": "68abb80942d054383a78498e",
//         "dis_quantity": 1,
//         "dis_price": 5.9
//       }
//     ],

    return TransactionModel(
      userId: '${userId}',
      totalAmount: totalAmount,
      author: json['userId'] != null ? User.fromJson(json['userId']) : null,
      price: price,
      couponCode: _trim(json['coupon_code']),
      couponAmount: _toDouble(json['coupon_amount']),
      tax: _toDouble(json['tax']),
      taxAmount: _toDouble(json['tax_amount']),
      paymentMethod: method,
      paymentStatus: PaymentStatusX.fromString(json['payment_status']),
      transactionId: _trim(json['transaction_id']),
      dispersion: _toListOfMap(json['dispersion']),
      meta: _toMap(json['meta']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'total_amount': totalAmount,
      'price': price,
      'coupon_code': couponCode,
      'coupon_amount': couponAmount,
      'tax': tax,
      'tax_amount': taxAmount,
      'payment_method': paymentMethod.toJsonString(),
      'payment_status': paymentStatus?.toJsonString(),
      'transaction_id': transactionId,
      'dispersion': dispersion,
      'meta': meta,
    };
  }

  @override
  String toString() {
    return 'TransactionModel(userId: $userId, totalAmount: $totalAmount, price: $price, '
        'couponCode: $couponCode, couponAmount: $couponAmount, tax: $tax, taxAmount: $taxAmount, '
        'paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, transactionId: $transactionId, '
        'dispersion: $dispersion, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TransactionModel &&
            other.userId == userId &&
            other.totalAmount == totalAmount &&
            other.price == price &&
            other.couponCode == couponCode &&
            other.couponAmount == couponAmount &&
            other.tax == tax &&
            other.taxAmount == taxAmount &&
            other.paymentMethod == paymentMethod &&
            other.paymentStatus == paymentStatus &&
            other.transactionId == transactionId &&
            _mapEquals(other.meta, meta));
  }

  @override
  int get hashCode => Object.hash(
        userId,
        totalAmount,
        price,
        couponCode,
        couponAmount,
        tax,
        taxAmount,
        paymentMethod,
        paymentStatus,
        transactionId,
        _deepMapHash(meta),
      );
}

enum PaymentMethod {
  cashOnDelivery,
  paypal,
  stripe,
  stripeLink,
  razorpay,
  jataiMobile
}

extension PaymentMethodX on PaymentMethod {
  static PaymentMethod? fromString(dynamic value) {
    if (value == null) return null;
    final v = value.toString().trim().toLowerCase();
    switch (v) {
      case 'cash on delivery':
      case 'cod':
        return PaymentMethod.cashOnDelivery;
      case 'paypal':
        return PaymentMethod.paypal;
      case 'jatai-mobile':
        return PaymentMethod.jataiMobile;
      case 'stripe':
        return PaymentMethod.stripe;
      case 'stripe-link':
      case 'stripe_link':
        return PaymentMethod.stripeLink;
      case 'razorpay':
        return PaymentMethod.razorpay;
      default:
        return null;
    }
  }

  String toJsonString() {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash On Delivery';
      case PaymentMethod.paypal:
        return 'Paypal';
      case PaymentMethod.stripe:
        return 'stripe';
      case PaymentMethod.stripeLink:
        return 'stripe-link';
      case PaymentMethod.razorpay:
        return 'Razorpay';
      case PaymentMethod.jataiMobile:
        return 'Jatai-mobile';
    }
  }
}

enum PaymentStatus { completed, failed, pending }

extension PaymentStatusX on PaymentStatus {
  static PaymentStatus? fromString(dynamic value) {
    if (value == null) return null;
    switch (value.toString().trim().toLowerCase()) {
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'pending':
        return PaymentStatus.pending;
      default:
        return null;
    }
  }

  String toJsonString() {
    switch (this) {
      case PaymentStatus.completed:
        return 'Successful';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.pending:
        return 'pending';
    }
  }
}

List<Map<String, dynamic>> _toListOfMap(dynamic v) {
  if (v is List<Map<String, dynamic>>) return v;
  if (v is List) {
    return v
        .map<Map<String, dynamic>?>((e) {
          if (e is Map<String, dynamic>) return e;
          if (e is Map) return Map<String, dynamic>.from(e);
          return null;
        })
        .whereType<Map<String, dynamic>>()
        .toList();
  }
  return <Map<String, dynamic>>[];
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

String? _trim(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

Map<String, dynamic> _toMap(dynamic v) {
  if (v is Map<String, dynamic>) return v;
  if (v is Map) return Map<String, dynamic>.from(v);
  return <String, dynamic>{};
}

String? _readUserId(dynamic v) {
  if (v == null) return null;
  if (v is String) return v.trim();
  if (v is Map) {
    // Common MongoDB representations
    if (v.containsKey(r'$oid')) return v[r'$oid']?.toString();
    if (v.containsKey('_id')) return v['_id']?.toString();
  }
  return v.toString();
}

bool _mapEquals(Map a, Map b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key)) return false;
    final va = a[key];
    final vb = b[key];
    if (va is Map && vb is Map) {
      if (!_mapEquals(va, vb)) return false;
    } else if (va != vb) {
      return false;
    }
  }
  return true;
}

int _deepMapHash(Map value) {
  var hash = 0;
  value.forEach((k, v) {
    final kh = k.hashCode;
    final vh = v is Map ? _deepMapHash(v) : v.hashCode;
    hash = Object.hash(hash, Object.hash(kh, vh));
  });
  return hash;
}

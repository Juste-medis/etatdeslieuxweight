// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FormsProvider extends ChangeNotifier {
  final Map<String, String> fieldErrors = {};

  void setFieldError(String field, String error) {
    fieldErrors[field] = error;
    notifyListeners();
  }

  @override
  String toString() {
    return 'FormsProvider(fieldErrors: $fieldErrors)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormsProvider && mapEquals(other.fieldErrors, fieldErrors);
  }

  @override
  int get hashCode => fieldErrors.hashCode;
}

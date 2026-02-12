import 'package:flutter/material.dart';

extension strEtx on String {
  Color get fromHex {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension WidgetStyleExtension on Widget {
  TextStyle? get textStyle {
    if (this is Text) {
      return (this as Text).style;
    }

    if (this is SingleChildRenderObjectWidget) {
      final child = (this as SingleChildRenderObjectWidget).child;
      if (child is Text) {
        return child.style;
      }
    }

    return null;
  }
}

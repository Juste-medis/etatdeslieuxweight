// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class TextFieldLabelWrapper extends StatelessWidget {
  const TextFieldLabelWrapper({
    super.key,
    this.labelText,
    this.enabled,
    this.label,
    this.labelStyle,
    required this.inputField,
  });
  final bool? enabled;
  final String? labelText;
  final Widget? label;
  final TextStyle? labelStyle;
  final Widget inputField;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label == null)
          Text(
            labelText ?? 'Enter label text',
            style: labelStyle ?? _theme.inputDecorationTheme.floatingLabelStyle,
          )
        else
          label!,
        const SizedBox(height: 8),

        if (enabled == false)
          Stack(
            children: [
              inputField,
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          )
        else
          inputField,
      ],
    );
  }
}

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';

// 🌎 Project imports:
import '../../../../core/helpers/field_styles/field_styles.dart';
import '../../../../widgets/widgets.dart';

class LanguageDropdownWidget extends StatelessWidget {
  const LanguageDropdownWidget({
    super.key,
    this.value,
    this.supportedLanguage = const {},
    this.onChanged,
  });
  final Locale? value;
  final Map<String, Locale> supportedLanguage;
  final void Function(Locale? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);

    final _dropdownStyle = AcnooDropdownStyle(context);

    final _item = supportedLanguage.entries
        .map((item) => DropdownMenuItem<Locale>(
              value: item.value,
              child: buildDropdownTile(context, item: item),
            ))
        .toList();

    final _selectedChild =
        _item.firstWhereOrNull((e) => e.value == value)?.child;

    return Theme(
      data: _theme.copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all<bool?>(false),
          trackVisibility: WidgetStateProperty.all<bool?>(false),
        ),
      ),
      child: DropdownButton2<Locale>(
        underline: const SizedBox.shrink(),
        isDense: true,
        isExpanded: true,
        customButton: OutlinedDropdownButton(child: _selectedChild),
        style: _theme.textTheme.bodyMedium,
        iconStyleData: _dropdownStyle.iconStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
          width: _mqSize.width > 480 ? 150 : null,
        ),
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        value: value,
        items: _item,
        onChanged: onChanged,
      ),
    );
  }
}

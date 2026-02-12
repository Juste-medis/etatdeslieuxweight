import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/field_styles/_dropdown_styles.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:responsive_grid/responsive_grid.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final void Function(dynamic)? onChanged;
  final void Function()? onclose;
  final Widget? customButton;
  final String? buttonTitle;
  final IconData buttonIcon;
  final double? dropdownWidth;
  final double? maxDropdownHeight;
  final Offset? dropdownOffset;
  final EdgeInsets? buttonPadding;
  final Color? buttonBackgroundColor;
  final Color? buttonForegroundColor;
  final bool showScrollbars;
  final bool enableFeedback;
  final BorderSide? buttonBorder;
  final TextStyle? itemTextStyle;
  final double? iconSize;
  final EdgeInsets? itemPadding;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  final bool changeOnlyOnClose;
  dynamic theValue;

  CustomDropdownButton({
    super.key,
    required this.items,
    this.onChanged,
    this.onclose,
    this.customButton,
    this.buttonTitle,
    this.buttonIcon = Icons.arrow_drop_down,
    this.dropdownWidth,
    this.maxDropdownHeight = 425,
    this.dropdownOffset,
    this.buttonPadding,
    this.buttonBackgroundColor,
    this.buttonForegroundColor,
    this.showScrollbars = false,
    this.enableFeedback = true,
    this.buttonBorder,
    this.itemTextStyle,
    this.iconSize = 20,
    this.itemPadding,
    this.changeOnlyOnClose = false,
  });

  void openDropdown() => dropdownKey.currentState?.callTap();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = AcnooDropdownStyle(context);

    return DropdownButton2(
      key: dropdownKey,
      underline: const SizedBox.shrink(),
      customButton: customButton ?? _buildDefaultButton(context, theme),
      dropdownStyleData: _getDropdownStyleData(context, defaultStyle, theme),
      menuItemStyleData: _getMenuItemStyleData(defaultStyle),
      items: _buildMenuItems(theme),
      onChanged: (value) {
        theValue = value;
        if (!changeOnlyOnClose) {
          onChanged!(value);
        }
      },
      onMenuStateChange: (isOpen) {
        if (!isOpen && onclose != null) {
          onclose!();
        }
        if (!isOpen && changeOnlyOnClose && theValue is int) {
          onChanged!(theValue);
        }
      },
    );
  }

  DropdownStyleData _getDropdownStyleData(
    BuildContext context,
    AcnooDropdownStyle defaultStyle,
    ThemeData theme,
  ) {
    return defaultStyle.dropdownStyle.copyWith(
      width:
          dropdownWidth ?? responsiveValue<double>(context, xs: 200, md: 246),
      maxHeight: maxDropdownHeight,
      offset: dropdownOffset ?? const Offset(0, -24),
      scrollbarTheme: showScrollbars ? null : _getScrollbarTheme(theme),
      padding: EdgeInsets.zero,
    );
  }

  MenuItemStyleData _getMenuItemStyleData(AcnooDropdownStyle defaultStyle) {
    return defaultStyle.menuItemStyle.copyWith(padding: EdgeInsets.zero);
  }

  List<DropdownMenuItem<dynamic>> _buildMenuItems(ThemeData theme) {
    final List<DropdownMenuItem<dynamic>> menuItems = [];
    final hasIcon = items.any((item) => item['icon'] != null);

    for (int i = 0; i < items.length; i++) {
      final whithicon = items[i]['icon'] != null;
      menuItems.add(
        DropdownMenuItem<dynamic>(
          value: items[i]['value'],
          child: _DropdownItemWrapper(
            child: ['counterfield', "text"].contains(items[i]['value'])
                ? editUserField(
                    showLabel: false,
                    showplaceholder: true,
                    title: "Nombre",
                    layout: 'row',
                    type: items[i]['value'],
                    placeholder: "",
                    initialvalue: buttonTitle,
                    onChanged: (text) {
                      theValue = text;
                      if (!changeOnlyOnClose) {
                        onChanged!(text);
                      }
                    },
                  )
                : ListTile(
                    onTap: () {
                      theValue = items[i]['value'];
                      onChanged!(items[i]['value']);
                    },
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: (whithicon || !hasIcon) ? 10 : 40,
                    ),
                    leading: whithicon
                        ? Icon(
                            items[i]['icon'],
                            size: iconSize,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    title: Text(
                      items[i]['label'],
                      style:
                          itemTextStyle ??
                          theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
          ),
        ),
      );
    }

    return menuItems;
  }

  Widget _buildDefaultButton(BuildContext context, ThemeData theme) {
    return inventoryActionButton(
      context,
      title: buttonTitle,
      onPressed: openDropdown,
      icon: buttonIcon,
    );
  }

  ScrollbarThemeData _getScrollbarTheme(ThemeData theme) {
    return theme.scrollbarTheme.copyWith(
      thumbVisibility: WidgetStateProperty.all<bool>(false),
      trackVisibility: WidgetStateProperty.all<bool>(false),
    );
  }
}

DropdownMenuItem<String> classicMenuItem({
  required String name,
  required IconData icon,
  required theme,
  required void Function() ontap,
}) {
  return DropdownMenuItem(
    onTap: () {
      ontap();
    },
    value: name,
    child: Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: _DropdownItemWrapper(
        child: ListTile(
          key: ValueKey(icon),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, size: 20),
          title: Text(name),
          titleTextStyle: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onTertiaryContainer,
          ),
        ),
      ),
    ),
  );
}

class _DropdownItemWrapper extends StatelessWidget {
  const _DropdownItemWrapper({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(color: _theme.colorScheme.outline),
        ),
      ),
      child: child,
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/field_styles/_dropdown_styles.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:feather_icons/feather_icons.dart';

class StateOfItemDropDown extends StatelessWidget {
  final GlobalKey<DropdownButton2State> _dropdownKey = GlobalKey();
  StateOfItemDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    final lang = l.S.of(context);

    return DropdownButton2(
      key: _dropdownKey, // Assign the key

      underline: const SizedBox.shrink(),
      customButton:
          inventoryActionButton(context, title: "bon etat", onPressed: () {
        _dropdownKey.currentState?.callTap();
      }),
      dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
        width: responsiveValue<double>(
          context,
          xs: 200,
          md: 246,
        ),
        maxHeight: 425,
        offset: const Offset(0, -24),
        scrollbarTheme: _theme.scrollbarTheme.copyWith(
          thumbVisibility: WidgetStateProperty.all<bool>(false),
          trackVisibility: WidgetStateProperty.all<bool>(false),
        ),
      ),
      menuItemStyleData: _dropdownStyle.menuItemStyle.copyWith(
        customHeights: [60, 48, 48],
        padding: EdgeInsets.zero,
      ),
      items: [
        // Profile Tile
        DropdownMenuItem<String>(
          value: 'user_profile',
          child: _DropdownItemWrapper(
            child: ListTile(
              visualDensity: const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
              contentPadding: EdgeInsets.zero,
              title: const Text('Shahidul Islam'),
              titleTextStyle: _theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              subtitle: const Text('Admin'),
              subtitleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                color: _theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ),

        classicMenuItem(
            theme: _theme,
            name: "Profile",
            icon: FeatherIcons.user,
            ontap: () {}),
        classicMenuItem(
            name: lang.signout,
            theme: _theme,
            icon: FeatherIcons.power,
            ontap: () async {
              simulateScreenTap();
            }),
      ],
      onChanged: (value) async {
        if (value == null) return;
        if (value == 'user_profile') {
          // Handle user profile case
        } else if (value == lang.signout) {
        } else {
          // Handle other cases
        }
      },
    );
  }
}

class MoreActionDropDown extends StatelessWidget {
  const MoreActionDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    final lang = l.S.of(context);

    DropdownMenuItem<String> classicMenuItem(
        {required String name,
        required IconData icon,
        required void Function() ontap}) {
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
              visualDensity: const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon, size: 20),
              title: Text(name),
              titleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: _theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(60),
      child: DropdownButton2(
        underline: const SizedBox.shrink(),
        customButton: Icon(Icons.more),
        dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
          width: responsiveValue<double>(
            context,
            xs: 200,
            md: 246,
          ),
          maxHeight: 425,
          offset: const Offset(0, -24),
          scrollbarTheme: _theme.scrollbarTheme.copyWith(
            thumbVisibility: WidgetStateProperty.all<bool>(false),
            trackVisibility: WidgetStateProperty.all<bool>(false),
          ),
        ),
        menuItemStyleData: _dropdownStyle.menuItemStyle.copyWith(
          customHeights: [60, 48, 48],
          padding: EdgeInsets.zero,
        ),
        items: [
          // Profile Tile
          DropdownMenuItem<String>(
            value: 'user_profile',
            child: _DropdownItemWrapper(
              child: ListTile(
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                contentPadding: EdgeInsets.zero,
                title: const Text('Shahidul Islam'),
                titleTextStyle: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                subtitle: const Text('Admin'),
                subtitleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                  color: _theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ),

          classicMenuItem(
              name: "Profile", icon: FeatherIcons.user, ontap: () {}),
          classicMenuItem(
              name: lang.signout,
              icon: FeatherIcons.power,
              ontap: () async {
                simulateScreenTap();
              }),
        ],
        onChanged: (value) async {
          if (value == null) return;
          if (value == 'user_profile') {
            // Handle user profile case
          } else if (value == lang.signout) {
          } else {
            // Handle other cases
          }
        },
      ),
    );
  }
}

class _DropdownItemWrapper extends StatelessWidget {
  const _DropdownItemWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: _theme.colorScheme.outline,
          ),
        ),
      ),
      child: child,
    );
  }
}

DropdownMenuItem<String> classicMenuItem(
    {required String name,
    required IconData icon,
    required theme,
    required void Function() ontap}) {
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
          visualDensity: const VisualDensity(
            horizontal: -4,
            vertical: -4,
          ),
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

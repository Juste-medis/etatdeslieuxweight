part of '_topbar.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({super.key});

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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
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
        customButton: _buildButton(context),
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
          customHeights: [60, 48],
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
                contentPadding: EdgeInsets.only(bottom: 10, left: 16),
                title:
                    Text('${appStore.userFirstName} ${appStore.userLastName}'),
                titleTextStyle: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                subtitle: Text('${getUserTypeName(appStore.userType)}'),
                subtitleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                  color: _theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ),

          classicMenuItem(
              name: lang.signout,
              icon: FeatherIcons.power,
              ontap: () async {
                simulateScreenTap();
              }),
        ],
        onChanged: (value) async {
          if (value == null) return;
          if (value == lang.signout) {
            final confirmed = await showAwesomeConfirmDialog(
              context: context,
              title: '${lang.signmeout} ',
              description:
                  '${lang.youwillbeloggedout}. ${lang.doyouwantToproceed}',
            );
            if (confirmed ?? false) {
              await logout(context).whenComplete(() {});
            }
          } else {
            context.go(
              '/users/user-profile',
            );
          }
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final _size = constraints.biggest;
        return SizedBox.square(
          dimension: _size.height / 2,
          child: AvatarWidget(
            imagePath:
                'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_02.jpeg',
          ),
        );
      },
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

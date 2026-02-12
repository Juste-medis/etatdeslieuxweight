part of '_topbar.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    final lang = l.S.of(context);
    final wizardState = context.watch<AppThemeProvider>();

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
              title: Text(
                name,
                maxLines: 1,
              ),
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
            xs: 250,
            md: 300,
          ),
          maxHeight: 425,
          offset: const Offset(0, -24),
          scrollbarTheme: _theme.scrollbarTheme.copyWith(
            thumbVisibility: WidgetStateProperty.all<bool>(false),
            trackVisibility: WidgetStateProperty.all<bool>(false),
          ),
        ),
        menuItemStyleData: _dropdownStyle.menuItemStyle.copyWith(
          customHeights: [48, 48],
          padding: EdgeInsets.zero,
        ),
        items: [
          classicMenuItem(
              name:
                  '${wizardState.currentUser.firstName} ${wizardState.currentUser.lastName}',
              icon: Icons.person_4_outlined,
              ontap: () async {
                simulateScreenTap();
              }),
          classicMenuItem(
              name: lang.signout,
              icon: Icons.power_settings_new_rounded,
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
              confirmText: "Continuer".tr,
              cancelText: "Annuler".tr,
              description:
                  "La deconnexion entraînera la perte irréversible des états des lieux non synchronisés. Voulez-vous poursuivre ?"
                      .tr,
            );
            if (confirmed ?? false) {
              Jks.checkingAuth = false;
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
            imagePath: 'assets/images/static_images/placeholder_avatar_02.svg',
          ),
        );
      },
    );
  }
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
          bottom: BorderSide(
            color: _theme.colorScheme.outline,
          ),
        ),
      ),
      child: child,
    );
  }
}

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/providers/_theme_provider.dart';
import 'package:nb_utils/nb_utils.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/fuctions/_get_image.dart';
import 'package:provider/provider.dart';
import '../../core/app_config/app_config.dart';

class UserProfileDetailsWidget extends StatelessWidget {
  const UserProfileDetailsWidget({
    super.key,
    required double padding,
    required this.theme,
    required this.textTheme,
  }) : _padding = padding;

  final double _padding;
  final ThemeData theme;
  final TextTheme textTheme;

  Widget _buildProfileDetailRow(
    String label,
    String value, {
    int titleFlex = 4,
    int valueFlex = 4,
    bool inLine = false,
  }) {
    final isDeskotp = Jks.context!.width() > 600;
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: (isDeskotp || inLine)
          ? Row(
              children: [
                Expanded(
                  flex: titleFlex,
                  child: Text(
                    label,
                    style: textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Expanded(
                  flex: valueFlex,
                  child: Row(
                    children: [
                      Text(':', style: textTheme.bodyMedium),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppThemeProvider appstate = context.watch<AppThemeProvider>();

    final lang = l.S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: context.height() * .2,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: context.primaryColor),
          child: const AnimageWidget(
            imagePath: AppConfig.logowhite,
            fit: BoxFit.contain,
            height: 100,
            width: 100,
          ).withWidth(double.infinity),
        ),
        Padding(
          padding: EdgeInsets.all(_padding),
          child: Container(
            padding: EdgeInsets.all(_padding),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.outline,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileDetailRow(
                  lang.fullName,
                  '${appstate.currentUser.firstName} ${appstate.currentUser.lastName}',
                ),
                Divider(color: theme.colorScheme.outline, height: 1),
                _buildProfileDetailRow(
                  lang.email,
                  "${appstate.currentUser.email}",
                ),
                Divider(color: theme.colorScheme.outline, height: 0.0),
                _buildProfileDetailRow(
                  lang.phoneNumber,
                  "${appstate.currentUser.phoneNumber}",
                ),
                Divider(color: theme.colorScheme.outline, height: 0.0),
                _buildProfileDetailRow(
                  lang.registrationDate,
                  DateFormat('dd-MM-yyyy')
                      .format(
                        (appstate.currentUser.createdAt ?? DateTime.now()),
                      )
                      .toString(),
                ),
              ],
            ),
          ),
        ),
        10.height,
        Text(
          "Soldes".tr,
          style: textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ).paddingLeft(_padding),
        Padding(
          padding: EdgeInsets.all(_padding),
          child: Container(
            padding: EdgeInsets.all(_padding),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.outline,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileDetailRow(
                  "Procurations + Etat des lieux".tr,
                  '${appstate.currentUser.balance?.procurement ?? 0}',
                  titleFlex: 5,
                  valueFlex: 1,
                  inLine: true,
                ),
                Divider(color: theme.colorScheme.outline, height: 1),
                _buildProfileDetailRow(
                  "Etat des lieux simple".tr.tr,
                  '${appstate.currentUser.balance?.simple ?? 0}',
                  titleFlex: 5,
                  valueFlex: 1,
                  inLine: true,
                ),
                //bouton voir mes transactions
                Divider(color: theme.colorScheme.outline, height: 0.0),
                15.height,
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.push('/transactions');
                    },
                    child: Text("Voir mes transactions".tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const (String,) _userProfile = (
  'assets/images/static_images/background_images/background_image_08.png',
);

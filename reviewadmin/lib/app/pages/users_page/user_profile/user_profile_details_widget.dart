// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/providers/_theme_provider.dart';
import 'package:nb_utils/nb_utils.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/fuctions/_get_image.dart';
import 'package:provider/provider.dart';
import '../../../core/app_config/app_config.dart';

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

  Widget _buildProfileDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(
                  ':',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
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
          decoration: BoxDecoration(
            color: context.primaryColor,
          ),
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
                _buildProfileDetailRow(lang.fullName,
                    '${appstate.currentUser.firstName} ${appstate.currentUser.lastName}'),
                Divider(color: theme.colorScheme.outline, height: 1),
                _buildProfileDetailRow(
                    lang.email, "${appstate.currentUser.email}"),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(
                    lang.phoneNumber, "${appstate.currentUser.phoneNumber}"),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(
                    lang.registrationDate,
                    DateFormat('dd-MM-yyyy')
                        .format((appstate.currentUser.createdAt!))
                        .toString()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const (String,) _userProfile =
    ('assets/images/static_images/background_images/background_image_08.png',);

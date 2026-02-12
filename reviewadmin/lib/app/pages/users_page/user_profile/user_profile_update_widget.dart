// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/theme/theme.dart';
import 'package:jatai_etadmin/app/providers/_theme_provider.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../widgets/file_input_field/_file_input_field.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';

class UserProfileUpdateWidget extends StatelessWidget {
  const UserProfileUpdateWidget({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  Widget _buildTextFormField({
    required String initialValue,
    required bool obscureText,
  }) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscureText,
      decoration: const InputDecoration(),
    );
  }

  Widget _buildRow({
    required String label,
    required String initialValue,
    required bool obscureText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyLarge,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          flex: 2,
          child: _buildTextFormField(
            initialValue: initialValue,
            obscureText: obscureText,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    AppThemeProvider appstate = context.watch<AppThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        editUserField(
          initialvalue: appstate.currentUser.lastName ?? '',
          title: "Nom".tr,
          onChanged: (text) {
            appstate.formValues['user_lastName'] = text;
          },
          required: true,
        ),
        editUserField(
          initialvalue: appstate.currentUser.firstName ?? '',
          title: "Prénom".tr,
          onChanged: (text) {
            appstate.formValues['user_firstName'] = text;
          },
          required: true,
        ),
        editUserField(
          initialvalue: appstate.currentUser.email ?? '',
          title: "Email".tr,
          onChanged: (text) {
            appstate.formValues['user_email'] = text;
          },
          required: true,
        ),
        editUserField(
          initialvalue: appstate.currentUser.phoneNumber ?? '',
          title: "Téléphone".tr,
          onChanged: (text) {
            appstate.formValues['user_phone'] = text;
          },
          required: true,
        ),
        editUserField(
          textEditingController: TextEditingController(
              text: appstate.formValues['user_address'] ??
                  appstate.currentUser.address),
          initialvalue: appstate.currentUser.address ?? '',
          title:
              "Adresse *${appstate.currentUser.address}* ${appstate.formValues['user_address']}"
                  .tr,
          type: "place",
          onChanged: (text) {
            appstate.formValues['user_address'] = text;
          },
          required: true,
        ),
        editUserField(
          textEditingController: TextEditingController(
            text: DateFormat('dd/MM/yyyy').format(
                appstate.formValues['dob'] != null
                    ? DateTime(appstate.formValues['dob'])
                    : DateTime.now()),
          ),
          initialvalue: appstate.currentUser.dob ?? '',
          title: "Date de naissance".tr,
          type: "date",
          onChanged: (text) {
            myprint(text);
            appstate.formValues['user_birthDate'] = text;
          },
          required: true,
        ),
        editUserField(
          initialvalue: appstate.currentUser.placeOfBirth ?? '',
          title: "Lieu de naissance".tr,
          onChanged: (text) {
            appstate.formValues['user_placeOfBirth'] = text;
          },
          required: true,
        ),
        editUserField(
          type: "password",
          initialvalue: appstate.currentUser.placeOfBirth ?? '',
          title: "Mot de passe actuel".tr,
          onChanged: (text) {
            appstate.formValues['user_currentPassword'] = text;
          },
        ),
        editUserField(
          type: "password",
          initialvalue: appstate.currentUser.placeOfBirth ?? '',
          title: "Nouveau mot de passe".tr,
          onChanged: (text) {
            appstate.formValues['user_newPassword'] = text;
          },
        ),
        editUserField(
          type: "password",
          initialvalue: appstate.currentUser.placeOfBirth ?? '',
          title: "Confirmer le mot de passe".tr,
          onChanged: (text) {
            appstate.formValues['user_confirmPassword'] = text;
          },
        ),
        const SizedBox(height: 34),
        ElevatedButton.icon(
          label: Text(
            lang.save,
            //'Save Changes',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          onPressed: appstate.loading
              ? null
              : () {
                  appstate.updateUserProfile();
                },
        ),
        50.height,
        ElevatedButton.icon(
          icon: const Icon(Icons.delete_outlined),
          onPressed: () async {
            final confirmed = await showAwesomeConfirmDialog(
              context: context,
              title: 'Supprimer le compte',
              description: 'Etes-vous sûr de vouloir supprimer votre compte ?',
            );
            if (confirmed ?? false) {}
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.primaryColor.withOpacity(0.15),
            foregroundColor: context.primaryColor,
            shadowColor: Colors.transparent,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            textStyle: context.theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            elevation: 0,
          ),
          label: Text("Supprimer mon compte".tr,
              style: context.theme.textTheme.bodyLarge),
        ).withWidth(double.infinity),
      ],
    );
  }
}

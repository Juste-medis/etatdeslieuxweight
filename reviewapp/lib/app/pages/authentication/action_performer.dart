import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class ActionPerformer extends StatefulWidget {
  final String? action;
  const ActionPerformer({super.key, this.action});

  @override
  State<ActionPerformer> createState() => _ActionPerformerState();
}

class _ActionPerformerState extends State<ActionPerformer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(ActionPerformer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.action != widget.action) {
      performeMyTask();
    }
  }

  void performeMyTask() async {
    await Future.delayed(const Duration(seconds: 1));

    if (widget.action == "logout") {
      final confirmed = await showAwesomeConfirmDialog(
        context: context,
        title: "Déconnexion".tr,
        confirmText: "Continuer".tr,
        cancelText: "Annuler".tr,
        description: "Êtes-vous sûr de vouloir vous déconnecter ?".tr,
      );
      if (confirmed ?? false) {
        await logout(context).whenComplete(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ).withHeight(MediaQuery.of(context).size.height),
    );
  }
}

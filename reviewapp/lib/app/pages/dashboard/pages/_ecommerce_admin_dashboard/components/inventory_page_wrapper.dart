// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/providers/_theme_provider.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class InventoryPageWraper extends StatefulWidget {
  const InventoryPageWraper({super.key, required this.child});

  final Widget child;

  @override
  State<InventoryPageWraper> createState() => _InventoryPageWraperState();
}

class _InventoryPageWraperState extends State<InventoryPageWraper> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLargeSidebarExpaned = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: wizardState.isDarkTheme
          ? theme.colorScheme.surface
          : theme.colorScheme.onPrimary,
      floatingActionButton: Jks.canEditReview == "canEditReview"
          ? SizedBox(
              width: 320,
              child: ElevatedButton.icon(
                onPressed: wizardState.edited
                    ? () {
                        Jks.quietsavereview = false;
                        Jks.savereviewStep();
                      }
                    : null,
                icon: const Icon(Icons.save),
                label: Text("Enrégistrer les modifications".tr),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Expanded(
            child: rf.ResponsiveRowColumn(
              layout: rf.ResponsiveRowColumnType.ROW,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                rf.ResponsiveRowColumnItem(
                  rowFit: FlexFit.tight,
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

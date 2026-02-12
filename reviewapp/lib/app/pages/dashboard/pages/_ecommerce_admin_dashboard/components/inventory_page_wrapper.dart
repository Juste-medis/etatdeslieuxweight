// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/providers/_theme_provider.dart';

import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:provider/provider.dart';

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

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && result == null) {
          Jks.savereviewStep = () async {};
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: wizardState.isDarkTheme
            ? theme.colorScheme.surface
            : theme.colorScheme.onPrimary,
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
      ),
    );
  }
}

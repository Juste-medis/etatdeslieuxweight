// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../core/static/static.dart';
import '../../core/theme/theme.dart';
import 'components/_components.dart';
import 'models/models.dart';

class ShellRouteWrapper extends StatefulWidget {
  const ShellRouteWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<ShellRouteWrapper> createState() => _ShellRouteWrapperState();
}

class _ShellRouteWrapperState extends State<ShellRouteWrapper> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLargeSidebarExpaned = true;

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    final isLaptop = false;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor:
          isDark ? AcnooAppColors.kDark1 : AcnooAppColors.kPrimary50,
      drawer: mqSize.width > 1240 ? null : buildSidebar(isLaptop),
      body: rf.ResponsiveRowColumn(
        layout: rf.ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rf.ResponsiveRowColumnItem(
            rowFit: FlexFit.tight,
            child: rf.ResponsiveRowColumn(
              layout: rf.ResponsiveRowColumnType.COLUMN,
              children: [
                // Static Topbar
                rf.ResponsiveRowColumnItem(
                  child: buildTopbar(isLaptop),
                ),
                rf.ResponsiveRowColumnItem(
                  columnFit: FlexFit.tight,
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildTopbar(bool isLaptop) {
    if (isLaptop) scaffoldKey.currentState?.closeDrawer();
    return TopBarWidget(
      onMenuTap: () {
        if (isLaptop) {
          setState(() => isLargeSidebarExpaned = !isLargeSidebarExpaned);
        } else {
          return scaffoldKey.currentState?.openDrawer();
        }
      },
    );
  }

  Widget buildSidebar(bool isExpanded) {
    return SideBarWidget(
      rootScaffoldKey: scaffoldKey,
      iconOnly: isExpanded,
    );
  }
}

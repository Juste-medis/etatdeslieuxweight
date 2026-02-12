// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/pages/settings/priceSettings.dart';
import 'package:jatai_etadmin/app/providers/_settings_provider.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/fuctions/helper_functions.dart';
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  final String section = "settings";
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );

    return Consumer<SettingsProvider>(
      builder: (context, appTheme, child) {
        Jks.settingState = appTheme;
        Jks.context = context;
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(_padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.fromSize(
                  size: Size.fromHeight(_mqSize.height * 0.9),
                  child: TabUnderline(
                    theme: _theme,
                    textTheme: _textTheme,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TabUnderline extends StatefulWidget {
  const TabUnderline({super.key, required this.theme, required this.textTheme});
  final ThemeData theme;
  final TextTheme textTheme;
  @override
  State<TabUnderline> createState() => _TabUnderlineState();
}

class _TabUnderlineState extends State<TabUnderline>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(_onTabChanged);
    Jks.settingState.fetchPlans(refresh: true);
  }

  void _onTabChanged() {
    setState(() {
      _selectedTitle = _title[_tabController.index];
    });
    switch (_tabController.index) {
      case 0:
        Jks.settingState.fetchPlans(refresh: true);
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      default:
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _selectedTitle = 'Home';
  List<String> get _title => [
        "Plans er prix".tr,
        // l.S.current.home,
        // l.S.current.details,
        // l.S.current.profile,
      ];
  @override
  Widget build(BuildContext context) {
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    return Consumer<SettingsProvider>(builder: (context, formState, child) {
      return ShadowContainer(
        customHeader: TabBar(
          splashBorderRadius: BorderRadius.circular(12),
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          indicatorColor: AcnooAppColors.kPrimary600,
          indicatorWeight: 2.0,
          dividerColor: widget.theme.colorScheme.outline,
          unselectedLabelColor: widget.theme.colorScheme.onTertiary,
          onTap: (_) => setState(
            () => _selectedTitle = _title[_],
          ),
          tabs: _title
              .map(
                (e) => Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _padding / 2,
                    ),
                    child: Text(e),
                  ),
                ),
              )
              .toList(),
        ),
        decoration: BoxDecoration(
            color: widget.theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PriceSettings(
                    section: "section",
                  ),
                  // TabBarData(
                  //   textTheme: widget.textTheme,
                  //   theme: widget.theme,
                  // ),
                  // TabBarData(
                  //   textTheme: widget.textTheme,
                  //   theme: widget.theme,
                  // ),
                  // TabBarData(
                  //   textTheme: widget.textTheme,
                  //   theme: widget.theme,
                  // ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class TabBarData extends StatelessWidget {
  const TabBarData({
    super.key,
    required this.theme,
    required this.textTheme,
  });

  final ThemeData theme;
  final TextTheme textTheme;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Contenu en cours de développement...',
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

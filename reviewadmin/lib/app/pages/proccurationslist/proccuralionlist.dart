// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:jatai_etadmin/app/core/helpers/fuctions/helper_functions.dart';
import 'package:jatai_etadmin/app/core/helpers/helpers.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/providers/_proccuration_provider.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/theme/theme.dart';
import '../../widgets/widgets.dart';
import 'package:provider/provider.dart';

part '_proccuration_list.dart';

class ProccurationList extends StatefulWidget {
  final String status;

  const ProccurationList({super.key, this.status = "all"});

  @override
  State<ProccurationList> createState() => _ProccurationListState();
}

class _ProccurationListState extends State<ProccurationList>
    with TickerProviderStateMixin {
  late TextEditingController searchController;
  final ScrollController scrollController = ScrollController();
  late final messageEditingController = TextEditingController();
  late FocusNode msgFocus;
  late final _tabController = TabController(length: 3, vsync: this);

  late AppThemeProvider wizardState;
  late ReviewProvider reviewstate;
  late ProccurationProvider proccurationstate;

  @override
  void initState() {
    super.initState();

    getProccurations();
    Jks.canEditProccuration = "canEditProccuration";

    searchController = TextEditingController()..addListener(filterUsers);
    msgFocus = FocusNode()
      ..addListener(() {
        if (msgFocus.hasFocus) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        filterUsersByTab(_tabController.index);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
    reviewstate = context.watch<ReviewProvider>();
    proccurationstate = context.watch<ProccurationProvider>();
    Jks.reviewState = reviewstate;
    Jks.wizardState = wizardState;
    Jks.proccurationState = proccurationstate;
  }

  @override
  void didUpdateWidget(ProccurationList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if status changed, and reload reviews if it did
    if (oldWidget.status != widget.status) {
      getProccurations();
    }
  }

  void getProccurations() async {
    await Future.delayed(const Duration(seconds: 1));

    proccurationstate.fetchProccurations(refresh: true, type: "mine");
    Jks.proccurationState = proccurationstate;
  }

  @override
  void dispose() {
    searchController.dispose();
    msgFocus.dispose();
    messageEditingController.dispose();
    scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void filterUsers() {
    final query = searchController.text.toLowerCase();
    proccurationstate.filtering = {
      'q': query.isEmpty ? null : query,
      'status': widget.status == "all" ? null : widget.status,
    };
    proccurationstate.fetchProccurations();
  }

  void filterUsersByTab(int tabIndex) {
    var status = ["mine", "guess", "all"][tabIndex];
    proccurationstate.filtering = {'status': status};
    proccurationstate.fetchProccurations(refresh: true, type: status);
  }

  @override
  Widget build(BuildContext context) {
    final sizeInfo = _getSizeInfo(context);

    return Consumer<ProccurationProvider>(
      builder: (context, lang, child) {
        Jks.context = context;
        return Padding(
            padding: sizeInfo.padding / 1.5,
            child: Center(child: _buildTabBarAndUserList()));
      },
    );
  }

  Widget _buildTabBarAndUserList() {
    return Scaffold(
      body: UserList(
        filteredUsers: proccurationstate.proccurations,
        searchController: searchController,
        onUserTap: (user) {},
        tabController: _tabController,
      ),
    );
  }

  _SizeInfo _getSizeInfo(BuildContext context) {
    return rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
            start: 0,
            end: 599,
            value: _SizeInfo(
                alertFontSize: 12,
                padding: EdgeInsets.all(16),
                innerSpacing: 16)),
        const rf.Condition.between(
            start: 600,
            end: 1023,
            value: _SizeInfo(
                alertFontSize: 16,
                padding: EdgeInsets.all(20),
                innerSpacing: 20)),
        const rf.Condition.between(
            start: 1024,
            end: 9999,
            value: _SizeInfo(
                alertFontSize: 18,
                padding: EdgeInsets.all(24),
                innerSpacing: 24)),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
  }
}

class _SizeInfo {
  final double alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;

  const _SizeInfo({
    this.alertFontSize = 16,
    this.padding = EdgeInsets.zero,
    this.innerSpacing = 8.0,
  });
}

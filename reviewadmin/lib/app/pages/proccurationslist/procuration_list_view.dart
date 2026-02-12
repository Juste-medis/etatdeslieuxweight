import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/core/theme/theme.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/pages/pages.dart';
import 'package:jatai_etadmin/app/pages/proccuration/proccuration_detail.dart';
import 'package:jatai_etadmin/app/pages/reviewlist/_pagination_widget.dart';
import 'package:jatai_etadmin/app/pages/reviewlist/_topbar.dart';
import 'package:jatai_etadmin/app/providers/_proccuration_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../providers/providers.dart';

class ListProccuration extends StatefulWidget {
  final String status;
  const ListProccuration({
    super.key,
    this.status = "all",
  });

  @override
  State<ListProccuration> createState() => _ListProccurationState();
}

class _ListProccurationState extends State<ListProccuration>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late AppThemeProvider wizardState;
  late ReviewProvider reviewstate;
  late ProccurationProvider proccurationstate;

  late final scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getProccurations();
    Jks.canEditProccuration = "canEditProccuration";
    _tabController = TabController(length: 4, vsync: this);
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
  void didUpdateWidget(ListProccuration oldWidget) {
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

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: Durations.medium3,
      curve: Curves.easeInToLinear,
    );
  }

  int showPerPage = 10;

  @override
  void dispose() {
    scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _ontabChanged(int index) {
    scrollToTop();
    proccurationstate.setFilter(
      {
        "progress": defaultReviewStatus.keys.elementAt(index),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    Jks.proccurationState = proccurationstate;
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDesktop = _mqSize.width >= 600;

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      md: _isDesktop ? 24 : 16,
      lg: 24,
    );
    return Scaffold(
      backgroundColor: _theme.colorScheme.primaryContainer,
      key: scaffoldKey,
      body: ScrollbarTheme(
        data: const ScrollbarThemeData(),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsetsDirectional.all(_padding / 2.5),
          child: ResponsiveGridRow(
            children: [
              ResponsiveGridCol(
                lg: 12,
                md: 12,
                child: Padding(
                  padding: _isDesktop
                      ? EdgeInsetsDirectional.fromSTEB(
                          0,
                          0,
                          _padding / 2.5,
                          _padding / 2.5,
                        )
                      : EdgeInsets.all(_padding / 2.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Liste des procurations".tr,
                          style: boldTextStyle(
                            size: 22,
                            color: _theme.colorScheme.onPrimaryContainer,
                          )),
                      10.height,
                      Row(children: [
                        !isDesktop
                            ? Expanded(
                                child: TabBar(
                                  indicatorPadding: EdgeInsets.zero,
                                  splashBorderRadius: BorderRadius.circular(12),
                                  isScrollable: false,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  controller: _tabController,
                                  indicatorColor: AcnooAppColors.kPrimary600,
                                  indicatorWeight: 2.0,
                                  dividerColor: Colors.transparent,
                                  unselectedLabelColor:
                                      _theme.colorScheme.onTertiary,
                                  onTap: _ontabChanged,
                                  tabs: defaultReviewStatus.keys
                                      .map(
                                        (e) => Tab(
                                          child: Text(
                                            defaultReviewStatus[e] ?? e,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: _theme.textTheme.bodySmall!
                                                .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                            : Expanded(
                                child: TabBar(
                                  indicatorPadding: EdgeInsets.zero,
                                  splashBorderRadius: BorderRadius.circular(12),
                                  isScrollable: true,
                                  tabAlignment: TabAlignment.start,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  controller: _tabController,
                                  indicatorColor: AcnooAppColors.kPrimary600,
                                  indicatorWeight: 2.0,
                                  dividerColor: Colors.transparent,
                                  unselectedLabelColor:
                                      _theme.colorScheme.onTertiary,
                                  onTap: _ontabChanged,
                                  tabs: defaultReviewStatus.keys
                                      .map(
                                        (e) => Tab(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: _padding / 2,
                                            ),
                                            child: Text(
                                              defaultReviewStatus[e] ?? e,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: _theme.textTheme.bodySmall!
                                                  .copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                      ]),
                      SizedBox(height: _padding / 2.5),
                      //les filtreur par type daterange et status
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Topbar(
                                scaffoldKey: scaffoldKey,
                                showDesktop: _isDesktop,
                                perPage: showPerPage,
                                onFilterChange: (v) {
                                  if (v != null) {
                                    if (v.isNotEmpty) {
                                      proccurationstate.setFilter(
                                        {
                                          "q": v,
                                        },
                                      );
                                    } else {
                                      proccurationstate.setFilter(null);
                                    }
                                  }
                                },
                              )),
                          Expanded(
                            flex: 1,
                            child: editUserField(
                              showplaceholder: true,
                              showLabel: false,
                              title: "Filtrer par date",
                              placeholder: "Filtrer par date",
                              textEditingController: TextEditingController(
                                text: proccurationstate.filtering != null &&
                                        proccurationstate.filtering!
                                            .containsKey("dateRange")
                                    ? proccurationstate.filtering!["dateRange"]
                                        .toString()
                                    : "",
                              ),
                              type: "daterange",
                              initialvalue: widget.status,
                              onChanged: (v) {
                                if (v != null) {
                                  proccurationstate.setFilter(
                                    {
                                      "dateRange": v,
                                    },
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      // 16.width,

                      Stack(children: [
                        if (proccurationstate.proccurations.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.list_alt,
                                    size: 48,
                                    color: _theme.colorScheme.outline),
                                const SizedBox(height: 16),
                                Text(
                                  "Aucune procuration trouvée".tr,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Aucune procuration ${(proccurationstate.filtering != null && proccurationstate.filtering != null) ? "ne correspond à vos critères de recherche" : "n'a encore été créé"}"
                                      .tr,
                                  style: _theme.textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ).center(),
                          )
                        else
                          SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
                                    scrollbars: false,
                                  ),
                                  child: Column(
                                    children: proccurationstate.proccurations
                                        .asMap()
                                        .entries
                                        .map(
                                          (proc) => ProcurementRow(
                                            from: "list",
                                            index: proc.key,
                                            procuration: proc.value,
                                            onTap: () {
                                              seeProcuration(
                                                  proccuration: proc.value,
                                                  context: context);
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ))),
                        if (proccurationstate.isLoading)
                          Positioned.fill(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: Container(
                                color: _theme.colorScheme.primaryContainer
                                    .withAlpha(150),
                                child: const Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    height: 4,
                                    width: double.infinity,
                                    child: LinearProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ]),
                      SizedBox(
                        width: double.maxFinite,
                        child: Align(
                          child: PaginationWidget(
                            currentPage: proccurationstate.currentPage,
                            totalItem:
                                proccurationstate.totalPages * showPerPage,
                            perPage: showPerPage,
                            onPagePress: (page) => _handlePageChange(
                              page,
                              proccurationstate,
                            ),
                            onNextPressed: (page) => _handlePageChange(
                              page,
                              proccurationstate,
                            ),
                            onPreviousPressed: (page) => _handlePageChange(
                              page,
                              proccurationstate,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePageChange(int page, ProccurationProvider notifier) {
    scrollToTop();
    notifier.fetchProccurations(page: page);
  }
}

class ProcurementRow extends StatelessWidget {
  final Procuration procuration;
  final VoidCallback onTap;
  final int index;
  final String from;

  const ProcurementRow({
    super.key,
    required this.procuration,
    required this.onTap,
    this.from = "dashboard",
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<AppThemeProvider>();
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      key: ValueKey(procuration.id),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: wizardState.isDarkTheme
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Adresse du bien
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 16),
                      if (!isMobile)
                        Text(
                          procuration.propertyDetails?.address ??
                              'Adresse non renseignée',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                // Auteur
                Expanded(
                  flex: 2,
                  child: _buildAuthorWidget(theme, context, isMobile: isMobile),
                ),

                // Date de création
                Expanded(
                  flex: 1,
                  child: Text(
                    _formatDate(procuration.createdAt),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),

                // Statut avec badge
                Expanded(
                  flex: 1,
                  child: _buildStatusBadge(theme),
                ),

                // Pourcentage de complétion
                Expanded(
                  flex: 1,
                  child: _buildCompletionPercentage(theme),
                ),

                // Indicateur Nouveau
                Expanded(
                  flex: 1,
                  child: _buildNewIndicator(theme),
                ),

                // Indicateur de crédité
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.monetization_on,
                    color: procuration.credited == true
                        ? Colors.green
                        : Colors.grey,
                    size: 20,
                  ),
                ),

                // Bouton d'action
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(0),
                          ),
                        ),
                        builder: (context) => Wrap(
                          children: [
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              title: Text(
                                  procuration.propertyDetails?.address ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 18,
                                      )),
                              subtitle: Text(
                                'Que souhaitez-vous faire ?',
                                style: Theme.of(context).textTheme.bodySmall,
                              ).paddingTop(12),
                            ).paddingTop(16),
                            if (procuration.meta?["signaturesMeta"] != null &&
                                procuration.meta?["signaturesMeta"]
                                        ?["allSigned"] ==
                                    true)
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                leading: const Icon(Icons.edit),
                                title: Text(
                                    'Voir et télécharger la procuration',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        )),
                                subtitle: Text(
                                  'Télécharger la proccuration signée. Vous pouvez la prévisualiser avant de la télécharger.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                onTap: () {
                                  seeProcuration(
                                      proccuration: procuration,
                                      context: context);
                                },
                              ),
                            proccuration_action_sheet(
                                title: 'Voir ou modifier la procuration',
                                subtitle:
                                    'Modifier l\'état des lieux. Assurez-vous de sauvegarder vos modifications.'
                                        .tr,
                                context: context,
                                proccuration: procuration,
                                onTap: () {
                                  previewProcuration(procuration,
                                      review: procuration, context: context);
                                }),
                          ],
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--/--/--';
    return DateFormat('dd/MM/yy').format(date);
  }

  Widget _buildStatusBadge(ThemeData theme) {
    final status = procuration.status ?? 'draft';
    final statusColor = _getStatusColor(theme, status);
    final statusText = getStatusText(status).toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCompletionPercentage(ThemeData theme) {
    final isCompleted = procuration.status == 'completed';
    final percentage = isCompleted
        ? "100%"
        : "${procuration.meta?["fillingPercentage"] ?? 0}%";

    return Text(
      percentage,
      style: theme.textTheme.bodySmall?.copyWith(
        color: isCompleted ? Colors.green : null,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAuthorWidget(
    ThemeData theme,
    BuildContext context, {
    required bool isMobile,
  }) {
    final authorName = procuration.author != null
        ? "${procuration.author?.firstName ?? ''} ${procuration.author?.lastName ?? ''}"
            .trim()
        : 'Auteur inconnu';

    return GestureDetector(
      onTap: procuration.author != null
          ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) => UserInfoDialog(
                  user: InventoryAuthor.fromUser(procuration.author),
                  proccuration: procuration,
                ),
              );
            }
          : null,
      child: isMobile
          ? Icon(
              Icons.person,
              size: 16,
              color: procuration.author != null
                  ? theme.colorScheme.primary
                  : Colors.grey,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          authorName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: procuration.author != null
                                ? theme.colorScheme.primary
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (procuration.author != null) ...[
                        const SizedBox(width: 5),
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNewIndicator(ThemeData theme) {
    final isNew = procuration.createdAt != null &&
        DateTime.now().difference(procuration.createdAt!).inMinutes < 30;

    if (!isNew) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.primary,
      ),
      child: Text(
        "Nouveau".tr.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primaryContainer,
          fontWeight: FontWeight.w600,
          fontSize: 8,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getStatusColor(ThemeData theme, String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'signing':
        return Colors.orange;
      case 'draft':
        return Colors.grey;
      default:
        return theme.colorScheme.primary;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Terminé';
      case 'signing':
        return 'Signature';
      case 'draft':
        return 'Brouillon';
      default:
        return status;
    }
  }
}

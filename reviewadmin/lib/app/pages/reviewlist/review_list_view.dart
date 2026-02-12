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
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../providers/providers.dart';

class DashBoardReviewList extends StatefulWidget {
  final String status;
  const DashBoardReviewList({
    super.key,
    this.status = "all",
  });

  @override
  State<DashBoardReviewList> createState() => _DashBoardReviewListState();
}

class _DashBoardReviewListState extends State<DashBoardReviewList>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late AppThemeProvider wizardState;
  late ReviewProvider reviewstate;

  late final scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getReviews();
    Jks.canEditReview = "canEditReview";
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
    reviewstate = context.watch<ReviewProvider>();
    Jks.reviewState = reviewstate;
    Jks.wizardState = wizardState;
  }

  @override
  void didUpdateWidget(DashBoardReviewList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if status changed, and reload reviews if it did
    if (oldWidget.status != widget.status) {
      getReviews();
    }
  }

  void getReviews() async {
    await Future.delayed(const Duration(seconds: 1));

    reviewstate.fetchReviews(refresh: true, type: widget.status);
    Jks.reviewState = reviewstate;
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
    reviewstate.setFilter(
      {
        "status": defaultReviewStatus.keys.elementAt(index),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDesktop = _mqSize.width >= 992;

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
                      Text("Liste des états des lieux",
                          style: boldTextStyle(
                            size: 22,
                            color: _theme.colorScheme.onPrimaryContainer,
                          )),
                      10.height,
                      Row(children: [
                        isMobile
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
                                                fontSize: 14,
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
                                      reviewstate.setFilter(
                                        {
                                          "q": v,
                                        },
                                      );
                                    } else {
                                      reviewstate.setFilter(null);
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
                                text: reviewstate.filtering != null &&
                                        reviewstate.filtering!
                                            .containsKey("dateRange")
                                    ? reviewstate.filtering!["dateRange"]
                                        .toString()
                                    : "",
                              ),
                              type: "daterange",
                              initialvalue: widget.status,
                              items: defaultReviewStatus,
                              onChanged: (v) {
                                if (v != null) {
                                  reviewstate.setFilter(
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
                        if (reviewstate.reviews.isEmpty)
                          buildReviewEmptyState(_theme)
                        else
                          SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ScrollConfiguration(
                                  behavior:
                                      ScrollConfiguration.of(context).copyWith(
                                    scrollbars: false,
                                  ),
                                  child: Column(
                                    children: reviewstate.reviews
                                        .asMap()
                                        .entries
                                        .map(
                                          (review) => ReviewTableRow(
                                            from: "list",
                                            index: review.key,
                                            review: review.value,
                                            onTap: () {
                                              handleReviewTap(
                                                  context, review.value);
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ))),
                        if (reviewstate.isLoading)
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
                            currentPage: reviewstate.currentPage,
                            totalItem: reviewstate.totalPages * showPerPage,
                            perPage: showPerPage,
                            onPagePress: (page) => _handlePageChange(
                              page,
                              reviewstate,
                            ),
                            onNextPressed: (page) => _handlePageChange(
                              page,
                              reviewstate,
                            ),
                            onPreviousPressed: (page) => _handlePageChange(
                              page,
                              reviewstate,
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

  void _handlePageChange(int page, ReviewProvider notifier) {
    scrollToTop();
    notifier.fetchReviews(page: page);
  }
}

class ReviewTableRow extends StatelessWidget {
  final Review review;
  final VoidCallback onTap;
  final int index;
  final String from;

  const ReviewTableRow({
    super.key,
    required this.review,
    required this.onTap,
    this.from = "dashboard",
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<AppThemeProvider>();
    final theme = Theme.of(context);
    final _isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      key: ValueKey(review.id),
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
        color: review.procuration != null
            ? generateReviewColor(review.procuration?.id ?? "").withAlpha(25)
            : Colors.transparent,
        child: InkWell(
          onTap: () {
            final wizardState = context.read<AppThemeProvider>();
            wizardState.prefillReview(
              review,
            );
            context.push(
              '/review/${review.id}',
              extra: review,
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(
                        review.reviewType == 'entrance'
                            ? Icons.login
                            : Icons.logout,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 16),
                      if (!_isMobile)
                        Text(
                          review.procuration != null
                              ? "Entrée/Sortie"
                              : (review.reviewType == 'entrance'
                                  ? "Entrée".tr
                                  : "Sortie"),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),
                ),

                // Adresse du bien
                Expanded(
                  flex: 2,
                  child: Text(
                    review.propertyDetails!.address!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Auteur
                Expanded(
                  flex: 2,
                  child:
                      _buildAuthorWidget(theme, context, ismobile: _isMobile),
                ),

                // Date de création
                Expanded(
                  flex: 1,
                  child: Text(
                    DateFormat('dd/MM/yy').format(review.createdAt!),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),

                // Statut avec badge
                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(theme, review.status).withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      getStatusText(review.status ?? 'Brouillon').toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(theme, review.status),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // Pourcentage de complétion
                Expanded(
                  flex: 1,
                  child: review.status != 'completed'
                      ? Text(
                          review.meta?["fillingPercentage"] != null
                              ? "${review.meta?["fillingPercentage"]}%"
                              : "0%",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "100%",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),

                // Indicateur Nouveau
                Expanded(
                  flex: 1,
                  child: _buildNewIndicator(theme),
                ),

                // Indicateur de credited
                Expanded(
                    child: Icon(Icons.monetization_on,
                        color: review.credited == true
                            ? Colors.green
                            : Colors.grey,
                        size: 20)),

                // Bouton d'action
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.more_vert,
                        color: theme.colorScheme.primary, size: 20),
                    onPressed: onTap,
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

  Widget _buildAuthorWidget(ThemeData theme, BuildContext context,
      {required bool ismobile}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return UserInfoDialog(
              user: review.author,
              proccuration: review.procuration,
            );
          },
        );
      },
      child: ismobile
          ? Icon(
              Icons.person,
              size: 16,
              color: theme.colorScheme.primary,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "${review.author?.firstname ?? ''} ${review.author?.lastName ?? ''}"
                            .trim(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      5.width,
                      if (review.author != null)
                        Icon(Icons.info_outline,
                            size: 14,
                            color: theme.colorScheme.onPrimaryContainer)
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNewIndicator(ThemeData theme) {
    final isNew = DateTime.now().difference(review.createdAt!).inMinutes < 30;

    if (!isNew) {
      return const SizedBox();
    }

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

  Color _getStatusColor(ThemeData theme, String? status) {
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

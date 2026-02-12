import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/pages/pages.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../providers/providers.dart';
import '_components.dart' as comp;

class DashBoardReviewList extends StatefulWidget {
  final String status;
  const DashBoardReviewList({super.key, this.status = "all"});

  @override
  State<DashBoardReviewList> createState() => _DashBoardReviewListState();
}

class _DashBoardReviewListState extends State<DashBoardReviewList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late AppThemeProvider wizardState;
  late ReviewProvider reviewstate;

  late final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getReviews();
    Jks.canEditReview = "canEditReview";
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

  int filterId = 1;
  int showPerPage = 10;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                lg: 9,
                md: _mqSize.width < 992 ? null : 9,
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
                    children: [
                      SizedBox(height: _padding / 2.5),
                      comp.Topbar(
                        scaffoldKey: scaffoldKey,
                        showDesktop: _isDesktop,
                        perPage: showPerPage,
                        filterId: filterId,
                        onFilterChange: (v) => setState(() => filterId = v!),
                      ),
                      Stack(
                        children: [
                          if (reviewstate.reviews.isEmpty)
                            buildReviewEmptyState(_theme)
                          else
                            SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(
                                  context,
                                ).copyWith(scrollbars: false),
                                child: Column(
                                  children: reviewstate.reviews
                                      .asMap()
                                      .entries
                                      .map(
                                        (review) => ReviewCard(
                                          from: "list",
                                          index: review.key,
                                          review: review.value,
                                          onTap: () => handleReviewTap(
                                            context,
                                            review.value,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
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
                        ],
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Align(
                          child: comp.PaginationWidget(
                            currentPage: reviewstate.currentPage,
                            totalItem: reviewstate.totalPages * showPerPage,
                            perPage: showPerPage,
                            onPagePress: (page) =>
                                _handlePageChange(page, reviewstate),
                            onNextPressed: (page) =>
                                _handlePageChange(page, reviewstate),
                            onPreviousPressed: (page) =>
                                _handlePageChange(page, reviewstate),
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
    notifier.fetchReviews(page: page);
    scrollToTop();
  }
}

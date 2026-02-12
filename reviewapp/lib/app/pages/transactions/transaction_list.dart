import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/core/theme/theme.dart';
import 'package:mon_etatsdeslieux/app/models/_transaction.dart';
import 'package:mon_etatsdeslieux/app/pages/reviewlist/_pagination_widget.dart';
import 'package:mon_etatsdeslieux/app/providers/_payment_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../providers/providers.dart';

class DashBoardTransactionList extends StatefulWidget {
  final String status;
  const DashBoardTransactionList({super.key, this.status = "all"});

  @override
  State<DashBoardTransactionList> createState() =>
      _DashBoardTransactionListState();
}

class _DashBoardTransactionListState extends State<DashBoardTransactionList>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late AppThemeProvider wizardState;
  late PaymentProvider paymentState;

  late final scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getReviews();
    Jks.canEditReview = "canEditReview";
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
    paymentState = context.watch<PaymentProvider>();
    Jks.wizardState = wizardState;
    Jks.paymentState = paymentState;
  }

  @override
  void didUpdateWidget(DashBoardTransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if status changed, and reload reviews if it did
    if (oldWidget.status != widget.status) {
      getReviews();
    }
  }

  void getReviews() async {
    await Future.delayed(const Duration(seconds: 1));

    paymentState.fetchTransactions(refresh: true, type: widget.status);
    Jks.paymentState = paymentState;
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
    paymentState.setFilter({
      "status": transactionsStatus.keys.elementAt(index),
    });
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
                      backbutton(() {
                        context.pop();
                      }),
                      Text(
                        "Liste des transactions".tr,
                        style: boldTextStyle(
                          size: 22,
                          color: _theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      10.height,
                      Row(
                        children: [
                          isMobile
                              ? Expanded(
                                  child: TabBar(
                                    indicatorPadding: EdgeInsets.zero,
                                    splashBorderRadius: BorderRadius.circular(
                                      12,
                                    ),
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
                                    tabs: transactionsStatus.keys
                                        .map(
                                          (e) => Tab(
                                            child: Text(
                                              transactionsStatus[e] ?? e,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: _theme.textTheme.bodySmall,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                              : Expanded(
                                  child: TabBar(
                                    indicatorPadding: EdgeInsets.zero,
                                    splashBorderRadius: BorderRadius.circular(
                                      12,
                                    ),
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
                                    tabs: transactionsStatus.keys
                                        .map(
                                          (e) => Tab(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: _padding / 2,
                                              ),
                                              child: Text(
                                                transactionsStatus[e] ?? e,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style:
                                                    _theme.textTheme.bodySmall,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: _padding / 2.5),
                      //les filtreur par type daterange et status
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: editUserField(
                              showplaceholder: true,
                              showLabel: false,
                              title: "Filtrer par date",
                              placeholder: "Filtrer par date",
                              textEditingController: TextEditingController(
                                text:
                                    paymentState.filtering != null &&
                                        paymentState.filtering!.containsKey(
                                          "dateRange",
                                        )
                                    ? paymentState.filtering!["dateRange"]
                                          .toString()
                                    : "",
                              ),
                              type: "daterange",
                              initialvalue: widget.status,
                              onChanged: (v) {
                                if (v != null) {
                                  paymentState.setFilter({"dateRange": v});
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      // 16.width,
                      Stack(
                        children: [
                          if (paymentState.toString().isEmpty)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.list_alt,
                                    size: 48,
                                    color: _theme.colorScheme.outline,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Vous n'avez pas éffectué des achats".tr,
                                    style: _theme.textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Faites vos premiers achats pour voir vos transactions ici."
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
                                behavior: ScrollConfiguration.of(
                                  context,
                                ).copyWith(scrollbars: false),
                                child: Column(
                                  children: paymentState.transactions
                                      .asMap()
                                      .entries
                                      .map(
                                        (review) => TransactionTableRow(
                                          index: review.key,
                                          transaction: review.value,
                                          onTap: () {
                                            showDetail(context, review.value);
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          if (paymentState.isLoading)
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
                          child: PaginationWidget(
                            currentPage: paymentState.currentPage,
                            totalItem: paymentState.totalPages * showPerPage,
                            perPage: showPerPage,
                            onPagePress: (page) =>
                                _handlePageChange(page, paymentState),
                            onNextPressed: (page) =>
                                _handlePageChange(page, paymentState),
                            onPreviousPressed: (page) =>
                                _handlePageChange(page, paymentState),
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

  void _handlePageChange(int page, PaymentProvider notifier) {
    scrollToTop();
    notifier.fetchTransactions(page: page);
  }
}

void showDetail(BuildContext context, TransactionModel transaction) {
  final theme = Theme.of(context);

  String label;
  final isDebit = transaction.paymentMethod == PaymentMethod.jataiMobile;

  try {
    label = !isDebit
        ? "Achat de credit"
        : transaction.dispersion[0]["type"] == "review"
        ? "Achat d'état des lieux"
        : "Achat de procuration";
  } catch (e) {
    myprint("Error printing dispersion data: $e");
    label = "Achat";
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.primaryContainer,
    builder: (context) {
      return Consumer<PaymentProvider>(
        builder: (context, appTheme, child) {
          Jks.paymentState = appTheme;
          return DraggableScrollableSheet(
            minChildSize: 0.4,
            initialChildSize: isDebit ? 0.55 : 0.7,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        labelText(
                          "Id de la transaction".tr,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          transaction.transactionId ?? 'N/A',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        labelText("Methode de paiement".tr),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              _getPaymentMethodIcon(transaction.paymentMethod),
                              color: theme.colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getPaymentMethodText(transaction.paymentMethod),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        labelText("Date".tr),
                        Text(
                          transaction.createdAt != null
                              ? formatDate(
                                  transaction.createdAt!.toIso8601String(),
                                )
                              : 'N/A',
                          style: theme.textTheme.bodyMedium,
                        ),

                        // Statut du paiement
                        labelText("${isDebit ? "Coût" : "Montant"} total".tr),
                        Text(
                          isDebit
                              ? '- ${transaction.price.round()} credit'
                              : '${transaction.price.toStringAsFixed(2)} €',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _getAmountColor(
                              theme,
                              transaction.totalAmount,
                              isDebit,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // Taxes
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (transaction.tax != null)
                              Text(
                                '${transaction.tax}%',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                            if (transaction.taxAmount != null)
                              Text(
                                '${transaction.taxAmount!.toStringAsFixed(2)}€',
                                style: theme.textTheme.labelSmall,
                              ),
                          ],
                        ),
                        10.height,
                        labelText("Coupon".tr),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (transaction.couponCode != null)
                              Text(
                                transaction.couponCode!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (transaction.couponAmount != null)
                              Text(
                                '-${transaction.couponAmount!.toStringAsFixed(2)}€',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                          ],
                        ),
                        labelText("Statut du paiement".tr),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              theme,
                              transaction.paymentStatus,
                            ).withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusText(
                              transaction.paymentStatus,
                            ).toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _getStatusColor(
                                theme,
                                transaction.paymentStatus,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        20.height,
                        if (!isDebit) ...[
                          TextButton.icon(
                            icon: appTheme.isLoading
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.primary,
                                    ),
                                  )
                                : const Icon(Icons.download),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: appTheme.isLoading
                                ? null
                                : () async {
                                    appTheme.setloading(true);
                                    await getTransactionInvoice(
                                          transaction.transactionId!,
                                        )
                                        .then((res) async {
                                          appTheme.setloading(false);
                                          if (res.status == true) {
                                            downloadWithHttp(
                                              documentUrl(
                                                    res.data["invoice_pdf"] ??
                                                        "",
                                                  ) ??
                                                  "",
                                              fileName:
                                                  "Facture_${transaction.createdAt}.pdf"
                                                      .replaceAll("/", "_")
                                                      .replaceAll("\\", "_")
                                                      .replaceAll(" ", "_"),
                                            );
                                          }
                                        })
                                        .catchError((e) {
                                          my_inspect(e);
                                          toast(e.toString());
                                          appTheme.setloading(false);
                                        });
                                  },
                            label: Text(
                              "Télécharger la facture".tr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}

class TransactionTableRow extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;
  final int index;

  const TransactionTableRow({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<AppThemeProvider>();
    final theme = Theme.of(context);

    //  si c'est un achat le type se trouve ands la premiecre clé de dispersion : review ou procuration

    String label;
    final isDebit = transaction.paymentMethod == PaymentMethod.jataiMobile;

    try {
      label = !isDebit
          ? "Achat de credit"
          : transaction.dispersion[0]["type"] == "review"
          ? "Achat d'état des lieux"
          : "Achat de procuration";
    } catch (e) {
      myprint("Error printing dispersion data: $e");
      label = "Achat";
    }

    return Container(
      key: ValueKey(transaction.transactionId),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: wizardState.isDarkTheme
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
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
                // ID de transaction
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Montant total
                      Text(
                        isDebit
                            ? '- ${transaction.price.round()} credit'
                            : '${transaction.price.toStringAsFixed(2)} €',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _getAmountColor(
                            theme,
                            transaction.totalAmount,
                            isDebit,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Métadonnées (résumé)
                    ],
                  ),
                ),
                //la date de la transaction
                Expanded(
                  flex: 3,
                  child: Text(
                    transaction.createdAt != null
                        ? formatDate(transaction.updatedAt!.toIso8601String())
                        : 'N/A',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _getStatusColor(ThemeData theme, PaymentStatus? status) {
  switch (status) {
    case PaymentStatus.completed:
      return Colors.green;
    case PaymentStatus.pending:
      return Colors.orange;
    case PaymentStatus.failed:
      return Colors.red;
    default:
      return theme.colorScheme.primary;
  }
}

Color _getAmountColor(ThemeData theme, double amount, bool isDebit) {
  if (isDebit) {
    return theme.colorScheme.onSurface;
  }
  if (amount > 0) {
    return Colors.green;
  } else if (amount < 0) {
    return Colors.red;
  } else {
    return theme.colorScheme.onSurface;
  }
}

IconData _getPaymentMethodIcon(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.stripe:
      return Icons.credit_card;
    case PaymentMethod.paypal:
      return Icons.paypal;
    case PaymentMethod.stripeLink:
      return Icons.link;
    default:
      return Icons.payment;
  }
}

String _getPaymentMethodText(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.stripe:
      return 'Stripe';
    case PaymentMethod.paypal:
      return 'Paypal';
    case PaymentMethod.stripeLink:
      return 'Stripe web';
    default:
      return method.toString().split('.').last;
  }
}

String _getStatusText(PaymentStatus? status) {
  switch (status) {
    case PaymentStatus.completed:
      return 'Complété';
    case PaymentStatus.pending:
      return 'En attente';
    case PaymentStatus.failed:
      return 'Échoué';
    default:
      return 'Inconnu';
  }
}

Widget labelText(String text, {TextStyle? style}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Jks.context!.theme.colorScheme.primary,
    ),
  ).paddingTop(16);
}

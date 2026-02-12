// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole3.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_transaction.dart';
import 'package:jatai_etadmin/app/models/_user_model.dart';
import 'package:jatai_etadmin/app/providers/_payment_provider.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import 'package:jatai_etadmin/app/widgets/shadow_container/_shadow_container.dart';
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/helpers.dart';
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';

class POSPurchaseListView extends StatefulWidget {
  final String? couponCode;
  const POSPurchaseListView({super.key, this.couponCode});

  @override
  State<POSPurchaseListView> createState() => _POSPurchaseListViewState();
}

class _POSPurchaseListViewState extends State<POSPurchaseListView> {
  late final List<TransactionModel> _filteredData = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  int _rowsPerPage = 10;
  String _searchQuery = '';
  bool _selectAll = false;
  bool _isLoading = false;
  int totalItems = 0;
  int totalPages = 1;
  double chiffreAffaire = 0.0;

  @override
  void initState() {
    super.initState();
    fetchTransactions(refresh: true);
  }

  void fetchTransactions({bool refresh = false}) async {
    setState(() {
      _isLoading = true;
    });

    if (refresh) {
      _currentPage = 0;
      _rowsPerPage = 10;
      _searchQuery = '';
      _selectAll = false;
    }

    try {
      final response = await getransactions(
          page: _currentPage,
          limit: "$_rowsPerPage",
          filter: {
            "q": _searchQuery,
            "couponCode": widget.couponCode,
          });

      if (response.status == true) {
        _filteredData.clear();

        if (refresh) {
          setState(() {
            _filteredData.clear();
          });
        }
        if (widget.couponCode != null) {
          setState(() {
            chiffreAffaire = response.meta != null &&
                    response.meta!['chiffreAffaire'] != null
                ? double.tryParse(
                        response.meta!['chiffreAffaire'].toString()) ??
                    0.0
                : 0.0;
          });
        }
        setState(() {
          _filteredData.addAll(response.list);
          _isLoading = false;
          totalItems = response.totalItems;
          totalPages = response.totalPages;
        });
      }
    } catch (err) {
      debugPrint('Error fetching users: $err');
      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    final _showingText =
        '${l.S.of(context).showing} ${(_currentPage * _rowsPerPage) + 1} ${l.S.of(context).to} ${(_currentPage * _rowsPerPage) + _filteredData.length} ${l.S.of(context).oF} $totalItems ${l.S.of(context).entries}';

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet =
                    constraints.maxWidth < 992 && constraints.maxWidth >= 481;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.couponCode != null) ...[
                      BackButton(color: theme.colorScheme.primary),
                      const SizedBox(height: 8),
                      Text.rich(
                          TextSpan(
                            text: "Transactions éffectuées avec le coupon",
                            children: [
                              TextSpan(
                                text: ' ${widget.couponCode}',
                                style: theme.textTheme.headlineMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          style: theme.textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          )),

                      //Statistics Card
                      const SizedBox(height: 16),
                      Wrap(
                        children: [
                          couponStatisticsCard(context,
                              couponCode: widget.couponCode!,
                              title: "Nombre de fois utilisé",
                              value: '$totalItems'),
                          couponStatisticsCard(context,
                              couponCode: widget.couponCode!,
                              title: "Chiffre d'affaires généré",
                              value: formatPrixEuro(chiffreAffaire)),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                    isMobile
                        ? Padding(
                            padding: _sizeInfo.padding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: showingValueDropDown(
                                          isTablet: isTablet,
                                          isMobile: isMobile,
                                          textTheme: textTheme),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                searchFormField(textTheme: textTheme),
                              ],
                            ),
                          )
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: showingValueDropDown(
                                      isTablet: isTablet,
                                      isMobile: isMobile,
                                      textTheme: textTheme),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: isTablet || isMobile ? 2 : 3,
                                  child: searchFormField(textTheme: textTheme),
                                )
                              ],
                            ),
                          ),

                    //__________________________Data_table__________________
                    isMobile || isTablet
                        ? RawScrollbar(
                            padding: const EdgeInsets.only(left: 18),
                            trackBorderColor: theme.colorScheme.surface,
                            trackVisibility: true,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 8.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  padding: EdgeInsets.all(16.0),
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                    ),
                                    child: userListDataTable(context),
                                  ),
                                ),
                                Padding(
                                  padding: _sizeInfo.padding,
                                  child: Text(
                                    _showingText,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(16.0),
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: userListDataTable(context),
                            ),
                          ),

                    //__________________________footer__________________
                    isTablet || isMobile
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _showingText,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                DataTablePaginator(
                                  currentPage: _currentPage + 1,
                                  totalPages: totalPages,
                                  onPreviousTap: _goToPreviousPage,
                                  onNextTap: _goToNextPage,
                                )
                              ],
                            )),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ///_____________________________________select_dropdown_val_________
  void _setRowsPerPage(int value) {
    setState(() {
      _rowsPerPage = value;
      _currentPage = 0;
    });
  }

  ///_____________________________________go_next_page________________
  void _goToNextPage() {
    if (_currentPage < totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
    fetchTransactions();
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
    fetchTransactions();
  }

  ///___________________Search_Field___________________________________
  TextFormField searchFormField({required TextTheme textTheme}) {
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Au moins 3 caractères',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child:
              const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: (value) {
        // 3 lenght minimum to start search
        if (value.length < 3 && value.isNotEmpty) return;
        setState(() {
          _searchQuery = value;
          _currentPage = 0;
        });
        fetchTransactions();
      },
    );
  }

  ///___________________DropDownList___________________________________
  Container showingValueDropDown(
      {required bool isTablet,
      required bool isMobile,
      required TextTheme textTheme}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    //final theme = Theme.of(context);
    final lang = l.S.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<int>(
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: _rowsPerPage,
        items: [10, 20, 30, 40, 50].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              '${lang.show} $value',
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            _setRowsPerPage(value);
          }
          fetchTransactions();
        },
      ),
    );
  }

  Widget userListDataTable(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MyDataTable(
      isLoading: _isLoading,
      columns: [
        DataColumn(
          label: Text(
            "Date",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Auteur",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text(
            "Montant payé",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
          numeric: true,
        ),
        DataColumn(
          label: Text(
            "Type de paiement",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Statut",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      rows: _filteredData.map((data) {
        final isDebit = data.paymentMethod == PaymentMethod.jataiMobile;

        return DataRow(
          onSelectChanged: (selected) {
            if (selected == true) {
              showTransactionDetails(context, data, isDebit);
            }
          },
          cells: [
            DataCell(
              Tooltip(
                message: DateFormat('EEEE d MMMM yyyy - HH:mm')
                    .format(data.updatedAt ?? DateTime.now()),
                child: Text(
                  DateFormat('d MMM yyyy')
                      .format(data.updatedAt ?? DateTime.now()),
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
            DataCell(
              Tooltip(
                message: '${data.author?.firstName} ${data.author?.lastName}',
                child: Text(
                  _formatAuthorName(data.author),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  isDebit
                      ? '- ${data.price.round()}'
                      : '${data.price.toStringAsFixed(2)}€',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _getAmountColor(theme, data.price, isDebit),
                  ),
                ),
              ),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getPaymentMethodIcon(data.paymentMethod),
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getPaymentMethodText(data.paymentMethod),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            DataCell(
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(theme, data.paymentStatus)
                        .withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStatusColor(theme, data.paymentStatus)
                          .withAlpha(100),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusText(data.paymentStatus).toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(theme, data.paymentStatus),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        );
      }).toList(),
    );
  }

  String _formatAuthorName(dynamic author) {
    if (author?.firstName == null && author?.lastName == null) {
      return 'Inconnu';
    }
    final firstName = author?.firstName ?? '';
    final lastName = author?.lastName ?? '';
    return '$firstName $lastName'.trim();
  }
}

void showTransactionDetails(
    BuildContext context, TransactionModel transaction, bool isDebit) {
  final theme = Theme.of(context);
  final textTheme = theme.textTheme;

  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: theme.colorScheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
            maxHeight: 700,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Détails de la transaction',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Transaction ID
                  _buildDetailRow(
                    theme: theme,
                    label: 'ID Transaction',
                    value: transaction.transactionId ?? 'N/A',
                    icon: Icons.receipt_long,
                    isImportant: true,
                  ),

                  const SizedBox(height: 20),

                  // Status & Amount Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Status
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Statut',
                                style: textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                          theme, transaction.paymentStatus)
                                      .withAlpha(30),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _getStatusColor(
                                        theme, transaction.paymentStatus),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  _getStatusText(transaction.paymentStatus)
                                      .toUpperCase(),
                                  style: textTheme.labelSmall?.copyWith(
                                    color: _getStatusColor(
                                        theme, transaction.paymentStatus),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Vertical divider
                        Container(
                          width: 1,
                          height: 40,
                          color: theme.colorScheme.outline.withOpacity(0.3),
                        ),

                        // Amount
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Montant total',
                                style: textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isDebit
                                    ? '${transaction.price.round()} Unités'
                                    : '${transaction.price.toStringAsFixed(2)}€',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: _getAmountColor(
                                      theme, transaction.price, isDebit),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    _getPaymentMethodIcon(
                                        transaction.paymentMethod),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Via ${_getPaymentMethodText(transaction.paymentMethod)}",
                                    style: textTheme.bodyMedium,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (transaction.tax != null || transaction.couponCode != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.surfaceVariant.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          if (transaction.tax != null) ...[
                            const SizedBox(height: 12),
                            _buildPaymentDetailRow(
                              theme: theme,
                              label: 'Taxes (${transaction.tax}%)',
                              value:
                                  '${transaction.taxAmount?.toStringAsFixed(2) ?? '0.00'}€',
                              icon: Icons.percent,
                            ),
                          ],
                          if (transaction.couponCode != null) ...[
                            const SizedBox(height: 12),
                            _buildPaymentDetailRow(
                              theme: theme,
                              label: 'Coupon appliqué',
                              value:
                                  '-${transaction.couponAmount?.toStringAsFixed(2) ?? '0.00'}€',
                              icon: Icons.local_offer,
                              valueColor: Colors.green,
                            ),
                          ],
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // User & Date Information
                  Text(
                    'Informations générales',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          theme: theme,
                          label: 'Auteur',
                          value:
                              '${transaction.author?.firstName ?? ''} ${transaction.author?.lastName ?? ''}'
                                  .trim(),
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          theme: theme,
                          label: 'Date de création',
                          value: DateFormat('EEEE d MMMM yyyy - HH:mm').format(
                            transaction.createdAt ?? DateTime.now(),
                          ),
                          icon: Icons.calendar_today,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          theme: theme,
                          label: 'Dernière modification',
                          value: DateFormat('EEEE d MMMM yyyy - HH:mm').format(
                            transaction.updatedAt ?? DateTime.now(),
                          ),
                          icon: Icons.update,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (transaction.dispersion.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Crédits achetés',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: transaction.dispersion.map((entry) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RichTextWidget(list: [
                                      TextSpan(
                                        text: getPlanName(entry["id"] ??
                                            entry["thingid"] ??
                                            ""),
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '/  ${entry["dis_quantity"]}  /',
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: isDebit ? " Pour " : ' A ',
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${entry["dis_price"]} ${isDebit ? "crédits" : "€"}',
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      )
                                    ]),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  const SizedBox(width: 12),
                  if (!isDebit)
                    Consumer<PaymentProvider>(
                        builder: (context, appTheme, child) {
                      Jks.paymentState = appTheme;
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  padding: EdgeInsets.zero),
                              onPressed: appTheme.isLoading
                                  ? null
                                  : () async {
                                      appTheme.setloading(true);
                                      await getTransactionInvoice(
                                              transaction.transactionId!)
                                          .then((res) async {
                                        if (res.status == true) {
                                          downloadWithHttp(
                                            documentUrl(
                                                    res.data["invoice_pdf"] ??
                                                        "") ??
                                                "",
                                            fileName:
                                                "Facture_${transaction.createdAt}.pdf"
                                                    .replaceAll("/", "_")
                                                    .replaceAll("\\", "_")
                                                    .replaceAll(" ", "_"),
                                          );
                                          appTheme.setloading(false);
                                        }
                                      }).catchError((e) {
                                        my_inspect(e);
                                        appTheme.setloading(false);
                                      });
                                    },
                              label: Text("Télécharger la facture".tr,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  )),
                            ),
                          ]);
                    }),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// Helper Widgets
Widget _buildDetailRow({
  required ThemeData theme,
  required String label,
  required String value,
  required IconData icon,
  bool isImportant = false,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: theme.colorScheme.outline.withOpacity(0.1),
      ),
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isImportant ? FontWeight.w700 : FontWeight.w500,
                  color: isImportant
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontFamily: isImportant ? 'monospace' : null,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildPaymentDetailRow({
  required ThemeData theme,
  required String label,
  required String value,
  required IconData icon,
  Color? valueColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
      Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: valueColor ?? theme.colorScheme.onSurface,
        ),
      ),
    ],
  );
}

Widget _buildInfoRow({
  required ThemeData theme,
  required String label,
  required String value,
  required IconData icon,
}) {
  return Row(
    children: [
      Icon(
        icon,
        size: 18,
        color: theme.colorScheme.primary.withOpacity(0.7),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
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
        color: Jks.context!.theme.colorScheme.primary),
  ).paddingTop(16);
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}

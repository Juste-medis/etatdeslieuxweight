// 🐦 Flutter imports:
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole3.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/couponmodel.dart';
import 'package:jatai_etadmin/app/pages/coupons/add_coupon_popup.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/helpers/helpers.dart';
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';

class POSCouponView extends StatefulWidget {
  const POSCouponView({super.key});

  @override
  State<POSCouponView> createState() => _POSCouponViewState();
}

class _POSCouponViewState extends State<POSCouponView> {
  late final List<CouponModel> _filteredData = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  int _rowsPerPage = 10;
  String _searchQuery = '';
  bool _selectAll = false;
  bool _isLoading = false;
  int totalItems = 0;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchCoupons(refresh: true);
  }

  void fetchCoupons({bool refresh = false}) async {
    setState(() {
      _isLoading = true;
    });
    _filteredData.clear();

    if (refresh) {
      _currentPage = 0;
      _rowsPerPage = 10;
      _searchQuery = '';
      _selectAll = false;
    }

    try {
      final response =
          await getcoupons(page: _currentPage, limit: "$_rowsPerPage", filter: {
        "code": _searchQuery,
      });

      if (response.status == true) {
        if (refresh) {
          _filteredData.clear();
          setState(() {
            _filteredData.clear();
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
      debugPrint('Error fetching plans: $err');
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

  addOreditCoupon({
    CouponModel? coupon,
  }) {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: AddCouponDialog(
                  coupon: coupon,
                  onSuccessAction: () {
                    fetchCoupons();
                  }));
        },
      );
    });
  }

  deleteCoupon(CouponModel coupon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text("Confirmer la suppression".tr),
          content: Text(
            "Êtes-vous sûr de vouloir supprimer le coupon ${coupon.code} ?".tr,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler".tr,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final response = await deleteThecoupon(coupon.id ?? '');
                if (response.status == true) {
                  fetchCoupons();
                } else {
                  toast(
                      response.message ??
                          "Échec de la suppression du coupon".tr,
                      bgColor: Colors.red);
                }
              },
              child: Text(
                "Supprimer".tr,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
    Jks.context = context;

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          headerText: "Liste des coupons".tr,
          showHeader: true,
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
                                    const Spacer(),
                                    ajoutercoupon(textTheme, context),
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
                                ),
                                Spacer(flex: isTablet || isMobile ? 1 : 2),
                                ajoutercoupon(textTheme, context),
                              ],
                            ),
                          ),

                    //Data_table____
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

                    //footer____
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

  ElevatedButton ajoutercoupon(TextTheme textTheme, BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        addOreditCoupon();
      },
      label: Text(
        "Ajouter un coupon".tr,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  ///_________select_dropdown_val_________
  void _setRowsPerPage(int value) {
    setState(() {
      _rowsPerPage = value;
      _currentPage = 0;
    });
    fetchCoupons();
  }

  ///_________go_next_page__
  void _goToNextPage() {
    if (_currentPage < totalPages) {
      setState(() {
        _currentPage++;
      });
      fetchCoupons();
    }
  }

  ///_________go_previous_page____________
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        --_currentPage;
      });
      fetchCoupons();
    }
  }

  TextFormField searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: '${lang.search}...',
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
        setState(() {
          _searchQuery = value;
          _currentPage = 0;
        });
        fetchCoupons();
      },
    );
  }

  ///_______DropDownList_______
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
        items: [
          10,
          20,
        ].map((int value) {
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
        },
      ),
    );
  }

  ///_______User_List_Data_Table_____________
  Widget userListDataTable(BuildContext context) {
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    final styleColums = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );
    return MyDataTable(
      isLoading: _isLoading,
      columns: [
        DataColumn(
          label: Row(
            children: [
              Checkbox(
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                value: _selectAll,
                onChanged: (value) {
                  _selectAllRows(value ?? false);
                },
              ),
            ],
          ),
        ),
        DataColumn(
          label: Text(
            lang.code,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Réduction (€)".tr,
            //'Qty',
            style: style,
          ),
        ),
        DataColumn(
          label: Text(
            "Montant minimum (€)".tr,
            style: style,
          ),
        ),
        DataColumn(
          label: Text(
            "Date d'expiration".tr,
            style: style,
          ),
        ),
        DataColumn(
            label: Text(
          lang.action,
          style: style,
        )),
      ],
      rows: _filteredData.map(
        (coupon) {
          return DataRow(
            cells: [
              DataCell(
                Checkbox(
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  value: coupon.isSelected,
                  onChanged: (selected) {
                    setState(() {
                      coupon.isSelected = selected ?? false;
                      _selectAll = _filteredData.every((d) => d.isSelected);
                    });
                  },
                ),
              ),
              DataCell(
                Text(
                  coupon.code,
                  overflow: TextOverflow.ellipsis,
                  style: styleColums,
                ),
              ),
              DataCell(
                Center(
                  child: Text(
                    coupon.discount.toString(),
                    style: styleColums,
                  ),
                ),
              ),
              DataCell(Center(
                child: Text(
                  (coupon.minimumAmount ?? 0).toString(),
                  style: styleColums,
                ),
              )),
              DataCell(
                Center(
                  child: Text(
                    formatDate(coupon.expiryDate.toString(),
                        format: DATE_FORMAT_2),
                    style: styleColums,
                  ),
                ),
              ),
              DataCell(
                PopupMenuButton(
                  color: theme.colorScheme.primaryContainer,
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Modifier')
                        ],
                      ),
                      onTap: () {
                        addOreditCoupon(
                          coupon: coupon,
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.bar_chart),
                          SizedBox(width: 8),
                          Text('Statistiques')
                        ],
                      ),
                      onTap: () {
                        context.push(
                          '/transactions/coupons/codeusage',
                          extra: coupon.code,
                        );
                      },
                    ),
                    PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('Supprimer')
                          ],
                        ),
                        onTap: () {
                          deleteCoupon(coupon);
                        }),
                  ],
                ),
              )
            ],
          );
        },
      ).toList(),
    );
  }

  ///_____________Selected_datatable___________
  void _selectAllRows(bool select) {
    setState(() {
      for (var data in _filteredData) {
        data.isSelected = select;
      }
      _selectAll = select;
    });
  }
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

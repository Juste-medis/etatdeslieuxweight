// 🐦 Flutter imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_salesoverview_model.dart';
import 'package:jatai_etadmin/app/pages/statistics_dashboard/components/_numeric_chart.dart';
import 'package:nb_utils/nb_utils.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';
import 'components/_components.dart' as comp;

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  List<SaleOverViewModel> statsticsData = [];
  Map<int, String> xaxixList = {};
  Map filter = {"period": "monthly"};
  bool isLoading = false;
  double totalSalesAmount = 0.0;
  int totalSalesCredits = 0;
  int userLogins = 0;

  @override
  void initState() {
    fetchStatisticksData();
    super.initState();
  }

  void fetchStatisticksData() async {
    setState(() {
      isLoading = true;
    });

    //dateRange
    //period

    getstatistics(filter).then((value) {
      if (value.data != null) {
        totalSalesAmount = 0.0;
        totalSalesCredits = 0;
        xaxixList = {};
        int index = 1;
        userLogins = value.data["userLogins"] ?? 0;
        for (var day in value.data["theDays"]) {
          DateTime date = DateFormat("dd/MM/yyyy").parse(day.toString());
          String formattedDate = DateFormat("dd MMM. yy", "en_US").format(date);
          xaxixList[index] = formattedDate;
          index++;
        }
        List<SaleOverViewModel> tempList = [];
        value.data["dataListAgregated"].forEach((key, valueList) {
          List<FlSpot> spots = [];
          int spotIndex = 1;
          int totalCredits = 0;
          double totalAmount = 0.0;
          for (var item in valueList) {
            double disPrice = 0;
            int disCredits = 0;
            if (item.containsKey("dis_price")) {
              disPrice = double.tryParse("${item["dis_price"]}") ?? 0.0;
            }
            if (item.containsKey("dis_quantity")) {
              disCredits = int.tryParse("${item["dis_quantity"]}") ?? 0;
            }

            spots.add(FlSpot(spotIndex.toDouble(), disPrice));
            totalAmount += disPrice;
            totalCredits += disCredits;
            spotIndex++;
          }
          totalSalesAmount += totalAmount;
          totalSalesCredits += totalCredits;
          tempList.add(SaleOverViewModel(
              name: key,
              dataPoints: spots,
              totalAmount: totalAmount,
              totalCredits: totalCredits,
              newlyCreated: value.data["newLyReviews"][key]));
        });

        setState(() {
          isLoading = false;
          statsticsData = tempList;
          xaxixList = xaxixList;
        });
      }
    }).catchError((error) {
      // my_inspect(error);
      // my_inspect(error.stackTrace);
    });
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    final _mqSize = MediaQuery.sizeOf(context);
    final _lang = l.S.of(context);

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );

    final List<Widget> _filterers = [
      FilterDropdownButton(
        minimumWidth:
            (filter["period"] == "monthly" || filter["period"] == null)
                ? 60
                : 0,
        onChanged: (value) {
          setState(() {
            filter["period"] = value;
          });
          fetchStatisticksData();
        },
      ),
      10.width,
      Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor.withAlpha(50),
          ),
        ),
        child: AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: TextEditingController(
            text: filter.containsKey("dateRange")
                ? filter["dateRange"].toString()
                : "Filtrer pour une plage de dates",
          ),
          onChanged: (v) {
            setState(() {
              filter["dateRange"] = v;
              filter["period"] = "dateRange";
            });
            fetchStatisticksData();
          },
          decoration: inputDecoration(
            context,
          ).copyWith(
              fillColor: Colors.transparent,
              prefixIcon: const Icon(Icons.date_range),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 10,
              )), // Set padding here
          readOnly: true,
          onTap: () {
            showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            ).then((value) {
              if (value != null) {
                String formattedDateRange =
                    "${formatDate(value.start.toIso8601String(), format: 'dd/MM/yyyy')} - ${formatDate(value.end.toIso8601String(), format: 'dd/MM/yyyy')}";
                setState(() {
                  filter["dateRange"] = formattedDateRange;
                  filter["period"] = "dateRange";
                });
                fetchStatisticksData();
              }
            });
          },
        ).withWidth(
          _mqSize.width >= 1400 ? 250 : 150,
        ),
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: Column(
          children: [
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: _mqSize.width < 1700 ? 7 : 8,
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                          child: ShadowContainer(
                        contentPadding: EdgeInsetsDirectional.symmetric(
                            horizontal: _padding, vertical: _padding),
                        margin: EdgeInsetsDirectional.all(_padding / 2.5),
                        headerText: "Tableau de bord des statistiques",
                        child: Row(
                          children: _filterers,
                        ),
                      )),
                      ResponsiveGridCol(
                          child: ShadowContainer(
                        margin: EdgeInsetsDirectional.all(_padding / 2.5),
                        headerText: _lang.salesOverview,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.loose(
                            const Size.fromHeight(390),
                          ),
                          child: statsticsData.isEmpty
                              ? const Center(
                                  child: Text("Aucune donnée disponible"))
                              : comp.SalesOverviewChart(
                                  statsticsData: statsticsData,
                                  xaxixList: xaxixList,
                                  totalSalesAmount: totalSalesAmount,
                                  totalSalesCredits: totalSalesCredits,
                                ),
                        ),
                      )),
                    ],
                  ),
                ),
                ResponsiveGridCol(
                  lg: _mqSize.width < 1700 ? 5 : 4,
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        md: 12,
                        child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                              height: _mqSize.width < 1240
                                  ? 480
                                  : _mqSize.width < 1400
                                      ? 380
                                      : _mqSize.width < 1700
                                          ? 340
                                          : 320,
                            ),
                            child: ShadowContainer(
                              // headerText: 'Word Generation',
                              headerText: 'Nouveaux',
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                6,
                                12,
                                6,
                                6,
                              ),
                              child: NumericAxisChart(
                                statsticsData: statsticsData,
                              ),
                            )),
                      ),
                      ResponsiveGridCol(
                        md: 12,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            height: _mqSize.width < 1240
                                ? 480
                                : _mqSize.width < 1400
                                    ? 380
                                    : _mqSize.width < 1700
                                        ? 340
                                        : 320,
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsetsDirectional.all(
                              _padding / 2.5,
                            ),
                            contentPadding: EdgeInsetsDirectional.symmetric(
                              horizontal: _padding,
                            ),
                            // headerText: 'User Statistics',
                            headerText: _lang.userStatistics,
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: comp.UserStatisticsPiChart(
                                  userLogins: userLogins),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Tables
            // ResponsiveGridRow(
            //   children: [
            //     ResponsiveGridCol(
            //       lg: 7,
            //       child: ShadowContainer(
            //         margin: EdgeInsetsDirectional.all(_padding / 2.5),
            //         contentPadding: EdgeInsetsDirectional.zero,
            //         // headerText: 'Top Vendors',
            //         headerText: _lang.topVendors,
            //         trailing: Text.rich(
            //           TextSpan(
            //             //text: 'View All',
            //             text: _lang.viewAll,
            //             style: TextStyle(
            //               color: _theme.colorScheme.primary,
            //             ),
            //             mouseCursor: SystemMouseCursors.click,
            //           ),
            //           style: _theme.textTheme.bodyMedium,
            //         ),
            //         child: const comp.TopVendorsTable(),
            //       ),
            //     ),
            //     ResponsiveGridCol(
            //       lg: 5,
            //       child: ShadowContainer(
            //         margin: EdgeInsetsDirectional.all(_padding / 2.5),
            //         contentPadding: EdgeInsetsDirectional.zero,
            //         // headerText: 'Top Delivery Man',
            //         headerText: _lang.topDeliveryMan,
            //         trailing: Text.rich(
            //           TextSpan(
            //             //text: 'View All',
            //             text: _lang.viewAll,
            //             style: TextStyle(
            //               color: _theme.colorScheme.primary,
            //             ),
            //             mouseCursor: SystemMouseCursors.click,
            //           ),
            //           style: _theme.textTheme.bodyMedium,
            //         ),
            //         child: const comp.TopDeliveryManTable(),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

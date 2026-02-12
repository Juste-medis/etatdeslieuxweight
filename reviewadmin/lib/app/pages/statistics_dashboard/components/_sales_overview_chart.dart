// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/theme/theme.dart';
import 'package:jatai_etadmin/app/models/_salesoverview_model.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/static/static.dart';

class SalesOverviewChart extends StatelessWidget {
  final List<SaleOverViewModel> statsticsData;
  final Map<int, String> xaxixList;
  final double totalSalesAmount;
  final int totalSalesCredits;

  const SalesOverviewChart(
      {super.key,
      required this.statsticsData,
      required this.xaxixList,
      required this.totalSalesAmount,
      required this.totalSalesCredits});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _lightGradientColors = [
      const Color(0xffF9F3FF),
      const Color(0xffE8FFF0),
      const Color(0xffF0E3FF),
      const Color(0xffFFF1E3),
      const Color(0xffF9F3FF),
    ];
    final _darkGradientColors = [
      const Color(0xffF9F3FF).withOpacity(0.04),
      const Color(0xff8FFFB9).withOpacity(0.25),
      const Color(0xffC696FF).withOpacity(0.25),
      const Color(0xffFFCC9D).withOpacity(0.25),
      const Color(0xffF9F3FF).withOpacity(0.04),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints.loose(const Size.fromHeight(64)),
          padding: const EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: _isDark ? _darkGradientColors : _lightGradientColors,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: {
              lang.revenue: formatPrixEuro(totalSalesAmount),
              lang.sales: totalSalesCredits,
              lang.products: statsticsData.length,
            }.entries.map((item) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.value.toString(),
                    style: _theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    item.key,
                    style: _theme.textTheme.bodyMedium?.copyWith(
                        color: _theme.colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
        Flexible(
            child: _SalesOverviewLineChart(
          statsticsData: statsticsData,
          xaxixList: xaxixList,
        )),
      ],
    );
  }
}

class _SalesOverviewLineChart extends StatelessWidget {
  final List<SaleOverViewModel> statsticsData;
  final Map<int, String> xaxixList;
  const _SalesOverviewLineChart(
      {required this.statsticsData, required this.xaxixList});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _mqSize = MediaQuery.sizeOf(context);

    var maximumY = statsticsData
        .map(
            (e) => e.dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b);

    var botomInterval = dynamycLineInterval(xaxixList.length);
    // Choose the Y interval used for both grid and labels
    const int yInterval = 500;

    // Round the max Y up to the next multiple of yInterval (so the top tick is visible)
    final int roundedMaxY =
        (((maximumY.toDouble() + 100) / yInterval).ceil()) * yInterval;

    // Ensure the chart's maxY (defined later as maximumY + 100) matches roundedMaxY
    // by setting maximumY so that maximumY + 100 == roundedMaxY
    maximumY = (roundedMaxY - 100).toDouble();

    // Build Y-axis titles from 0 up to the rounded upper bound
    final Map<int, String> titlesMap = {
      for (int v = 0; v <= roundedMaxY; v += yInterval) v: v.toString(),
    };

    return Column(
      children: [
        Wrap(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '● ',
                    style: TextStyle(color: AcnooAppColors.kPrimary600),
                  ),
                  TextSpan(
                    text: "${statsticsData[0].name}:",
                    style: TextStyle(
                      color: _isDark
                          ? _theme.colorScheme.onPrimaryContainer
                          : const Color(0xff667085),
                    ),
                  ),
                  TextSpan(
                    text: " ${formatPrixEuro(statsticsData[0].totalAmount)}",
                    style: TextStyle(
                      color: _isDark
                          ? _theme.colorScheme.onPrimaryContainer
                          : const Color(0xff344054),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: " (${statsticsData[0].totalCredits})   ",
                    style: TextStyle(
                        color: _theme.colorScheme.primary,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: '● ',
                    style: TextStyle(color: AcnooAppColors.kSuccess),
                  ),
                  TextSpan(
                    //text: "Expense:",
                    text: "${statsticsData[1].name}:",
                    style: TextStyle(
                      color: _isDark
                          ? _theme.colorScheme.onPrimaryContainer
                          : const Color(0xff667085),
                    ),
                  ),
                  TextSpan(
                    text: " €${formatPrixEuro(statsticsData[1].totalAmount)}",
                    style: TextStyle(
                      color: _isDark
                          ? _theme.colorScheme.onPrimaryContainer
                          : const Color(0xff344054),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: " (${statsticsData[1].totalCredits})   ",
                    style: TextStyle(
                        color: _theme.colorScheme.primary,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              style: _theme.textTheme.bodyMedium?.copyWith(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Flexible(
            child: LineChart(
          LineChartData(
            minX: 1,
            minY: 0,
            maxY: maximumY.toDouble() + 100,
            maxX: xaxixList.length.toDouble(),
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: _theme.colorScheme.outline,
                dashArray: [10, 5],
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes
                    .map(
                      (item) => TouchedSpotIndicatorData(
                        const FlLine(color: Colors.transparent),
                        FlDotData(
                          getDotPainter: (p0, p1, p2, p3) {
                            return FlDotCirclePainter(
                              color: Colors.white,
                              strokeWidth: 2.5,
                              strokeColor: p2.color ?? Colors.transparent,
                            );
                          },
                        ),
                      ),
                    )
                    .toList();
              },
              touchTooltipData: LineTouchTooltipData(
                maxContentWidth: 240,
                fitInsideHorizontally: true,
                // Place le tooltip à droite du point touché
                tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                tooltipMargin: 8,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((item) {
                    final _value = NumberFormat.compactCurrency(
                      decimalDigits: 4,
                      symbol: '€',
                      locale: AppLocale.defaultLocale.countryCode,
                    ).format(item.bar.spots[item.spotIndex].y);

                    return LineTooltipItem(
                      "",
                      _theme.textTheme.bodySmall!,
                      textAlign: TextAlign.start,
                      children: [
                        TextSpan(
                          text: ' ${xaxixList[item.spotIndex + 1]}\n',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        /// Text Dot Indicator [used for the replacement of a circle widget. due to the limitation of fl_chart package, LineTooltipItem class doesn't support a widget span]
                        TextSpan(
                          text: '● ',
                          style: TextStyle(color: item.bar.color),
                        ),
                        TextSpan(
                          //text: "Withdraw:",
                          text: "CA:",
                          style: TextStyle(
                            color: _isDark
                                ? _theme.colorScheme.onPrimaryContainer
                                : const Color(0xff667085),
                          ),
                        ),
                        TextSpan(
                          text: " $_value",
                          style: TextStyle(
                            color: _isDark
                                ? _theme.colorScheme.onPrimaryContainer
                                : const Color(0xff344054),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
                getTooltipColor: (touchedSpot) {
                  return _isDark
                      ? _theme.colorScheme.tertiaryContainer
                      : Colors.white;
                },
              ),
            ),
            lineBarsData: [
              _getData(
                data: statsticsData[0].dataPoints,
                color: AcnooAppColors.kPrimary600,
              ),
              _getData(
                data: statsticsData[1].dataPoints,
                color: AcnooAppColors.kSuccess,
              ),
              // _getData(
              //   data: statsticsData[2].dataPoints,
              //   color: AcnooAppColors.kSuccess,
              // ),
            ],
            titlesData: FlTitlesData(
              topTitles: _getTitlesData(show: false),
              rightTitles: _getTitlesData(show: false),
              leftTitles: _getTitlesData(
                reservedSize: 40,
                interval: 500,
                getTitlesWidget: (value, titleMeta) {
                  return Text(
                    titlesMap[value.toInt()] ?? '',
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      color: _theme.colorScheme.onTertiary,
                    ),
                  );
                },
              ),
              bottomTitles: _getTitlesData(
                interval: botomInterval,
                reservedSize: 28,
                getTitlesWidget: (value, titleMeta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Transform.rotate(
                      angle: _mqSize.width < 480
                          ? (-45 * (3.1416 / 180))
                          : botomInterval < 4
                              ? 0
                              : (-22.5 * (3.1416 / 180)),
                      child: Text(
                        xaxixList[value.toInt()] ?? '',
                        style: _theme.textTheme.bodyMedium?.copyWith(
                          color: _theme.colorScheme.onTertiary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )),
      ],
    );
  }

  double dynamycLineInterval(int taille) {
    if (taille <= 0) return 1;
    const maxVisibleLabels = 8;
    final step = (taille / maxVisibleLabels).ceil();
    return step.toDouble();
  }

  AxisTitles _getTitlesData({
    bool show = true,
    Widget Function(double value, TitleMeta titleMeta)? getTitlesWidget,
    double reservedSize = 22,
    double? interval,
  }) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: show,
        getTitlesWidget: getTitlesWidget ?? defaultGetTitle,
        reservedSize: reservedSize,
        interval: interval,
      ),
    );
  }

  LineChartBarData _getData({
    required List<FlSpot> data,
    Color? color,
  }) {
    return LineChartBarData(
      spots: data,
      isCurved: true,
      barWidth: 5,
      dotData: const FlDotData(show: false),
      color: color,
    );
  }
}

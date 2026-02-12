// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/models/_salesoverview_model.dart';
import 'package:nb_utils/nb_utils.dart';

// 📦 Package imports:
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:jatai_etadmin/app/core/theme/theme.dart';

class NumericAxisChart extends StatefulWidget {
  const NumericAxisChart({super.key, required this.statsticsData});
  final List<SaleOverViewModel> statsticsData;

  @override
  State<NumericAxisChart> createState() => _NumericAxisChartState();
}

class _NumericAxisChartState extends State<NumericAxisChart> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = widget.statsticsData
        .map((e) => ChartData(e.name, e.newlyCreated?.toDouble() ?? 0))
        .toList();
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Container(
          color: theme.colorScheme.primaryContainer,
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(
              //horizontable bars 4
              axisLine: AxisLine(width: 0), // Remove bottom axis line
              majorGridLines:
                  MajorGridLines(width: 0), // Remove vertical grid lines
              majorTickLines: MajorTickLines(size: 0),
            ),
            primaryYAxis: const NumericAxis(
              axisLine: AxisLine(width: 0), // Remove left axis line
              majorGridLines: MajorGridLines(
                color: Color(0xffD1D5DB),
                dashArray: [
                  5,
                  5
                ], // Creates a dotted line pattern for horizontal grid lines
              ),
            ),
            plotAreaBorderWidth: 0,
            series: <CartesianSeries<ChartData, String>>[
              BarSeries<ChartData, String>(
                dataSource: chartData,
                spacing: 0.3,
                width: 0.5,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                // name: 'Sales',
                name: "Nouveaux ajouts",
                onPointTap: (ChartPointDetails details) {
                  _showPopup(context, chartData[details.pointIndex!]);
                },
                dataLabelSettings: const DataLabelSettings(isVisible: false),
                gradient: LinearGradient(colors: [
                  context.primaryColor,
                  context.theme.colorScheme.primary
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPopup(BuildContext context, ChartData data) {
  TextTheme textTheme = Theme.of(context).textTheme;
  ColorScheme color = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: color.primaryContainer,
        contentPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: AcnooAppColors.kPrimary500,
                  size: 10,
                ),
                const SizedBox(
                  width: 5,
                ),
                RichText(
                    text: TextSpan(
                        text: "Total Nouveaux: ",
                        style: textTheme.bodySmall?.copyWith(fontSize: 12),
                        children: [
                      TextSpan(
                          text: "${data.y.toInt()}",
                          style: textTheme.titleSmall?.copyWith(fontSize: 12))
                    ]))
              ],
            )
          ],
        ),
      );
    },
  );
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

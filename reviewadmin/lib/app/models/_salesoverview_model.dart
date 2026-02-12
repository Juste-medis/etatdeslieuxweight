import 'package:fl_chart/fl_chart.dart';

class SaleOverViewModel {
  final String name;
  final List<FlSpot> dataPoints;
  final double totalAmount;
  final int totalCredits;
  final int? newlyCreated;

  const SaleOverViewModel({
    required this.name,
    required this.dataPoints,
    required this.totalAmount,
    required this.totalCredits,
    this.newlyCreated,
  });
}

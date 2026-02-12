// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/theme/theme.dart';

class UserStatisticsPiChart extends StatefulWidget {
  const UserStatisticsPiChart({super.key, required this.userLogins});
  final int userLogins;

  @override
  State<UserStatisticsPiChart> createState() => _UserStatisticsPiChartState();
}

class _UserStatisticsPiChartState extends State<UserStatisticsPiChart> {
  int touchedIndex = -1;
  List<PiChartData> get _mockList => [
        PiChartData(
          color: AcnooAppColors.kPrimary600,
          label: "${l.S.current.customer}: ${widget.userLogins}",
          value: widget.userLogins.toDouble(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final _size = constraints.biggest;

        final _chartRadius = responsiveValue<double>(
          context,
          xs: _size.height *
              (_mqSize.width < 375
                  ? 0.115
                  : _mqSize.width < 420
                      ? 0.135
                      : 0.175),
          md: _size.height * (_mqSize.width < 992 ? 0.20 : 0.225),
          lg: _size.height * (_mqSize.width < 1400 ? 0.20 : 0.25),
        );

        return Center(
          child: Text.rich(
            TextSpan(
              text: '${widget.userLogins}',
              children: [
                TextSpan(
                  text: '\nConnexions utilisateurs',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: responsiveValue<double?>(
                      context,
                      xs: _mqSize.width < 420 ? 12 : 14,
                    ),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: _theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: responsiveValue<double?>(
                context,
                xs: _mqSize.width < 420 ? 25 : 35,
                md: null,
              ),
            ),
          ),
        );
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: _chartRadius + 24,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: _chartRadius * 0.95,
                        startDegreeOffset: -90,
                        pieTouchData: PieTouchData(
                          touchCallback: (event, pieTouchResponse) {
                            final isInteractionValid =
                                event.isInterestedForInteractions &&
                                    pieTouchResponse?.touchedSection != null;
                            final newIndex = isInteractionValid
                                ? pieTouchResponse!
                                    .touchedSection!.touchedSectionIndex
                                : -1;

                            if (newIndex != touchedIndex) {
                              setState(() => touchedIndex = newIndex);
                            }
                          },
                        ),
                        sections: List.generate(
                          _mockList.length,
                          (index) {
                            final _data = _mockList[index];
                            return PieChartSectionData(
                              radius: (_chartRadius - (_chartRadius * 0.5)) *
                                  (index == touchedIndex ? 1.05 : 1),
                              value: _data.value,
                              color: _data.color,
                              title: "${_data.value}%",
                              showTitle: index == touchedIndex,
                              titleStyle: _theme.textTheme.bodyLarge?.copyWith(
                                color: _theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: '${widget.userLogins}',
                        children: [
                          TextSpan(
                            text: '\nConnexions utilisateurs',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: responsiveValue<double?>(
                                context,
                                xs: _mqSize.width < 420 ? 12 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: _theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: responsiveValue<double?>(
                          context,
                          xs: _mqSize.width < 420 ? 14 : 24,
                          md: null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(width: _chartRadius * 1.25),
            // Flexible(
            //   flex: 6,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     // children: List.generate(
            //     //   _mockList.length,
            //     //   (index) {
            //     //     final _data = _mockList[index];
            //     //     return Indicator(
            //     //       color: _data.color,
            //     //       text: _data.label,
            //     //     );
            //     //   },
            //     // ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints.tight(const Size.square(12)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: _theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class PiChartData {
  final Color color;
  final String label;
  final double value;

  const PiChartData({
    required this.color,
    required this.label,
    required this.value,
  });
}

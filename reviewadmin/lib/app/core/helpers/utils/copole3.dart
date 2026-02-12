import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';

Widget buildAppNotificationWidget(
    BuildContext context, AppLanguageProvider notificationProvider) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final isDesktop = screenWidth >= 600;
  final _theme = Theme.of(context);
  return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: notificationProvider.showNotification ? 0 : -300,
      right: 0,
      width: MediaQuery.sizeOf(context).width * (isDesktop ? 0.3 : 1.0),
      child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
              opacity: notificationProvider.showNotification ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: () {
                  if (notificationProvider.onNotificationTap != null) {
                    notificationProvider.onNotificationTap!();
                    notificationProvider.hideAppNotification();
                  } else {
                    notificationProvider.hideAppNotification();
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 8,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(100),
                        blurRadius: 15,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichTextWidget(list: [
                        if (notificationProvider.notificationTitle != null)
                          TextSpan(
                              text:
                                  "${notificationProvider.notificationMessage}\n",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        TextSpan(
                          text: notificationProvider.notificationMessage,
                          style: _theme.textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
              ).paddingOnly(top: 35, right: 5, left: 5))));
}

Widget couponStatisticsCard(BuildContext context,
    {required String couponCode,
    required String title,
    required String value}) {
  final _theme = Theme.of(context);
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
        color: _theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: _theme.colorScheme.primary.withAlpha(350),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _theme.colorScheme.primary,
          width: 1,
        )),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: _theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: _theme.colorScheme.primary,
          ),
        ),
        // Additional statistics widgets can be added here
      ],
    ),
  );
}

class MyDataTable extends StatelessWidget {
  final List<DataRow> rows;
  final List<DataColumn> columns;
  final bool isLoading;
  const MyDataTable(
      {super.key,
      required this.rows,
      required this.columns,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: theme.colorScheme.outline.withOpacity(0.3),
        dividerTheme: DividerThemeData(
          color: theme.colorScheme.outline.withOpacity(0.3),
          thickness: 1,
          space: 0,
        ),
        dataTableTheme: DataTableThemeData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: theme.colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onPrimaryContainer.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: DataTable(
                    showCheckboxColumn: false,
                    showBottomBorder: true,
                    horizontalMargin: 16,
                    columnSpacing: 24,
                    headingRowHeight: 56,
                    dataRowHeight: 60,
                    dividerThickness: 1,
                    checkboxHorizontalMargin: 16,
                    dataTextStyle: textTheme.bodyMedium,
                    headingTextStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                    headingRowColor: WidgetStateProperty.all(
                      theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    ),
                    dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return theme.colorScheme.primary.withOpacity(0.1);
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return theme.colorScheme.surfaceVariant
                              .withOpacity(0.3);
                        }
                        return Colors.transparent;
                      },
                    ),
                    columns: columns,
                    rows: rows,
                  )),
            ),
          ),
          if (isLoading) SizedBox(height: (context.height())),
          if (isLoading)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Chargement des transactions...',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/pdf_summary_summary.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:provider/provider.dart';

class PdfOffSummary extends StatelessWidget {
  final AppThemeProvider wizardState;
  const PdfOffSummary({super.key, required this.wizardState});

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<AppThemeProvider>();

    Jks.imperativeActions["beforeLeaveProccuration"] = null;
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: wizardState.formKeys[WizardStep.values[7]],
                child: SumaryOfSummary(wizardState: wizardState))));
  }
}

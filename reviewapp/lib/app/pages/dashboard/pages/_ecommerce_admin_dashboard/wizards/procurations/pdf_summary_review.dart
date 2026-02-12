import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/pdf_summary_summary.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:provider/provider.dart';

class PdfOffSummary extends StatelessWidget {
  final AppThemeProvider wizardState;
  const PdfOffSummary({super.key, required this.wizardState});

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<AppThemeProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: wizardState.formKeys[WizardStep.values[7]],
          child: SumaryOfSummary(wizardState: wizardState, seesign: true),
        ),
      ),
    );
  }
}

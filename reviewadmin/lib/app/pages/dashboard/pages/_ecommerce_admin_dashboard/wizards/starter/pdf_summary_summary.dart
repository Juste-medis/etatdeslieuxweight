import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/network_utils.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/pdf_summary_summary.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:provider/provider.dart';

class SumaryOfSummary extends StatelessWidget {
  final AppThemeProvider wizardState;
  const SumaryOfSummary({super.key, required this.wizardState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    final documentLink = wizardState.formValues['entranDocumentId'] ??
        wizardState.formValues['sortantDocumentId'];
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: Padding(
              padding: EdgeInsets.all(_padding / 2.75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  Text(
                    "Etat des lieux ${wizardState.formValues['review_id']}"
                        .tr
                        .capitalizeFirstLetter(),
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 40),
                  ),
                  20.height,
                  Text(
                    "Découvrez ici un aperçu de l'état des lieux que vous avez créé. Vous pouvez revoir les informations saisies, les documents générés, et vous assurer que tout est en ordre avant de finaliser le processus."
                        .tr
                        .capitalizeFirstLetter(),
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  20.height,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 300,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.dividerColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: SfPdfViewer.network(
                              documentUrl(documentLink)!,
                              key:
                                  GlobalKey(), // Optionnel si tu veux un contrôle
                              headers:
                                  buildHeaderTokens(), // 👈 Ajout des headers personnalisés ici
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            right: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return SummaryPdfView(
                                      pdfPath: documentUrl(documentLink)!,
                                      title:
                                          "Prévisualisation de la procuration",
                                      footerText:
                                          'Review carefully before proceeding',
                                    );
                                  },
                                );
                              },
                              child: const Text("Voir"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).center(),
                  30.height,
                ],
              ),
            )));
  }
}

class PdfOffSummary extends StatelessWidget {
  final AppThemeProvider wizardState;
  const PdfOffSummary({super.key, required this.wizardState});

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<AppThemeProvider>();

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

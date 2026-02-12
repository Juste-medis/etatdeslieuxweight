import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/app_config/app_config.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/network_utils.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:jatai_etadmin/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
                    "Procuration".tr.capitalizeFirstLetter(),
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 40),
                  ),
                  20.height,
                  Text(
                    "Découvrez ici un aperçu des documents liés à la procuration"
                        .tr
                        .capitalizeFirstLetter(),
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  20.height,
                  Text(
                    "Procuration pour les locataires entrants"
                        .tr
                        .capitalizeFirstLetter(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ).paddingAll(8),
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
                              documentUrl(
                                  wizardState.formValues['entranDocumentId'])!,
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
                                      pdfPath: documentUrl(wizardState
                                          .formValues['entranDocumentId'])!,
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
                  Text(
                    "Procuration pour les locataires sortants"
                        .tr
                        .capitalizeFirstLetter(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ).paddingAll(8),
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
                              documentUrl(
                                  wizardState.formValues['sortantDocumentId'])!,
                              headers:
                                  buildHeaderTokens(), // 👈 ajoute les headers ici
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
                                      pdfPath: documentUrl(wizardState
                                          .formValues['sortantDocumentId'])!,
                                      title:
                                          "Prévisualisation de la procuration",
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

class SummaryPdfView extends StatefulWidget {
  final String pdfPath;
  final String title;
  final String? footerText;
  final String footerButtonText;
  final Widget? customFooter;
  final Review? thereview;

  const SummaryPdfView({
    super.key,
    required this.pdfPath,
    required this.title,
    this.footerText,
    this.footerButtonText = 'Confirm',
    this.customFooter,
    this.thereview,
  });

  @override
  State<SummaryPdfView> createState() => _SummaryPdfViewState();
}

class _SummaryPdfViewState extends State<SummaryPdfView> {
  late PdfViewerController _pdfController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      _pdfController = PdfViewerController();
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700, color: blackColor, fontSize: 13),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: colorScheme.onSecondary),
            onPressed: () {
              shareLinkData(
                context,
                "${AppConfig.simplebaseUrl}/etat-des-lieux/${widget.thereview?.id}",
                subject: "Partager l'état des lieux".tr,
                message: "Voici le lien de l'état des lieux".tr,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(
            color: theme.primaryColor,
            height: 10,
            thickness: 4,
          ),
          Expanded(
            child: _buildPdfContent(theme, colorScheme),
          ),
          Divider(
            color: context.primaryColor,
          ),
          if (widget.customFooter != null) widget.customFooter!
        ],
      ),
    );
  }

  Widget _buildPdfContent(ThemeData theme, ColorScheme colorScheme) {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load PDF',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            inventoryActionButton(
              context,
              title: 'Retry',
              icon: Icons.refresh,
              onPressed: _reloadPdf,
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    return SfPdfViewer.network(
      widget.pdfPath,
      controller: _pdfController,
      headers: buildHeaderTokens(),
    );
  }

  Future<void> _reloadPdf() async {
    // setState(() => _isLoading = true);
    // _pdfController.setZoom(Offset(0, 0), 1);
    // await _loadPdf();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

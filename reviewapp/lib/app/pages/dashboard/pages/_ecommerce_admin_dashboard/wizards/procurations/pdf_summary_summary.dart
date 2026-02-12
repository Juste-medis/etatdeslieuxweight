import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/app_config/app_config.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole3.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

import 'dart:typed_data';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class SumaryOfSummary extends StatefulWidget {
  final AppThemeProvider wizardState;
  final bool? seesign;
  const SumaryOfSummary({super.key, required this.wizardState, this.seesign});

  @override
  State<SumaryOfSummary> createState() => _SumaryOfSummaryState();
}

class _SumaryOfSummaryState extends State<SumaryOfSummary> {
  @override
  void dispose() {
    super.dispose();
  }

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
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Padding(
          padding: EdgeInsets.all(_padding / 2.75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Aperçu des documents liés à la procuration".tr
                    .capitalizeFirstLetter(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              5.height,
              Text(
                "Procuration pour les locataires entrants".tr
                    .capitalizeFirstLetter(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).paddingAll(8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 350,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.0,
                        spreadRadius: 2.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: -25,
                        child: PdfPreviewer(
                          url: documentUrl(
                            widget.wizardState.formValues['entranDocumentId'],
                          )!,
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierColor: theme.colorScheme.primaryContainer,
                              barrierDismissible: true,
                              builder: (context) {
                                return SummaryPdfView(
                                  seesign: widget.seesign ?? false,
                                  pdfPath: documentUrl(
                                    widget
                                        .wizardState
                                        .formValues['entranDocumentId'],
                                  )!,
                                  title: "Prévisualisation de la procuration",
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
                "Procuration pour les locataires sortants".tr
                    .capitalizeFirstLetter(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ).paddingAll(8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 350,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.0,
                        spreadRadius: 2.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: -25,
                        child: PdfPreviewer(
                          url: documentUrl(
                            widget.wizardState.formValues['sortantDocumentId'],
                          )!,
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierColor: theme.colorScheme.primaryContainer,
                              barrierDismissible: true,
                              builder: (context) {
                                return SummaryPdfView(
                                  seesign: widget.seesign ?? false,
                                  pdfPath: documentUrl(
                                    widget
                                        .wizardState
                                        .formValues['sortantDocumentId'],
                                  )!,
                                  title: "Prévisualisation de la procuration",
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
        ),
      ),
    );
  }
}

class SummaryPdfView extends StatefulWidget {
  final String pdfPath;
  final String title;
  final String? footerText;
  final String footerButtonText;
  final Widget? customFooter;
  final Review? thereview;
  final bool shareable;
  final bool seesign;

  const SummaryPdfView({
    super.key,
    required this.pdfPath,
    required this.title,
    this.footerText,
    this.footerButtonText = 'Confirm',
    this.customFooter,
    this.thereview,
    this.shareable = true,
    this.seesign = false,
  });

  @override
  State<SummaryPdfView> createState() => _SummaryPdfViewState();
}

class _SummaryPdfViewState extends State<SummaryPdfView> {
  PdfController? _pdfController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<Uint8List> _loadPdfBytesFromNetwork(
    String url,
    Map<String, String>? headers,
  ) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw Exception("Failed to load PDF from network");
  }

  Future<void> _loadPdf() async {
    try {
      String path = widget.pdfPath;

      // -----------------------------
      // Local PDF
      // -----------------------------
      if (path.contains('/storage/') || path.contains('mon_etatsdeslieux/')) {
        _pdfController = PdfController(document: PdfDocument.openFile(path));
      }
      // -----------------------------
      // Network PDF
      // -----------------------------
      else {
        Uint8List data = await _loadPdfBytesFromNetwork(
          path,
          buildHeaderTokens(),
        );

        _pdfController = PdfController(
          document: PdfDocument.openData(data),
          initialPage: widget.seesign ? _pdfController?.pagesCount ?? 1 : 1,
        );
      }

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      debugPrint("Error loading PDF: $e");
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
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 13,
          ),
        ),
        actions: [
          if (widget.shareable)
            IconButton(
              icon: Icon(Icons.share, color: colorScheme.onSecondary),
              onPressed: () {
                shareLinkData(
                  context,
                  "${AppConfig.simplebaseUrl}/etat-des-lieux/${widget.thereview?.id}"
                  "${Jks.isNetworkAvailable ? '?mode=offline' : '?mode=view'}",
                  subject: "Partager l'état des lieux".tr,
                  message: "Voici le lien de l'état des lieux".tr,
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Divider(color: theme.primaryColor, height: 10, thickness: 4),
          Expanded(child: _buildPdfContent(theme, colorScheme)),
          Divider(color: theme.primaryColor),
          if (widget.customFooter != null) widget.customFooter!,
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
              'Erreur lors du chargement du PDF.'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            inventoryActionButton(
              context,
              title: 'Reéssayer'.tr,
              icon: Icons.refresh,
              onPressed: _reloadPdf,
            ),
          ],
        ),
      );
    }

    if (_isLoading || _pdfController == null) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    return PdfView(controller: _pdfController!, scrollDirection: Axis.vertical);
  }

  Future<void> _reloadPdf() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    await _loadPdf();
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}

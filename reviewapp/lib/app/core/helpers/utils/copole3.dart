import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pdfx/pdfx.dart';

class PdfPreviewer extends StatefulWidget {
  final String? url;
  const PdfPreviewer({super.key, required this.url});

  @override
  State<PdfPreviewer> createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<PdfPreviewer> {
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    if (widget.url == null || widget.url!.isEmpty) {
      setState(() => _error = "URL manquante");
      return;
    }
    try {
      if (widget.url!.contains('/storage/') ||
          widget.url!.contains('mon_etatsdeslieux/')) {
        _pdfController = PdfControllerPinch(
          document: PdfDocument.openFile(widget.url!),
        );
        setState(() => _isLoading = false);
        return;
      }

      final bytes = await loadPdfFromNetwork(
        widget.url!,
        headers: buildHeaderTokens(),
      );
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(bytes),
      );
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _error = "Erreur de chargement");
    }
  }

  @override
  void dispose() {
    if (!_isLoading && _error == null) {
      _pdfController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (_isLoading) {
      return Center(
        child: SizedBox(
          width: 180,
          child: LinearProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ).paddingSymmetric(horizontal: 16);
    }
    return PdfViewPinch(
      key: Key('pdf_preview_${generateClientId('pdf')}'),
      padding: 1,
      controller: _pdfController,
      onDocumentLoaded: (doc) {},
    );
  }
}

Widget buildAppNotificationWidget(
  BuildContext context,
  AppLanguageProvider notificationProvider,
) {
  final _theme = Theme.of(context);
  return AnimatedPositioned(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    top: notificationProvider.showNotification ? 0 : -300,
    left: 0,
    right: 0,
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
                RichTextWidget(
                  list: [
                    if (notificationProvider.notificationTitle != null)
                      TextSpan(
                        text: "${notificationProvider.notificationTitle}\n",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    TextSpan(
                      text: notificationProvider.notificationMessage,
                      style: _theme.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).paddingOnly(top: 35, right: 5, left: 5),
      ),
    ),
  );
}

Widget emptyReviewWidget(BuildContext context) {
  return Scaffold(
    backgroundColor: context.theme.colorScheme.primaryContainer,
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButton(),
            40.height,
            // Title placeholder
            Container(
              height: 32,
              width: 240,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            24.height,
            // Address placeholder
            Container(
              height: 24,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            12.height,
            Container(
              height: 18,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            32.height,
            // Cards placeholders
            ...List.generate(
              6,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

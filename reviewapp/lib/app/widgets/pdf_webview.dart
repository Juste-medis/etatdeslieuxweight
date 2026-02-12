import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

class PdfHtmlWebView extends StatefulWidget {
  final String html; // ta page contenant le <a>
  const PdfHtmlWebView({super.key, required this.html});
  @override
  State<PdfHtmlWebView> createState() => _PdfHtmlWebViewState();
}

class _PdfHtmlWebViewState extends State<PdfHtmlWebView> {
  InAppWebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(data: widget.html),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        useOnDownloadStart: true,
        // Optionnel si redirections complexes
        useShouldOverrideUrlLoading: true,
      ),
      onWebViewCreated: (c) => _controller = c,
      onDownloadStartRequest: (controller, req) async {
        final url = req.url.toString();
        try {
          final r = await http.get(Uri.parse(url));
          if (r.statusCode != 200) {
            debugPrint("Download HTTP ${r.statusCode}");
            return;
          }
          final dir = await getExternalStorageDirectory();
          final file = File("${dir!.path}/document.pdf");
          await file.writeAsBytes(r.bodyBytes);
          await OpenFile.open(file.path);
        } catch (e) {
          debugPrint("Erreur download: $e");
        }
      },
      shouldOverrideUrlLoading: (controller, nav) async {
        // Laisser passer les liens de fichier
        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}

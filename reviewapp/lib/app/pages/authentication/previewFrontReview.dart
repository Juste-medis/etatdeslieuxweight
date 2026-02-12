// 🐦 Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:go_router/go_router.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../widgets/widgets.dart';

class PreviewFrontReview extends StatefulWidget {
  final String? url;

  const PreviewFrontReview({super.key, this.url});

  @override
  State<PreviewFrontReview> createState() => _PreviewFrontReviewState();
}

class _PreviewFrontReviewState extends State<PreviewFrontReview> {
  @override
  void initState() {
    super.initState();
    // Enlève l’ouverture automatique qui “prend” la navigation
    // if (widget.url != null) {
    //   commonLaunchUrl(widget.url!, launchMode: LaunchMode.inAppBrowserView);
    // }
  }

  Future<void> _openExternal() async {
    final url = widget.url;
    if (url == null) return;
    final uri = Uri.tryParse(url);
    if (uri == null) {
      toast('URL invalide');
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.inAppWebView);
    if (!ok) {
      toast('Verifiez que votre navigateur est bien installé');
      debugPrint('launchUrl externalApplication FAILED for $uri');
    } else {
      debugPrint('launchUrl externalApplication OK for $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primaryContainer,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          30.height,
          BackButton(
            onPressed: () {
              context.go("/");
            },
          ),
          SizedBox(
            height: context.height() - 100,
            width: context.width(),
            child: InAppWebView(
              initialUrlRequest: widget.url != null
                  ? URLRequest(url: WebUri(widget.url!))
                  : null,
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useOnDownloadStart: true,
                // Optionnel si redirections complexes
                useShouldOverrideUrlLoading: true,
              ),
              onDownloadStartRequest: (controller, req) async {
                final url = req.url.toString();
                myprint("Download start: $url");

                try {
                  final r = await http.get(Uri.parse(url));
                  if (r.statusCode != 200) {
                    debugPrint("Download HTTP ${r.statusCode}");
                    return;
                  }
                  final dir = await getExternalStorageDirectory();
                  final file = File("${dir!.path}/etat_des_lieux.pdf");
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
            ),
          ),
        ],
      ),
    );
  }
}

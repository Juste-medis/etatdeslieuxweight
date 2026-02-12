import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui; // Required for ui.Image
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';

class SignaturePadWidget extends StatefulWidget {
  final void Function()? onDrawEnd;
  final String? getter;
  final String? username;
  const SignaturePadWidget(this.getter,
      {super.key, this.onDrawEnd, this.username});

  @override
  _SignaturePadWidgetState createState() => _SignaturePadWidgetState();
}

class _SignaturePadWidgetState extends State<SignaturePadWidget> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SfSignaturePad(
                    key: _signaturePadKey,
                    backgroundColor: Colors.white,
                    strokeColor: Colors.black,
                    minimumStrokeWidth: 1.0,
                    maximumStrokeWidth: 4.0,
                    onDrawEnd: () async {
                      try {
                        // Get signature as ui.Image
                        final ui.Image? signatureImage =
                            await _signaturePadKey.currentState!.toImage();

                        if (signatureImage != null) {
                          // Convert ui.Image to ByteData (PNG format)
                          final ByteData? byteData = await signatureImage
                              .toByteData(format: ui.ImageByteFormat.png);

                          if (byteData != null) {
                            // Convert ByteData to Uint8List
                            final Uint8List signatureBytes =
                                byteData.buffer.asUint8List();
                            myprint(widget.getter);
                            Jks.griffes![widget.getter ?? "content"] =
                                signatureBytes;
                          } else {
                            throw Exception(
                                'Failed to convert signature to bytes.');
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving signature: $e')),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            child: IconButton(
              onPressed: _clearSignature,
              icon: const Icon(Icons.clear, color: Colors.red),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Text(
              "<- ${widget.username != null ? "Signature de ${widget.username!}" : "déssinez votre signature ici".tr} ->",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ).center(),
        ],
      ),
    );
  }

  void _clearSignature() {
    _signaturePadKey.currentState!.clear();
    Jks.griffes![widget.getter ?? "content"] = null;
  }
}

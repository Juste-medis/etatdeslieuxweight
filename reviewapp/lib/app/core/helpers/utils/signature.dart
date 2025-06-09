import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui; // Required for ui.Image

class SignaturePadWidget extends StatefulWidget {
  final void Function()? onDrawEnd;
  final String? getter;
  const SignaturePadWidget(this.getter, {super.key, this.onDrawEnd});

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
                    border: Border.all(color: Colors.grey),
                  ),
                  child: SfSignaturePad(
                    key: _signaturePadKey,
                    backgroundColor: Colors.white,
                    strokeColor: Colors.black,
                    minimumStrokeWidth: 1.0,
                    maximumStrokeWidth: 4.0,
                    onDrawEnd: () async {
                      Jks.pSp!["procuationspk"] = _signaturePadKey.currentState!
                          .toPathList()
                          .isNotEmpty;

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
                            Jks.pSp![widget.getter ?? "content"] =
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
          )
        ],
      ),
    );
  }

  void _clearSignature() {
    _signaturePadKey.currentState!.clear();
    Jks.pSp!["procuationspk"] =
        _signaturePadKey.currentState!.toPathList().isNotEmpty;
    Jks.pSp![widget.getter ?? "content"] = null;
  }
}

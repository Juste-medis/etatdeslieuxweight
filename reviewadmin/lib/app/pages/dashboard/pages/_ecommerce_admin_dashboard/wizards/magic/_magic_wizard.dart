// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/magic/analyse_image.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/magic/magic_results.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'magic_presentation.dart';
import 'magic_loader.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etadmin/app/core/helpers/extensions/_build_context_extensions.dart';

class MagicWizard extends StatefulWidget {
  final dynamic type;
  final int? piece;

  const MagicWizard({super.key, this.type, this.piece});

  @override
  State<MagicWizard> createState() => _MagicWizardState();
}

class _MagicWizardState extends State<MagicWizard> {
  final PageController _pageController = PageController();
  late AppThemeProvider wizardState;
  late ReviewProvider reviewState;

  @override
  void dispose() {
    _pageController.dispose();
    wizardState.initMagicSelectedPiece();
    super.dispose();
  }

  @override
  void initState() {
    // Initialize the wizard state
    reviewState = context.read<ReviewProvider>();
    reviewState.currentStep = MagicStep.presentation;
    wizardState = context.read<AppThemeProvider>();
    super.initState();
    wizardState.initMagicSelectedPiece();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
    reviewState = context.watch<ReviewProvider>();
  }

  void _sendPhotoTorecognize(
      ReviewProvider reviewState, AppThemeProvider wizardState) async {
    final payload = {
      'photos': wizardState.magicSelectedPiece.photos,
      "review_id": reviewState.editingReview?.id,
      "piece_order": widget.piece,
    };
    _nextStep();
    await magicanalyse(payload).then((res) async {
      if (res.status == true) {
        // Navigator.of(context).pop();
        var things = <InventoryOfThing>[];
        try {
          int actualOrder = wizardState.inventoryofPieces
                  .firstWhere((element) => element.order == widget.piece,
                      orElse: () => wizardState.inventoryofPieces[0])
                  .order ??
              0;
          things = (res.data as List).asMap().entries.map((entry) {
            actualOrder += 1;
            final map = Map<String, dynamic>.from(entry.value as Map);
            map['order'] = actualOrder;
            map['newlyAdded'] = true;
            map["meta"] = {
              "analyzedByAI": true,
              "analyzedAt": DateTime.now().toIso8601String()
            };
            return InventoryOfThing.fromJson(map);
          }).toList();
        } catch (e) {
          my_inspect(e);
          things = [];
        }
        if (things.isEmpty) {
          await showFullScreenSuccessDialog(
            context,
            icon: Icons.warning_amber_rounded,
            title: "Aucun élément n'a été détecté sur les photos téléchargées.",
            message:
                "Veuillez réessayer avec des photos plus claires ou de meilleure qualité.",
            okText: 'Continuer',
            onOk: () {
              context.popRoute();
            },
          );
          context.popRoute();
          return;
        }

        wizardState.updateMagicSelectedPiece(
          wizardState.magicSelectedPiece.copyWith(things: things),
        );

        var list = wizardState.inventoryofPieces;
        var topSelectedPiece = wizardState.inventoryofPieces.firstWhere(
            (element) => element.order == widget.piece,
            orElse: () => wizardState.inventoryofPieces[0]);

        topSelectedPiece.things = [
          ...topSelectedPiece.things ?? [],
          ...things,
        ];

        topSelectedPiece.photos = [
          ...topSelectedPiece.photos ?? [],
          ...wizardState.magicSelectedPiece.photos ?? [],
        ];

        wizardState.updateInventory(
            iop: list.map((actpiece) {
          if (actpiece.order == widget.piece) {
            return topSelectedPiece;
          }
          return actpiece;
        }).toList());

        _nextStep();
      }
    }).catchError((e) {
      my_inspect(e);
      // toast(e.toString());
    });
    wizardState.setloading(false);
  }

  void _nextStep() async {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = context.watch<ReviewProvider>();

    return Consumer<AppThemeProvider>(
      builder: (context, lang, child) {
        return Scaffold(
          backgroundColor: context.theme.colorScheme.primaryContainer,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.close_rounded, size: 30),
                onPressed: () {
                  context.popRoute();
                },
                color: Colors.grey.shade600,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable swipe
                  onPageChanged: (index) {
                    setState(() {
                      reviewState.updateInventory(
                        step: MagicStep.values[index],
                      );
                    });
                  },
                  children: [
                    KeepAliveWidget(
                      child: MagicPresentation(
                        onsTart: () {
                          _nextStep();
                        },
                      ),
                    ),
                    KeepAliveWidget(child: AnalyzeImage(
                      onsTart: () {
                        _sendPhotoTorecognize(reviewState, wizardState);
                      },
                    )),
                    const KeepAliveWidget(
                      child: MagicAnalyzing(),
                    ),
                    KeepAliveWidget(
                        child: MagicResult(
                      piece: widget.piece,
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

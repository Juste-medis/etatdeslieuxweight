import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/magic/magic_presentation.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class AnalyzeImage extends StatelessWidget {
  final VoidCallback onsTart;

  const AnalyzeImage({super.key, required this.onsTart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: wizardState.magicSelectedPiece.photos!.isEmpty
            ? null
            : () {
                onsTart();
              },
        label: Text("Suivant".tr,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: context.primaryColor,
        icon: wizardState.loading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(
                Icons.auto_awesome,
                color: Colors.white,
              ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: wizardState.formKeys[WizardStep.values[1]],
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Photographiez la pièce".tr,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          10.height,
                          Text(
                            "Pour commencer, prenez une photo claire et bien éclairée de la pièce que vous souhaitez analyser. Assurez-vous que tous les détails importants sont visibles."
                                .tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                          20.height,
                          if (wizardState.magicSelectedPiece.photos!.isEmpty)
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: theme.colorScheme.primaryContainer,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withAlpha(300),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: theme.primaryColor,
                                  ),
                                  10.height,
                                  Text(
                                    "Cliquez ci-dessous pour ajouter une photo"
                                        .tr,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ).center()
                          else
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .3,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 150,
                                      child: GridView.count(
                                        scrollDirection: Axis.horizontal,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                        children: List.generate(
                                          (wizardState
                                                  .magicSelectedPiece.photos!)
                                              .length,
                                          (index) {
                                            final _item = wizardState
                                                .magicSelectedPiece
                                                .photos![index];
                                            return JataiGalleryImageCard(
                                              width: 200,
                                              height: 200,
                                              item: _item,
                                              thingtype:
                                                  reviewState.editingReview,
                                              onDelete: () {
                                                var newList = List<String>.from(
                                                    wizardState
                                                        .magicSelectedPiece
                                                        .photos!);
                                                newList.removeAt(index);
                                                wizardState.magicSelectedPiece
                                                    .photos = newList;
                                                wizardState
                                                    .updateMagicSelectedPiece(
                                                        wizardState
                                                            .magicSelectedPiece);
                                              },
                                            );
                                          },
                                        ),
                                      ).paddingOnly(bottom: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          8.height,
                          if (wizardState.magicSelectedPiece.photos!.length < 4)
                            OutlinedButton.icon(
                                icon: Icon(Icons.add_a_photo_rounded, size: 30),
                                label: Text("Prendre une photo".tr,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold)),
                                onPressed: wizardState.magicSelectedPiece
                                            .photos!.length >=
                                        4
                                    ? null
                                    : () {
                                        wizardState.pickImage(
                                            review: reviewState.editingReview,
                                            context: context);
                                      })
                        ],
                      ),
                    ],
                  )))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/core/theme/theme.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';

import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class ThingInventory extends StatelessWidget {
  final Map<String, dynamic>? thing;
  const ThingInventory({super.key, this.thing});

  void _updatePiece(
    AppThemeProvider wizardState,
    InventoryPiece selectedPiece,
    InventoryOfThing selectedThing,
  ) {
    selectedPiece.things = selectedPiece.things!.map((thing) {
      if (thing.id == selectedThing.id) {
        return selectedThing;
      }
      return thing;
    }).toList();

    wizardState.updateInventory(
      iop: wizardState.inventoryofPieces.map((piece) {
        if (piece.id == selectedPiece.id) {
          return selectedPiece;
        }
        return piece;
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);

    var selectedPiece = wizardState.inventoryofPieces.firstWhere(
          (element) => element.id == thing!["piece"],
          orElse: () => wizardState.inventoryofPieces.first,
        ),
        selectedThing = selectedPiece.things!.firstWhere(
          (element) => (element.id == thing!["thingid"]),
          orElse: () => selectedPiece.things!.first,
        );

    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );

    return Container(
      color: theme.colorScheme.primaryContainer,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.popRoute();
                },
              ),
              title: Text(
                _lang.itemInventories,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).paddingBottom(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    editUserField(
                      initialvalue: "${selectedThing.name}",
                      layout: 'row',
                      title: "Nom de l'équipement".tr,
                      onChanged: (text) {
                        selectedThing.name = text;
                        _updatePiece(wizardState, selectedPiece, selectedThing);
                      },
                      required: true,
                    ),
                    10.height,
                    editUserField(
                      title: "Nombre".tr,
                      type: "counterfield",
                      layout: 'row',
                      items: defaultroooms,
                      placeholder: "${_lang.enterThe} ${_lang.heatingMode}",
                      initialvalue: "${selectedThing.count ?? 0}",
                      onChanged: (text) {
                        selectedThing.count = text;
                        _updatePiece(wizardState, selectedPiece, selectedThing);
                      },
                    ),
                  ],
                ),
                30.height,
                Text(
                  "état de l'équipement".tr.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                30.height,
                editUserField(
                  title: "Etat d'usure".tr,
                  type: "select",
                  layout: 'simplerow',
                  items: defaultStates,
                  placeholder: "${_lang.enterThe} ${_lang.heatingMode}",
                  initialvalue: "${selectedThing.condition}",
                  onChanged: (text) {
                    selectedThing.condition = text;
                    _updatePiece(wizardState, selectedPiece, selectedThing);
                  },
                ),
                10.height,
                editUserField(
                  title: "Fonctionnalité".tr,
                  type: "select",
                  layout: 'simplerow',
                  items: defaultTestingStates,
                  initialvalue:
                      selectedThing.testingStage ??
                      defaultTestingStates.entries.first.value,
                  onChanged: (text) {
                    selectedThing.testingStage = text;
                    _updatePiece(wizardState, selectedPiece, selectedThing);
                  },
                ),
                30.height,
                Text(
                  '${_lang.photos} (${selectedThing.photos!.length})',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                10.height,
                inventoryAddButton(
                  context,
                  title: _lang.addPhoto,
                  isLoading: Jks.wizardState.photoLoading,
                  icon: Icons.add_a_photo,
                  onPressed:
                      [
                        "completed",
                        "signing",
                      ].contains(Jks.reviewState.editingReview?.status)
                      ? null
                      : () async {
                          if (selectedThing.photos!.length >=
                              MaxPhotosPerPiece) {
                            Jks.languageState.showAppNotification(
                              message:
                                  "Vous avez atteint le nombre maximum de photos pour cet équipement."
                                      .tr,
                              title: "Limite de photos atteinte".tr,
                            );
                            return;
                          }
                          sourceSelect(
                            context: context,
                            callback: (croppedFile) async {
                              await uploadFile(
                                croppedFile,
                                thing: selectedThing,
                                cb: (photolist) {
                                  selectedThing.addphoto(photolist);
                                  _updatePiece(
                                    wizardState,
                                    selectedPiece,
                                    selectedThing,
                                  );
                                },
                              );
                            },
                          );
                        },
                ).paddingOnly(bottom: 10),
                if (selectedThing.photos!.isNotEmpty)
                  SizedBox(
                    height: selectedThing.photos!.length > 2
                        ? MediaQuery.of(context).size.height * 0.5
                        : 200,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.count(
                      primary: false,
                      crossAxisCount: responsiveValue<int>(
                        context,
                        xs: 2,
                        sm: 2,
                        md: 3,
                        lg: 4,
                      ),
                      childAspectRatio: 360 / 320,
                      mainAxisSpacing: _innerSpacing,
                      crossAxisSpacing: _innerSpacing,
                      children: List.generate(selectedThing.photos!.length, (
                        index,
                      ) {
                        final _item = selectedThing.photos![index];

                        return JataiGalleryImageCard(
                          item: _item,
                          thingtype: selectedThing,
                          onDelete: () {
                            selectedThing.photos!.removeAt(index);
                            _updatePiece(
                              wizardState,
                              selectedPiece,
                              selectedThing,
                            );
                          },
                        );
                      }),
                    ).paddingOnly(bottom: 10),
                  ),
                Text(
                  _lang.photoDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                30.height,
                editUserField(
                  title: "_lang.comments",
                  showLabel: false,
                  showplaceholder: true,
                  placeholder: _lang.comments,
                  initialvalue: selectedThing.comment ?? "",
                  type: "textarea",
                  onChanged: (text) {
                    selectedThing.comment = text;
                    _updatePiece(wizardState, selectedPiece, selectedThing);
                  },
                  required: true,
                ),
                30.height,
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete_outlined),
                  onPressed:
                      [
                        "completed",
                        "signing",
                      ].contains(Jks.reviewState.editingReview?.status)
                      ? null
                      : () async {
                          final confirmed = await showAwesomeConfirmDialog(
                            context: context,
                            title: '${_lang.delete} ',
                            description:
                                'Etes-vous sûr de vouloir supprimer cet équipement ?',
                          );
                          if (confirmed ?? false) {
                            var newPiecethings = selectedPiece.things!
                                .where((thing) => thing.id != selectedThing.id)
                                .toList();
                            selectedPiece.things = newPiecethings;
                            _updatePiece(
                              wizardState,
                              selectedPiece,
                              selectedThing,
                            );

                            context.popRoute();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcnooAppColors.kError.withOpacity(0.15),
                    foregroundColor: AcnooAppColors.kError,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    elevation: 0,
                  ),
                  label: Text(
                    "Supprimer l'équipement".tr,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AcnooAppColors.kError,
                    ),
                  ),
                ).withWidth(double.infinity),
              ],
            ).paddingSymmetric(vertical: 20, horizontal: 16),
          ],
        ),
      ),
    );
  }
}

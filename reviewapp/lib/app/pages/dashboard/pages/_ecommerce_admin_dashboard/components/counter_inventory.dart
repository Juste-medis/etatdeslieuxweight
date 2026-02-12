import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole2.dart';
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

class CounterInventory extends StatelessWidget {
  final Map<String, dynamic>? thing;
  const CounterInventory({super.key, this.thing});

  void _updateCompteur(AppThemeProvider wizardState, Compteur selectedThing) {
    wizardState.domaine.compteurs = wizardState.domaine.compteurs.map((thing) {
      if (thing.order == selectedThing.order) {
        return selectedThing;
      }
      return thing;
    }).toList();

    wizardState.updateInventory(domaine: wizardState.domaine);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);

    var selectedcompteur = wizardState.domaine.compteurs.firstWhere(
      (element) =>
          (element.order == thing!["thing"] || element.id == thing!["thingid"]),
      orElse: () => wizardState.domaine.compteurs[0],
    );

    final bgColor = wizardState.isDarkTheme
        ? theme.colorScheme.surface
        : theme.colorScheme.onPrimary;
    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    return Container(
      color: bgColor,
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
                "Modifier un compteur".tr,
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
                      required: true,
                      title: "Nom/type de compteur".tr,
                      type: "select",
                      layout: 'row',
                      items: defaulcompteurs,
                      placeholder: "${_lang.enterThe} ${_lang.heatingMode}",
                      initialvalue: "${selectedcompteur.type}",
                      onChanged: (text) {
                        selectedcompteur.type = text;
                        selectedcompteur.name = defaulcompteurs[text]!["name"];
                        _updateCompteur(wizardState, selectedcompteur);
                      },
                    ),
                    10.height,
                  ],
                ),
                50.height,
                Text(
                  "Caractéristiques du compteur".tr.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                5.height,
                editUserField(
                  required: true,
                  layout: 'column',
                  title: "Numéros de série/Identifiant".tr,
                  placeholder: "${_lang.enterThe} ${_lang.heatingMode}",
                  initialvalue: selectedcompteur.serialNumber ?? "",
                  onChanged: (text) {
                    selectedcompteur.serialNumber = text;
                    _updateCompteur(wizardState, selectedcompteur);
                  },
                ),
                if (selectedcompteur.type != "electricity")
                  editUserField(
                    title: "Relevé".tr,
                    type: "number",
                    placeholder: "${_lang.enterThe} ${_lang.heatingMode}",
                    initialvalue: selectedcompteur.initialReading ?? "",
                    rightwidget:
                        (selectedcompteur.type == "cold_water" ||
                            selectedcompteur.type == "hot_water" ||
                            selectedcompteur.type == "gas")
                        ? "m3"
                        : selectedcompteur.type == "electricity"
                        ? "kWh"
                        : selectedcompteur.type == "energy"
                        ? "kWh"
                        : " ",
                    onChanged: (text) {
                      selectedcompteur.initialReading = double.tryParse(
                        "$text",
                      );
                      _updateCompteur(wizardState, selectedcompteur);
                    },
                  ),
                30.height,
                if (selectedcompteur.type == "electricity")
                  Text(
                    "Heures pleines/creuses".tr.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                if (selectedcompteur.type == "electricity")
                  Row(
                    children: [
                      Expanded(
                        child: editUserField(
                          title: "Relevé HP".tr,
                          type: "number",
                          rightwidget: "kWh",
                          placeholder: "Heures pleines initial",
                          initialvalue: selectedcompteur.initialReadingHp ?? "",
                          onChanged: (text) {
                            selectedcompteur.initialReadingHp = double.tryParse(
                              "$text",
                            );
                            _updateCompteur(wizardState, selectedcompteur);
                          },
                        ),
                      ),
                      10.width,
                      Expanded(
                        child: editUserField(
                          title: "Relevé HC".tr,
                          type: "number",
                          rightwidget: "kWh",
                          placeholder: "Heures creuses initial",
                          initialvalue: selectedcompteur.initialReadingHc ?? "",
                          onChanged: (text) {
                            selectedcompteur.initialReadingHc = double.tryParse(
                              "$text",
                            );
                            _updateCompteur(wizardState, selectedcompteur);
                          },
                        ),
                      ),
                    ],
                  ),
                30.height,
                Text(
                  '${_lang.photos} (${selectedcompteur.photos!.length})',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                10.height,
                inventoryAddButton(
                  context,
                  title: _lang.addPhoto,
                  icon: Icons.add_a_photo,
                  isLoading: Jks.wizardState.photoLoading,
                  onPressed:
                      [
                        "completed",
                        "signing",
                      ].contains(Jks.reviewState.editingReview?.status)
                      ? null
                      : () async {
                          if (selectedcompteur.photos!.length >=
                              MaxPhotosPerPiece) {
                            Jks.languageState.showAppNotification(
                              message:
                                  "Vous avez atteint le nombre maximum de photos pour ce compteur."
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
                                thing: selectedcompteur,
                                cb: (photolist) {
                                  selectedcompteur.photos!.add(photolist);
                                  _updateCompteur(
                                    wizardState,
                                    selectedcompteur,
                                  );
                                },
                              );
                            },
                          );
                        },
                ).paddingOnly(bottom: 10),
                if (selectedcompteur.photos!.isNotEmpty)
                  SizedBox(
                    height: selectedcompteur.photos!.length > 2
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
                      children: List.generate(selectedcompteur.photos!.length, (
                        index,
                      ) {
                        final _item = selectedcompteur.photos![index];
                        return JataiGalleryImageCard(
                          item: _item,
                          thingtype: selectedcompteur,
                          onDelete: () {
                            selectedcompteur.photos!.removeAt(index);
                            _updateCompteur(wizardState, selectedcompteur);
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
                Text(
                  _lang.comments,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                editUserField(
                  title: "",
                  showLabel: false,
                  showplaceholder: true,
                  placeholder: _lang.comments,
                  initialvalue: selectedcompteur.comment ?? "",
                  type: "textarea",
                  onChanged: (text) {
                    selectedcompteur.comment = text;
                    _updateCompteur(wizardState, selectedcompteur);
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
                                'êtes-vous sûr de vouloir supprimer ce compteur ?',
                          );
                          if (confirmed ?? false) {
                            wizardState.domaine.compteurs.removeWhere(
                              (element) =>
                                  element.order == selectedcompteur.order ||
                                  element.id == selectedcompteur.id,
                            );
                            wizardState.updateInventory(
                              domaine: wizardState.domaine,
                            );
                            Jks.savereviewStep();
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
                    "Supprimer le compteur".tr,
                    style: theme.textTheme.bodyLarge,
                  ),
                ).withWidth(double.infinity),
                70.height,
              ],
            ).paddingSymmetric(vertical: 20, horizontal: 16),
          ],
        ),
      ),
    );
  }
}

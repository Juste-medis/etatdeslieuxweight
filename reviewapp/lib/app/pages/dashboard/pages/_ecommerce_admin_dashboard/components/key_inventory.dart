import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/theme.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';

import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class ClesInventory extends StatelessWidget {
  final Map<String, dynamic>? thing;
  const ClesInventory({super.key, this.thing});

  void _updateCleDePorte(
      AppThemeProvider wizardState, CleDePorte selectedThing) {
    wizardState.domaine.clesDePorte =
        wizardState.domaine.clesDePorte.map((thing) {
      if (thing.order == selectedThing.order) {
        return selectedThing;
      }
      return thing;
    }).toList();

    wizardState.updateInventory(
      domaine: wizardState.domaine,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);

    var selectedcle = wizardState.domaine.clesDePorte.firstWhere(
        (element) => (element.order == thing!["thing"] ||
            element.id == thing!["thingid"]),
        orElse: () => wizardState.domaine.clesDePorte[0]);

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
              "Modifier une clé".tr,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ).paddingBottom(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  editUserField(
                    initialvalue: "${selectedcle.name}",
                    layout: 'row',
                    title: "Nom/type de la clé".tr,
                    onChanged: (text) {
                      selectedcle.name = text;
                      _updateCleDePorte(wizardState, selectedcle);
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
                    initialvalue: "${selectedcle.count ?? 0}",
                    onChanged: (text) {
                      selectedcle.count = text;
                      _updateCleDePorte(wizardState, selectedcle);
                    },
                  ),
                ],
              ),
              30.height,
              Text(
                "Caractéristiques de la clé".tr.toUpperCase(),
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: theme.colorScheme.onSurface),
              ),
              30.height,
              Text(
                '${_lang.photos} (${selectedcle.photos!.length})',
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: theme.colorScheme.onSurface),
              ),
              10.height,
              inventoryAddButton(
                context,
                title: _lang.addPhoto,
                icon: Icons.add_a_photo,
                onPressed: () async {
                  sourceSelect(
                      context: context,
                      callback: (croppedFile) async {
                        await uploadFile(croppedFile, thing: selectedcle,
                            cb: (photolist) {
                          selectedcle.photos!.add(photolist);
                          _updateCleDePorte(wizardState, selectedcle);
                        });
                      });
                },
              ).paddingOnly(bottom: 10),
              if (selectedcle.photos!.isNotEmpty)
                SizedBox(
                  height: selectedcle.photos!.length > 2
                      ? MediaQuery.of(context).size.height * 0.5
                      : 200,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
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
                    children: List.generate(
                      selectedcle.photos!.length,
                      (index) {
                        final _item = selectedcle.photos![index];
                        return JataiGalleryImageCard(
                            item: _item,
                            thingtype: selectedcle,
                            onDelete: () {
                              selectedcle.photos!.removeAt(index);
                              _updateCleDePorte(wizardState, selectedcle);
                            });
                      },
                    ),
                  ).paddingOnly(bottom: 10),
                ),
              Text(
                _lang.photoDescription,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
              30.height,
              Text(
                _lang.comments,
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: theme.colorScheme.onSurface),
              ),
              editUserField(
                title: "",
                showLabel: false,
                showplaceholder: true,
                placeholder: _lang.comments,
                initialvalue: selectedcle.comment ?? "",
                type: "textarea",
                onChanged: (text) {
                  selectedcle.comment = text;
                  _updateCleDePorte(wizardState, selectedcle);
                },
                required: true,
              ),
              30.height,
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_outlined),
                onPressed: () async {
                  final confirmed = await showAwesomeConfirmDialog(
                    context: context,
                    title: '${_lang.delete} ',
                    description:
                        'êtes-vous sûr de vouloir supprimer cette clé ?',
                  );
                  if (confirmed ?? false) {
                    wizardState.domaine.clesDePorte.removeWhere((element) =>
                        element.order == selectedcle.order ||
                        element.id == selectedcle.id);
                    wizardState.updateInventory(
                      domaine: wizardState.domaine,
                    );
                    Jks.savereviewStep();

                    context.popRoute();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor.withOpacity(0.15),
                  foregroundColor: context.primaryColor,
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
                label: Text("Supprimer".tr, style: theme.textTheme.bodyLarge),
              ).withWidth(double.infinity),
              70.height,
            ],
          ).paddingSymmetric(vertical: 20, horizontal: 16),
        ],
      )),
    );
  }
}

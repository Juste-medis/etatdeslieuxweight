import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/theme.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/providers/_theme_provider.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/prompt_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:go_router/go_router.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/_app_colors.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';

class InventoryOfRooms extends StatelessWidget {
  final Review? review;
  const InventoryOfRooms({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();
    final _lang = l.S.of(context);
    Jks.savereviewStep = () async {
      if (review != null) {
        try {
          wizardState.setloading(true);
          await reviewState.updateThereview(
              wizardState: wizardState, review!, "pieces");
          wizardState.setloading(false);
        } catch (e) {
          show_common_toast(
              "Une erreur s'est produite, veuillez réessayer plus tard.".tr,
              context);
        }
      } else {}
    };
    return Scaffold(
      backgroundColor: reviewState.editingReview != null
          ? wizardState.isDarkTheme
              ? blackColor
              : whiteColor
          : null,
      bottomNavigationBar: (reviewState.editingReview != null &&
              wizardState.edited)
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: wizardState.loading ? null : Jks.savereviewStep,
                    icon: wizardState.loading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              color: AcnooAppColors.kWhiteColor,
                              strokeWidth: 2,
                            ),
                          )
                        : null,
                    label: Text("Enrégistrer les modifications".tr),
                  ),
                ],
              ),
            )
          : null,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: wizardState.formKeys[WizardStep.values[4]],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      if (reviewState.editingReview != null)
                        backbutton(
                          () => {context.popRoute()},
                        ),
                      Text(
                        _lang.roomInventories.capitalizeFirstLetter(),
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "listes des pièces et identifiées dans l'enceinte du bien"
                            .tr
                            .capitalizeFirstLetter(),
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: theme.colorScheme.onSurface),
                      ),
                      20.height,
                      inventoryAddButton(
                        context,
                        title: _lang.room,
                        onPressed: () async {
                          final formKey = GlobalKey<FormState>();
                          var name = "", type = "livingRoom";
                          await showAwesomeFormDialog(
                              context: context,
                              submitText: _lang.add,
                              title: "${_lang.add} ${_lang.room}",
                              formContent: Column(
                                key: const ValueKey('addpiece'),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  editUserField(
                                    showplaceholder: true,
                                    title: _lang.room,
                                    placeholder:
                                        "${_lang.enterThe} ${_lang.room} ${_lang.name}",
                                    onChanged: (text) {
                                      name = text;
                                    },
                                    required: true,
                                  ),
                                  editUserField(
                                    title: _lang.type,
                                    type: "select",
                                    layout: 'column',
                                    items: defaultroooms,
                                    placeholder:
                                        "${_lang.enterThe} ${_lang.heatingMode}",
                                    onChanged: (text) {
                                      type = text;
                                    },
                                  ),
                                ],
                              ),
                              formKey: formKey);
                          if (name.isEmpty) return;
                          // Add the new room to the list
                          var list = wizardState.inventoryofPieces;
                          list.insert(
                              0,
                              InventoryPiece(
                                name: name,
                                count: 1,
                                things: basethings,
                                type: type,
                                area: 1,
                                comment: "",
                                id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
                                order: wizardState.inventoryofPieces.length + 2,
                                meta: {'icon': defaultroooms[type]!['icon']},
                              ));
                          var review = wizardState.updateInventory(iop: list);
                          Jks.savereviewStep();
                        },
                      ).paddingOnly(bottom: 20),
                      ReorderableListView(
                        dragStartBehavior: DragStartBehavior.start,
                        buildDefaultDragHandles: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final list = wizardState.inventoryofPieces;
                          final item = list.removeAt(oldIndex);
                          list.insert(newIndex, item);
                          wizardState.updateInventory(iop: list);
                          Jks.savereviewStep();
                        },
                        children: [
                          ...(reviewState.editingReview != null
                                  ? reviewState.editingReview!.pieces!
                                  : wizardState.inventoryofPieces)
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key, item = entry.value;
                            return Column(
                              key: ValueKey('iop${item.order}'),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    context.push(
                                      '/piece-inventory',
                                      extra: item.order,
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ReorderableDragStartListener(
                                        index: index,
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Image.asset(
                                            defaultroooms[item.type]!["icon"],
                                            fit: BoxFit.contain,
                                            color: wizardState.isDarkTheme
                                                ? theme.colorScheme.secondary
                                                : theme.colorScheme.onSecondary,
                                          ),
                                        ),
                                      ), // Product Details
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: (index !=
                                                    wizardState
                                                        .inventoryofPieces
                                                        .length)
                                                ? Border(
                                                    bottom: BorderSide(
                                                      width: 1,
                                                      color: theme
                                                          .colorScheme.outline,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.name!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.labelMedium
                                                        ?.copyWith(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(
                                                    "${item.things!.length} ${_lang.items}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodyLarge
                                                        ?.copyWith(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                ],
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                color:
                                                    AcnooAppColors.kPrimary700,
                                              )
                                            ],
                                          ).paddingOnly(
                                            left: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(
                                    top: 4,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ],
                  )))),
    );
  }
}

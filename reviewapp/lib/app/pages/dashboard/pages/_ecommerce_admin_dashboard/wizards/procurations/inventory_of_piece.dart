import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/actions.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/theme.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/providers/_theme_provider.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/prompt_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:go_router/go_router.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class InventoryOfRooms extends StatelessWidget {
  final AppThemeProvider wizardState;
  const InventoryOfRooms({super.key, required this.wizardState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: wizardState.formKeys[WizardStep.inventoryOfRooms],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
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
                        var name = "";
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
                                order:
                                    wizardState.inventoryofPieces.length + 2));
                        wizardState.updateInventory(iop: list);
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
                      },
                      children: [
                        ...wizardState.inventoryofPieces
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      .inventoryofPieces.length)
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
                                                              FontWeight.bold),
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
                                              color: AcnooAppColors.kPrimary700,
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
                    30.height,
                    Text(
                      _lang.itemInventories.capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "listes des équipement directs identifiées dans l'enceinte du bien (pas forcément rattaché à une pièce)"
                          .tr
                          .capitalizeFirstLetter(),
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: theme.colorScheme.onSurface),
                    ),
                    20.height,
                    inventoryAddButton(
                      context,
                      title: _lang.equipment,
                      onPressed: () async {
                        final formKey = GlobalKey<FormState>();
                        var name = "";
                        await showAwesomeFormDialog(
                            context: context,
                            submitText: _lang.add,
                            title: "${_lang.add} ${_lang.equipment}",
                            formContent: Column(
                              key: const ValueKey('addequipement'),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                editUserField(
                                  showplaceholder: true,
                                  title: _lang.room,
                                  placeholder:
                                      "${_lang.enterThe} ${_lang.equipment} ${_lang.name}",
                                  onChanged: (text) {
                                    name = text;
                                  },
                                  required: true,
                                ),
                              ],
                            ),
                            formKey: formKey);
                        if (name.isEmpty) return;

                        var domain = wizardState.domaine!;
                        domain.things!.insert(0, InventoryOfThing(name: name));
                        wizardState.updateInventory(domaine: domain);
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
                        final list = wizardState.domaine!.things!;
                        final item = list.removeAt(oldIndex);
                        list.insert(newIndex, item);
                        wizardState.updateInventory(
                            domaine: wizardState.domaine);
                      },
                      children: [
                        ...wizardState.domaine!.things!
                            .asMap()
                            .entries
                            .map((entry) {
                          final index2 = entry.key, thing = entry.value;
                          return Column(
                            key: ValueKey('thing$index2'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpansionWidget(
                                expandedAlignment: Alignment.topLeft,
                                initiallyExpanded: index2 == 0,
                                titleBuilder: (animationValue, easeInValue,
                                        isExpanded, toggleFunction) =>
                                    InkWell(
                                  onTap: () => toggleFunction(animated: true),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      border: BorderDirectional(
                                        bottom: BorderSide(
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ReorderableDragStartListener(
                                                index: index2,
                                                child: SvgPicture.asset(
                                                  'assets/images/sidebar_icons/arrows-move.svg',
                                                  colorFilter: ColorFilter.mode(
                                                    theme.colorScheme.primary,
                                                    BlendMode.srcIn,
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                )),
                                            20.width,
                                            Text(
                                              thing.name!,
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        AnimatedRotation(
                                          turns: isExpanded ? 0.25 : 0,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: AcnooAppColors.kPrimary700,
                                          ),
                                        ),
                                      ],
                                    ).paddingSymmetric(vertical: 5),
                                  ),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                            child: CustomDropdownButton(
                                          onclose: () =>
                                              {wizardState.updateInventory()},
                                          buttonTitle: "${thing.count ?? 1}",
                                          buttonIcon: Icons.onetwothree_sharp,
                                          items: [...defaultcountNumber.entries]
                                              .map((e) => {
                                                    'label': e.value,
                                                    'value': e.key,
                                                  })
                                              .toList(),
                                          onChanged: (value) {
                                            var domain = wizardState.domaine;

                                            var updatedThing = thing.copyWith(
                                                count: value is int
                                                    ? value
                                                    : int.parse(value));

                                            domain!.things![index2] =
                                                updatedThing;

                                            wizardState.updateInventory(
                                                domaine: domain,
                                                liveupdate: false);
                                          },
                                        )),
                                        10.width,
                                        Flexible(
                                            child: CustomDropdownButton(
                                          buttonTitle:
                                              defaultStates[thing.condition] ??
                                                  defaultStates
                                                      .entries.first.value,
                                          buttonIcon: Icons.star,
                                          items: [...defaultStates.entries]
                                              .map((e) => {
                                                    'label': e.value,
                                                    'value': e.key,
                                                  })
                                              .toList(),
                                          onChanged: (value) {
                                            var domain = wizardState.domaine;

                                            var updatedThing = thing.copyWith(
                                                condition: value);

                                            domain!.things![index2] =
                                                updatedThing;

                                            wizardState.updateInventory(
                                                domaine: domain);
                                          },
                                        )),
                                        10.width,
                                        Flexible(
                                            child: CustomDropdownButton(
                                          buttonTitle: defaultTestingStates[
                                                  thing.testingStage] ??
                                              defaultTestingStates
                                                  .entries.first.value,
                                          buttonIcon: Icons.star,
                                          items:
                                              [...defaultTestingStates.entries]
                                                  .map((e) => {
                                                        'label': e.value,
                                                        'value': e.key,
                                                      })
                                                  .toList(),
                                          onChanged: (value) {
                                            var domain = wizardState.domaine;

                                            var updatedThing = thing.copyWith(
                                                testingStage: value);

                                            domain!.things![index2] =
                                                updatedThing;

                                            wizardState.updateInventory(
                                                domaine: domain);
                                          },
                                        )),
                                        10.width,
                                        //use chat more button instead

                                        Flexible(
                                          child: inventoryActionButton(
                                            context,
                                            title: const Icon(Icons.more_horiz),
                                            onPressed: () {
                                              context.push(
                                                '/thing-inventory',
                                                extra: {
                                                  "thing": thing.order,
                                                  "piece": wizardState.domaine
                                                },
                                              );
                                            },
                                          ).withWidth(56),
                                        ),
                                        10.width,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })
                      ],
                    ),
                  ],
                ))));
  }
}

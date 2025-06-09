import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/actions.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/theme.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/prompt_dialog.dart';
import 'package:jatai_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:go_router/go_router.dart';

class PieceInventory extends StatelessWidget {
  final int? piece;
  const PieceInventory({super.key, this.piece});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    var selectedPiece = wizardState.inventoryofPieces.firstWhere(
        (element) => element.order == piece,
        orElse: () => wizardState.inventoryofPieces[0]);
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
              _lang.itemInventories,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ).paddingBottom(10),
          ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: ShadowContainer(
                decoration: BoxDecoration(color: bgColor),
                headerBackgroundColor: bgColor,
                contentPadding: EdgeInsets.all(_padding / 2.75),
                customHeader: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        editUserField(
                          initialvalue: "${selectedPiece.name}",
                          layout: 'row',
                          title: "${_lang.name} ${_lang.oF} ${_lang.room}",
                          placeholder:
                              "${_lang.enterThe} ${_lang.fullNameMandataire}",
                          onChanged: (text) {
                            selectedPiece.name = text;
                            wizardState.updateInventory(
                              iop: wizardState.inventoryofPieces.map((piece) {
                                if (piece.order == selectedPiece.order) {
                                  return selectedPiece;
                                }
                                return piece;
                              }).toList(),
                            );
                          },
                          required: true,
                        ),
                        10.height,
                        editUserField(
                          title: _lang.type,
                          type: "select",
                          layout: 'row',
                          items: defaultroooms,
                          placeholder: "${_lang.enterThe} ${_lang.heatingMode}",
                          initialvalue: "${selectedPiece.type}",
                          onChanged: (text) {
                            selectedPiece.type = text;
                            wizardState.updateInventory(
                              iop: wizardState.inventoryofPieces.map((piece) {
                                if (piece.order == selectedPiece.order) {
                                  return selectedPiece;
                                }
                                return piece;
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                    30.height,
                    Text(
                      _lang.listOfEquipements,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: theme.colorScheme.onSurface),
                    ),
                    20.height,
                    inventoryAddButton(
                      context,
                      title: '${_lang.item}s',
                      onPressed: () async {
                        final formKey = GlobalKey<FormState>();
                        var name = "";
                        await showAwesomeFormDialog(
                            context: context,
                            submitText: _lang.add,
                            title: "${_lang.add} ${_lang.item}",
                            formContent: Column(
                              key: const ValueKey('addthing'),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                editUserField(
                                  showplaceholder: true,
                                  title: _lang.item,
                                  placeholder:
                                      "${_lang.enterThe} ${_lang.item} ${_lang.name}",
                                  onChanged: (text) {
                                    name = text;
                                  },
                                  required: true,
                                ),
                              ],
                            ),
                            formKey: formKey);
                        if (name.isEmpty) return;
                        // Add the new thing to the selected room's inventory
                        var list = wizardState.inventoryofPieces;
                        selectedPiece.things!.insert(
                            0,
                            InventoryOfThing(
                              id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
                              name: name,
                              type: selectedPiece.type,
                              order: (selectedPiece.things?.length ?? 0) + 2,
                            ));

                        // Update the inventory with the modified list
                        wizardState.updateInventory(
                          iop: list.map((piece) {
                            if (piece.order == selectedPiece.order) {
                              return selectedPiece;
                            }
                            return piece;
                          }).toList(),
                        );
                        Jks.savereviewStep();
                      },
                    ),
                  ],
                ),
                child: ReorderableListView(
                  dragStartBehavior: DragStartBehavior.start,
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = selectedPiece.things!.removeAt(oldIndex);
                    selectedPiece.things!.insert(newIndex, item);

                    wizardState.updateInventory(
                      iop: wizardState.inventoryofPieces.map((piece) {
                        if (piece.order == selectedPiece.order) {
                          return selectedPiece;
                        }
                        return piece;
                      }).toList(),
                    );
                  },
                  children: [
                    ...selectedPiece.things!.asMap().entries.map((entry) {
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  fontWeight: FontWeight.w600),
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
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                        var list =
                                            wizardState.inventoryofPieces;
                                        var updatedThing = thing.copyWith(
                                            count: value is int
                                                ? value
                                                : int.parse(value));
                                        selectedPiece.things![index2] =
                                            updatedThing;
                                        wizardState.updateInventory(
                                            iop: list.map((piece) {
                                              if (piece.order ==
                                                  selectedPiece.order) {
                                                return selectedPiece;
                                              }
                                              return piece;
                                            }).toList(),
                                            liveupdate: false);
                                      },
                                    )),
                                    10.width,
                                    Flexible(
                                        child: CustomDropdownButton(
                                      buttonTitle:
                                          defaultStates[thing.condition] ??
                                              defaultStates.entries.first.value,
                                      buttonIcon: Icons.star,
                                      items: [...defaultStates.entries]
                                          .map((e) => {
                                                'label': e.value,
                                                'value': e.key,
                                              })
                                          .toList(),
                                      onChanged: (value) {
                                        var list =
                                            wizardState.inventoryofPieces;
                                        var updatedThing =
                                            thing.copyWith(condition: value);
                                        selectedPiece.things![index2] =
                                            updatedThing;
                                        wizardState.updateInventory(
                                          iop: list.map((piece) {
                                            if (piece.order ==
                                                selectedPiece.order) {
                                              return selectedPiece;
                                            }
                                            return piece;
                                          }).toList(),
                                        );
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
                                      items: [...defaultTestingStates.entries]
                                          .map((e) => {
                                                'label': e.value,
                                                'value': e.key,
                                              })
                                          .toList(),
                                      onChanged: (value) {
                                        var list =
                                            wizardState.inventoryofPieces;
                                        var updatedThing =
                                            thing.copyWith(testingStage: value);
                                        selectedPiece.things![index2] =
                                            updatedThing;
                                        wizardState.updateInventory(
                                          iop: list.map((piece) {
                                            if (piece.order ==
                                                selectedPiece.order) {
                                              return selectedPiece;
                                            }
                                            return piece;
                                          }).toList(),
                                        );
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
                                              "piece": piece,
                                              "thingid": thing.id,
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
              )).paddingSymmetric(horizontal: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.height,
              Text(
                '${_lang.photos} (${selectedPiece.photos!.length})',
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
                        await uploadFile(croppedFile, thing: selectedPiece,
                            cb: (photolist) {
                          selectedPiece.photos!.add(photolist);
                          wizardState.updateInventory(
                            iop: wizardState.inventoryofPieces.map((piece) {
                              if (piece.order == selectedPiece.order) {
                                return selectedPiece;
                              }
                              return piece;
                            }).toList(),
                          );
                        });
                      });
                },
              ).paddingOnly(bottom: 10),
              SizedBox(
                height: selectedPiece.photos!.length > 2
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
                    selectedPiece.photos!.length,
                    (index) {
                      final _item = selectedPiece.photos![index];

                      return JataiGalleryImageCard(
                        item: _item,
                        thingtype: selectedPiece,
                        onDelete: () {
                          selectedPiece.photos!.removeAt(index);
                          wizardState.updateInventory(
                            iop: wizardState.inventoryofPieces.map((piece) {
                              if (piece.order == selectedPiece.order) {
                                return selectedPiece;
                              }
                              return piece;
                            }).toList(),
                          );
                        },
                      );
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
                type: "textarea",
                initialvalue: selectedPiece.comment ?? "",
                onChanged: (text) {
                  selectedPiece.comment = text;
                  wizardState.updateInventory(
                    iop: wizardState.inventoryofPieces.map((piece) {
                      if (piece.order == selectedPiece.order) {
                        return selectedPiece;
                      }
                      return piece;
                    }).toList(),
                  );
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
                        '${_lang.confirmationPrompt} ${_lang.deleteRoom}',
                  );
                  if (confirmed ?? false) {
                    wizardState.updateInventory(
                      iop: wizardState.inventoryofPieces
                          .where((piece) => piece.order != selectedPiece.order)
                          .toList(),
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
                label: Text(_lang.deleteRoom),
              ).withWidth(double.infinity),
              70.height,
            ],
          ).paddingSymmetric(vertical: 20, horizontal: 16),
        ],
      )),
    );
  }
}

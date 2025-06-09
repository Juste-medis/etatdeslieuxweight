import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/theme.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/prompt_dialog.dart';
import 'package:jatai_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class DetailsOfThings extends StatelessWidget {
  final AppThemeProvider wizardState;
  const DetailsOfThings({super.key, required this.wizardState});

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
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                child: ShadowContainer(
                  contentPadding: EdgeInsets.all(_padding / 2.75),
                  customHeader: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      Text(
                        _lang.itemInventories.capitalizeFirstLetter(),
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      // complementary information
                      Text(
                        _lang.roomInventoriesDescription,
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: theme.colorScheme.onSurface),
                      ),
                      20.height,
                    ],
                  ),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: wizardState.inventoryofPieces.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var piece = wizardState.inventoryofPieces[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                            padding: EdgeInsets.all(_padding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: theme.colorScheme.primaryContainer,
                              border: Border.all(
                                  color: theme.colorScheme.surface, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff2E2D74).withOpacity(0.05),
                                  blurRadius: 30,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ExpansionWidget(
                              expandedAlignment: Alignment.topLeft,
                              initiallyExpanded: index == 0,
                              titleBuilder: (animationValue, easeInValue,
                                      isExpanded, toggleFunction) =>
                                  InkWell(
                                onTap: () => toggleFunction(animated: true),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        piece.name!,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        // inventoryAddButton2(
                                        //   context,
                                        //   title: '${_lang.item}s',
                                        //   onPressed: () async {
                                        //     final formKey =
                                        //         GlobalKey<FormState>();
                                        //     var name = "";
                                        //     await showAwesomeFormDialog(
                                        //         context: context,
                                        //         submitText: _lang.add,
                                        //         title:
                                        //             "${_lang.add} ${_lang.item}",
                                        //         formContent: Column(
                                        //           key: const ValueKey(
                                        //               'addthing'),
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             editUserField(
                                        //               showplaceholder: true,
                                        //               title: _lang.item,
                                        //               placeholder:
                                        //                   "${_lang.enterThe} ${_lang.item} ${_lang.name}",
                                        //               onChanged: (text) {
                                        //                 name = text;
                                        //               },
                                        //               required: true,
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         formKey: formKey);
                                        //     if (name.isEmpty) return;
                                        //     // Add the new room to the list

                                        //     var list =
                                        //         wizardState.inventoryofPieces;
                                        //     list[index].things!.insert(
                                        //         0,
                                        //         InventoryOfThing(
                                        //             name: name,
                                        //             type: piece.type));
                                        //     wizardState.updateInventory(
                                        //         iop: list);
                                        //   },
                                        // ),
                                        10.width,
                                        AnimatedRotation(
                                          turns: isExpanded ? 0.25 : 0,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: AcnooAppColors.kPrimary700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ReorderableListView(
                                  dragStartBehavior: DragStartBehavior.start,
                                  buildDefaultDragHandles: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  onReorder: (oldIndex, newIndex) {
                                    if (newIndex > oldIndex) {
                                      newIndex -= 1;
                                    }
                                    final list = wizardState.inventoryofPieces;
                                    final item =
                                        list[index].things!.removeAt(oldIndex);
                                    list[index].things!.insert(newIndex, item);
                                    wizardState.updateInventory(iop: list);
                                  },
                                  children: [
                                    ...piece.things!
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index2 = entry.key,
                                          thing = entry.value;
                                      return Column(
                                        key: ValueKey('thing$index2'),
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          editUserDetail(
                                            // leftwidget:
                                            //     ReorderableDragStartListener(
                                            //   index: index2,
                                            //   child: SvgPicture.asset(
                                            //     'assets/images/sidebar_icons/arrows-move.svg',
                                            //     colorFilter: ColorFilter.mode(
                                            //       theme.colorScheme.primary,
                                            //       BlendMode.srcIn,
                                            //     ),
                                            //     width: 20,
                                            //     height: 20,
                                            //   ).paddingTop(5),
                                            // ),
                                            // rightwidget: Row(
                                            //   children: [
                                            //     removeButton(context,
                                            //         item: thing,
                                            //         wizardState: wizardState,
                                            //         onPressed: () {
                                            //       var list = wizardState
                                            //           .inventoryofPieces;
                                            //       list[index]
                                            //           .things!
                                            //           .removeAt(index2);
                                            //       wizardState.updateInventory(
                                            //           iop: list);
                                            //     }),
                                            //   ],
                                            // ).paddingTop(10),
                                            type: "editsimpleform",
                                            title: thing.name,
                                            secondtitle: _lang.location,
                                            placeholder:
                                                "${_lang.enterThe} ${_lang.mailbox}",
                                            dataform: {
                                              "state": {
                                                "name": "Etat".tr,
                                                "type": "String"
                                              },
                                              "color": {
                                                "name": "Couleur".tr,
                                                "type": "color"
                                              },
                                              "coating": {
                                                "name": "Revêtement".tr,
                                                "type": "String"
                                              },
                                              "comment": {
                                                "name": "Commentaire".tr,
                                                "type": "String"
                                              },
                                            },
                                            onChanged: (text, secondtext) {
                                              if (text != null) {
                                                wizardState.updateFormValue(
                                                    'iot${text}_$index2',
                                                    secondtext);
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    })
                                  ],
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                ))));
  }
}

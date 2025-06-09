import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/actions.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/prompt_dialog.dart';
import 'package:jatai_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';

class InventoryOfCounter extends StatelessWidget {
  final Review? review;
  const InventoryOfCounter({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();

    final _lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    Jks.savereviewStep = () async {
      if (review != null) {
        try {
          wizardState.setloading(true);
          await reviewState.updateThereview(review!, "compteurs",
              wizardState: wizardState);
          wizardState.setloading(false);
        } catch (e) {
          show_common_toast(
              "Une erreur s'est produite, veuillez réessayer plus tard.".tr,
              context);
        }
      } else {}
    };

    return Scaffold(
      backgroundColor: review != null
          ? wizardState.isDarkTheme
              ? blackColor
              : whiteColor
          : null,
      bottomNavigationBar: (review != null && wizardState.edited)
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
            key: wizardState.formKeys[WizardStep.values[5]],
            child: ShadowContainer(
              contentPadding: EdgeInsets.all(_padding / 2.75),
              customHeader: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (review != null)
                    backbutton(
                      () => {context.popRoute()},
                    ),
                  20.height,
                  Text(
                    "${_lang.compteurs} ".capitalizeFirstLetter(),
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  20.height,
                ],
              ),
              child: Column(
                children: [
                  ReorderableListView(
                    dragStartBehavior: DragStartBehavior.start,
                    buildDefaultDragHandles: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.height,
                        Row(
                          children: [
                            Expanded(
                              child: inventoryAddButton(
                                context,
                                title: '${_lang.item}s',
                                onPressed: () async {
                                  final formKey = GlobalKey<FormState>();
                                  var thenewThing = Compteur(
                                    name: "",
                                    type: "",
                                    order:
                                        wizardState.domaine.compteurs.length +
                                            1,
                                  );
                                  final add = await showAwesomeFormDialog(
                                    context: context,
                                    submitText: _lang.add,
                                    title: "${_lang.add} ${_lang.item}",
                                    formContent: Column(
                                      key: const ValueKey('addthingofkeys'),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        editUserField(
                                          required: true,
                                          title: "Nom/type de compteur".tr,
                                          type: "select",
                                          layout: 'column',
                                          items: defaulcompteurs,
                                          placeholder:
                                              "${_lang.enterThe} ${_lang.heatingMode}",
                                          // initialvalue: "${selectedcompteur.type}",
                                          onChanged: (text) {
                                            thenewThing.type = text;
                                            thenewThing.name =
                                                defaulcompteurs[text]!["name"];
                                          },
                                        ),
                                      ],
                                    ),
                                    formKey: formKey,
                                  );
                                  if (!add ||
                                      thenewThing.name!.isEmpty ||
                                      thenewThing.type!.isEmpty) {
                                    return;
                                  }

                                  var domain = wizardState.domaine;
                                  domain.compteurs.insert(0, thenewThing);
                                  wizardState.updateInventory(domaine: domain);
                                  Jks.savereviewStep();
                                },
                              ),
                            ),
                            100.width,
                            Text(
                              '${wizardState.domaine.compteurs.length} ${_lang.items}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        20.height,
                      ],
                    ),
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex < 0 ||
                          newIndex >= wizardState.domaine.compteurs.length) {
                        return;
                      }
                      if (oldIndex < 0 ||
                          oldIndex >= wizardState.domaine.compteurs.length) {
                        return;
                      }

                      final compteur = wizardState.domaine.compteurs[oldIndex];
                      wizardState.domaine.compteurs.removeAt(oldIndex);
                      wizardState.domaine.compteurs.insert(newIndex, compteur);

                      // Update the order of the compteur
                      for (int i = 0;
                          i < wizardState.domaine.compteurs.length;
                          i++) {
                        wizardState.domaine.compteurs[i] =
                            wizardState.domaine.compteurs[i].copyWith(
                          order: i + 1,
                        );
                      }

                      Jks.savereviewStep();
                    },
                    children: [
                      ...(reviewState.editingReview != null
                              ? reviewState.editingReview!.compteurs!
                              : wizardState.domaine.compteurs)
                          .asMap()
                          .entries
                          .map((entry) {
                        final index2 = entry.key;
                        final compteur = entry.value;
                        final originalIndex =
                            wizardState.domaine.compteurs.indexOf(compteur);

                        return Column(
                          key: ValueKey('compteur${compteur.order}'),
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
                                            compteur.name!,
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
                                        buttonTitle: "${compteur.count ?? 1} ",
                                        buttonIcon: Icons.onetwothree_sharp,
                                        items: [...defaultcountNumber.entries]
                                            .map((e) => {
                                                  'label': e.value,
                                                  'value': e.key,
                                                })
                                            .toList(),
                                        onChanged: (value) {
                                          var domain = wizardState.domaine;

                                          var updatedThing = compteur.copyWith(
                                              count: value is int
                                                  ? value
                                                  : int.parse(value));

                                          final actualindex = domain.compteurs
                                              .indexWhere((c) =>
                                                  c.order == compteur.order);

                                          if (actualindex != -1) {
                                            domain.compteurs[actualindex] =
                                                updatedThing;
                                            wizardState.updateInventory(
                                                domaine: domain,
                                                liveupdate: false);
                                          }
                                        },
                                      )),
                                      10.width,
                                      Flexible(
                                          child: CustomDropdownButton(
                                        onclose: () =>
                                            {wizardState.updateInventory()},
                                        buttonTitle:
                                            "${compteur.serialNumber ?? 1}",
                                        buttonIcon: Icons.width_wide,
                                        items: [...fairplaymap.entries]
                                            .map((e) => {
                                                  'label': e.value,
                                                  'value': e.key,
                                                })
                                            .toList(),
                                        onChanged: (value) {
                                          var domain = wizardState.domaine;

                                          var updatedThing = compteur.copyWith(
                                              serialNumber: value);

                                          domain.compteurs[originalIndex] =
                                              updatedThing;

                                          wizardState.updateInventory(
                                              domaine: domain,
                                              liveupdate: false);
                                        },
                                      )),
                                      10.width,
                                      Flexible(
                                        child: inventoryActionButton(
                                          context,
                                          title: const Icon(Icons.more_horiz),
                                          onPressed: () {
                                            context.push(
                                              '/counter-inventory',
                                              extra: {
                                                "thing": compteur.order,
                                                "thingid": compteur.id
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
                      }),
                      if (reviewState.editingReview?.compteurs!.isEmpty == true)
                        Center(
                          key: const ValueKey('nofound'),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _lang.noItemsFound,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  50.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

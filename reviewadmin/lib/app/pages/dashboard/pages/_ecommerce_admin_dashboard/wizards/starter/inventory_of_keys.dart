import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/addkeyform.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/prompt_dialog.dart';
import 'package:jatai_etadmin/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etadmin/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/extensions/_build_context_extensions.dart';

class InventoryOfKeys extends StatelessWidget {
  final Review? review;
  const InventoryOfKeys({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );

    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();
    Jks.savereviewStep = () async {
      if (review != null) {
        try {
          wizardState.setloading(true);
          await reviewState.updateThereview(
            review!,
            "cledeportes",
            wizardState: wizardState,
          );
          wizardState.setloading(false);
        } catch (e) {
          show_common_toast(
              "Une erreur s'est produite, veuillez réessayer plus tard.".tr,
              context);
        }
      } else {}
    };

    return Scaffold(
      backgroundColor: context.theme.colorScheme.primaryContainer,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
          ),
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: review != null
                ? null
                : wizardState.formKeys[WizardStep.values[5]],
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
                    "Clés".capitalizeFirstLetter(),
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
                                title: 'Ajouter une clé'.tr,
                                onPressed: ["completed", "signing"].contains(
                                        Jks.reviewState.editingReview?.status)
                                    ? null
                                    : () async {
                                        final thenewThing = CleDePorte(
                                          name: "",
                                          count: 1,
                                          order: wizardState
                                                  .domaine.clesDePorte.length +
                                              1,
                                        );
                                        final formKey = GlobalKey<FormState>();

                                        final go = await showAwesomeFormDialog(
                                          context: context,
                                          submitText: _lang.add,
                                          title: "Ajouter une clé".tr,
                                          formContent: AddKeyForm(
                                            onChanged: (text) {
                                              thenewThing.type = text;
                                              thenewThing
                                                  .name = defaulcles[text] !=
                                                      null
                                                  ? defaulcles[text]!["name"]
                                                  : text;
                                            },
                                            onChangedName: (type, name) {
                                              thenewThing.type = type;
                                              thenewThing.name = name;
                                            },
                                          ),
                                          formKey: formKey,
                                        );
                                        try {
                                          if (go && thenewThing.name == "") {
                                            show_common_toast(
                                              "Veuillez entrer un nom valide pour la clé.",
                                              context,
                                            );
                                            return;
                                          }

                                          var domain = wizardState.domaine;
                                          domain.clesDePorte
                                              .insert(0, thenewThing);
                                          wizardState.updateInventory(
                                              domaine: domain);
                                          Jks.savereviewStep();
                                        } catch (e) {}
                                      },
                              ),
                            ),
                            100.width,
                            Text(
                              '${wizardState.domaine.clesDePorte.length} ${_lang.items}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex < 0 ||
                          newIndex >= wizardState.domaine.clesDePorte.length) {
                        return;
                      }
                      if (oldIndex < 0 ||
                          oldIndex >= wizardState.domaine.clesDePorte.length) {
                        return;
                      }

                      final domain = wizardState.domaine;
                      final item = domain.clesDePorte.removeAt(oldIndex);
                      domain.clesDePorte.insert(newIndex, item);

                      // Update the order of the items
                      for (int i = 0; i < domain.clesDePorte.length; i++) {
                        domain.clesDePorte[i] =
                            domain.clesDePorte[i].copyWith(order: i + 1);
                      }

                      wizardState.updateInventory(domaine: domain);
                      Jks.savereviewStep();
                    },
                    children: [
                      ...(reviewState.editingReview != null
                              ? reviewState.editingReview!.cledeportes!
                              : wizardState.domaine.clesDePorte)
                          .asMap()
                          .entries
                          .map((entry) {
                        final index2 = entry.key;
                        final cledeporte = entry.value;
                        return Column(
                          key: ValueKey('cledp${cledeporte.order}'),
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
                                            cledeporte.name!,
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
                                      // Flexible(
                                      //     child: CustomDropdownButton(
                                      //   onclose: () =>
                                      //       {wizardState.updateInventory()},
                                      //   buttonTitle:
                                      //       "${cledeporte.count ?? 1} ",
                                      //   buttonIcon: Icons.onetwothree_sharp,
                                      //   items: [...defaultcountNumber.entries]
                                      //       .map((e) => {
                                      //             'label': e.value,
                                      //             'value': e.key,
                                      //           })
                                      //       .toList(),
                                      //   onChanged: (value) {
                                      //     var domain = wizardState.domaine;

                                      //     var updatedThing =
                                      //         cledeporte.copyWith(
                                      //             count: value is int
                                      //                 ? value
                                      //                 : int.parse(value));

                                      //     final actualindex = domain.clesDePorte
                                      //         .indexWhere((c) =>
                                      //             c.order == cledeporte.order);

                                      //     if (actualindex != -1) {
                                      //       domain.clesDePorte[actualindex] =
                                      //           updatedThing;
                                      //       wizardState.updateInventory(
                                      //           domaine: domain,
                                      //           liveupdate: false);
                                      //     }
                                      //   },
                                      // )),
                                      // 10.width,
                                      // Flexible(
                                      //     child: CustomDropdownButton(
                                      //   onclose: () =>
                                      //       {wizardState.updateInventory()},
                                      //   buttonTitle:
                                      //       "${cledeporte.serialNumber ?? 1}",
                                      //   buttonIcon: Icons.width_wide,
                                      //   items: [...fairplaymap.entries]
                                      //       .map((e) => {
                                      //             'label': e.value,
                                      //             'value': e.key,
                                      //           })
                                      //       .toList(),
                                      //   onChanged: (value) {
                                      //     var domain = wizardState.domaine;

                                      //     var updatedThing = cledeporte
                                      //         .copyWith(serialNumber: value);

                                      //     domain.clesDePorte[originalIndex] =
                                      //         updatedThing;

                                      //     wizardState.updateInventory(
                                      //         domaine: domain,
                                      //         liveupdate: false);
                                      //   },
                                      // )),
                                      // 10.width,
                                      Flexible(
                                        child: inventoryActionButton(
                                          context,
                                          title: "Compléter".tr,
                                          onPressed: () {
                                            context.push(
                                              '/key-inventory',
                                              extra: {
                                                "thing": cledeporte.order,
                                                "thingid": cledeporte.id
                                              },
                                            );
                                          },
                                        ),
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
                      if (reviewState.editingReview!.cledeportes!.isEmpty)
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/_select_tile.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class LesLocataires extends StatelessWidget {
  final Review? review;

  const LesLocataires({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);
    bool byprocuration = review != null && review!.procuration != null;

    return SingleChildScrollView(
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
                          "${_lang.tenantInfo.capitalizeFirstLetter()} ${byprocuration ? "sortant" : ""}",
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        20.height,
                        ...wizardState.inventoryLocatairesSortant
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key, item = entry.value;
                          return Column(
                            key: ValueKey('tenant${item.id}'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  inventoryFormLabel(context,
                                          title:
                                              "${_lang.tenant.capitalizeFirstLetter()} ${byprocuration ? "sortant".tr : ""} ${index + 1} :")
                                      .paddingOnly(bottom: 8),
                                  if (wizardState
                                          .inventoryLocatairesSortant.length >
                                      1)
                                    removeButton(context,
                                        item: item, wizardState: wizardState,
                                        onPressed: () {
                                      var list = wizardState
                                          .inventoryLocatairesSortant;
                                      list.removeAt(index);
                                      wizardState.updateInventory(
                                          locataires: list);
                                    }),
                                ],
                              ),
                              SelectGrid(
                                entries: [
                                  SelectionTile(
                                    title: "Personne Physique".tr,
                                    isSelected: wizardState.formValues[
                                            'exittenant${index}_type'] ==
                                        "physique",
                                    onTap: () => wizardState.updateFormValue(
                                        'exittenant${index}_type', "physique"),
                                  ),
                                  SelectionTile(
                                    title: "Personne Morale".tr,
                                    isSelected: wizardState.formValues[
                                            'exittenant${index}_type'] ==
                                        "morale",
                                    onTap: () => wizardState.updateFormValue(
                                        'exittenant${index}_type', "morale"),
                                  ),
                                ],
                              ),
                              30.height,
                              if (wizardState
                                      .formValues['exittenant${index}_type'] !=
                                  "morale")
                                Row(
                                  children: [
                                    Expanded(
                                      child: editUserField(
                                        title: "Nom",
                                        placeholder: "${_lang.enterThe} Nom",
                                        onChanged: (text) {
                                          wizardState.updateFormValue(
                                              'exittenant${index}_lastname',
                                              text);
                                        },
                                        required: true,
                                      ),
                                    ),
                                    16.width,
                                    Expanded(
                                      child: editUserField(
                                        title: "Prénom",
                                        placeholder: "${_lang.enterThe} Prénom",
                                        onChanged: (text) {
                                          wizardState.updateFormValue(
                                              'exittenant${index}_firstname',
                                              text);
                                        },
                                        required: true,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    editUserField(
                                      title: "Dénomination de la société".tr,
                                      placeholder:
                                          "Dénomination de la société".tr,
                                      onChanged: (text) {
                                        wizardState.updateFormValue(
                                            'exittenant${index}_denomination',
                                            text);
                                      },
                                      required: true,
                                    ),
                                    dividerWithLabel(
                                      label: "Le représentant".tr,
                                    ).paddingSymmetric(vertical: 5),
                                    editUserField(
                                      title: "Nom de famille".tr,
                                      placeholder: "Nom de famille".tr,
                                      onChanged: (text) {
                                        wizardState.updateFormValue(
                                            'exittenant${index}_representantlastname',
                                            text);
                                      },
                                      required: true,
                                    ),
                                    editUserField(
                                      title: "Prénom(s)".tr,
                                      placeholder: "Prénom(s)".tr,
                                      onChanged: (text) {
                                        wizardState.updateFormValue(
                                            'exittenant${index}_representantfirstname',
                                            text);
                                      },
                                      required: true,
                                    ),
                                  ],
                                ),
                              editUserField(
                                type: "date",
                                title: "Date de naissance".tr,
                                onChanged: (text) {
                                  wizardState.updateFormValue(
                                      'exittenant${index}_dob', text);
                                },
                                textEditingController: TextEditingController(
                                  text: wizardState.formValues[
                                              'exittenant${index}_dob'] !=
                                          null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(wizardState.formValues[
                                              'exittenant${index}_dob'])
                                          .toString()
                                      : getRandomDate(),
                                ),
                                required: true,
                              ),
                              editUserField(
                                textEditingController: TextEditingController(
                                  text: wizardState.formValues[
                                          'exittenant${index}_placeofbirth'] ??
                                      getRandomAddress(),
                                ),
                                title: "Lieu de naissance du locataire".tr,
                                type: "place",
                                onChanged: (text) {
                                  wizardState.updateFormValue(
                                      'exittenant${index}_placeofbirth', text);
                                },
                                required: true,
                              ),
                              editUserField(
                                textEditingController: TextEditingController(
                                  text: wizardState.formValues[
                                          'exittenant${index}_address'] ??
                                      getRandomAddress(),
                                ),
                                title: _lang.addressTenant,
                                type: "place",
                                onChanged: (text) {
                                  wizardState.updateFormValue(
                                      'exittenant${index}_address', text);
                                },
                                required: true,
                              ),
                              editUserField(
                                title: _lang.emailTenant,
                                onChanged: (text) {
                                  wizardState.updateFormValue(
                                      'exittenant${index}_email', text);
                                },
                                email: true,
                              ),
                              20.height,
                            ],
                          );
                        }),
                        inventoryAddButton(
                          context,
                          title: _lang.tenant,
                          onPressed: () {
                            var list = wizardState.inventoryLocatairesSortant;
                            list.add(
                              InventoryAuthor(
                                order: wizardState
                                        .inventoryLocatairesSortant.length +
                                    1,
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                              ),
                            );
                            wizardState.updateInventory(locataires: list);
                          },
                        ).paddingOnly(top: 8),
                      ],
                    ),
                    50.height,
                    if (byprocuration)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // tenant(s) information
                          20.height,
                          Text(
                            "${_lang.tenantInfo.capitalizeFirstLetter()}  ${"entrant".tr}",
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          20.height,
                          ...wizardState.inventoryLocatairesEntrants
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key, item = entry.value;
                            return Column(
                              key: ValueKey('tenant${item.id}'),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    inventoryFormLabel(context,
                                            title:
                                                "${_lang.tenant.capitalizeFirstLetter()} ${byprocuration ? "sortant".tr : ""} ${index + 1} :")
                                        .paddingOnly(bottom: 8),
                                    if (wizardState
                                            .inventoryLocatairesSortant.length >
                                        1)
                                      removeButton(context,
                                          item: item, wizardState: wizardState,
                                          onPressed: () {
                                        var list = wizardState
                                            .inventoryLocatairesSortant;
                                        list.removeAt(index);
                                        wizardState.updateInventory(
                                            locataires: list);
                                      }),
                                  ],
                                ),
                                SelectGrid(
                                  entries: [
                                    SelectionTile(
                                      title: "Personne Physique".tr,
                                      isSelected: wizardState.formValues[
                                              'entranttenant${index}_type'] ==
                                          "physique",
                                      onTap: () => wizardState.updateFormValue(
                                          'entranttenant${index}_type',
                                          "physique"),
                                    ),
                                    SelectionTile(
                                      title: "Personne Morale".tr,
                                      isSelected: wizardState.formValues[
                                              'entranttenant${index}_type'] ==
                                          "morale",
                                      onTap: () => wizardState.updateFormValue(
                                          'entranttenant${index}_type',
                                          "morale"),
                                    ),
                                  ],
                                ),
                                30.height,
                                if (wizardState.formValues[
                                        'entranttenant${index}_type'] !=
                                    "morale")
                                  Row(
                                    children: [
                                      Expanded(
                                        child: editUserField(
                                          title: "Nom",
                                          placeholder: "${_lang.enterThe} Nom",
                                          onChanged: (text) {
                                            wizardState.updateFormValue(
                                                'entranttenant${index}_lastname',
                                                text);
                                          },
                                          required: true,
                                        ),
                                      ),
                                      16.width,
                                      Expanded(
                                        child: editUserField(
                                          title: "Prénom",
                                          placeholder:
                                              "${_lang.enterThe} Prénom",
                                          onChanged: (text) {
                                            wizardState.updateFormValue(
                                                'entranttenant${index}_firstname',
                                                text);
                                          },
                                          required: true,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Column(
                                    children: [
                                      editUserField(
                                        title: "Dénomination de la société".tr,
                                        placeholder:
                                            "Dénomination de la société".tr,
                                        onChanged: (text) {
                                          wizardState.updateFormValue(
                                              'entranttenant${index}_denomination',
                                              text);
                                        },
                                        required: true,
                                      ),
                                      dividerWithLabel(
                                        label: "Le représentant".tr,
                                      ).paddingSymmetric(vertical: 5),
                                      editUserField(
                                        title: "Nom de famille".tr,
                                        placeholder: "Nom de famille".tr,
                                        onChanged: (text) {
                                          wizardState.updateFormValue(
                                              'entranttenant${index}_representantlastname',
                                              text);
                                        },
                                        required: true,
                                      ),
                                      editUserField(
                                        title: "Prénom(s)".tr,
                                        placeholder: "Prénom(s)".tr,
                                        onChanged: (text) {
                                          wizardState.updateFormValue(
                                              'entranttenant${index}_representantfirstname',
                                              text);
                                        },
                                        required: true,
                                      ),
                                    ],
                                  ),
                                editUserField(
                                  type: "date",
                                  title: "Date de naissance".tr,
                                  onChanged: (text) {
                                    wizardState.updateFormValue(
                                        'entranttenant${index}_dob', text);
                                  },
                                  textEditingController: TextEditingController(
                                    text: wizardState.formValues[
                                                'entranttenant${index}_dob'] !=
                                            null
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(wizardState.formValues[
                                                'entranttenant${index}_dob'])
                                            .toString()
                                        : getRandomDate(),
                                  ),
                                  required: true,
                                ),
                                editUserField(
                                  textEditingController: TextEditingController(
                                    text: wizardState.formValues[
                                            'entranttenant${index}_placeofbirth'] ??
                                        getRandomAddress(),
                                  ),
                                  title: "Lieu de naissance du locataire".tr,
                                  type: "place",
                                  onChanged: (text) {
                                    wizardState.updateFormValue(
                                        'entranttenant${index}_placeofbirth',
                                        text);
                                  },
                                  required: true,
                                ),
                                editUserField(
                                  textEditingController: TextEditingController(
                                    text: wizardState.formValues[
                                            'entranttenant${index}_address'] ??
                                        getRandomAddress(),
                                  ),
                                  title: _lang.addressTenant,
                                  type: "place",
                                  onChanged: (text) {
                                    wizardState.updateFormValue(
                                        'entranttenant${index}_address', text);
                                  },
                                  required: true,
                                ),
                                editUserField(
                                  title: _lang.emailTenant,
                                  onChanged: (text) {
                                    wizardState.updateFormValue(
                                        'entranttenant${index}_email', text);
                                  },
                                  email: true,
                                ),
                                30.height
                              ],
                            );
                          }),
                          inventoryAddButton(
                            context,
                            title: _lang.tenant,
                            onPressed: () {
                              var list =
                                  wizardState.inventoryLocatairesEntrants;
                              list.add(
                                InventoryAuthor(
                                  order: wizardState
                                          .inventoryLocatairesEntrants.length +
                                      1,
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                ),
                              );
                              wizardState.updateInventory(locataires: list);
                            },
                          ).paddingOnly(top: 8),
                        ],
                      ),
                  ],
                ))));
  }
}

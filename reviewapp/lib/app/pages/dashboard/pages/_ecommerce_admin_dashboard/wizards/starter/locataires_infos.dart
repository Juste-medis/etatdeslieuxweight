import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/select_tile.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class LocatairesInfos extends StatelessWidget {
  final Review? review;

  const LocatairesInfos({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);
    bool byprocuration =
        wizardState.reviewType == "procuration" ||
        (review != null && review!.procuration != null);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: wizardState.formKeys[WizardStep.values[1]],
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_lang.tenantInfo.capitalizeFirstLetter()} ${byprocuration ? "sortant(s)" : ""}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  20.height,
                  ...wizardState.inventoryLocatairesSortant.asMap().entries.map((
                    entry,
                  ) {
                    final index = entry.key, item = entry.value;
                    final isPhysical =
                            wizardState
                                .inventoryLocatairesSortant[index]
                                .type ==
                            "physique",
                        addressifier = editUserField(
                          textEditingController: TextEditingController(
                            text:
                                wizardState
                                    .inventoryLocatairesSortant[index]
                                    .address ??
                                getRandomAddress(),
                          ),
                          title: isPhysical ? "Adresse".tr : "Domicilié à".tr,
                          type: "place",
                          onChanged: (text) {
                            wizardState
                                    .inventoryLocatairesSortant[index]
                                    .address =
                                text;
                            if (wizardState
                                    .inventoryLocatairesSortant[index]
                                    .type ==
                                "morale") {
                              wizardState
                                      .inventoryLocatairesSortant[index]
                                      .representant!
                                      .address =
                                  text;
                            }
                          },
                          required: true,
                        );

                    return Column(
                      key: ValueKey('tenant${item.id}'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            inventoryFormLabel(
                              context,
                              title:
                                  "${_lang.tenant.capitalizeFirstLetter()} ${byprocuration ? "sortant".tr : ""} ${index + 1} :",
                            ).paddingOnly(bottom: 8),
                            if (wizardState.inventoryLocatairesSortant.length >
                                1)
                              removeButton(
                                context,
                                item: item,
                                wizardState: wizardState,
                                onPressed: () {
                                  var list =
                                      wizardState.inventoryLocatairesSortant;
                                  list.removeAt(index);
                                  wizardState.updateInventory(locataires: list);
                                },
                              ),
                          ],
                        ),
                        SelectGrid(
                          entries: [
                            SelectionTile(
                              title: "Personne Physique".tr,
                              isSelected:
                                  wizardState
                                      .inventoryLocatairesSortant[index]
                                      .type ==
                                  "physique",
                              onTap: () {
                                wizardState
                                        .inventoryLocatairesSortant[index]
                                        .settype =
                                    "physique";
                              },
                            ),
                            SelectionTile(
                              title: "Personne Morale".tr,
                              isSelected:
                                  wizardState
                                      .inventoryLocatairesSortant[index]
                                      .type ==
                                  "morale",
                              onTap: () {
                                wizardState
                                        .inventoryLocatairesSortant[index]
                                        .representant =
                                    InventoryAuthor();
                                wizardState
                                        .inventoryLocatairesSortant[index]
                                        .settype =
                                    "morale";
                              },
                            ),
                          ],
                        ),
                        30.height,
                        if (wizardState
                                .inventoryLocatairesSortant[index]
                                .type ==
                            "physique")
                          Row(
                            children: [
                              Expanded(
                                child: editUserField(
                                  title: _lang.lastName,
                                  placeholder: "${_lang.enterThe} Nom",
                                  initialvalue: wizardState
                                      .inventoryLocatairesSortant[index]
                                      .lastName,
                                  onChanged: (text) {
                                    wizardState
                                            .inventoryLocatairesSortant[index]
                                            .lastName =
                                        text;
                                  },
                                  required: true,
                                ),
                              ),
                              16.width,
                              Expanded(
                                child: editUserField(
                                  title: "${_lang.firstName}(s)",
                                  initialvalue: wizardState
                                      .inventoryLocatairesSortant[index]
                                      .firstname,
                                  placeholder: "${_lang.enterThe} Prénom",
                                  onChanged: (text) {
                                    wizardState
                                            .inventoryLocatairesSortant[index]
                                            .firstname =
                                        text;
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
                                placeholder: "Dénomination de la société".tr,
                                initialvalue: wizardState
                                    .inventoryLocatairesSortant[index]
                                    .denomination,
                                onChanged: (text) {
                                  wizardState
                                          .inventoryLocatairesSortant[index]
                                          .denomination =
                                      text;
                                },
                                required: true,
                              ),
                              addressifier,
                              dividerWithLabel(
                                label: "Le représentant".tr,
                              ).paddingSymmetric(vertical: 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: editUserField(
                                      title: "Nom de famille".tr,
                                      placeholder: "Nom de famille".tr,
                                      initialvalue: wizardState
                                          .inventoryLocatairesSortant[index]
                                          .representant!
                                          .lastName,
                                      onChanged: (text) {
                                        wizardState
                                                .inventoryLocatairesSortant[index]
                                                .representant!
                                                .lastName =
                                            text;
                                      },
                                      required: true,
                                    ),
                                  ),
                                  16.width,
                                  Expanded(
                                    child: editUserField(
                                      title: "Prénom(s)".tr,
                                      placeholder: "Prénom(s)".tr,
                                      initialvalue: wizardState
                                          .inventoryLocatairesSortant[index]
                                          .representant!
                                          .firstname,
                                      onChanged: (text) {
                                        wizardState
                                                .inventoryLocatairesSortant[index]
                                                .representant!
                                                .firstname =
                                            text;
                                      },
                                      required: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (wizardState.reviewType == "procuration") ...[
                          editUserField(
                            title: "Numéro de téléphone".tr,
                            onChanged: (text) {
                              wizardState
                                      .inventoryLocatairesSortant[index]
                                      .phone =
                                  text;
                              if (wizardState
                                      .inventoryLocatairesSortant[index]
                                      .type ==
                                  "morale") {
                                wizardState
                                        .inventoryLocatairesSortant[index]
                                        .representant!
                                        .phone =
                                    text;
                                wizardState.updateFormValue("-", '-');
                              }
                            },
                            initialvalue: wizardState
                                .inventoryLocatairesSortant[index]
                                .phone,
                            type: "phone",
                            required: true,
                          ),
                          editUserField(
                            type: "date",
                            maximumDate: DateTime.now(),
                            title: "Date de naissance".tr,
                            onChanged: (text) {
                              wizardState
                                      .inventoryLocatairesSortant[index]
                                      .dob =
                                  text;
                              if (wizardState
                                      .inventoryLocatairesSortant[index]
                                      .type ==
                                  "morale") {
                                wizardState
                                        .inventoryLocatairesSortant[index]
                                        .representant!
                                        .dob =
                                    text;
                              }
                            },
                            textEditingController: TextEditingController(
                              text:
                                  wizardState
                                          .inventoryLocatairesSortant[index]
                                          .dob !=
                                      null
                                  ? DateFormat('dd-MM-yyyy')
                                        .format(
                                          wizardState
                                              .inventoryLocatairesSortant[index]
                                              .dob!,
                                        )
                                        .toString()
                                  : getRandomDate(),
                            ),
                            required: true,
                          ),
                          editUserField(
                            textEditingController: TextEditingController(
                              text:
                                  wizardState
                                      .inventoryLocatairesSortant[index]
                                      .placeOfBirth ??
                                  wizardState
                                      .inventoryLocatairesSortant[index]
                                      .representant
                                      ?.placeOfBirth ??
                                  getRandomAddress(),
                            ),
                            title: "Lieu de naissance du locataire".tr,
                            type: "place",
                            onChanged: (text) {
                              wizardState
                                      .inventoryLocatairesSortant[index]
                                      .placeOfBirth =
                                  text;
                              if (wizardState
                                      .inventoryLocatairesSortant[index]
                                      .type ==
                                  "morale") {
                                wizardState
                                        .inventoryLocatairesSortant[index]
                                        .representant!
                                        .placeOfBirth =
                                    text;
                              }
                            },
                            required: true,
                          ),
                        ],
                        if (isPhysical) addressifier,
                        editUserField(
                          title: "Addresse email".tr,
                          initialvalue: wizardState
                              .inventoryLocatairesSortant[index]
                              .email,
                          onChanged: (text) {
                            wizardState
                                    .inventoryLocatairesSortant[index]
                                    .email =
                                text;
                            if (wizardState
                                    .inventoryLocatairesSortant[index]
                                    .type ==
                                "morale") {
                              wizardState
                                      .inventoryLocatairesSortant[index]
                                      .representant!
                                      .email =
                                  text;
                            }
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
                          order:
                              wizardState.inventoryLocatairesSortant.length + 1,
                          id: generateClientId("tenant"),
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
                      "${_lang.tenantInfo.capitalizeFirstLetter()}  ${"entrant(s)".tr}",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    20.height,
                    ...wizardState.inventoryLocatairesEntrants.asMap().entries.map((
                      entry,
                    ) {
                      final index = entry.key, item = entry.value;

                      final isPhysical =
                              wizardState
                                  .inventoryLocatairesEntrants[index]
                                  .type ==
                              "physique",
                          addressifier = editUserField(
                            textEditingController: TextEditingController(
                              text:
                                  wizardState
                                      .inventoryLocatairesEntrants[index]
                                      .address ??
                                  getRandomAddress(),
                            ),
                            title: isPhysical ? "Adresse".tr : "Domicilié à".tr,
                            type: "place",
                            onChanged: (text) {
                              wizardState
                                      .inventoryLocatairesEntrants[index]
                                      .address =
                                  text;
                              if (wizardState
                                      .inventoryLocatairesEntrants[index]
                                      .type ==
                                  "morale") {
                                wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .representant!
                                        .address =
                                    text;
                              }
                            },
                            required: true,
                          );

                      return Column(
                        key: ValueKey('tenant${item.id}'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              inventoryFormLabel(
                                context,
                                title:
                                    "${_lang.tenant.capitalizeFirstLetter()} entrant ${index + 1} :",
                              ).paddingOnly(bottom: 8),
                              if (wizardState
                                      .inventoryLocatairesEntrants
                                      .length >
                                  1)
                                removeButton(
                                  context,
                                  item: item,
                                  wizardState: wizardState,
                                  onPressed: () {
                                    var list =
                                        wizardState.inventoryLocatairesEntrants;
                                    list.removeAt(index);
                                    wizardState.updateInventory(
                                      locatairesentry: list,
                                    );
                                  },
                                ),
                            ],
                          ),
                          SelectGrid(
                            entries: [
                              SelectionTile(
                                title: "Personne Physique".tr,
                                isSelected:
                                    wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .type ==
                                    "physique",
                                onTap: () {
                                  wizardState
                                          .inventoryLocatairesEntrants[index]
                                          .settype =
                                      "physique";
                                },
                              ),
                              SelectionTile(
                                title: "Personne Morale".tr,
                                isSelected:
                                    wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .type ==
                                    "morale",
                                onTap: () {
                                  wizardState
                                          .inventoryLocatairesEntrants[index]
                                          .representant =
                                      InventoryAuthor();
                                  wizardState
                                          .inventoryLocatairesEntrants[index]
                                          .settype =
                                      "morale";
                                },
                              ),
                            ],
                          ),
                          30.height,
                          if (isPhysical)
                            Row(
                              children: [
                                Expanded(
                                  child: editUserField(
                                    title: _lang.lastName,
                                    placeholder: "${_lang.enterThe} Nom",
                                    initialvalue: wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .lastName,
                                    onChanged: (text) {
                                      wizardState
                                              .inventoryLocatairesEntrants[index]
                                              .lastName =
                                          text;
                                    },
                                    required: true,
                                  ),
                                ),
                                16.width,
                                Expanded(
                                  child: editUserField(
                                    title: "${_lang.firstName}(s)",
                                    initialvalue: wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .firstname,
                                    placeholder: "${_lang.enterThe} Prénom",
                                    onChanged: (text) {
                                      wizardState
                                              .inventoryLocatairesEntrants[index]
                                              .firstname =
                                          text;
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
                                  placeholder: "Dénomination de la société".tr,
                                  initialvalue: wizardState
                                      .inventoryLocatairesEntrants[index]
                                      .denomination,
                                  onChanged: (text) {
                                    wizardState
                                            .inventoryLocatairesEntrants[index]
                                            .denomination =
                                        text;
                                  },
                                  required: true,
                                ),
                                addressifier,
                                dividerWithLabel(
                                  label: "Le représentant".tr,
                                ).paddingSymmetric(vertical: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: editUserField(
                                        title: "Nom de famille".tr,
                                        placeholder: "Nom de famille".tr,
                                        initialvalue: wizardState
                                            .inventoryLocatairesEntrants[index]
                                            .representant!
                                            .lastName,
                                        onChanged: (text) {
                                          wizardState
                                                  .inventoryLocatairesEntrants[index]
                                                  .representant!
                                                  .lastName =
                                              text;
                                        },
                                        required: true,
                                      ),
                                    ),
                                    16.width,
                                    Expanded(
                                      child: editUserField(
                                        title: "Prénom(s)".tr,
                                        placeholder: "Prénom(s)".tr,
                                        initialvalue: wizardState
                                            .inventoryLocatairesEntrants[index]
                                            .representant!
                                            .firstname,
                                        onChanged: (text) {
                                          wizardState
                                                  .inventoryLocatairesEntrants[index]
                                                  .representant!
                                                  .firstname =
                                              text;
                                        },
                                        required: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (wizardState.reviewType == "procuration") ...[
                            editUserField(
                              title: "Numéro de téléphone".tr,
                              onChanged: (text) {
                                wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .phone =
                                    text;
                                if (wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .type ==
                                    "morale") {
                                  wizardState
                                          .inventoryLocatairesEntrants[index]
                                          .representant!
                                          .phone =
                                      text;
                                }
                                wizardState.updateFormValue("-", '-');
                              },
                              type: "phone",
                              initialvalue: wizardState
                                  .inventoryLocatairesEntrants[index]
                                  .phone,
                              required: true,
                            ),
                            editUserField(
                              type: "date",
                              maximumDate: DateTime.now(),
                              title: "Date de naissance".tr,
                              onChanged: (text) {
                                wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .dob =
                                    text;
                                if (wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .type ==
                                    "morale") {
                                  wizardState
                                          .inventoryLocatairesEntrants[index]
                                          .representant!
                                          .dob =
                                      text;
                                }
                              },
                              textEditingController: TextEditingController(
                                text:
                                    wizardState
                                            .inventoryLocatairesEntrants[index]
                                            .dob !=
                                        null
                                    ? DateFormat('dd-MM-yyyy')
                                          .format(
                                            wizardState
                                                .inventoryLocatairesEntrants[index]
                                                .dob!,
                                          )
                                          .toString()
                                    : getRandomDate(),
                              ),
                              required: true,
                            ),
                            editUserField(
                              textEditingController: TextEditingController(
                                text:
                                    wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .representant
                                        ?.placeOfBirth ??
                                    wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .placeOfBirth ??
                                    getRandomAddress(),
                              ),
                              title: "Lieu de naissance du locataire".tr,
                              type: "place",
                              onChanged: (text) {
                                wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .placeOfBirth =
                                    text;

                                if (wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .type ==
                                    "morale") {
                                  wizardState
                                          .inventoryLocatairesEntrants[index]
                                          .representant!
                                          .placeOfBirth =
                                      text;
                                }
                              },
                              required: true,
                            ),
                          ],
                          if (isPhysical) addressifier,
                          editUserField(
                            title: "Addresse email".tr,
                            initialvalue: wizardState
                                .inventoryLocatairesEntrants[index]
                                .email,
                            onChanged: (text) {
                              wizardState
                                      .inventoryLocatairesEntrants[index]
                                      .email =
                                  text;

                              if (wizardState
                                      .inventoryLocatairesEntrants[index]
                                      .type ==
                                  "morale") {
                                wizardState
                                        .inventoryLocatairesEntrants[index]
                                        .representant!
                                        .email =
                                    text;
                              }
                            },
                            email: true,
                          ),
                          30.height,
                        ],
                      );
                    }),
                    inventoryAddButton(
                      context,
                      title: _lang.tenant,
                      onPressed: () {
                        var list = wizardState.inventoryLocatairesEntrants;
                        list.add(
                          InventoryAuthor(
                            order:
                                wizardState.inventoryLocatairesEntrants.length +
                                1,
                            id: generateClientId("tenant"),
                          ),
                        );
                        wizardState.updateInventory(locatairesentry: list);
                      },
                    ).paddingOnly(top: 8),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/_components.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class Proprietary extends StatelessWidget {
  final AppThemeProvider wizardState;
  const Proprietary({super.key, required this.wizardState});

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
                key: wizardState.formKeys[WizardStep.values[0]],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    Text(
                      "procuration".tr.capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 40),
                    ),
                    20.height,
                    ...wizardState.inventoryProprietaires
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key, item = entry.value;

                      if (index == 0 &&
                          !wizardState.formValues.keys
                              .any((k) => k.startsWith('owner${index}_'))) {
                        wizardState.formValues["owner${index}_type"] =
                            "physique";
                        wizardState.formValues["owner${index}_denomination"] =
                            "";
                        wizardState.formValues["owner${index}_lastname"] =
                            wizardState.currentUser.lastName;
                        wizardState.formValues["owner${index}_firstname"] =
                            wizardState.currentUser.firstName;
                        wizardState.formValues["owner${index}_phone"] =
                            wizardState.currentUser.phoneNumber;
                        wizardState.formValues["owner${index}_dob"] =
                            wizardState.currentUser.dob;
                        wizardState.formValues["owner${index}_placeofbirth"] =
                            wizardState.currentUser.placeOfBirth;
                        wizardState.formValues["owner${index}_address"] =
                            wizardState.currentUser.address;
                        wizardState
                                .formValues["owner${index}_representantemail"] =
                            wizardState.currentUser.email;
                        wizardState.formValues["owner${index}_email"] =
                            wizardState.currentUser.email;
                      }
                      return Column(
                        key: ValueKey('owner${item.id}'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              inventoryFormLabel(context,
                                      title:
                                          "${"Bailleur mandant".tr.capitalizeFirstLetter()} ${index + 1} :")
                                  .paddingOnly(bottom: 8),
                              if (wizardState.inventoryProprietaires.length > 1)
                                removeButton(context,
                                    item: item,
                                    wizardState: wizardState, onPressed: () {
                                  var list = wizardState.inventoryProprietaires;
                                  list.removeAt(index);
                                  wizardState.updateInventory(
                                      proprietaires: list);
                                }),
                            ],
                          ),
                          SelectGrid(
                            entries: [
                              SelectionTile(
                                title: "Personne Physique".tr,
                                isSelected: wizardState
                                        .formValues['owner${index}_type'] ==
                                    "physique",
                                onTap: () => wizardState.updateFormValue(
                                    'owner${index}_type', "physique"),
                              ),
                              SelectionTile(
                                title: "Personne Morale".tr,
                                isSelected: wizardState
                                        .formValues['owner${index}_type'] ==
                                    "morale",
                                onTap: () => wizardState.updateFormValue(
                                    'owner${index}_type', "morale"),
                              ),
                            ],
                          ),
                          30.height,
                          if (wizardState.formValues['owner${index}_type'] !=
                              "morale")
                            Column(
                              children: [
                                editUserField(
                                  title: _lang.lastName,
                                  initialvalue: wizardState.formValues[
                                          'owner${index}_lastname'] ??
                                      '',
                                  placeholder:
                                      "${_lang.enterThe} ${_lang.ownerfullname}",
                                  onChanged: (text) {
                                    wizardState.updateFormValue(
                                        'owner${index}_lastname', text);
                                  },
                                  required: true,
                                ),
                                editUserField(
                                  title: "${_lang.firstName}(s)",
                                  initialvalue: wizardState.formValues[
                                          'owner${index}_firstname'] ??
                                      '',
                                  placeholder:
                                      "${_lang.enterThe} ${_lang.ownerfullname}",
                                  onChanged: (text) {
                                    wizardState.updateFormValue(
                                        'owner${index}_firstname', text);
                                  },
                                  required: true,
                                )
                              ],
                            )
                          else
                            Column(
                              children: [
                                editUserField(
                                  title: "Dénomination de la société".tr,
                                  placeholder: "Dénomination de la société".tr,
                                  onChanged: (text) {
                                    wizardState.updateFormValue(
                                        'owner${index}_denomination', text);
                                  },
                                  required: true,
                                ),
                                dividerWithLabel(
                                  label: "Le représentant".tr,
                                ).paddingSymmetric(vertical: 5),
                                editUserField(
                                  title: "Nom de famille".tr,
                                  initialvalue: wizardState.formValues[
                                          'owner${index}_lastname'] ??
                                      '',
                                  placeholder: "Nom de famille".tr,
                                  onChanged: (text) {
                                    wizardState.updateFormValue(
                                        'owner${index}_representantlastname',
                                        text);
                                  },
                                  required: true,
                                ),
                                editUserField(
                                  title: "Prénom(s)".tr,
                                  placeholder: "Prénom(s)".tr,
                                  initialvalue: wizardState.formValues[
                                          'owner${index}_firstname'] ??
                                      '',
                                  onChanged: (text) {
                                    wizardState.updateFormValue(
                                        'owner${index}_representantfirstname',
                                        text);
                                  },
                                  required: true,
                                ),
                              ],
                            ),
                          editUserField(
                            title: "Numéro de téléphone".tr,
                            placeholder: "Entrez le numéro de téléphone".tr,
                            initialvalue:
                                wizardState.formValues['owner${index}_phone'] ??
                                    '',
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'owner${index}_representantphone', text);
                            },
                            type: "phone",
                            required: true,
                          ),
                          editUserField(
                            type: "date",
                            title: "Date de naissance".tr,
                            initialvalue:
                                wizardState.formValues['owner${index}_dob'] !=
                                        null
                                    ? DateFormat('dd-MM-yyyy')
                                        .format(wizardState
                                            .formValues['owner${index}_dob'])
                                        .toString()
                                    : '',
                            placeholder:
                                "${_lang.enterThe} ${"Date de naissance".tr}",
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'owner${index}_dob', text);
                            },
                            textEditingController: TextEditingController(
                              text:
                                  wizardState.formValues['owner${index}_dob'] !=
                                          null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(wizardState
                                              .formValues['owner${index}_dob'])
                                          .toString()
                                      : '',
                            ),
                            required: true,
                          ),
                          editUserField(
                            textEditingController: TextEditingController(
                              text: wizardState.formValues[
                                      'owner${index}_placeofbirth'] ??
                                  '',
                            ),
                            title: "Lieu de naissance".tr,
                            initialvalue: wizardState
                                    .formValues['owner${index}_placeofbirth'] ??
                                '',
                            placeholder:
                                "${_lang.enterThe} ${"Lieu de naissance".tr}",
                            type: "place",
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'owner${index}_placeofbirth', text);
                            },
                            required: true,
                          ),
                          editUserField(
                            textEditingController: TextEditingController(
                              text: wizardState
                                      .formValues['owner${index}_address'] ??
                                  '',
                            ),
                            title: _lang.owneraddress,
                            initialvalue: wizardState
                                    .formValues['owner${index}_address'] ??
                                '',
                            placeholder:
                                "${_lang.enterThe} ${_lang.owneraddress}",
                            type: "place",
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'owner${index}_address', text);
                            },
                            required: true,
                          ),
                          editUserField(
                            title: _lang.owneremail,
                            initialvalue: wizardState.formValues[
                                    'owner${index}_representantemail'] ??
                                '',
                            placeholder:
                                "${_lang.enterThe} ${_lang.owneremail}",
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'owner${index}_representantemail', text);
                            },
                            email: true,
                          ),
                        ],
                      );
                    }),
                    20.height,
                    inventoryAddButton(
                      context,
                      title: _lang.owner,
                      onPressed: () {
                        var list = wizardState.inventoryProprietaires;
                        list.add(
                          InventoryAuthor(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            order:
                                wizardState.inventoryProprietaires.length + 1,
                          ),
                        );
                        wizardState.updateInventory(proprietaires: list);
                      },
                    ).paddingOnly(top: 8),
                  ],
                ))));
  }
}

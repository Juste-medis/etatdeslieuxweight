import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/_components.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;

class TheGood extends StatelessWidget {
  final AppThemeProvider wizardState;
  const TheGood({super.key, required this.wizardState});

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
                key: wizardState.formKeys[WizardStep.values[2]],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Owner(s) information
                    20.height,
                    Text(
                      _lang.propertyLabel.capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // Property information
                    20.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        editUserField(
                          title: _lang.propertyAddress,
                          textEditingController: TextEditingController(
                            text: wizardState.formValues['property_address'] ??
                                '',
                          ),
                          placeholder:
                              "${_lang.enterThe} ${_lang.propertyAddress}",
                          type: "place",
                          onChanged: (text) {
                            wizardState.updateFormValue(
                                'property_address', text);
                          },
                          required: true,
                        ),
                        editUserField(
                          title: _lang.addressComplement,
                          placeholder:
                              "${_lang.enterThe} ${_lang.fullNameMandataire}",
                          onChanged: (text) {
                            wizardState.updateFormValue(
                                'property_complement', text);
                          },
                        ),
                        editUserField(
                          type: "number",
                          title: _lang.floor,
                          placeholder: "${_lang.enterThe} ${_lang.floor}",
                          onChanged: (text) {
                            wizardState.updateFormValue('property_floor', text);
                          },
                        ),
                        editUserField(
                          title: _lang.surface,
                          placeholder: "${_lang.enterThe} ${_lang.surface}",
                          onChanged: (text) {
                            wizardState.updateFormValue(
                                'property_surface', text);
                          },
                          rightwidget: "m²",
                          type: "number",
                          required: true,
                        ),
                        editUserField(
                          type: "counterfield",
                          title: _lang.roomCount,
                          placeholder: "${_lang.enterThe} ${_lang.roomCount}",
                          onChanged: (text) {
                            wizardState.updateFormValue(
                                'property_roomCount', text);
                          },
                        ),
                      ],
                    ),
                    // is it furnished?
                    SelectGrid(
                      entries: [
                        SelectionTile(
                          title: _lang.furnished,
                          isSelected:
                              wizardState.formValues['property_furnitured'] ==
                                  true,
                          onTap: () => wizardState.updateFormValue(
                              "property_furnitured", true),
                        ),
                        SelectionTile(
                          title: _lang.unfurnished,
                          isSelected:
                              wizardState.formValues['property_furnitured'] ==
                                  false,
                          onTap: () => wizardState.updateFormValue(
                              "property_furnitured", false),
                        ),
                      ],
                    ), // is it furnished?
                    20.height,
                    editUserField(
                      type: "number",
                      title: _lang.box,
                      placeholder: "${_lang.enterThe} ${_lang.box}",
                      onChanged: (text) {
                        wizardState.updateFormValue('property_box', text);
                      },
                    ),
                    editUserField(
                      type: "number",
                      title: _lang.cellar,
                      placeholder: "${_lang.enterThe} ${_lang.cellar}",
                      onChanged: (text) {
                        wizardState.updateFormValue('property_cellar', text);
                      },
                    ),
                    editUserField(
                      type: "number",
                      title: _lang.garage,
                      placeholder: "${_lang.enterThe} ${_lang.garage}",
                      onChanged: (text) {
                        wizardState.updateFormValue('property_garage', text);
                      },
                    ),
                    editUserField(
                      type: "number",
                      title: _lang.parking,
                      placeholder: "${_lang.enterThe} ${_lang.parking}",
                      onChanged: (text) {
                        wizardState.updateFormValue('property_parking', text);
                      },
                    ),

                    editUserField(
                      title: _lang.documentMadeAt,
                      textEditingController: TextEditingController(
                        text: wizardState.formValues['document_address'] ?? '',
                      ),
                      placeholder: "${_lang.enterThe} ${_lang.documentMadeAt}",
                      type: "place",
                      onChanged: (text) {
                        wizardState.updateFormValue('document_address', text);
                      },
                      required: true,
                    ),
                  ],
                ))));
  }
}

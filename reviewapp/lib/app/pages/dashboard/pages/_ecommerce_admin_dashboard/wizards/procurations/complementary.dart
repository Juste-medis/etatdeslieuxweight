import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;

class Complementary extends StatelessWidget {
  final AppThemeProvider wizardState;
  const Complementary({super.key, required this.wizardState});

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
                key: wizardState.formKeys[WizardStep.values[4]],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    Text(
                      _lang.additionalInfo.capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // complementary information
                    20.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        editUserField(
                            title: _lang.heatingType,
                            placeholder:
                                "${_lang.enterThe} ${_lang.heatingType}",
                            type: "select",
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'complementary_heatingType', text);
                            },
                            items: heatingTypes),
                        editUserField(
                          title: _lang.heatingMode,
                          type: "select",
                          items: heatingmODes,
                          placeholder: "${_lang.enterThe} ${_lang.heatingMode}",
                          onChanged: (text) {
                            wizardState.updateFormValue(
                                'complementary_heatingMode', text);
                          },
                        ),
                        editUserField(
                          title: _lang.hotWaterType,
                          type: "select",
                          items: heatingTypes,
                          placeholder:
                              "${_lang.enterThe} ${_lang.hotWaterType}",
                          onChanged: (text) {
                            wizardState.updateFormValue(
                                'complementary_hotWaterType', text);
                          },
                        ),
                        editUserField(
                          title: _lang.hotWaterMode,
                          type: "select",
                          items: heatingwatermODes,
                          placeholder:
                              "${_lang.enterThe} ${_lang.hotWaterMode}",
                          onChanged: (text) {
                            wizardState.updateFormValue(
                                'complementary_hotWaterMode', text);
                          },
                        ),
                        20.height,
                        // editUserField(
                        //   type: "numberandtext",
                        //   title: _lang.mailbox,
                        //   secondtitle: _lang.location,
                        //   placeholder: "${_lang.enterThe} ${_lang.mailbox}",
                        //   onChanged: (text, secondtext) {
                        //     if (text != null) {
                        //       wizardState.updateFormValue(
                        //           'complementary_mailbox', text);
                        //     }
                        //     if (secondtext != null && secondtext.isNotEmpty) {
                        //       wizardState.updateFormValue(
                        //           'complementary_mailboxlocation', secondtext);
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ))));
  }
}

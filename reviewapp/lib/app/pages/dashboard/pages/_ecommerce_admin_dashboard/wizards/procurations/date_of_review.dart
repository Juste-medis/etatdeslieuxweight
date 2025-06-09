import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/_components.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class DateOfEtatDesLieux extends StatelessWidget {
  final AppThemeProvider wizardState;
  const DateOfEtatDesLieux({super.key, required this.wizardState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: wizardState.formKeys[WizardStep.values[3]],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Owner(s) information
                    20.height,
                    Text(
                      "Etat des lieux".capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // Property information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        editUserField(
                          type: "date",
                          title: "Date prévue de l'état des lieux".tr,
                          onChanged: (text) {
                            wizardState.updateFormValue(
                                'review_estimed_date', text);
                          },
                          textEditingController: TextEditingController(
                            text:
                                wizardState.formValues['review_estimed_date'] !=
                                        null
                                    ? DateFormat('dd-MM-yyyy')
                                        .format(wizardState
                                            .formValues['review_estimed_date'])
                                        .toString()
                                    : '',
                          ),
                          required: true,
                        ),
                        // editUserField(
                        //   title: "",
                        //   showLabel: false,
                        //   showplaceholder: true,
                        //   placeholder: _lang.comments,
                        //   type: "textarea",
                        //   onChanged: (text) {
                        //     wizardState.updateFormValue(
                        //         'preocuration_comments', text);
                        //   },
                        // ),
                        20.height
                      ],
                    ),
                    // is it furnished?
                    20.height,
                    Text(
                      "Accès à l'application accordé au locataire: "
                          .capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    editUserField(
                      title: "Fonctionnalité".tr,
                      type: "select",
                      required: true,
                      layout: 'column',
                      items: Map.fromEntries(
                        [
                          ...wizardState.inventoryLocatairesSortant,
                          ...wizardState.inventoryLocatairesEntrants,
                        ].map((author) => MapEntry('${author.id}', {
                              "name": "${author.lastName} ${author.firstname}",
                            })),
                      ),
                      onChanged: (text) {
                        wizardState.updateFormValue('accesgivenTo', text);
                      },
                    ),
                    20.height,
                  ],
                ))));
  }
}

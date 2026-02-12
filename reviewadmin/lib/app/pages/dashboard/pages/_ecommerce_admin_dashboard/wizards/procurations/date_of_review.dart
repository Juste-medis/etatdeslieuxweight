import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/core/helpers/helpers.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/providers/_proccuration_provider.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';

class DateOfEtatDesLieux extends StatelessWidget {
  const DateOfEtatDesLieux({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final proccurationState = context.watch<ProccurationProvider>();
    var thereview = proccurationState.editingProccuration;

    Jks.savereviewStep = () async {
      if (thereview != null && thereview.source != 'new') {
        try {
          wizardState.setloading(true);

          await proccurationState.updateTheproccuration(
            thereview,
            "accesssection",
            wizardState: wizardState,
          );

          wizardState.setloading(false);
        } catch (e) {
          my_inspect(e);
          show_common_toast(
              "Une erreur s'est produite, veuillez réessayer plus tard.".tr,
              context);
        }
      } else {}
    };

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: thereview != null
                      ? null
                      : wizardState.formKeys[WizardStep.values[5]],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Owner(s) information
                      if (thereview != null)
                        backbutton(
                          () => {context.popRoute()},
                          title: "Réalisation et access à l'état des lieux".tr,
                        )
                      else
                        Text(
                          "Réalisation et access à l'état des lieux".tr,
                          style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
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
                            minimumDate: DateTime.now(),
                            initialvalue:
                                wizardState.formValues['review_estimed_date'],
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'review_estimed_date', text);
                            },
                            textEditingController: TextEditingController(
                              text: wizardState
                                          .formValues['review_estimed_date'] !=
                                      null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(
                                        wizardState.formValues[
                                                    'review_estimed_date']
                                                is DateTime
                                            ? wizardState.formValues[
                                                'review_estimed_date']
                                            : DateTime.parse(
                                                wizardState.formValues[
                                                    'review_estimed_date']),
                                      )
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
                      editUserField(
                        title:
                            "Qui choisissez-vous pour réaliser l'état des lieux ?"
                                .tr,
                        type: "select",
                        required: true,
                        initialvalue: wizardState.formValues['accesgivenTo'],
                        layout: 'column',
                        items: Map.fromEntries(
                          [
                            ...wizardState.inventoryLocatairesSortant,
                            ...wizardState.inventoryLocatairesEntrants,
                          ].map((author) => MapEntry(
                              '${author.id}', {"name": authorname(author)})),
                        ),
                        onChanged: (text) {
                          wizardState.updateFormValue('accesgivenTo', text);
                        },
                      ),
                      editUserField(
                        textEditingController: TextEditingController(
                            text: wizardState.formValues['doccument_city']),
                        type: "city",
                        title: "Ville où vous établissez cette procuration".tr,
                        initialvalue: wizardState.formValues['doccument_city'],
                        onChanged: (text) {
                          wizardState.updateFormValue('doccument_city', text);
                        },
                        required: true,
                      ),
                    ],
                  )))),
    );
  }
}

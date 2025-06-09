import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/fuctions/_overlay_helper.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/date_of_review.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/pdf_summary_summary.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:jatai_etatsdeslieux/main.dart';

import 'package:nb_utils/nb_utils.dart';
import 'proprietaire_informations.dart';
import 'locataires_infos.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'procuration_signatures.dart';
import 'the_good.dart';
import 'pdf_summary_review.dart';
import 'finalization_view.dart';
import 'complementary.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/_app_colors.dart';

class ProcurationFormWizard extends StatefulWidget {
  final Map? type;
  const ProcurationFormWizard({super.key, this.type});

  @override
  State<ProcurationFormWizard> createState() => _ProcurationFormWizardState();
}

class _ProcurationFormWizardState extends State<ProcurationFormWizard> {
  final PageController _pageController = PageController();
  late AppThemeProvider wizardState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
  }

  void _prevStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submitForm(Map<String, dynamic> formData) {
    // Process all collected data
    final owners = [];
    final tenants = [];

    formData.forEach((key, value) {
      if (key.startsWith('owner')) {
        // Parse owner data
        final parts = key.split('_');
        final ownerId = parts[0].replaceAll('owner', '');
        final field = parts[1];

        if (owners.length <= int.parse(ownerId)) {
          owners.add({'id': ownerId});
        }
        owners[int.parse(ownerId)][field] = value;
      }
    });

    // Create your final payload
    final payload = {
      'owners': owners,
      'tenants': tenants,
      'reviewType': formData['reviewType'],
      'isMandated': formData['isMandated'],
    };

    debugPrint('Submitting: ${payload.toString()}');
    // Call your API here
  }

  void saveprocuration(AppThemeProvider wizardState) async {
    var formData = wizardState.formValues;
    // my_inspect(formData);
    wizardState.setloading(true);
    var owners = extracthings(formData, "owner", wizardState);
    var exitenants = extracthings(formData, "exittenant", wizardState);
    var entrantenants = extracthings(formData, "entranttenant", wizardState);

    // Create your final payload
    final payload = {
      'owners': owners,
      'exitenants': exitenants,
      'entrantenants': entrantenants,
      'propertyDetails': {
        'address': formData['property_address'],
        'complement': formData['property_complement'],
        'floor': formData['property_floor'],
        'surface': formData['property_surface'],
        'roomCount': formData['property_roomCount'],
        'furnitured': formData['property_furnitured'],
        'box': formData['property_box'],
        'cellar': formData['property_cellar'],
        'garage': formData['property_garage'],
        'parking': formData['property_parking'],
      },
      'documentDetails': {
        'address': formData['document_address'],
        'review_type': formData['review_type'],
        'review_estimed_date': "${formData['review_estimed_date']}",
        'preocuration_comments': formData['preocuration_comments'],
        'accesgivenTo': formData['accesgivenTo'],
      },
      'complementaryDetails': {
        'heatingType': formData['complementary_heatingType'],
        'heatingMode': formData['complementary_heatingMode'],
        'hotWaterType': formData['complementary_hotWaterType'],
        'hotWaterMode': formData['complementary_hotWaterMode'],
      },
    };

    my_inspect(formData);
    my_inspect(payload);

    // await createprocuration(payload).then((res) async {
    //   if (res.status == true) {
    //     wizardState.updateFormValue(
    //         'entranDocumentId', res.data["entranDocumentId"]);
    //     wizardState.updateFormValue(
    //         'sortantDocumentId', res.data["sortantDocumentId"]);
    //     wizardState.updateFormValue('procurationId', res.data["_id"]);
    //     _nextStep();
    //   }
    // }).catchError((e) {
    //   my_inspect(e);
    //   // toast(e.toString());
    // });
    wizardState.setloading(false);
  }

  void _nextStep() async {
    wizardState.updateFormValue("", "");
    var owners = extracthings(wizardState.formValues, "owner", wizardState);

    if (wizardState.currentStep == WizardStep.values[0]) {
      final userEmail = appStore.userEmail;
      bool isConnectedUserOwner =
          owners.any((owner) => owner['representantemail'] == userEmail);
      if (!isConnectedUserOwner) {
        await showAwesomeConfirmDialog(
          forceHorizontalButtons: true,
          cancelText: "bailleurs".tr,
          shownegative: false,
          onnegative: () {
            _pageController.jumpTo(0);
          },
          onpositive: () {
            _pageController.jumpTo(0);
          },
          confirmText: 'Remplir'.tr,
          context: context,
          title: 'Vous n\'êtes pas dans la liste des bailleurs !'.tr,
          description:
              'Ce qui signifie que vous ne pourrez pas apposer votre signature. pour continuer vous devez remplir les information vous concernant tels que votre nom, prénom, email et téléphone.'
                  .tr,
        );
        return;
      }
    }
    if (wizardState.currentStep == WizardStep.signatures) {
      if (Jks.pSp!["content"] == null) {
        final confirmed = await showAwesomeConfirmDialog(
          forceHorizontalButtons: true,
          cancelText: "Non".tr,
          confirmText: 'Oui'.tr,
          context: context,
          title: 'Aucune signature apportée'.tr,
          description: 'Souhaitez vous signer plus-tard ?'.tr,
        );
        if (confirmed ?? false) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } else {
        // my_inspect(formData);
        wizardState.setloading(true);
        // Create your final payload

        final payload = {
          'signature': base64Encode(Jks.pSp!["content"]),
          "procurationId": wizardState.formValues['procurationId']
        };
        await griffeprocuration(payload).then((res) async {
          if (res.status == true) {
            // wizardState.updateFormValue(
            //     'entranDocumentId', res.data["entranDocumentId"]);
            // wizardState.updateFormValue(
            //     'sortantDocumentId', res.data["sortantDocumentId"]);
            // _pageController.nextPage(
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.easeInOut,
            // );
          }
        }).catchError((e) {
          my_inspect(e);
          // toast(e.toString());
        });
        wizardState.setloading(false);
      }
      return;
    }

    if (wizardState.canGoNext ||
        wizardState.currentStep == WizardStep.locataireSortantAddress) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final _lang = l.S.of(context);
    wizardState = context.watch<AppThemeProvider>();
    return Consumer<AppThemeProvider>(
      builder: (context, lang, child) {
        WizardStep _currentStep = wizardState.currentStep;
        Jks.context = context;

        return PopScope(
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop && result == null) {
              if (_currentStep != WizardStep.values[0]) {
                await showAwesomeConfirmDialog(
                  context: context,
                  title: "Annuler les modification".tr,
                  description: "Êtes-vous sûr de vouloir annuler ?".tr,
                  onpositive: () {
                    context.popRoute();
                  },
                  onnegative: () {},
                );
                return; // Return true to allow the pop action
              } else {
                context.popRoute();
              }
            }
          },
          child: Scaffold(
            backgroundColor: isDark ? black : white,
            body: Column(
              children: [
                backbutton(() => {context.popRoute()}, title: "Procuration".tr),

                // Progress indicator
                LinearProgressIndicator(
                  value:
                      (_currentStep.index + 1) / (WizardStep.values.length - 1),
                ),

                // Form content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable swipe
                    onPageChanged: (index) {
                      setState(() {
                        wizardState.updateInventory(
                          step: WizardStep.values[index],
                        );
                      });
                    },
                    children: [
                      KeepAliveWidget(
                        child: Proprietary(wizardState: wizardState),
                      ),
                      KeepAliveWidget(
                        child: LesLocataires(),
                      ),
                      KeepAliveWidget(
                        child: TheGood(wizardState: wizardState),
                      ),
                      KeepAliveWidget(
                        child: DateOfEtatDesLieux(wizardState: wizardState),
                      ),
                      KeepAliveWidget(
                        child: Complementary(wizardState: wizardState),
                      ),
                      KeepAliveWidget(
                        child: SumaryOfSummary(wizardState: wizardState),
                      ),
                      KeepAliveWidget(
                        child: Signatures(wizardState: wizardState),
                      ),
                      KeepAliveWidget(
                        child: PdfOffSummary(wizardState: wizardState),
                      ),
                      KeepAliveWidget(
                        child: FinalizationView(wizardState: wizardState),
                      ),
                    ],
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: _prevStep,
                        child: Text(_lang.previous),
                      ),
                      const Spacer(),
                      if (_currentStep != WizardStep.confirmation)
                        ElevatedButton.icon(
                          onPressed: wizardState.loading
                              ? null
                              : _currentStep == WizardStep.values[4]
                                  ? () => saveprocuration(wizardState)
                                  : _nextStep,
                          icon: wizardState.loading
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    color: AcnooAppColors.kWhiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                          label: Text(_currentStep == WizardStep.values[4]
                              ? _lang.save
                              : _lang.next),
                        ),
                      if (_currentStep == WizardStep.confirmation)
                        ElevatedButton(
                          onPressed: () => _submitForm(wizardState.formValues),
                          child: Text(_lang.submit),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

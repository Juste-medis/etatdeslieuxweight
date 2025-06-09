// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/fuctions/_overlay_helper.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/complementary.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/locataires_infos.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'inventory_report.dart';
import 'the_good.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'sortan_locataire_address.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/_app_colors.dart';
import 'package:go_router/go_router.dart';

class WizardForm extends StatefulWidget {
  final String? type;
  const WizardForm({super.key, this.type});

  @override
  State<WizardForm> createState() => _WizardFormState();
}

class _WizardFormState extends State<WizardForm> {
  final PageController _pageController = PageController();
  late AppThemeProvider wizardState;
  late ReviewProvider reviewState;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // Initialize the wizard state
    wizardState = context.read<AppThemeProvider>();
    wizardState.currentStep = WizardStep.reviewInfos;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
    reviewState = context.watch<ReviewProvider>();
  }

  void _prevStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void savereview(AppThemeProvider wizardState) async {
    var formData = wizardState.formValues;

    wizardState.setloading(true);
    var owners = extracthings(formData, "owner", wizardState);
    var exitenants = extracthings(formData, "exittenant", wizardState);

    // Create your final payload
    final payload = {
      'owners': owners,
      'exitenants': exitenants,
      'isMandated': wizardState.isMandated,
      'mandataire': {
        "type": formData["mandataire_type"],
        "denomination": formData["mandataire_denomination"],
        "lastname": formData["mandataire_lastname"],
        "firstname": formData["mandataire_firstname"],
        "phone": formData["mandataire_phone"],
        "dob": formData["mandataire_dob"],
        "placeofbirth": formData["mandataire_placeofbirth"],
        "address": formData["mandataire_address"],
        "email": formData["mandataire_email"],
      },
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
        'review_type': wizardState.reviewType,
      },
      'complementaryDetails': {
        'heatingType': formData['complementary_heatingType'],
        'heatingMode': formData['complementary_heatingMode'],
        'hotWaterType': formData['complementary_hotWaterType'],
        'hotWaterMode': formData['complementary_hotWaterMode'],
        'tenant_new_address': formData['tenant_new_address'],
        'tenant_entry_date': formData['tenant_entry_date']?.toIso8601String(),
        'comments': formData['comments'],
        'security_smoke': formData['security_smoke'],
        'security_smoke_functioning': formData['security_smoke_functioning'],
      },
    };

    my_inspect(payload);
    await createreview(payload).then((res) async {
      if (res.status == true) {
        showFullScreenSuccessDialog(
          context,
          title:
              'Votre état des lieux est maintenant dans votre espace personnel.',
          message:
              'Pour le completer, rendez-vous dans la section "Mes états des lieux".',
          okText: 'Continuer',
          onOk: () {
            reviewState.fetchReviews();
            context.pushReplacement(
              '/',
            );
          },
        );
      }
    }).catchError((e) {
      my_inspect(e);
      // toast(e.toString());
    });
    wizardState.setloading(false);
  }

  void _nextStep() async {
    wizardState.updateFormValue("", "");
    myprint("Next step: ${wizardState.currentStep}");

    if (wizardState.canGoNext) {
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
    final wizardState = context.watch<AppThemeProvider>();
    reviewState.seteditingReview(null, quiet: true);

    return Consumer<AppThemeProvider>(
      builder: (context, lang, child) {
        WizardStep _currentStep = wizardState.currentStep;

        Jks.context = context;
        return Scaffold(
          backgroundColor: isDark ? black : white,
          body: Column(
            children: [
              backbutton(() => {context.popRoute()}),

              // Progress indicator
              LinearProgressIndicator(
                value:
                    (_currentStep.index + 1) / (WizardStep.values.length - 4),
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
                      child: InventoryReport(),
                    ),
                    const KeepAliveWidget(
                      child: LesLocataires(),
                    ),
                    const KeepAliveWidget(
                      child: TheGood(),
                    ),
                    const KeepAliveWidget(
                      child: Complementary(),
                    ),
                    KeepAliveWidget(
                      child: LocataireSortantAddress(),
                    ),
                    // KeepAliveWidget(
                    //   child: PdfOffSummary(wizardState: wizardState),
                    // ),
                    // KeepAliveWidget(
                    //   child: FinalizationView(wizardState: wizardState),
                    // ),
                    // PreferencesStep(),
                    // ConfirmationStep(),
                  ],
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep != WizardStep.reviewInfos)
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
                                ? () => savereview(wizardState)
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
                            ? "Terminer".tr
                            : _lang.next),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

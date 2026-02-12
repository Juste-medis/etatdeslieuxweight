// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/complementary.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/locataires_infos.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/review_signatures.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'inventory_report.dart';
import 'the_good.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etadmin/generated/l10n.dart' as l;
import 'sortan_locataire_address.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/theme/_app_colors.dart';
import 'package:go_router/go_router.dart';

class WizardForm extends StatefulWidget {
  final dynamic type;
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
    Jks.imperativeActions["beforeLeaveProccuration"] = null;

    super.dispose();
  }

  @override
  void initState() {
    // Initialize the wizard state
    wizardState = context.read<AppThemeProvider>();
    wizardState.currentStep = WizardStep.reviewInfos;
    reviewState = context.read<ReviewProvider>();
    reviewState.seteditingReview(null, quiet: true, source: "wizardbuild");

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

    // Create your final payload
    final payload = {
      'owners': wizardState.inventoryProprietaires,
      'exitenants': wizardState.inventoryLocatairesSortant,
      'isMandated': wizardState.isMandated,
      'mandataire': wizardState.mandataire,
      "copyOptions": formData["copyOptions"] ?? false,
      'documentDetails': {
        'review_type': wizardState.reviewType,
      },
      'propertyDetails': wizardState.domaine.propertyDetails(),
      'complementaryDetails': {
        'tenant_new_address': formData['tenant_new_address'],
        'tenant_entry_date': formData['tenant_entry_date'] is String
            ? formData['tenant_entry_date']
            : formData['tenant_entry_date']?.toIso8601String(),
        'comments': formData['comments'],
        'security_smoke': formData['security_smoke'],
        'security_smoke_functioning': formData['security_smoke_functioning'],
      },
    };

    await createreview(payload).then((res) async {
      if (res.status == true) {
        reviewState.seteditingReview(null,
            quiet: true, source: "beforecreatereview");
        wizardState.updateFormValue('review_id', res.data['_id']);
        wizardState.updateFormValue(
            res.data['entranDocumentId'] != null
                ? 'entranDocumentId'
                : 'sortantDocumentId',
            res.data['entranDocumentId'] ?? res.data['sortantDocumentId']);
        final review = Review.fromJson(res.data);
        review.source = "saved";
        reviewState.fetchReviews(refresh: true);

        Jks.wizardNextStep = () {
          var computedReview = reviewState.editingReview ?? review;
          computedReview.setCredited(Jks.paymentState.paymentMade ?? "");
          reviewState.seteditingReview(computedReview,
              quiet: true, source: "wizard next step");
          wizardState.prefillReview(computedReview, quietly: true);
          context.push('/review/${review.id}', extra: computedReview);
        };

        showFullScreenSuccessDialog(
          context,
          title:
              'Votre état des lieux est maintenant dans votre espace personnel.',
          message:
              'Pour le compléter, rendez-vous dans la section "Mes états des lieux".',
          okText: 'Continuer',
          onOk: () {},
        );

        _nextStep();
        Jks.paymentState.paymentMade = "";
        wizardState.setloading(false);
      }
    }).catchError((e) {
      my_inspect(e);
      wizardState.setloading(false);
    });
    wizardState.setloading(false);
  }

  void _nextStep() async {
    wizardState.updateFormValue("", "");

    if (wizardState.canGoNext ||
        wizardState.currentStep == WizardStep.inventoryOfKeysCounters) {
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

    return Consumer<AppThemeProvider>(
      builder: (context, lang, child) {
        WizardStep _currentStep = wizardState.currentStep;

        Jks.context = context;
        Jks.imperativeActions["beforeLeaveProccuration"] = () {
          if (_currentStep != WizardStep.values[0] &&
              _currentStep != WizardStep.inventoryOfKeysCounters) {
            return showAwesomeConfirmDialog(
              context: context,
              title: "Annuler les modifications".tr,
              description: "Êtes-vous sûr de vouloir annuler ?".tr,
              persistantOnPositive: () {
                simulateScreenTap();
                Navigator.pop(context, true);
                Jks.imperativeActions["beforeLeaveProccuration"] = null;
              },
              onnegative: () {},
            );
          } else {
            Navigator.pop(context, true);
          }

          return Future.value(true);
        };
        return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop && result == null) {
                Jks.imperativeActions["beforeLeaveProccuration"]?.call();
              }
            },
            child: Scaffold(
              backgroundColor: isDark ? black : white,
              body: Column(
                children: [
                  backbutton(() {
                    Jks.imperativeActions["beforeLeaveProccuration"]?.call();
                  }, title: "Etat des lieux - Création".tr),

                  // Progress indicator
                  LinearProgressIndicator(
                    value: (_currentStep.index + 1) /
                        (WizardStep.values.length - 4),
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
                              liveupdate: false);
                        });
                      },
                      children: [
                        if (_currentStep !=
                            WizardStep.inventoryOfKeysCounters) ...[
                          KeepAliveWidget(
                            child: InventoryReport(),
                          ),
                          const KeepAliveWidget(
                            child: LocatairesInfos(),
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
                        ] else
                          ...List.generate(5, (index) {
                            return const SizedBox.shrink();
                          }),
                        KeepAliveWidget(
                          child: ReviewSignatures(wizardState: wizardState),
                        ),
                      ],
                    ),
                  ),

                  // Navigation buttons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep != WizardStep.reviewInfos &&
                            _currentStep != WizardStep.inventoryOfKeysCounters)
                          OutlinedButton(
                            onPressed: _prevStep,
                            child: Text(_lang.previous),
                          ),
                        const Spacer(),
                        if (_currentStep != WizardStep.confirmation &&
                            _currentStep != WizardStep.inventoryOfKeysCounters)
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
            ));
      },
    );
  }
}

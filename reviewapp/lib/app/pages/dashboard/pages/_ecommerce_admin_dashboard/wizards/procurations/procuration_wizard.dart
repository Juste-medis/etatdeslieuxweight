import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/date_of_review.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/finalization_view.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/pdf_summary_summary.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/complementary.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/inventory_report.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/locataires_infos.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/sortan_locataire_address.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/the_good.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:mon_etatsdeslieux/main.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;
import 'procuration_signatures.dart';
import 'pdf_summary_review.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/theme/_app_colors.dart';

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

  void goToHome() {
    Jks.proccurationState.proccurations.clear();
    Jks.proccurationState.fetchProccurations(refresh: true);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    Jks.paymentState.paymentMade = "";
    Jks.wizardNextStep = () {
      _nextStep();
    };
  }

  @override
  void dispose() {
    Jks.tenantApprovals = {};
    super.dispose();
  }

  void saveprocuration(AppThemeProvider wizardState) async {
    var formData = wizardState.formValues;
    wizardState.setloading(true);
    // Create your final payload
    final payload = {
      'owners': wizardState.inventoryProprietaires,
      'exitenants': wizardState.inventoryLocatairesSortant,
      'entrantenants': wizardState.inventoryLocatairesEntrants,
      'propertyDetails': wizardState.domaine.propertyDetails(),
      'documentDetails': {
        'address': formData['document_address'],
        'review_type': formData['review_type'],
        'review_estimed_date': "${formData['review_estimed_date']}",
        'preocuration_comments': formData['preocuration_comments'],
        'accesgivenTo': formData['accesgivenTo'],
      },
      'complementaryDetails': {
        'doccument_city': formData['doccument_city'],
        'tenant_entry_date': formData['tenant_entry_date'] is String
            ? formData['tenant_entry_date']
            : formData['tenant_entry_date']?.toIso8601String(),
        'comments': formData['comments'],
        'security_smoke': formData['security_smoke'],
        'security_smoke_functioning': formData['security_smoke_functioning'],
      },
    };

    await createprocuration(payload)
        .then((res) async {
          if (res.status == true) {
            var procuration = Procuration.fromJson(res.data);

            procuration.source = 'new';

            Jks.proccurationState.seteditingProcuration(
              procuration,
              source: 'new',
            );
            Jks.proc = procuration.copyWith(source: 'saved');

            wizardState.inventoryProprietaires = [...procuration.owners!];
            wizardState.inventoryLocatairesEntrants = [
              ...procuration.entrantenants!,
            ];
            wizardState.inventoryLocatairesSortant = [
              ...procuration.exitenants!,
            ];

            wizardState.updateFormValue(
              'entranDocumentId',
              res.data["entranDocumentId"],
            );
            wizardState.updateFormValue(
              'sortantDocumentId',
              res.data["sortantDocumentId"],
            );
            wizardState.updateFormValue('procurationId', res.data["_id"]);
            Jks.wizardState = wizardState;
            Jks.paymentState.paymentMade = "";
            Jks.proccurationState.fetchProccurations(
              refresh: true,
              type: "all",
            );

            for (final tenant in getAllProcurationAuthors(
              Jks.wizardState,
              ownerOnly: true,
            )) {
              Jks.tenantApprovals['${tenant.id}'] = GlobalKey<FormState>();
            }

            _nextStep(from: 'saveprocuration');
          }
        })
        .catchError((e) {
          my_inspect(e);
          // toast(e.toString());
        });
    wizardState.setloading(false);
  }

  void _nextStep({String? from}) async {
    wizardState.updateFormValue("", "");

    if (wizardState.currentStep == WizardStep.values[0]) {
      final userEmail = appStore.userEmail;
      bool isConnectedUserOwner = wizardState.inventoryProprietaires.any(
        (owner) => owner.email == userEmail,
      );
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
    if (wizardState.currentStep == WizardStep.locataireSortantAddress) {
      bool _validateSignatures() {
        for (final aythor in getAllProcurationAuthors(
          wizardState,
          ownerOnly: true,
        )) {
          final tenantKey = '${aythor.id}';
          var labelname = authorname(aythor);

          var isOwner = wizardState.inventoryProprietaires.any(
            (owner) => owner.id == aythor.id,
          );

          final hasSignature = Jks.griffes![tenantKey] != null;
          final isApproved =
              Jks.tenantApprovals[tenantKey]?.currentState?.validate() ?? false;

          final actionsCompleted = [hasSignature, isApproved];
          final completedCount = actionsCompleted
              .where((action) => action)
              .length;

          if (completedCount > 0 && completedCount < 2) {
            List<String> missingActions = [];
            if (!hasSignature) missingActions.add("signer");
            if (!isApproved) missingActions.add("accepter les conditions");

            String actionsText = "";
            if (missingActions.length > 1) {
              final lastAction = missingActions.removeLast();
              actionsText = "${missingActions.join(", ")} et $lastAction";
            } else if (missingActions.length == 1) {
              actionsText = missingActions.first;
            }

            show_common_toast(
              "$labelname doit $actionsText pour continuer".tr,
              Jks.context!,
            );
            return false;
          }
          if (isOwner) {
            wizardState.updateInventory(
              proprietaires: wizardState.inventoryProprietaires.map((e) {
                if (e.id == aythor.id) {
                  e.meta!["hasSigned"] = hasSignature;
                }
                return e;
              }).toList(),
              liveupdate: false,
            );
          } else {
            wizardState.updateInventory(
              locatairesentry: wizardState.inventoryLocatairesEntrants.map((e) {
                if (e.id == aythor.id) {
                  e.meta!["hasSigned"] = hasSignature;
                }
                return e;
              }).toList(),
              locataires: wizardState.inventoryLocatairesSortant.map((e) {
                if (e.id == aythor.id) {
                  e.meta!["hasSigned"] = hasSignature;
                }
                return e;
              }).toList(),
              liveupdate: false,
            );
          }
        }

        return true;
      }

      var validateSignatures = _validateSignatures();
      if (!validateSignatures) return;

      // Check if all owners have signed
      List<String> unsignedOwners = [], unsignedTenants = [];
      for (var owner in wizardState.inventoryProprietaires) {
        if (owner.meta == null || owner.meta!["hasSigned"] != true) {
          String ownerName = authorname(owner);
          if (ownerName.isEmpty) {
            ownerName = owner.email ?? "Propriétaire inconnu";
          }
          unsignedOwners.add(ownerName);
        }
      }
      for (var tenant in [
        ...wizardState.inventoryLocatairesEntrants,
        ...wizardState.inventoryLocatairesSortant,
      ]) {
        if (tenant.meta == null || tenant.meta!["hasSigned"] != true) {
          String tenantName = authorname(tenant);
          if (tenantName.isEmpty) {
            tenantName = tenant.email ?? "Locataire inconnu";
          }
          unsignedTenants.add(tenantName);
        }
      }

      if (unsignedOwners.isNotEmpty) {
        String unsignedNames = unsignedOwners.join(
          unsignedOwners.length == 2 ? " et " : ", ",
        );
        var plural = unsignedOwners.length > 1 ? "s" : "";
        final confirmed = await showAwesomeConfirmDialog(
          forceHorizontalButtons: true,
          cancelText: "Non".tr,
          confirmText: 'Oui'.tr,
          context: context,
          description:
              "Le$plural Bailleur$plural : $unsignedNames n'${unsignedOwners.length > 1 ? "ont" : "a"} pas signé"
                  .tr,
          title: 'Souhaitez vous signer plus-tard ?'.tr,
        );
        if (confirmed ?? false) {
          if ((unsignedOwners.length !=
                  wizardState.inventoryProprietaires.length) ||
              (unsignedTenants.length !=
                  (wizardState.inventoryLocatairesEntrants.length +
                      wizardState.inventoryLocatairesSortant.length))) {
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            return;
          }
        } else {
          return;
        }
      }

      var signer = await showModalBottomSheet(
        context: Jks.context!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        ),
        builder: (context) => Wrap(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                "Action irréversible",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Êtes-vous sûr de vouloir signer la procuration ? Cette action est irréversible et vous ne pourrez pas modifier les informations une fois signé.'
                    .tr,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(fontSize: 14),
              ).paddingTop(12),
            ).paddingTop(16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text("Annuler".tr),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text("Signer".tr),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      if (signer != true) {
        return;
      }
      wizardState.setloading(true);
      // Create your final payload
      Map<String, dynamic> payload = {
        "procurationId": wizardState.formValues['procurationId'],
      };
      payload["tenantSignatures"] = {};
      for (final tenant in getAllProcurationAuthors(wizardState)) {
        if (Jks.griffes!["${tenant.id}"] != null) {
          payload["tenantSignatures"]["${tenant.id}"] = base64Encode(
            Jks.griffes!["${tenant.id}"],
          );
        }
      }
      await griffeprocuration(payload)
          .then((res) async {
            if (res.status == true) {
              Jks.proccurationState.seteditingProcuration(
                Jks.proccurationState.editingProccuration!.copyWith(
                  meta: res.data["meta"],
                ),
              );

              wizardState.updateFormValue(
                'entranDocumentId',
                res.data["entranDocumentId"],
              );
              wizardState.updateFormValue(
                'sortantDocumentId',
                res.data["sortantDocumentId"],
              );
              await showFullScreenSuccessDialog(
                context,
                title:
                    'Votre Procuration est maintenant dans votre espace personnel.',
                message:
                    'Rendez-vous dans la section "Mes procurations" pour visualiser vos procurations. Un email a été envoyé aux signataires pour les notifier.'
                        .tr,
                okText: 'Continuer',
                onOk: () {
                  // goToHome();
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  return;
                },
              );
              // goToHome();
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          })
          .catchError((e) {
            my_inspect(e);
            wizardState.setloading(false);
          });
      wizardState.setloading(false);
      return;
    }
    if (wizardState.canGoNext ||
        wizardState.currentStep == WizardStep.inventoryOfKeysCounters ||
        wizardState.currentStep == WizardStep.inventoryOfRooms ||
        wizardState.currentStep == WizardStep.pdfOffSummary) {
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
    bool canLeaveSafely =
        wizardState.currentStep == WizardStep.values[7] ||
        wizardState.currentStep == WizardStep.values[8] ||
        wizardState.currentStep == WizardStep.values[9];
    return Consumer<AppThemeProvider>(
      builder: (context, lang, child) {
        WizardStep _currentStep = wizardState.currentStep;
        void beforeLeave() {
          if (wizardState.currentStep != WizardStep.values[0]) {
            showAwesomeConfirmDialog(
              context: context,
              title: "Annuler les modifications".tr,
              description: "Êtes-vous sûr de vouloir annuler ?".tr,
              persistantOnPositive: () {
                simulateScreenTap();
                Navigator.pop(context, true);
              },
              onnegative: () {},
            );
          } else {
            try {
              Navigator.pop(context, true);
            } catch (e) {
              myprint(e);
            }
          }
        }

        Jks.context = context;
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop && result == null && (!canLeaveSafely)) {
              beforeLeave();
            } else {}
          },
          child: Scaffold(
            backgroundColor: isDark ? black : white,
            body: Column(
              children: [
                if (!canLeaveSafely)
                  backbutton(() {
                    beforeLeave();
                  }, title: "Procuration".tr),
                LinearProgressIndicator(
                  value:
                      (_currentStep.index + 1) / (WizardStep.values.length - 1),
                ),
                // Text(wizardState.currentStep.name),

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
                          liveupdate: false,
                        );
                      });
                    },
                    children: [
                      if (_currentStep != WizardStep.confirmation) ...[
                        KeepAliveWidget(child: InventoryReport()),
                        KeepAliveWidget(child: LocatairesInfos()),
                        KeepAliveWidget(child: TheGood()),
                        KeepAliveWidget(child: Complementary()),
                        // KeepAliveWidget(
                        //   child: LocataireSortantAddress(),
                        // ),
                        KeepAliveWidget(child: DateOfEtatDesLieux()),
                        KeepAliveWidget(
                          child: SumaryOfSummary(wizardState: wizardState),
                        ),
                        KeepAliveWidget(
                          child: Signatures(wizardState: wizardState),
                        ),
                        KeepAliveWidget(
                          child: PdfOffSummary(wizardState: wizardState),
                        ),
                      ] else
                        ...List.generate(8, (index) {
                          return const SizedBox.shrink();
                        }),
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
                      if (wizardState.formValues['procurationId'] == null ||
                          _currentStep == WizardStep.values[5] ||
                          _currentStep == WizardStep.values[7])
                        OutlinedButton(
                          onPressed: _prevStep,
                          child: Text(_lang.previous),
                        ),
                      const Spacer(),
                      if (_currentStep != WizardStep.pdfOffSummary)
                        ElevatedButton.icon(
                          onPressed: wizardState.loading
                              ? null
                              : () {
                                  if (_currentStep ==
                                      WizardStep.inventoryOfRooms) {
                                    saveprocuration(wizardState);
                                  } else {
                                    _nextStep();
                                  }
                                },
                          icon: wizardState.loading
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    color: AcnooAppColors.kWhiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                          label: Text(
                            _currentStep == WizardStep.inventoryOfRooms
                                ? _lang.save
                                : _lang.next,
                          ),
                        ),
                      if (_currentStep == WizardStep.pdfOffSummary)
                        ElevatedButton(
                          onPressed: () => goToHome(),
                          child: Text("Retourner à l'accueil".tr),
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

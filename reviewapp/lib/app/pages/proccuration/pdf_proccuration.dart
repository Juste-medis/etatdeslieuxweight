import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/pdf_summary_summary.dart';
import 'package:mon_etatsdeslieux/app/providers/_proccuration_provider.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:mon_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pdfx/pdfx.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:provider/provider.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';

class ProccurationPreview extends StatelessWidget {
  ProccurationPreview({super.key}) {
    for (final tenant in getReviewAllAuthors(Jks.wizardState)) {
      _tenantApprovals['${tenant.id}'] = GlobalKey<FormState>();
    }
  }

  final Map<String, GlobalKey<FormState>> _tenantApprovals = {};

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    final proccurationState = context.watch<ProccurationProvider>();
    final wizardState = context.watch<AppThemeProvider>();
    var me = proccurationState.editingProccuration!.me();
    var myposition = proccurationState.editingProccuration!.myposition()!;
    var haveSigned = proccurationState.editingProccuration!.haveSigned(
      author: me,
    );

    var maindocumentUrl = proccurationState
        .data["${myposition == "owner" ? ownerpositions[0] : myposition}_pdfPath"];
    var secondocumentUrl = proccurationState
        .data["${myposition == "owner" ? ownerpositions[1] : myposition}_pdfPath"];
    myprint(
      "maindocumentUrl $maindocumentUrl secondocumentUrl $secondocumentUrl",
    );
    final theme = Theme.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );

    Jks.dowloadreviewName =
        "poccuration_${slugify(proccurationState.editingProccuration!.myposition()!)}_${proccurationState.editingProccuration!.propertyDetails?.address}.pdf";
    me.photos = wizardState.mandataire!.photos;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    Future<void> _submitSignatures(
      ProccurationProvider proccurationstate,
      InventoryAuthor me, {
      context,
    }) async {
      if (!_validateSignatures(me)) return;

      final confirmed = await showAwesomeConfirmDialog(
        forceHorizontalButtons: true,
        cancelText: "Non".tr,
        confirmText: 'Oui'.tr,
        context: Jks.context!,
        title: 'Êtes-vous sûr de vouloir signer ?'.tr,
        description:
            "Si vous signez, vous acceptez que la procuration soit considérée comme finalisée et ne puisse plus être modifiée"
                .tr,
      );
      if (!(confirmed ?? false)) {
        return;
      }

      // my_inspect(formData);
      proccurationstate.setloading(true);
      // Create your final payload

      try {
        // Prepare payload with all signatures
        Map<String, dynamic> payload = {
          "procurationId": proccurationstate.editingProccuration!.id,
        };
        payload["tenantSignatures"] = {};

        // Add tenant signatures
        payload["tenantSignatures"]["${me.id}"] = base64Encode(
          Jks.griffes!["${me.id}"],
        );
        await griffeprocuration(payload)
            .then((res) async {
              if (res.status == true) {
                proccurationState.seteditingProcuration(
                  proccurationState.editingProccuration!.copyWith(
                    meta: res.data["meta"],
                  ),
                );

                proccurationstate.setloading(false);
                Jks.pSp!.clear();
                Jks.griffes!.clear();
                await showFullScreenSuccessDialog(
                  Jks.context!,
                  title: "Vous avez signé la procuration avec succès".tr,
                  message:
                      "La procuration est maintenant finalisée et ne peut plus être modifiée."
                          .tr,
                  okText: 'Continuer',
                  onOk: () {
                    if (proccurationstate.proccurations.isNotEmpty) {
                      proccurationstate.proccurations.clear();
                    }
                    proccurationstate.fetchProccurations();
                  },
                );

                closebottomSheet(context);
                Jks.dowloadreviewName =
                    "proccuration_${slugify(res.data["meta"]["signaturesMeta"]["establishedDate"])}_${slugify(proccurationstate.editingProccuration!.propertyDetails!.address ?? "")}.pdf";
                // downloadWithHttp(
                //   documentUrl(proccurationstate.data[
                //       "${getReviewExplicitName(proccurationstate.editingProccuration!.reviewType!)}_pdfPath"])!,
                //   fileName: Jks.dowloadreviewName!,
                // );
              } else {
                show_common_toast(
                  "Erreur lors de la signature".tr,
                  Jks.context!,
                );
              }
            })
            .catchError((e) {
              my_inspect(e);
              // toast(e.toString());
            });
      } catch (e) {
        my_inspect(e);
        show_common_toast("Une erreur est survenue".tr, Jks.context!);
      } finally {
        proccurationstate.setloading(false);
      }
      proccurationstate.setloading(false);

      return;
    }

    void presentSignatureSheet() {
      showModalBottomSheet(
        context: context,
        backgroundColor: context.theme.colorScheme.primaryContainer,
        isScrollControlled: true,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Consumer<AppThemeProvider>(
              builder: (context, appTheme, child) {
                return ShadowContainer(
                  customHeader: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      20.height,
                      Text(
                        "Signature".tr.capitalizeFirstLetter(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      // ===========================================================================================================Propriétaires ou mandataire
                      Column(
                        key: Key('tenant_${me.id}_signature'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          signatureDivider(),
                          SignatureSection(
                            userkey: myposition == "owner"
                                ? "Bailleur"
                                : "Locataire ${myposition == "sortant" ? "sortant" : "entrant"}",
                            title: authorname(me),
                            signatureKey: '${me.id}',
                            showApproval: true,
                            formKey: _tenantApprovals['${me.id}'],
                            acceptText: myposition == "owner"
                                ? "Bon pour pouvoir"
                                : "Bon pour acceptation",
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_circle_left_outlined),
                            onPressed: () {
                              context.popRoute();
                            },
                          ),
                          30.width,
                          inventoryAddButton(
                            context,
                            title: "Signer".tr,
                            isLoading: proccurationState.isLoading,
                            icon: Icons.edit,
                            onPressed: proccurationState.isLoading
                                ? null
                                : () async {
                                    await _submitSignatures(
                                      proccurationState,
                                      me,
                                      context: context,
                                    );
                                  },
                          ),
                        ],
                      ).paddingOnly(bottom: 10, right: _padding),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prévisualisation de la procuration".tr.capitalizeFirstLetter(),
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 14),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.popRoute(),
        ),
      ),
      persistentFooterButtons:
          proccurationState.editingProccuration!.status == "completed"
          ? []
          : [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichTextWidget(
                          list: [
                            TextSpan(
                              text: "Procuration : ",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: proccurationState.isLoading
                                  ? "Chargement...".tr
                                  : "Télécharger",
                              recognizer: TapGestureRecognizer()
                                ..onTap = proccurationState.isLoading
                                    ? null
                                    : () async {
                                        var docurl = documentUrl(
                                          maindocumentUrl,
                                        );
                                        downloadWithHttp(
                                          docurl!,
                                          fileName: Jks.dowloadreviewName!,
                                        );
                                      },
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 14,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ("La procuration est complète et prête à être signée")
                              .tr
                              .capitalizeFirstLetter(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!haveSigned)
                    inventoryAddButton(
                      context,
                      title: isSmallScreen
                          ? "Signer"
                          : "Signer la procuration".tr,
                      isLoading: proccurationState.isLoading,
                      icon: Icons.edit,
                      onPressed: proccurationState.isLoading
                          ? null
                          : proccurationState.editingProccuration!.credited ==
                                false
                          ? () {
                              Jks.reglerpayment(
                                context,
                                proccurationState.editingProccuration!,
                                onSuccess: () {
                                  presentSignatureSheet();
                                },
                              );
                            }
                          : proccurationState.editingProccuration!.status ==
                                "completed"
                          ? null
                          : () {
                              presentSignatureSheet();
                            },
                    ),
                ],
              ),
            ],
      body: Container(
        height: context.height(),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primaryContainer,
          border: Border(
            top: BorderSide(color: theme.primaryColor, width: 2.0),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 5.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ShadowContainer(
            contentPadding: EdgeInsets.all(_padding / 2.75),
            customHeader: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (proccurationState.isLoading)
                  const Center(
                    heightFactor: 13,
                    child: CircularProgressIndicator(),
                  )
                else ...[
                  20.height,
                  if (myposition == "owner")
                    Text(
                      "Procuration pour les Sortants :".tr
                          .capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ).paddingSymmetric(horizontal: _padding),
                  10.height,
                  if (maindocumentUrl != null)
                    _buildPdfPreview(
                      context,
                      maindocumentUrl: maindocumentUrl!,
                      proccurationState: proccurationState,
                      typename: myposition == "owner" ? "sortant" : myposition,
                    ),
                  if (myposition == "owner") ...[
                    20.height,
                    Text(
                      "Procuration pour les Entrants : ".tr
                          .capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ).paddingSymmetric(horizontal: _padding),
                    10.height,
                    if (secondocumentUrl != null)
                      _buildPdfPreview(
                        context,
                        maindocumentUrl: secondocumentUrl,
                        proccurationState: proccurationState,
                        typename: "entrant",
                      ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateSignatures(InventoryAuthor tenant) {
    final tenantKey = '${tenant.id}';
    var labelname = authorname(tenant);

    if (Jks.griffes![tenantKey] == null) {
      show_common_toast(
        "$labelname doit signer avant de continuer".tr,
        Jks.context!,
      );
      return false;
    }

    // Check approval
    if (!(_tenantApprovals[tenantKey]!.currentState!.validate())) {
      show_common_toast(
        "$labelname doit accepter les conditions".tr,
        Jks.context!,
      );
      return false;
    }

    return true;
  }

  void closebottomSheet(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Widget _buildPdfPreview(
    BuildContext context, {
    required String maindocumentUrl,
    required ProccurationProvider proccurationState,
    String? typename = "",
  }) {
    final theme = context.theme;

    _downloadworker() async {
      Navigator.pop(context);
      downloadWithHttp(
        documentUrl(maindocumentUrl)!,
        fileName:
            "procuration_${typename}_${slugify(proccurationState.editingProccuration!.propertyDetails!.address ?? "")}_${proccurationState.editingProccuration!.propertyDetails?.address}.pdf",
      );
    }

    _seepreview(bool? b) async {
      if (b ?? false) {
        Navigator.pop(context);
      }
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: theme.colorScheme.primaryContainer,
        builder: (context) {
          return SummaryPdfView(
            shareable: false,
            pdfPath: documentUrl(maindocumentUrl)!,
            title: "Prévisualisation de la procuration".tr
                .capitalizeFirstLetter(),
          );
        },
      );
    }

    return SizedBox(
      height:
          MediaQuery.of(context).size.height *
          ((proccurationState.editingProccuration!.status == "completed" ||
                  kIsWeb)
              ? .7
              : 0.5),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _seepreview(false),
            child:
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: PdfView(
                    key: Key('pdf_preview_${generateClientId('pdf')}'),
                    controller: PdfController(
                      document: PdfDocument.openData(
                        loadPdfFromNetwork(
                          documentUrl(maindocumentUrl)!,
                          headers: buildHeaderTokens(),
                        ),
                      ),
                    ),
                  ),
                ).paddingSymmetric(
                  horizontal:
                      (proccurationState.editingProccuration!.status ==
                          "completed"
                      ? 10
                      : 20),
                ),
          ),
          Positioned(
            top: -4,
            right: 50,
            child: IconButton(
              icon: Icon(Icons.more_horiz, color: theme.colorScheme.primary),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Wrap(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        title: Text(
                          "Actions pour la proccuration".tr
                              .capitalizeFirstLetter(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Sélectionnez une action à effectuer sur la proccuration.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ).paddingTop(16),
                      if (!kIsWeb)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          leading: const Icon(Icons.edit),
                          title: Text(
                            "Voir".tr.capitalizeFirstLetter(),
                            style: Theme.of(context).textTheme.headlineSmall!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            ' Voir le pdf de la proccuration.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () => _seepreview(true),
                        ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        leading: const Icon(Icons.download),
                        title: Text(
                          'Télcharger'.tr.capitalizeFirstLetter(),
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Télcharger le pdf de l\'état des lieux.'.tr
                              .capitalizeFirstLetter(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: _downloadworker,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

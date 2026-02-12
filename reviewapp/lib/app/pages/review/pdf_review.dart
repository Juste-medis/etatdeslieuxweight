import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/pdf_summary_summary.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:mon_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pdfx/pdfx.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:provider/provider.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';

class ReviewPreview extends StatelessWidget {
  ReviewPreview({super.key}) {
    for (final tenant in getReviewAllAuthors(Jks.wizardState)) {
      _tenantApprovals['${tenant.id}'] = GlobalKey<FormState>();
    }
  }
  final Map<String, GlobalKey<FormState>> _tenantApprovals = {};

  void presentSignatureSheet({
    required BuildContext context,
    required ThemeData theme,
    required ReviewProvider reviewState,
    required AppThemeProvider wizardState,
    required bool isByProccuration,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Consumer<AppThemeProvider>(
            builder: (context, appTheme, child) {
              return ShadowContainer(
                customHeader: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    20.height,
                    Text(
                      "Signature".tr.capitalizeFirstLetter(),
                      style: theme.textTheme.labelLarge?.copyWith(fontSize: 30),
                    ),
                    20.height,
                    // ===========================================================================================================Propriétaires ou mandataire
                    if (reviewState.editingReview!.mandataire?.id != null &&
                        !isByProccuration)
                      Column(
                        key: Key(
                          'tenant_${reviewState.editingReview!.mandataire!.id}_signature',
                        ),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          signatureDivider(),
                          SignatureSection(
                            userkey: "Mandataire",
                            title: authorname(
                              reviewState.editingReview!.mandataire!,
                            ),
                            signatureKey:
                                '${reviewState.editingReview!.mandataire!.id}',
                            showApproval: true,
                            formKey:
                                _tenantApprovals['${reviewState.editingReview!.mandataire!.id}'],
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20)
                    else if (wizardState.inventoryProprietaires.isNotEmpty &&
                        !reviewState.editingReview!.isThegrantedAcces())
                      for (final tenant in wizardState.inventoryProprietaires)
                        Column(
                          key: Key('tenant_${tenant.id}_signature'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            signatureDivider(),
                            SignatureSection(
                              userkey: "Bailleur",
                              title: authorname(tenant),
                              signatureKey: '${tenant.id}',
                              showApproval: true,
                              formKey: _tenantApprovals['${tenant.id}'],
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 20),
                    //=========================================================================================Locataire Sortant
                    if (wizardState.inventoryLocatairesSortant.isNotEmpty)
                      for (final tenant
                          in wizardState.inventoryLocatairesSortant)
                        // if (reviewState
                        //         .editingReview!
                        //         .isThegrantedAcces() &&
                        //     me.email !=
                        //         tenant.email)
                        Column(
                          key: Key('tenant_${tenant.id}_signature'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            signatureDivider(),
                            SignatureSection(
                              userkey:
                                  "Locataire ${isByProccuration ? "Sortant" : ""}",
                              title: authorname(tenant),
                              signatureKey: '${tenant.id}',
                              showApproval: true,
                              formKey: _tenantApprovals['${tenant.id}'],
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 20),

                    //=========================================================================================Locataire entrant
                    if (wizardState.inventoryLocatairesEntrants.isNotEmpty)
                      for (final tenant
                          in wizardState.inventoryLocatairesEntrants)
                        // if (reviewState
                        //         .editingReview!
                        //         .isThegrantedAcces() &&
                        //     me.email !=
                        //         tenant.email)
                        Column(
                          key: Key('tenant_${tenant.id}_signature'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            signatureDivider(),
                            SignatureSection(
                              userkey:
                                  "Locataire ${isByProccuration ? "Entrant" : ""}",
                              title: authorname(tenant),
                              signatureKey: '${tenant.id}',
                              showApproval: true,
                              formKey: _tenantApprovals['${tenant.id}'],
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 20),

                    // ===========================================================================================================
                    30.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.cancel),
                          label: Text("Annuler".tr),
                          onPressed: () {
                            context.popRoute();
                          },
                        ),
                        inventoryAddButton(
                          context,
                          title: "Signer".tr,
                          isLoading: reviewState.isLoading,
                          icon: Icons.edit,
                          onPressed:
                              reviewState.isLoading ||
                                  !Jks.isNetworkAvailable ||
                                  reviewState.editingReview!.status ==
                                      "completed"
                              ? null
                              : () async {
                                  await _submitSignatures(
                                    reviewState,
                                    getReviewAllAuthors(wizardState),
                                    context: context,
                                  );
                                },
                        ),
                      ],
                    ).paddingOnly(bottom: 10),
                    30.height,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = context.watch<ReviewProvider>();
    final wizardState = context.watch<AppThemeProvider>();
    Jks.context = context;

    var maindocumentUrl = reviewState
        .data["${getReviewExplicitName(reviewState.editingReview?.reviewType ?? "")}_pdfPath"];
    var seconddocumentUrl;
    var isByProccuration = reviewState.editingReview?.procuration != null;
    try {
      seconddocumentUrl = reviewState
          .data["${getReviewExplicitName(reviewState.editingReview?.reviewType ?? "", reverse: true)}_pdfPath"];
    } catch (e) {
      seconddocumentUrl = null;
    }

    final theme = Theme.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    var fillingPercentage =
        reviewState.editingReview?.meta!["fillingPercentage"] ?? 0.0;
    Jks.dowloadreviewName =
        "edl_${slugify(reviewState.editingReview!.meta!["signaturesMeta"]?["establishedDate"] ?? "")}_${reviewState.editingReview!.propertyDetails?.address}.pdf";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prévisualisation ${reviewState.editingReview!.isThegrantedAcces() ? "des états des lieux" : "de l'état des lieux"} "
              .tr
              .capitalizeFirstLetter(),
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 14),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.popRoute(),
        ),
      ),
      persistentFooterButtons: reviewState.editingReview!.status == "completed"
          ? []
          : [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichTextWidget(
                        list: [
                          TextSpan(
                            text: "État des lieux : ",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!reviewState.editingReview!.isThegrantedAcces())
                            TextSpan(
                              text: reviewState.isLoading
                                  ? "Chargement...".tr
                                  : "Télécharger",
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    (reviewState.isLoading ||
                                        !Jks.isNetworkAvailable)
                                    ? null
                                    : () async {
                                        var docurl = documentUrl(
                                          maindocumentUrl,
                                        );
                                        if (reviewState
                                                .editingReview!
                                                .credited ==
                                            false) {
                                          Jks.reglerpayment(
                                            context,
                                            Jks.wizardState,
                                            reviewState,
                                            reviewState.editingReview!,
                                            onSuccess: () {
                                              downloadWithHttp(
                                                docurl!,
                                                fileName:
                                                    Jks.dowloadreviewName!,
                                              );
                                            },
                                          );
                                          return;
                                        }
                                        downloadWithHttp(
                                          docurl!,
                                          fileName: Jks.dowloadreviewName!,
                                        );
                                      },
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 14,
                                color: !Jks.isNetworkAvailable
                                    ? theme.colorScheme.onSurface.withAlpha(200)
                                    : theme.colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        !Jks.isNetworkAvailable
                            ? "Veuillez vous connecter à Internet pour télécharger et/ou signer ${reviewState.editingReview!.isThegrantedAcces() ? "les états des lieux" : "l'état des lieux"}"
                                  .tr
                                  .capitalizeFirstLetter()
                            : (fillingPercentage != 100
                                      ? "Veuillez compléter l’état des lieux avant de pouvoir signer"
                                      : Jks.canEditReview == "signing"
                                      ? "Signé"
                                      : "L'état des lieux est complet et prêt à être signé")
                                  .tr
                                  .capitalizeFirstLetter(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 12,
                        ),
                      ).withWidth(MediaQuery.of(context).size.width * 0.5),
                    ],
                  ),
                  const Spacer(),
                  if (reviewState.editingReview!.status != "completed")
                    inventoryAddButton(
                      context,
                      title: "Signer".tr,
                      icon: Icons.edit,
                      isLoading: reviewState.isLoading,
                      onPressed:
                          reviewState.isLoading ||
                              !Jks.isNetworkAvailable ||
                              reviewState.editingReview!.status == "completed"
                          ? null
                          : reviewState.editingReview!.credited == false
                          ? () {
                              Jks.reglerpayment(
                                context,
                                wizardState,
                                reviewState,
                                reviewState.editingReview!,
                                onSuccess: () {
                                  presentSignatureSheet(
                                    context: context,
                                    theme: theme,
                                    reviewState: reviewState,
                                    wizardState: wizardState,
                                    isByProccuration: isByProccuration,
                                  );
                                },
                              );
                            }
                          : fillingPercentage < 50
                          ? null
                          : () {
                              presentSignatureSheet(
                                context: context,
                                theme: theme,
                                reviewState: reviewState,
                                wizardState: wizardState,
                                isByProccuration: isByProccuration,
                              );
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
                if (reviewState.isLoading)
                  const Center(
                    heightFactor: 13,
                    child: CircularProgressIndicator(),
                  ),
                20.height,
                if (!reviewState.isLoading && maindocumentUrl != null) ...[
                  if (isByProccuration)
                    Text(
                      "État des lieux ${reviewState.editingReview!.reviewType == "entrance" ? "d'entrée" : "de sortie"}"
                          .tr
                          .capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ).paddingSymmetric(
                      horizontal: _padding,
                      vertical: _padding,
                    ),
                  _buildPdfPreview(
                    context,
                    theme,
                    maindocumentUrl: maindocumentUrl!,
                    reviewState: reviewState,
                  ),
                ],
                20.height,
                if (!reviewState.isLoading && seconddocumentUrl != null) ...[
                  if (isByProccuration)
                    Text(
                      "État des lieux ${reviewState.editingReview!.reviewType == "entrance" ? "de sortie" : "d'entrée"}"
                          .tr
                          .capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ).paddingSymmetric(
                      horizontal: _padding,
                      vertical: _padding,
                    ),
                  _buildPdfPreview(
                    context,
                    theme,
                    maindocumentUrl: seconddocumentUrl!,
                    reviewState: reviewState,
                  ),
                ],
                30.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateSignatures(List<InventoryAuthor> allauthors) {
    for (final tenant in allauthors) {
      final tenantKey = '${tenant.id}';
      var labelname = tenant.type == "morale"
          ? "${tenant.denomination} (représenté par ${tenant.representant!.firstname} ${tenant.representant!.lastName})"
          : "${tenant.firstname} ${tenant.lastName}";
      // Check signature

      // Check if tenant has photos
      // if (tenant.photos == null || tenant.photos!.isEmpty) {
      //   show_common_toast(
      //     "$labelname doit joindre une photo".tr,
      //     Jks.context!,
      //   );
      //   return false;
      // }

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
    }

    return true;
  }

  Future<void> _submitSignatures(
    ReviewProvider reviewState,
    List<InventoryAuthor> allauthors, {
    context,
  }) async {
    if (!_validateSignatures(allauthors)) return;

    final confirmed = await showAwesomeConfirmDialog(
      forceHorizontalButtons: true,
      cancelText: "Non".tr,
      confirmText: 'Oui'.tr,
      context: Jks.context!,
      title: 'Êtes-vous sûr de vouloir signer ?'.tr,
      description:
          "Si vous signez, vous acceptez que l'état des lieux soit considéré comme finalisé et ne peut plus être modifié."
              .tr,
    );
    if (!(confirmed ?? false)) {
      return;
    }

    // my_inspect(formData);
    reviewState.setloading(true);
    // Create your final payload

    try {
      // Prepare payload with all signatures
      Map<String, dynamic> payload = {
        "reviewId": reviewState.editingReview!.id,
      };
      payload["tenantSignatures"] = {};

      // Add tenant signatures
      for (final tenant in allauthors) {
        payload["tenantSignatures"]["${tenant.id}"] = base64Encode(
          Jks.griffes!["${tenant.id}"],
        );
      }
      await grifferefiew(payload)
          .then((res) async {
            if (res.status == true) {
              reviewState.setloading(false);
              // return;
              Jks.pSp!.clear();
              Jks.griffes!.clear();
              reviewState.updateThereview(
                reviewState.editingReview!,
                "griffe",
                wizardState: Jks.wizardState,
                force: true,
              );

              await showFullScreenSuccessDialog(
                Jks.context!,
                title: "Vous avez signé l'état des lieux avec succès".tr,
                message:
                    "L'état des lieux est maintenant finalisé et ne peut plus être modifié."
                        .tr,
                okText: 'Continuer',
                onOk: () {
                  reviewState.reviews.clear();
                  reviewState.fetchReviews(refresh: true);
                },
              );

              closebottomSheet(context);
              Jks.dowloadreviewName =
                  "edl_${slugify(res.data["meta"]?["signaturesMeta"]?["establishedDate"] ?? "")}_${slugify(reviewState.editingReview!.propertyDetails!.address ?? "")}.pdf";
              downloadWithHttp(
                documentUrl(
                  reviewState
                      .data["${getReviewExplicitName(reviewState.editingReview!.reviewType!)}_pdfPath"],
                )!,
                fileName: Jks.dowloadreviewName!,
              );
            } else {
              show_common_toast("Erreur lors de la signature".tr, Jks.context!);
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
      reviewState.setloading(false);
    }
    reviewState.setloading(false);

    return;
  }

  void closebottomSheet(context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Widget _buildPdfPreview(
    context,
    theme, {
    required String maindocumentUrl,
    required ReviewProvider reviewState,
  }) {
    try {
      _downloadworker() async {
        if (reviewState.editingReview!.credited == false) {
          Jks.reglerpayment(
            context,
            Jks.wizardState,
            reviewState,
            reviewState.editingReview!,
            onSuccess: () {
              downloadWithHttp(
                documentUrl(maindocumentUrl)!,
                fileName:
                    "edl_${slugify(reviewState.editingReview!.propertyDetails!.address ?? "")}_${reviewState.editingReview!.propertyDetails?.address}.pdf",
              );
            },
          );
          return;
        }

        Navigator.pop(context);
        downloadWithHttp(
          documentUrl(maindocumentUrl)!,
          fileName:
              "edl_${slugify(reviewState.editingReview!.propertyDetails!.address ?? "")}_${reviewState.editingReview!.propertyDetails?.address}.pdf",
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
              pdfPath: documentUrl(maindocumentUrl)!,
              thereview: reviewState.editingReview!,
              title: "Prévisualisation de l'état des lieux".tr
                  .capitalizeFirstLetter(),
            );
          },
        );
      }

      return GestureDetector(
        onTap: () => _seepreview(false),
        child: SizedBox(
          height:
              MediaQuery.of(context).size.height *
              ((reviewState.editingReview!.status == "completed" || kIsWeb)
                  ? .7
                  : reviewState.editingReview!.procuration != null
                  ? .5
                  : .65),
          child: Stack(
            children: [
              Positioned.fill(
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
                      child:
                          maindocumentUrl.contains('/storage/') ||
                              maindocumentUrl.contains('mon_etatsdeslieux/')
                          ? PdfView(
                              key: Key(
                                'pdf_preview_${generateClientId('pdf')}',
                              ),
                              controller: PdfController(
                                document: PdfDocument.openFile(maindocumentUrl),
                              ),
                            )
                          : PdfView(
                              key: Key(
                                'pdf_preview_${generateClientId('pdf')}',
                              ),
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
                      vertical: 10,
                      horizontal:
                          (reviewState.editingReview!.status == "completed"
                          ? 10
                          : 20),
                    ),
              ),
              Positioned(
                top: -4,
                right: 50,
                child: IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: theme.colorScheme.primary,
                  ),
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
                              "Actions pour l'état des lieux".tr
                                  .capitalizeFirstLetter(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            subtitle: Text(
                              'Sélectionnez une action à effectuer sur l\'état des lieux.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ).paddingTop(16),
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
                              ' Voir le pdf de l\'état des lieux.',
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
                            onTap: !Jks.isNetworkAvailable
                                ? null
                                : _downloadworker,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Positioned(child: Text("${maindocumentUrl.hashCode}"))
            ],
          ),
        ),
      );
    } catch (e) {
      my_inspect(e);
      return Center(child: LinearProgressIndicator());
    }
  }
}

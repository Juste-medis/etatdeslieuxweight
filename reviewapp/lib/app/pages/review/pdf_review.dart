import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/signature.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/pdf_summary_summary.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:jatai_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReviewPreview extends StatelessWidget {
  ReviewPreview({super.key});
  final PdfViewerController _pdfController = PdfViewerController();
  final PdfViewerController _pdfController2 = PdfViewerController();
  final Map<String, GlobalKey<FormState>> _tenantApprovals = {};

  void _scrollToBottom() {
    try {
      _pdfController.jumpToPage(_pdfController.pageCount);
    } catch (e) {
      my_inspect(e);
    }
  }

  bool _validateSignatures(
      ReviewProvider reviewState, List<InventoryAuthor> allauthors) {
    for (final tenant in allauthors) {
      final tenantKey = '${tenant.id}';
      var labelname = tenant.type == "morale"
          ? "${tenant.denomination} (représenté par ${tenant.representant!.firstname} ${tenant.representant!.lastName})"
          : "${tenant.firstname} ${tenant.lastName}";
      // Check signature

      // Check if tenant has photos
      if (tenant.photos == null || tenant.photos!.isEmpty) {
        show_common_toast(
          "$labelname doit joindre une photo".tr,
          Jks.context!,
        );
        return false;
      }

      if (Jks.pSp![tenantKey] == null) {
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
      ReviewProvider reviewState, List<InventoryAuthor> allauthors) async {
    if (!_validateSignatures(reviewState, allauthors)) return;

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
      // Add mandataire signature if exists
      if (reviewState.editingReview!.mandataire != null &&
          Jks.pSp!["mandataireSignature"] != null) {
        payload["mandataireSignature"] =
            base64Encode(Jks.pSp!["mandataireSignature"]);
      }

      payload["tenantSignatures"] = {};

      // Add tenant signatures
      for (final tenant in allauthors) {
        payload["tenantSignatures"]["${tenant.id}"] =
            base64Encode(Jks.pSp!["${tenant.id}"]);
      }
      await grifferefiew(payload).then((res) async {
        if (res.status == true) {
          reviewState.setloading(false);
          Jks.pSp!.clear();
          my_inspect(res.data);
          await showFullScreenSuccessDialog(
            Jks.context!,
            title: "Vous avez signé l'état des lieux avec succès".tr,
            message:
                "L'état des lieux est maintenant finalisé et ne peut plus être modifié."
                    .tr,
            okText: 'Continuer',
            onOk: () {
              reviewState.reviews.clear();
              reviewState.fetchReviews();
            },
          );

          downloadWithHttp(
            documentUrl(reviewState.data['pdfPath'])!,
            fileName: "etat_des_lieux_${reviewState.editingReview!.id}.pdf",
          );
        } else {
          show_common_toast("Erreur lors de la signature".tr, Jks.context!);
        }
      }).catchError((e) {
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

  List<InventoryAuthor> _getAllAuthors(AppThemeProvider reviewState) {
    List<InventoryAuthor> allauthors = [
      ...reviewState.inventoryLocatairesEntrants,
      ...reviewState.inventoryLocatairesSortant,
      ...(!Jks.reviewState.editingReview!.isThegrantedAcces()
          ? reviewState.inventoryProprietaires
          : []),
      // if (reviewState.isMandated && reviewState.mandataire != null)
      //   reviewState.mandataire!,
    ];

    return allauthors;
  }

  _buildPdfPreview(context, theme,
      {required String maindocumentUrl,
      required ReviewProvider reviewState,
      pdfcontroller}) {
    _seepreview() {
      () {
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return SummaryPdfView(
              pdfPath: documentUrl(maindocumentUrl)!,
              title: "Prévisualisation de l'état des lieux"
                  .tr
                  .capitalizeFirstLetter(),
            );
          },
        );
      };
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SfPdfViewer.network(
                documentUrl(maindocumentUrl)!,
                controller: pdfcontroller,
                headers: buildHeaderTokens(),
              ),
            ).paddingSymmetric(horizontal: 50),
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          "Actions pour l'état des lieux"
                              .tr
                              .capitalizeFirstLetter(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                          'Sélectionnez une action à effectuer sur l\'état des lieux.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ).paddingTop(16),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        leading: const Icon(Icons.edit),
                        title: Text("Voir".tr.capitalizeFirstLetter(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                )),
                        subtitle: Text(
                          ' Voir le pdf de l\'état des lieux.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: _seepreview,
                      ),
                      ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          leading: const Icon(Icons.delete_outline),
                          title: Text('Télcharger'.tr.capitalizeFirstLetter(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  )),
                          subtitle: Text(
                            'Télcharger le pdf de l\'état des lieux.'
                                .tr
                                .capitalizeFirstLetter(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            downloadWithHttp(
                              documentUrl(maindocumentUrl)!,
                              fileName:
                                  "etat_des_lieux_${reviewState.editingReview!.id}.pdf",
                            );
                          }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ).center(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = context.watch<ReviewProvider>();
    final wizardState = context.watch<AppThemeProvider>();
    List<InventoryAuthor> allauthors = _getAllAuthors(wizardState);
    for (final tenant in allauthors) {
      _tenantApprovals['${tenant.id}'] = GlobalKey<FormState>();
    }
    var maindocumentUrl = reviewState.data[
        "${getReviewExplicitName(reviewState.editingReview!.reviewType!)}_pdfPath"];

    var seconddocumentUrl = reviewState.data[
        "${getReviewExplicitName(reviewState.editingReview!.reviewType!, reverse: true)}_pdfPath"];
    myprint("Preview data: $seconddocumentUrl");

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prévisualisation ${reviewState.editingReview!.isThegrantedAcces() ? "des états des lieux" : "de l'état des lieux"} "
              .tr
              .capitalizeFirstLetter(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.popRoute(),
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichTextWidget(list: [
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
                          : "Télecharger",
                      recognizer: TapGestureRecognizer()
                        ..onTap = reviewState.isLoading
                            ? null
                            : () {
                                downloadWithHttp(
                                  documentUrl(maindocumentUrl)!,
                                  fileName:
                                      "etat_des_lieux_${reviewState.editingReview!.id}.pdf",
                                );
                              },
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 14,
                        color: theme.colorScheme.primary,
                      ),
                    )
                ]),
                Text(
                    (fillingPercentage != 100
                            ? "Veiller completer l'état des lieux avant de pouvoir le signer"
                            : Jks.canEditReview == "signing"
                                ? "Signé"
                                : "L'état des lieux est complet et prêt à être signé")
                        .tr
                        .capitalizeFirstLetter(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 12,
                    )).withWidth(MediaQuery.of(context).size.width * 0.5),
              ],
            ),
            const Spacer(),
            inventoryAddButton(
              context,
              title: "Signer".tr,
              icon: Icons.edit,
              onPressed: reviewState.isLoading
                  ? null
                  : fillingPercentage < 50
                      ? null
                      : () {
                          Jks.pSp!["locataireSignature"] = null;

                          _scrollToBottom();

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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          20.height,
                                          Text(
                                            "Signature"
                                                .tr
                                                .capitalizeFirstLetter(),
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(fontSize: 30),
                                          ),
                                          20.height,
                                          // ===========================================================================================================Propriétaires
                                          if (wizardState.inventoryProprietaires
                                                  .isNotEmpty &&
                                              !reviewState.editingReview!
                                                  .isThegrantedAcces())
                                            for (final tenant in wizardState
                                                .inventoryProprietaires)
                                              Column(
                                                key: Key(
                                                    'tenant_${tenant.id}_signature'),
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Divider(
                                                    color: theme.dividerColor,
                                                    thickness: 20,
                                                  ).paddingSymmetric(
                                                      vertical: 20),
                                                  _SignatureSection(
                                                    title: tenant.type ==
                                                            "morale"
                                                        ? "Bailleur:  ${tenant.denomination} (représenté par ${tenant.representant!.firstname} ${tenant.representant!.lastName})"
                                                        : "Bailleur: ${tenant.firstname} ${tenant.lastName}",
                                                    signatureKey:
                                                        '${tenant.id}',
                                                    showApproval: true,
                                                    formKey: _tenantApprovals[
                                                        '${tenant.id}'],
                                                  ),
                                                  Text(
                                                    "Photos de la pièce d'identité + selfie d'identification avec pièce d'identité"
                                                        .tr,
                                                    style: theme
                                                        .textTheme.labelLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: theme
                                                                .colorScheme
                                                                .onSurface),
                                                  ).paddingAll(10),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .control_point_duplicate,
                                                            color: context
                                                                .primaryColor,
                                                          ),
                                                          onPressed: () async {
                                                            sourceSelect(
                                                                context:
                                                                    context,
                                                                callback:
                                                                    (croppedFile) async {
                                                                  await uploadFile(
                                                                      croppedFile,
                                                                      thing:
                                                                          tenant,
                                                                      cb: (photolist) {
                                                                    tenant
                                                                        .photos!
                                                                        .add(
                                                                            photolist);
                                                                    wizardState
                                                                        .updateInventory(
                                                                      proprietaires: wizardState
                                                                          .inventoryProprietaires
                                                                          .map(
                                                                              (piece) {
                                                                        if (piece.id ==
                                                                            tenant.id) {
                                                                          return tenant;
                                                                        }
                                                                        return piece;
                                                                      }).toList(),
                                                                    );
                                                                  });
                                                                });
                                                          },
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 100,
                                                            child:
                                                                GridView.count(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              crossAxisCount: 1,
                                                              mainAxisSpacing:
                                                                  5,
                                                              crossAxisSpacing:
                                                                  5,
                                                              children:
                                                                  List.generate(
                                                                (tenant.photos ??
                                                                        [])
                                                                    .length,
                                                                (index) {
                                                                  final _item =
                                                                      tenant.photos![
                                                                          index];
                                                                  return JataiGalleryImageCard(
                                                                    item: _item,
                                                                    thingtype:
                                                                        tenant,
                                                                    onDelete:
                                                                        () {
                                                                      tenant
                                                                          .photos!
                                                                          .removeAt(
                                                                              index);
                                                                      wizardState
                                                                          .updateInventory(
                                                                        proprietaires: wizardState
                                                                            .inventoryProprietaires
                                                                            .map((piece) {
                                                                          if (piece.id ==
                                                                              tenant.id) {
                                                                            return tenant;
                                                                          }
                                                                          return piece;
                                                                        }).toList(),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ).paddingOnly(
                                                                    bottom: 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ).paddingSymmetric(
                                                  horizontal: 20),
                                          //=========================================================================================Locataire Sortant
                                          if (wizardState
                                              .inventoryLocatairesSortant
                                              .isNotEmpty)
                                            for (final tenant in wizardState
                                                .inventoryLocatairesSortant)
                                              Column(
                                                key: Key(
                                                    'tenant_${tenant.id}_signature'),
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Divider(
                                                    color: theme.dividerColor,
                                                    thickness: 20,
                                                  ).paddingSymmetric(
                                                      vertical: 20),
                                                  _SignatureSection(
                                                    title: tenant.type ==
                                                            "morale"
                                                        ? "Locataire Sortant: ${tenant.denomination} (représenté par ${tenant.representant!.firstname} ${tenant.representant!.lastName})"
                                                        : "Locataire Sortant: ${tenant.firstname} ${tenant.lastName}",
                                                    signatureKey:
                                                        '${tenant.id}',
                                                    showApproval: true,
                                                    formKey: _tenantApprovals[
                                                        '${tenant.id}'],
                                                  ),
                                                  Text(
                                                    "Photos de la pièce d'identité + selfie d'identification avec pièce d'identité"
                                                        .tr,
                                                    style: theme
                                                        .textTheme.labelLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: theme
                                                                .colorScheme
                                                                .onSurface),
                                                  ).paddingAll(10),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .control_point_duplicate,
                                                            color: context
                                                                .primaryColor,
                                                          ),
                                                          onPressed: () async {
                                                            sourceSelect(
                                                                context:
                                                                    context,
                                                                callback:
                                                                    (croppedFile) async {
                                                                  await uploadFile(
                                                                      croppedFile,
                                                                      thing:
                                                                          tenant,
                                                                      cb: (photolist) {
                                                                    tenant
                                                                        .photos!
                                                                        .add(
                                                                            photolist);
                                                                    wizardState
                                                                        .updateInventory(
                                                                      locataires: wizardState
                                                                          .inventoryLocatairesSortant
                                                                          .map(
                                                                              (piece) {
                                                                        if (piece.id ==
                                                                            tenant.id) {
                                                                          return tenant;
                                                                        }
                                                                        return piece;
                                                                      }).toList(),
                                                                    );
                                                                  });
                                                                });
                                                          },
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 100,
                                                            child:
                                                                GridView.count(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              crossAxisCount: 1,
                                                              mainAxisSpacing:
                                                                  5,
                                                              crossAxisSpacing:
                                                                  5,
                                                              children:
                                                                  List.generate(
                                                                (tenant.photos ??
                                                                        [])
                                                                    .length,
                                                                (index) {
                                                                  final _item =
                                                                      tenant.photos![
                                                                          index];
                                                                  return JataiGalleryImageCard(
                                                                    item: _item,
                                                                    thingtype:
                                                                        tenant,
                                                                    onDelete:
                                                                        () {
                                                                      tenant
                                                                          .photos!
                                                                          .removeAt(
                                                                              index);
                                                                      wizardState
                                                                          .updateInventory(
                                                                        locataires: wizardState
                                                                            .inventoryLocatairesSortant
                                                                            .map((piece) {
                                                                          if (piece.id ==
                                                                              tenant.id) {
                                                                            return tenant;
                                                                          }
                                                                          return piece;
                                                                        }).toList(),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ).paddingOnly(
                                                                    bottom: 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ).paddingSymmetric(
                                                  horizontal: 20),

                                          //=========================================================================================Locataire entrant
                                          if (wizardState
                                              .inventoryLocatairesEntrants
                                              .isNotEmpty)
                                            for (final tenant in wizardState
                                                .inventoryLocatairesEntrants)
                                              Column(
                                                key: Key(
                                                    'tenant_${tenant.id}_signature'),
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Divider(
                                                    color: theme.dividerColor,
                                                    thickness: 20,
                                                  ).paddingSymmetric(
                                                      vertical: 20),
                                                  _SignatureSection(
                                                    title: tenant.type ==
                                                            "morale"
                                                        ? "Locataire Entrant:  ${tenant.denomination} (représenté par ${tenant.representant!.firstname} ${tenant.representant!.lastName})"
                                                        : "Locataire Entrant: ${tenant.firstname} ${tenant.lastName}",
                                                    signatureKey:
                                                        '${tenant.id}',
                                                    showApproval: true,
                                                    formKey: _tenantApprovals[
                                                        '${tenant.id}'],
                                                  ),
                                                  Text(
                                                    "Photos de la pièce d'identité + selfie d'identification avec pièce d'identité"
                                                        .tr,
                                                    style: theme
                                                        .textTheme.labelLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: theme
                                                                .colorScheme
                                                                .onSurface),
                                                  ).paddingAll(10),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .control_point_duplicate,
                                                            color: context
                                                                .primaryColor,
                                                          ),
                                                          onPressed: () async {
                                                            sourceSelect(
                                                                context:
                                                                    context,
                                                                callback:
                                                                    (croppedFile) async {
                                                                  await uploadFile(
                                                                      croppedFile,
                                                                      thing:
                                                                          tenant,
                                                                      cb: (photolist) {
                                                                    tenant
                                                                        .photos!
                                                                        .add(
                                                                            photolist);
                                                                    wizardState
                                                                        .updateInventory(
                                                                      locatairesentry: wizardState
                                                                          .inventoryLocatairesEntrants
                                                                          .map(
                                                                              (piece) {
                                                                        if (piece.id ==
                                                                            tenant.id) {
                                                                          return tenant;
                                                                        }
                                                                        return piece;
                                                                      }).toList(),
                                                                    );
                                                                  });
                                                                });
                                                          },
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 100,
                                                            child:
                                                                GridView.count(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              crossAxisCount: 1,
                                                              mainAxisSpacing:
                                                                  5,
                                                              crossAxisSpacing:
                                                                  5,
                                                              children:
                                                                  List.generate(
                                                                (tenant.photos ??
                                                                        [])
                                                                    .length,
                                                                (index) {
                                                                  final _item =
                                                                      tenant.photos![
                                                                          index];
                                                                  return JataiGalleryImageCard(
                                                                    item: _item,
                                                                    thingtype:
                                                                        tenant,
                                                                    onDelete:
                                                                        () {
                                                                      tenant
                                                                          .photos!
                                                                          .removeAt(
                                                                              index);
                                                                      wizardState
                                                                          .updateInventory(
                                                                        locatairesentry: wizardState
                                                                            .inventoryLocatairesEntrants
                                                                            .map((piece) {
                                                                          if (piece.id ==
                                                                              tenant.id) {
                                                                            return tenant;
                                                                          }
                                                                          return piece;
                                                                        }).toList(),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ).paddingOnly(
                                                                    bottom: 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ).paddingSymmetric(
                                                  horizontal: 20),

                                          // ===========================================================================================================

                                          30.height,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton.icon(
                                                icon: const Icon(Icons.cancel),
                                                label: Text(
                                                  "Annuler".tr,
                                                ),
                                                onPressed: () {
                                                  context.popRoute();
                                                },
                                              ),
                                              inventoryAddButton(context,
                                                  title: "Signer".tr,
                                                  icon: Icons.edit,
                                                  onPressed:
                                                      reviewState.isLoading
                                                          ? null
                                                          : () async {
                                                              await _submitSignatures(
                                                                  reviewState,
                                                                  _getAllAuthors(
                                                                      wizardState));
                                                            })
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
                        },
            ),
          ],
        )
      ],
      backgroundColor: whiteColor,
      body: Container(
        height: context.height(),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: whiteColor,
          border: Border(
            top: BorderSide(
              color: theme.primaryColor,
              width: 2.0,
            ),
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
                      heightFactor: 17,
                      child: CircularProgressIndicator(),
                    ),
                  20.height,
                  if (!reviewState.isLoading && maindocumentUrl != null)
                    _buildPdfPreview(context, theme,
                        maindocumentUrl: maindocumentUrl!,
                        pdfcontroller: _pdfController,
                        reviewState: reviewState),
                  if (!reviewState.isLoading && seconddocumentUrl != null)
                    _buildPdfPreview(context, theme,
                        maindocumentUrl: seconddocumentUrl!,
                        pdfcontroller: _pdfController2,
                        reviewState: reviewState),
                  30.height,
                ],
              ),
            )),
      ),
    );
  }
}

class _SignatureSection extends StatelessWidget {
  final String title;
  final String signatureKey;
  final bool showApproval;
  final ValueChanged<bool>? onApprovalChanged;
  final GlobalKey<FormState>? formKey;
  const _SignatureSection({
    this.formKey,
    required this.title,
    required this.signatureKey,
    this.showApproval = false,
    this.onApprovalChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: theme.textTheme.titleMedium)
            .paddingSymmetric(horizontal: 16),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 200,
          child: SignaturePadWidget(signatureKey),
        ),
        if (showApproval) ...[
          const SizedBox(height: 16),
          Form(
            key: formKey ?? GlobalKey<FormState>(),
            child: AcnooCheckBoxFormField(
              title: Text("Lu et approuvé".tr),
              validator: (value) {
                // Validate the checkbox
                if (onApprovalChanged != null) {
                  onApprovalChanged!(value ?? false);
                }

                if (value == null || !value) {
                  return "Veuillez accepter les conditions pour continuer".tr;
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ).paddingLeft(20),
        ],
      ],
    );
  }
}

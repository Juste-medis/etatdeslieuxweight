import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mon_etatsdeslieux/app/core/app_config/app_config.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole3.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/pages/review/overview_card.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:provider/provider.dart';

import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:mon_etatsdeslieux/app/core/theme/_app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ReviewDashboard extends StatefulWidget {
  final Review review;
  const ReviewDashboard({super.key, required this.review});

  @override
  State<ReviewDashboard> createState() => _ReviewDashboardState();
}

class _ReviewDashboardState extends State<ReviewDashboard> {
  final PageController _pageController = PageController();
  late AppThemeProvider wizardState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
  }

  @override
  dispose() {
    _pageController.dispose();
    Jks.canEditReview = "canEditReview";
    Jks.reviewState.seteditingReview(null, quiet: true);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Jks.reglerpayment = reglerpayment;
  }

  void previewReview() async {
    context.push('/preview/review/${widget.review.id}', extra: widget.review);
  }

  void signReview() async {
    context.push('/preview/review/${widget.review.id}', extra: widget.review);
  }

  void reglerpayment(
    BuildContext context,
    AppThemeProvider wizardState,
    ReviewProvider reviewState,
    Review thereview, {
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) {
    showpayementIntentDialog(
      context,
      dialogTitle: 'Utiliser un crédit État des Lieux simple ?'.tr,
      dialogDescription:
          'Vous allez pouvoir procéder à la signature de votre état des lieux en utilisant un crédit état des lieux.'
              .tr,
      balence: wizardState.currentUser.balance?.simple ?? 0,
      source: "reviewcreated",
      onConfirmed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        if (onSuccess != null) {
          onSuccess();
        }
      },
      onConsumption: () {
        if (Jks.isNetworkAvailable == false) {
          Jks.languageState.showAppNotification(
            title: "Pas de connexion Internet".tr,
            message: "Vérifiez votre connexion Internet et réessayez.".tr,
          );
          return;
        }
        Jks.paymentState
            .useOneCredit({
              'type': "review",
              "review_id": wizardState.formValues['review_id'] ?? thereview.id,
            })
            .then((val) {
              Jks.languageState.showAppNotification(
                message: "Etat des lieux réglé avec succès".tr,
                title: "Succès".tr,
              );
              var newpro = thereview.copyWith(credited: true);
              if (reviewState.reviews.isNotEmpty) {
                int index = reviewState.reviews.indexWhere(
                  (element) => element.id == thereview.id,
                );

                if (index != -1) {
                  reviewState.reviews[index] = newpro;

                  wizardState.prefillReview(newpro, quietly: true);
                }
              }
              reviewState.seteditingReview(newpro);

              Navigator.pop(context);
              if (onSuccess != null) {
                onSuccess();
              }
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();
    Jks.reviewState = reviewState;
    Jks.wizardState = wizardState;
    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);
    var thereview;
    try {
      thereview = (reviewState.reviews.isNotEmpty
          ? reviewState.reviews.firstWhereOrNull((element) {
              return element.id == widget.review.id ||
                  (element.localId != null &&
                      element.localId == widget.review.localId) ||
                  (element.localId != null &&
                      element.localId == widget.review.id);
            })
          : widget.review);
    } catch (e) {
      myprint("Error finding review in reviewState: $e");
      thereview = widget.review;
    }
    if (thereview == null) {
      return emptyReviewWidget(context);
    }
    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    if (reviewState.editingReview != null &&
        reviewState.editingReview!.status != "draft") {
      Jks.canEditReview = "${reviewState.editingReview!.status}";
    }
    var isTheAuthor = thereview.isTheAutor();
    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    // myprint(wizardState.reviewType);

    var moreOverviewData = [
      (
        "Informations générales".tr,
        "Cliquez pour renseigner l'adresse postale du logement mis en location."
            .tr,
        (thereview.propertyDetails?.surface != "" &&
                thereview.propertyDetails?.address != "")
            ? 2
            : 1,
        () {
          thereview = (reviewState.reviews.firstWhere(
            (element) =>
                element.id == widget.review.id ||
                element.localId == widget.review.localId ||
                element.localId == widget.review.id,
            orElse: () => widget.review,
          ));
          wizardState.prefillReview(thereview);
          reviewState.seteditingReview(thereview);

          context.push('/thegood/${thereview.id}', extra: thereview);
        },
        "Certains champs sont obligatoires".tr,
      ),
      (
        "Caractéristiques du logement".tr,
        "Cliquez pour renseigner le nombre de pièces, la superficie et les éléments de chauffage."
            .tr,
        (thereview.propertyDetails?.heatingType != null &&
                thereview.propertyDetails?.heatingMode != null &&
                thereview.propertyDetails?.hotWaterType != null &&
                thereview.propertyDetails?.hotWaterMode != null)
            ? 2
            : 1,
        () {
          thereview = reviewState.reviews.firstWhere(
            (element) =>
                element.id == widget.review.id ||
                element.localId == widget.review.localId ||
                element.localId == widget.review.id,
            orElse: () => widget.review,
          );
          wizardState.prefillReview(thereview);
          reviewState.seteditingReview(thereview);

          context.push('/complementary/${thereview.id}', extra: thereview);
        },
        "Certains champs ne sont pas renseignés".tr,
      ),
      (
        "État des pièces et éléments".tr,
        "Cliquez pour ajouter/modifier des pièces > et renseigner l'état des éléments et du mobilier."
            .tr,
        ((thereview.pieces ?? [])!.isNotEmpty &&
                thereview.pieces!.any(
                  (p) => (p.things != null && p.things!.isNotEmpty),
                ))
            ? 2
            : 0,
        () {
          thereview = reviewState.reviews.firstWhere(
            (element) =>
                element.id == widget.review.id ||
                element.localId == widget.review.localId ||
                element.localId == widget.review.id,
            orElse: () => widget.review,
          );
          thereview = thereview;

          reviewState.seteditingReview(
            thereview,
            source: "from inventory_of_piece",
          );
          wizardState.prefillReview(thereview);
          context.push('/reviewpieces/${thereview.id}', extra: thereview);
        },
        "Aucune pièce ajoutée".tr,
      ),
      (
        "Relevés de compteurs".tr,
        "Cliquez pour consigner les relevés de compteur (eau, gaz et/ou électricité)."
            .tr,
        ((thereview.compteurs ?? [])!.isNotEmpty) ? 2 : 0,
        () {
          thereview = reviewState.reviews.firstWhere(
            (element) =>
                element.id == widget.review.id ||
                element.localId == widget.review.localId ||
                element.localId == widget.review.id,
            orElse: () => widget.review,
          );
          reviewState.seteditingReview(thereview);
          wizardState.prefillReview(thereview);
          context.push('/comptors/${thereview.id}', extra: thereview);
        },
        "Aucun relevé de compteur saisi".tr,
      ),
      (
        "Clés".tr,
        "Cliquez pour dresser la liste des clés remises aux locataires.".tr,
        ((thereview.cledeportes ?? [])!.isNotEmpty) ? 2 : 0,
        () {
          thereview = reviewState.reviews.firstWhere(
            (element) =>
                element.id == widget.review.id ||
                element.localId == widget.review.localId ||
                element.localId == widget.review.id,
            orElse: () => widget.review,
          );
          reviewState.seteditingReview(thereview);
          wizardState.prefillReview(thereview);
          context.push('/keysreview/${thereview.id}', extra: thereview);
        },
        "Aucune clé saisie".tr,
      ),
      (
        "Signataires".tr,
        "Cliquez pour saisir les informations relatives aux signataires de l'état des"
            .tr,
        ((thereview.exitenants ?? [])!.isNotEmpty &&
                ((thereview.reviewType != "procuration" &&
                        thereview.exitenants!.isNotEmpty) ||
                    (thereview.reviewType == "procuration" &&
                        thereview.entrantenants!.isNotEmpty)) &&
                thereview.owners!.isNotEmpty)
            ? 2
            : 0,
        () {
          thereview = reviewState.reviews.firstWhere(
            (element) =>
                element.id == widget.review.id ||
                element.localId == widget.review.localId ||
                element.localId == widget.review.id,
            orElse: () => widget.review,
          );
          reviewState.seteditingReview(thereview);
          wizardState.prefillReview(thereview);
          context.push(
            '/signataire-inventory/${thereview.id}',
            extra: thereview,
          );
        },
        "Aucun signataire saisi".tr,
      ),
      (
        "Informations complémentaires".tr,
        "Cliquez pour renseigner la nouvelle adresse du locataire, les commentaires et les informations complémentaires."
            .tr,
        (((thereview.meta) != null &&
                thereview.meta!["security_smoke"] != null &&
                thereview.meta!["security_smoke"] != "" &&
                ((thereview.procuration != null ||
                        thereview.reviewType == "exit")
                    ? checksortantnewaddress(thereview)
                    : true)))
            ? 2
            : 1,
        () {
          thereview = reviewState.reviews.firstWhere(
            (element) =>
                element.id == widget.review.id ||
                element.localId == widget.review.localId ||
                element.localId == widget.review.id,
            orElse: () => widget.review,
          );
          wizardState.prefillReview(thereview);
          reviewState.seteditingReview(thereview);

          context.push(
            '/srtoantlocataireaddress/${thereview.id}',
            extra: {"review": thereview, "procuration": null},
          );
        },
        "Certains champs sont obligatoires".tr,
      ),
    ];

    // return InAppWebView(
    //     initialUrlRequest: URLRequest(
    //   url: WebUri(
    //       'file:///storage/emulated/0/Android/data/com.jatai.mon_etatsdeslieux/files/sortant_pdfPath.pdf'),
    // ));

    return Consumer<AppThemeProvider>(
      builder: (context, lang, child) {
        Jks.context = context;

        double percentPoint = !Jks.isNetworkAvailable
            ? 1
            : ((double.tryParse(
                        "${(reviewState.editingReview?.meta ?? {})!["fillingPercentage"]}",
                      ) ??
                      0) /
                  100);
        return Scaffold(
          backgroundColor: isDark ? black : white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backbutton(() {
                    context.popRoute();
                  }),
                  if (thereview.status != "completed")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          !Jks.isNetworkAvailable
                              ? "Progression non disponible en mode hors ligne"
                              : percentPoint == 0.0
                              ? "Vous n'avez pas encore commencé l'état des lieux"
                                    .tr
                                    .capitalizeFirstLetter()
                              : percentPoint < 0.5
                              ? "Vous avez remplié moins de la moitié de l'état des lieux, il vous reste encore beaucoup à faire"
                                    .tr
                                    .capitalizeFirstLetter()
                              : "Vous y etes presque il ne vous reste que quelques détails à compléter "
                                    .tr
                                    .capitalizeFirstLetter(),
                          style: _theme.textTheme.bodyMedium?.copyWith(),
                        ),
                        15.height,
                        LinearProgressIndicator(value: percentPoint),
                        10.height,
                        !Jks.isNetworkAvailable
                            ? SizedBox.shrink()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  1.width,
                                  Text(
                                    "${percentPoint * 100 ~/ 1}% réalisé".tr
                                        .capitalizeFirstLetter(),
                                    style: _theme.textTheme.bodyMedium
                                        ?.copyWith(),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  20.height,
                  Text(
                    "Votre etat des lieux".tr.capitalizeFirstLetter(),
                    style: _theme.textTheme.titleLarge?.copyWith(fontSize: 30),
                  ),
                  10.height,
                  Text(
                    "${thereview.propertyDetails?.address}",
                    style: _theme.textTheme.titleLarge?.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${thereview.propertyDetails?.complement}",
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  20.height,
                  if (thereview.credited == false &&
                      reviewState.editingReview?.credited == false)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xffFF8C08).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xffFF8C08),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 20,
                                    color: const Color(0xffFF8C08),
                                  ),
                                  8.width,
                                  Expanded(
                                    child: RichTextWidget(
                                      list: [
                                        TextSpan(
                                          text: "En attente de règlement".tr,
                                          style: _theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: const Color(0xffFF8C08),
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ), //hint text
                              12.height,
                              Text(
                                "Reglez votre état des lieux pour le signer et le rendre actif."
                                    .tr
                                    .capitalizeFirstLetter(),
                                style: _theme.textTheme.bodyMedium?.copyWith(
                                  color: _theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: reviewState.isLoading
                                    ? null
                                    : () {
                                        reglerpayment(
                                          context,
                                          wizardState,
                                          reviewState,
                                          thereview,
                                        );
                                      },
                                icon: reviewState.isLoading
                                    ? SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: _theme.colorScheme.onPrimary,
                                        ),
                                      )
                                    : Icon(
                                        Icons.payment,
                                        size: 16,
                                        color: _theme.colorScheme.onPrimary,
                                      ),
                                label: Text(
                                  "Régler maintenant".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _theme.colorScheme.onPrimary,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _theme.colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  minimumSize: const Size(100, 30),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  20.height,
                  Column(
                    children: List.generate(moreOverviewData.length, (index) {
                      final _data = moreOverviewData[index];

                      Color theColor;
                      IconData theIcon;
                      if (thereview.status == "completed") {
                        theColor = const Color(0xff03BB9A);
                        theIcon = Icons.check_circle;
                      } else {
                        switch (_data.$3) {
                          case 1:
                            theColor = const Color(0xffFF8C08);
                            theIcon = Icons.warning;
                            break;
                          case 2:
                            theColor = const Color(0xff03BB9A);
                            theIcon = Icons.check_circle;

                            break;
                          default:
                            theColor = const Color(0xffFF5A58);
                            theIcon = Icons.stop_circle;
                        }
                      }

                      return Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: 0,
                          start: _mqSize.width < 992 ? 6 : _padding / 2.5,
                          end: _mqSize.width < 992 ? 6 : _padding / 2.5,
                        ),
                        child: BorderOverviewCard(
                          onTap: _data.$4,
                          iconPath: Icon(theIcon, color: theColor),
                          border: Border(
                            left: BorderSide(color: theColor, width: 6),
                          ),
                          title: Text(
                            _data.$1,
                            style: _theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            _data.$2.tr,
                            style: _theme.textTheme.bodyMedium?.copyWith(),
                          ),
                          error: _data.$3 != 2
                              ? Text(
                                  _data.$5,
                                  style: _theme.textTheme.bodyMedium?.copyWith(
                                    color: theColor,
                                  ),
                                )
                              : null,
                          cardType: BorderOverviewCardType.horizontal,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isTheAuthor)
                  IconButton(
                    onPressed: reviewState.isLoading
                        ? null
                        : () async {
                            final confirmed = await showAwesomeConfirmDialog(
                              context: context,
                              title: "Supprimer l'état des lieux".tr,
                              description:
                                  'êtes-vous sûr de vouloir supprimer cet état des lieux ? Cette action est irréversible.'
                                      .tr,
                            );
                            if (confirmed ?? false) {
                              await reviewState.deleteTheReview(thereview);
                              if ("${widget.review.source}".contains("saved")) {
                                Jks.context!.pushReplacement('/');
                              } else {
                                Jks.checkingAuth = false;
                                Jks.context!.go('/');
                              }
                            }
                          },
                    icon: reviewState.isLoading
                        ? SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              color: _theme.colorScheme.primary,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(Icons.delete, color: _theme.colorScheme.primary),
                  ),
                1.width,
                const Spacer(),
                if (thereview.status == "completed") ...[
                  Tooltip(
                    message: "Partager et voir l'état des lieux".tr,
                    child: IconButton(
                      onPressed: () {
                        shareLinkData(
                          context,
                          "${AppConfig.simplebaseUrl}/etat-des-lieux/${thereview.id}",
                          subject: "Partager l'état des lieux".tr,
                          message: "Voici le lien de l'état des lieux".tr,
                        );
                      },
                      icon: wizardState.loading
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                color: AcnooAppColors.kWhiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              Icons.share,
                              color: _theme.colorScheme.primary,
                            ),
                    ),
                  ),
                  20.width,
                ],
                Tooltip(
                  message:
                      (percentPoint > .5 ||
                                  thereview.status == "completed" ||
                                  !Jks.isNetworkAvailable
                              ? ""
                              : "Vous devez remplir au moins 50% de l'état des lieux pour le prévisualiser et le signer")
                          .tr,
                  child: ElevatedButton.icon(
                    onPressed:
                        percentPoint > .5 ||
                            thereview.status == "completed" ||
                            !Jks.isNetworkAvailable
                        ? () async {
                            reviewState.seteditingReview(thereview);

                            reviewState.previewThereview(thereview);

                            previewReview();
                          }
                        : null,
                    icon: wizardState.loading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              color: AcnooAppColors.kWhiteColor,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            thereview.status == "completed"
                                ? Icons.remove_red_eye_rounded
                                : Icons.fingerprint_rounded,
                            color: _theme.colorScheme.onPrimary,
                          ),
                    label: Text(
                      thereview.status == "completed"
                          ? "Voir".tr
                          : "Prévisualiser et signer".tr,
                    ),
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

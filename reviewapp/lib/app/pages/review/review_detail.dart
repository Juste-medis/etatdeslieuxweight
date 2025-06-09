import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/pages/review/overview_card.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:provider/provider.dart';

import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/_app_colors.dart';
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
    super.dispose();
  }

  void previewReview() async {
    context.push(
      '/preview/review/${widget.review.id}',
      extra: widget.review,
    );
  }

  void signReview() async {
    context.push(
      '/preview/review/${widget.review.id}',
      extra: widget.review,
    );
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();
    Jks.reviewState = reviewState;

    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);
    var review = reviewState.reviews
        .firstWhere((element) => element.id == widget.review.id);

    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    if (reviewState.editingReview!.status != "draft") {
      // Jks.canEditReview = "${reviewState.editingReview!.status}";
    }
    // myprint(wizardState.inventoryLocatairesSortant);
    // myprint(wizardState.inventoryLocatairesEntrants);

    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    var moreOverviewData = [
      (
        "Informations générales".tr,
        "Cliquez pour renseigner l'adresse postale du logement mis en location."
            .tr,
        (review.propertyDetails?.surface != "" &&
                review.propertyDetails?.address != "")
            ? 2
            : 1,
        () {
          review = reviewState.reviews
              .firstWhere((element) => element.id == widget.review.id);
          wizardState.prefillReview(
            review,
          );
          reviewState.seteditingReview(review);

          context.push(
            '/thegood/${review.id}',
            extra: review,
          );
        },
        "Certains champs sont obligatoires".tr,
      ),
      (
        "Caractéristiques du logement".tr,
        "Cliquez pour renseigner le nombre de pièces, la superficie et les éléments de chauffage."
            .tr,
        (review.meta!["heatingType"] != null &&
                review.meta!["heatingMode"] != null)
            ? 2
            : 1,
        () {
          review = reviewState.reviews
              .firstWhere((element) => element.id == widget.review.id);
          wizardState.prefillReview(
            review,
          );
          reviewState.seteditingReview(review);

          context.push(
            '/complementary/${review.id}',
            extra: review,
          );
        },
        "Certains champs ne sont pas renseignés".tr,
      ),
      (
        "État des pièces et éléments".tr,
        "Cliquez pour ajouter/modifier des pièces > et renseigner l'état des éléments et du mobilier."
            .tr,
        (review.pieces!.isNotEmpty) ? 2 : 0,
        () {
          review = reviewState.reviews
              .firstWhere((element) => element.id == widget.review.id);

          reviewState.seteditingReview(review);
          wizardState.prefillReview(
            review,
          );
          context.push(
            '/reviewpieces/${review.id}',
            extra: review,
          );
        },
        "Aucune pièce ajoutée".tr,
      ),
      (
        "Relevés de compteurs".tr,
        "Cliquez pour consigner les relevés de compteur (eau, gaz et/ou électricité)."
            .tr,
        (review.compteurs!.isNotEmpty) ? 2 : 0,
        () {
          review = reviewState.reviews
              .firstWhere((element) => element.id == widget.review.id);
          reviewState.seteditingReview(review);
          wizardState.prefillReview(
            review,
          );
          context.push(
            '/comptors/${review.id}',
            extra: review,
          );
        },
        "Aucun relevé de compteur saisi".tr,
      ),
      (
        "Clés".tr,
        "Cliquez pour dresser la liste des clés remises aux locataires.".tr,
        (review.cledeportes!.isNotEmpty) ? 2 : 0,
        () {
          review = reviewState.reviews
              .firstWhere((element) => element.id == widget.review.id);
          reviewState.seteditingReview(review);
          wizardState.prefillReview(
            review,
          );
          context.push(
            '/keysreview/${review.id}',
            extra: review,
          );
        },
        "Aucune clé saisie".tr,
      ),
      (
        "Signataires".tr,
        "Cliquez pour saisir les informations relatives aux signataires de l'état des"
            .tr,
        (review.exitenants!.isNotEmpty &&
                ((review.reviewType != "procuration" &&
                        review.exitenants!.isNotEmpty) ||
                    (review.reviewType == "procuration" &&
                        review.entrantenants!.isNotEmpty)) &&
                review.owners!.isNotEmpty)
            ? 2
            : 0,
        () {
          review = reviewState.reviews
              .firstWhere((element) => element.id == widget.review.id);
          reviewState.seteditingReview(review);
          wizardState.prefillReview(
            review,
          );
          context.push(
            '/signataire-inventory/${review.id}',
            extra: review,
          );
        },
        "Aucun signataire saisi".tr,
      ),
      (
        "Informations complémentaires".tr,
        "Cliquez pour renseigner la nouvelle adresse du locataire, les commentaires et les informations complémentaires."
            .tr,
        (review.meta!["tenant_new_address"] != null &&
                review.meta!["tenant_new_address"] != "")
            ? 2
            : 1,
        () {
          review = reviewState.reviews
              .firstWhere((element) => element.id == widget.review.id);
          wizardState.prefillReview(
            review,
          );
          reviewState.seteditingReview(review);

          context.push(
            '/srtoantlocataireaddress/${review.id}',
            extra: review,
          );
        },
        "Certains champs sont obligatoires".tr,
      ),
    ];

    return Consumer<AppThemeProvider>(
      builder: (context, lang, child) {
        Jks.context = context;

        double percentPoint = (double.tryParse(
                    "${reviewState.editingReview?.meta!["fillingPercentage"]}") ??
                0) /
            100;
        return Scaffold(
          backgroundColor: isDark ? black : white,
          body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            backbutton(() => {context.popRoute()}),
                            Text(
                              percentPoint == 0.0
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
                            LinearProgressIndicator(
                              value: percentPoint,
                            ),
                            10.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                1.width,
                                Text(
                                  "${percentPoint * 100 ~/ 1}% réalisé"
                                      .tr
                                      .capitalizeFirstLetter(),
                                  style:
                                      _theme.textTheme.bodyMedium?.copyWith(),
                                )
                              ],
                            ),
                            20.height,
                            Text(
                              "Votre etat des lieux".tr.capitalizeFirstLetter(),
                              style: _theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Détails et informations sur l'état des lieux".tr,
                              style: _theme.textTheme.labelLarge?.copyWith(
                                color: _theme.colorScheme.onSurface,
                              ),
                            ),
                            20.height,
                          ],
                        ),
                        Column(
                          children:
                              List.generate(moreOverviewData.length, (index) {
                            final _data = moreOverviewData[index];

                            Color theColor;
                            IconData theIcon;
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

                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                top: 0,
                                start: _mqSize.width < 992 ? 6 : _padding / 2.5,
                                end: _mqSize.width < 992 ? 6 : _padding / 2.5,
                              ),
                              child: BorderOverviewCard(
                                onTap: _data.$4,
                                iconPath: Icon(
                                  theIcon,
                                  color: theColor,
                                ),
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
                                  style:
                                      _theme.textTheme.bodyMedium?.copyWith(),
                                ),
                                error: _data.$3 != 2
                                    ? Text(
                                        _data.$5,
                                        style: _theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: _data.$3 == 0
                                              ? Colors.red
                                              : _data.$3 == 1
                                                  ? Colors.amber
                                                  : Colors.green,
                                        ),
                                      )
                                    : null,
                                cardType: BorderOverviewCardType.horizontal,
                              ),
                            );
                          }),
                        )
                      ]))),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                1.width,
                const Spacer(),
                Tooltip(
                  message: (percentPoint > .5
                          ? "Vous pouvez prévisualiser et signer l'état des lieux"
                          : "Vous devez remplir au moins 50% de l'état des lieux pour le prévisualiser et le signer")
                      .tr,
                  child: ElevatedButton.icon(
                    onPressed: percentPoint > .5
                        ? () {
                            reviewState.previewThereview(review);
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
                        : Icon(Icons.fingerprint_rounded,
                            color: _theme.colorScheme.onPrimary),
                    label: Text("Prévisualiser et signer".tr),
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

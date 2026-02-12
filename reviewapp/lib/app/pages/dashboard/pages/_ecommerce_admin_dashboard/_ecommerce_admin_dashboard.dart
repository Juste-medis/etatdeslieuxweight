// 🐦 Flutter imports:

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:go_router/go_router.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/pages/proccuration/proccuration_detail.dart';
import 'package:mon_etatsdeslieux/app/providers/_payment_provider.dart';
import 'package:mon_etatsdeslieux/app/providers/_proccuration_provider.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ECommerceAdminDashboardView extends StatefulWidget {
  final String? url;
  const ECommerceAdminDashboardView({super.key, this.url});

  @override
  State<ECommerceAdminDashboardView> createState() =>
      _ECommerceAdminDashboardViewState();
}

class _ECommerceAdminDashboardViewState
    extends State<ECommerceAdminDashboardView> {
  late AppThemeProvider wizardState;
  late ReviewProvider reviewstate;
  late ProccurationProvider proccurationstate;
  late PaymentProvider paymentProvider;

  final codeformekey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getReviews();
    Jks.canEditReview = "canEditReview";
    if (widget.url != null) {
      myprint("PreviewFrontReview URL: ${widget.url}");

      commonLaunchUrl(widget.url!, launchMode: LaunchMode.externalApplication);
    }
  }

  void getReviews() async {
    await Future.delayed(const Duration(seconds: 1));

    reviewstate.fetchReviews(refresh: true);
    Jks.reviewState = reviewstate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
    reviewstate = context.watch<ReviewProvider>();
    proccurationstate = context.watch<ProccurationProvider>();
    paymentProvider = context.watch<PaymentProvider>();
  }

  void initDocumentState() {
    wizardState.isAuthenticated(quiet: true);
    Jks.proccurationState.seteditingProcuration(
      null,
      quiet: true,
      source: 'init',
    );
    Jks.paymentState.paymentMade = "";
    paymentProvider.paymentMade = "";
    Jks.reviewState.seteditingReview(null, quiet: true, source: "init");
    Jks.savereviewStep = () async {};
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _lang = l.S.of(context);
    Jks.context = context;

    Jks.reviewState = reviewstate;
    Jks.wizardState = wizardState;
    Jks.proccurationState = proccurationstate;
    Jks.paymentState = paymentProvider;

    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);
    final _buttonTextStyle = _theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              _lang.welcome,
              style: _theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              _lang.delegateedl,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: _theme.textTheme.labelLarge?.copyWith(
                // color: isHovering ? Colors.white : null,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // _setupNotificationHandler();
                // _testNotification();
                Jks.context = context;
                initDocumentState();
                context.push('/startprocuration');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _theme.colorScheme.primary,
                foregroundColor: _theme.colorScheme.onPrimary,
                shadowColor: Colors.transparent,
                elevation: 0,
                textStyle: _buttonTextStyle,
                padding: EdgeInsets.all(isSmallScreen ? 14 : 15),
              ),
              child: Text(
                "Créer les procurations et l'accès locataire",
                style: _theme.textTheme.titleLarge?.copyWith(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: _theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            20.height,
            Text(
              _lang.selfreview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: _theme.textTheme.labelLarge?.copyWith(
                // color: isHovering ? Colors.white : null,
              ),
            ),

            20.height,

            ElevatedButton(
              onPressed: () async {
                final wizardState = Provider.of<AppThemeProvider>(
                  context,
                  listen: false,
                );

                final result = await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return const SelectReviewType();
                  },
                );
                if (result == null) {
                  return;
                }
                Jks.context = context;
                initDocumentState();
                wizardState.initialiseReview(result);

                context.push('/startreview', extra: result);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _theme.colorScheme.primary,
                foregroundColor: _theme.colorScheme.onPrimary,
                shadowColor: Colors.transparent,
                elevation: 0,
                textStyle: _buttonTextStyle,
                padding: EdgeInsets.all(isSmallScreen ? 14 : 15),
              ),
              child: Text(
                _lang.createinventoryreport,
                style: _theme.textTheme.titleLarge?.copyWith(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: _theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // TextButton.icon(
            //     onPressed: () async {
            //       copyDataToClipboard(null);
            //     },
            //     label: Text(
            //       "copier log".tr,
            //       style: _theme.textTheme.bodyMedium?.copyWith(
            //         decoration: TextDecoration.underline,
            //         fontWeight: FontWeight.w600,
            //         color: _theme.colorScheme.primary,
            //       ),
            //     )),
            10.height,

            // Reviews List Section
            const SizedBox(height: 15),

            Text(
              "Vos états des lieux",
              style: _theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                if (reviewstate.reviews.isEmpty)
                  buildReviewEmptyState(_theme)
                else
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: Column(
                        children: reviewstate.reviews
                            .asMap()
                            .entries
                            .map(
                              (entry) => ReviewCard(
                                review: entry.value,
                                key: ValueKey(
                                  "${entry.value.id}_card${entry.key}",
                                ),
                                index: entry.key,
                                onTap: () =>
                                    handleReviewTap(context, entry.value),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                if (reviewstate.isLoading)
                  Positioned.fill(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Container(
                        color: _theme.colorScheme.primaryContainer.withAlpha(
                          150,
                        ),
                        child: const Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 4,
                            width: double.infinity,
                            child: LinearProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ),
                10.height,
              ],
            ),

            10.height,
            // voir plus button
            if (reviewstate.totalPages > reviewstate.currentPage)
              inventoryAddButton(
                context,
                title: "Voir plus".tr,
                icon: Icons.refresh,
                onPressed: () async {
                  context.go('/reviews/all');
                },
              ).paddingOnly(bottom: 10).center(),
          ],
        ).paddingSymmetric(vertical: _padding, horizontal: _padding),
      ),
    );
  }
}

Widget buildReviewEmptyState(ThemeData theme) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.list_alt, size: 48, color: theme.colorScheme.outline),
        const SizedBox(height: 16),
        Text(
          "Vous n'avez pas encore d'états des lieux".tr,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Créez votre premier état des lieux pour commencer.".tr,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    ).center(),
  );
}

void handleReviewTap(BuildContext context, Review review) {
  final reviewState = context.read<ReviewProvider>();
  reviewState.seteditingReview(review, source: "taptap");

  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    backgroundColor: context.theme.colorScheme.primaryContainer,
    context: context,
    builder: (context) => Wrap(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.propertyDetails?.address ?? "Adresse non spécifiée",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                review.propertyDetails?.complement ?? " ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          subtitle: Text(
            'Que souhaitez-vous faire ?',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ).paddingTop(16),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: const Icon(Icons.edit),
          title: Text(
            (review.canModify())
                ? (review.meta?["signaturesMeta"] != null &&
                          review.meta?["signaturesMeta"]?["allSigned"] == true)
                      ? "Voir"
                      : "Modifier"
                : "Voir",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            'Modifier l\'état des lieux. Assurez-vous de sauvegarder vos modifications.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {
            final wizardState = context.read<AppThemeProvider>();
            wizardState.prefillReview(review);
            Navigator.pop(context);

            context.push('/review/${review.id}', extra: review);
          },
        ),
        if (review.isTheAutor())
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: const Icon(Icons.delete_outline),
            title: Text(
              'Supprimer',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              'Supprimer l\'état des lieux. Cette action est irréversible.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () async {
              final confirmed = await showAwesomeConfirmDialog(
                context: context,
                title: "Supprimer l'état des lieux".tr,
                description:
                    "Êtes-vous sûr de vouloir supprimer cet état des lieux ?"
                        .tr,
              );
              if (confirmed ?? false) {
                final deletion = await reviewState.deleteTheReview(review);
                if (deletion) {
                  simulateRightCenterTap(context);
                  Jks.languageState.showAppNotification(
                    title: "Suppression réussie".tr,
                    message: "État des lieux supprimé avec succès".tr,
                  );
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
      ],
    ),
  );
}

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onTap;
  final int index;
  final String from;

  const ReviewCard({
    super.key,
    required this.review,
    required this.onTap,
    this.from = "dashboard",
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<AppThemeProvider>();
    final theme = Theme.of(context);
    // return Text("${review?.id}  ${Jks.reviewState.reviews.length} ");
    return Container(
      key: ValueKey(review.id),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: wizardState.isDarkTheme
            ? theme.colorScheme.onSecondary
            : from == "dashboard"
            ? theme.colorScheme.onPrimary
            : white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(
              from == "dashboard" ? 60 : 70,
            ),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (DateTime.now()
                      .difference(review.createdAt ?? DateTime.now())
                      .inMinutes <
                  30)
                SizedBox(
                  height: 22,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: theme.colorScheme.primary,
                          ),
                          child: Text(
                            "Nouveau".tr.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primaryContainer,
                              fontWeight: FontWeight.w600,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    review.reviewType == 'entrance'
                        ? Icons.login
                        : Icons.logout,
                    color: theme.colorScheme.primary,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: onTap,
                  ),
                ],
              ),
              Text(
                review.procuration != null
                    ? "Entrée/Sortie".tr
                    : (review.reviewType == 'entrance'
                          ? "Entrée".tr
                          : "Sortie".tr),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              5.height,
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        theme,
                        review.status,
                      ).withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      getStatusText(review.status ?? 'Brouillon').toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(theme, review.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (review.status != 'completed')
                    Text(
                      review.meta?["fillingPercentage"] != null
                          ? "${review.meta?["fillingPercentage"]}%"
                          : "En cours",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              if (review.procuration == null) const SizedBox(height: 12),
              Text(
                review.propertyDetails?.address ?? "Adresse non spécifiée",
                style: theme.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat(
                  'dd MMM yyyy',
                ).format(review.createdAt ?? DateTime.now()),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (review.procuration != null) const SizedBox(height: 12),
              if (review.procuration != null)
                RichTextWidget(
                  list: [
                    TextSpan(
                      text:
                          "Par procuration ${review.procuration?.author?.lastName != null ? " de " : ""}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: review.procuration?.author?.lastName != null
                          ? " :  ${review.procuration?.author?.firstName} ${review.procuration?.author?.lastName}"
                          : "",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return UserInfoDialog(
                                user: InventoryAuthor.fromUser(
                                  review.procuration?.author,
                                ),
                                proccuration: review.procuration,
                              );
                            },
                          );
                        },
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ThemeData theme, String? status) {
    switch ((status ?? "draft").toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'signing':
        return Colors.orange;
      case 'draft':
        return theme.brightness == Brightness.dark
            ? Colors.white70
            : Colors.grey;
      default:
        return theme.colorScheme.primary;
    }
  }
}

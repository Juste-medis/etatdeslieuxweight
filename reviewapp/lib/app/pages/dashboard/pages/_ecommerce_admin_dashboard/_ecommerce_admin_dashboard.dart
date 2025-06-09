// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ECommerceAdminDashboardView extends StatefulWidget {
  const ECommerceAdminDashboardView({super.key});

  @override
  State<ECommerceAdminDashboardView> createState() =>
      _ECommerceAdminDashboardViewState();
}

class _ECommerceAdminDashboardViewState
    extends State<ECommerceAdminDashboardView> {
  late AppThemeProvider wizardState;
  late ReviewProvider reviewstate;
  final codeformekey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getReviews();
    Jks.canEditReview = "canEditReview";
  }

  void getReviews() async {
    await Future.delayed(const Duration(seconds: 1));

    reviewstate.fetchReviews();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    wizardState = context.watch<AppThemeProvider>();
    reviewstate = context.watch<ReviewProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _lang = l.S.of(context);
    Jks.context = context;

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );
    final _buttonTextStyle = _theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
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
                Jks.context = context;
                wizardState.initialiseProcuration("procuration");

                context.push(
                  '/startprocuration',
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme.colorScheme.primary,
                  foregroundColor: _theme.colorScheme.onPrimary,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  textStyle: _buttonTextStyle,
                  padding: const EdgeInsets.all(15)),
              child: Text(
                "Créer les procurations et l'accès locataire",
                style: _theme.textTheme.titleLarge?.copyWith(
                    fontSize: 14, color: _theme.colorScheme.onPrimary),
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

            // Positioned(
            //           top: 60,
            //           right: 100,
            //           child: CustomPopover(
            //             direction: PopoverDirection.right,
            //             elevation: 0,
            //             popoverContent: Container(
            //               width: 100,
            //               child: Stack(clipBehavior: Clip.none, children: [
            //                 Positioned(
            //                   top: -30,
            //                   left: -43,
            //                   child: Icon(Icons.arrow_left_outlined,
            //                       size: 50, color: whiteColor),
            //                 ),
            //                 Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     Text(
            //                       "Vous pouvez signer l'état des lieux une fois que vous avez vérifié les informations."
            //                           .tr,
            //                       style: theme.textTheme.bodyMedium?.copyWith(
            //                         color: theme.colorScheme.onSurface.withOpacity(0.8),
            //                       ),
            //                     ).paddingAll(10),
            //                   ],
            //                 )
            //               ]),
            //             ),
            //             child: Icon(Icons.info_outline,
            //                 size: 20, color: theme.colorScheme.onSurface),
            //           ),
            //         ),
            20.height,

            ElevatedButton(
              onPressed: () async {
                final wizardState =
                    Provider.of<AppThemeProvider>(context, listen: false);

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
                wizardState.initialiseReview(result);

                context.push('/startreview', extra: result);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: _theme.colorScheme.primary,
                  foregroundColor: _theme.colorScheme.onPrimary,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  textStyle: _buttonTextStyle,
                  padding: const EdgeInsets.all(15)),
              child: Text(
                _lang.createinventoryreport,
                style: _theme.textTheme.titleLarge?.copyWith(
                    fontSize: 14, color: _theme.colorScheme.onPrimary),
              ),
            ),
            30.height,

            // Reviews List Section
            const SizedBox(height: 15),
            Text(
              "Vos états des lieux",
              style: _theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            if (reviewstate.reviews.isEmpty)
              _buildEmptyState(_theme, _lang)
            else
              SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false,
                      ),
                      child: Column(
                        children: reviewstate.reviews
                            .map(
                              (review) => _ReviewCard(
                                review: review,
                                onTap: () => _handleReviewTap(context, review),
                              ),
                            )
                            .toList(),
                      )))
          ],
        ).paddingSymmetric(
          vertical: _padding,
          horizontal: _padding,
        ),
      ),
    );
  }
}

Widget _buildEmptyState(ThemeData theme, l.S lang) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    ),
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

void _handleReviewTap(BuildContext context, Review review) {
  final reviewState = context.read<ReviewProvider>();
  reviewState.seteditingReview(review);

  showModalBottomSheet(
    context: context,
    builder: (context) => Wrap(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            review.propertyDetails!.address!,
            style: Theme.of(context).textTheme.titleLarge,
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
              '${(review.canModify()) ? "Modifier" : "Voir"} ${review.isThegrantedAcces() ? "(En tant que mandataire)" : ""} ',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          subtitle: Text(
            'Modifier l\'état des lieux. Assurez-vous de sauvegarder vos modifications.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {
            final wizardState = context.read<AppThemeProvider>();
            wizardState.prefillReview(
              review,
            );
            Navigator.pop(context);

            context.push(
              '/review/${review.id}',
              extra: review,
            );
          },
        ),
        ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: const Icon(Icons.delete_outline),
            title: Text('Supprimer',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            subtitle: Text(
              'Supprimer l\'état des lieux. Cette action est irréversible.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              Navigator.pop(context);
              showConfirmDialog(
                context,
                "Êtes-vous sûr de vouloir supprimer cet état des lieux ?".tr,
                onAccept: () async {
                  await deleteReview(review.id);
                  reviewState.seteditingReview(null, quiet: true);

                  reviewState.reviews.removeWhere((r) => r.id == review.id);
                  reviewState.notifyListeners();
                  show_common_toast(
                      "État des lieux supprimé avec succès".tr, context);
                },
              );
            }),
      ],
    ),
  );
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onTap;

  const _ReviewCard({required this.review, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final wizardState = context.watch<AppThemeProvider>();
    final theme = Theme.of(context);

    return Card(
      key: ValueKey(review.id),
      margin: const EdgeInsets.only(bottom: 10),
      color: wizardState.isDarkTheme
          ? theme.colorScheme.onSecondary
          : theme.colorScheme.onPrimary,
      elevation: 6,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    icon:
                        Icon(Icons.more_vert, color: theme.colorScheme.primary),
                    onPressed: onTap,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                review.reviewType == 'entrance' ? "Entrée".tr : "Sortie",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(theme, review.status).withOpacity(0.1),
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
              if (review.procuration == null) const SizedBox(height: 12),
              Text(
                review.propertyDetails!.address!,
                style: theme.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd MMM yyyy').format(review.createdAt!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (review.procuration != null) const SizedBox(height: 12),
              if (review.procuration != null)
                Text(
                  "Par procuration ${review.procuration?.author?.lastName != null ? "de :  ${review.procuration?.author?.firstName} ${review.procuration?.author?.lastName}" : ""}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600),
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
        return theme.colorScheme.outline;
      default:
        return theme.colorScheme.primary;
    }
  }
}

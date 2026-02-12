import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etadmin/app/core/helpers/fuctions/helper_functions.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/core/theme/theme.dart';
import 'package:jatai_etadmin/app/pages/pages.dart';
import 'package:jatai_etadmin/app/pages/proccuration/proccuration_detail.dart';
import 'package:jatai_etadmin/app/providers/_proccuration_provider.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';

class FinalizationView extends StatelessWidget {
  final AppThemeProvider wizardState;
  const FinalizationView({super.key, required this.wizardState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final proccurationState = context.watch<ProccurationProvider>();
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );

    var proc = proccurationState.editingProccuration;
    final isDark = theme.colorScheme.brightness == Brightness.dark;
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: wizardState.formKeys[WizardStep.values[8]],
                child: Padding(
                  padding: EdgeInsets.all(_padding / 2.75),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        20.height,
                        Text(
                          "Procuration terminée".tr.capitalizeFirstLetter(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        10.height,
                        if (proc != null)
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withAlpha(20)
                                      : Colors.grey.withAlpha(20),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              titleAlignment: ListTileTitleAlignment.center,
                              contentPadding: EdgeInsets.all(12),
                              onTap: () {
                                proc.setSource("saved");
                                seeProcuration(
                                    proccuration: proc, context: context);
                              },
                              minVerticalPadding: 0,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Text(
                                      "${proc.propertyDetails?.address}",
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Flexible(
                                      child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(0),
                                          ),
                                        ),
                                        builder: (context) => Wrap(
                                          children: [
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              title: Text(
                                                  proc.propertyDetails
                                                          ?.address ??
                                                      '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontSize: 18,
                                                      )),
                                              subtitle: Text(
                                                'Que souhaitez-vous faire ?',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ).paddingTop(12),
                                            ).paddingTop(16),
                                            if (proc.meta?["signaturesMeta"] !=
                                                    null &&
                                                proc.meta?["signaturesMeta"]
                                                        ?["allSigned"] ==
                                                    true)
                                              ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                leading: const Icon(Icons.edit),
                                                title: Text(
                                                    'Voir et télécharger la procuration',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                subtitle: Text(
                                                  'Télécharger la proccuration signée. Vous pouvez la prévisualiser avant de la télécharger.',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                onTap: () {
                                                  seeProcuration(
                                                      proccuration: proc,
                                                      context: context);
                                                },
                                              ),
                                            proccuration_action_sheet(
                                                title:
                                                    '${(proc.isTheAutor()) ? "Modifier" : "Voir et/ou signer "}  ',
                                                subtitle:
                                                    'Modifier l\'état des lieux. Assurez-vous de sauvegarder vos modifications.'
                                                        .tr,
                                                context: context,
                                                proccuration: proc,
                                                onTap: () {}),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.more_vert,
                                      size: 20,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                    padding: EdgeInsets.zero,
                                  )),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            getImageType(
                                                "assets/images/widget_images/entrantenant.svg",
                                                fit: BoxFit.cover,
                                                height: 20,
                                                width: 20,
                                                colorFilter: ColorFilter.mode(
                                                  isDark
                                                      ? Colors.grey.shade400
                                                      : AcnooAppColors
                                                          .kNeutral900,
                                                  BlendMode.srcIn,
                                                )),
                                            5.width,
                                            if (proc.entrantenants != null &&
                                                proc.entrantenants!.isNotEmpty)
                                              Text(
                                                "${authorname(proc.entrantenants![0])}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: isDark
                                                      ? Colors.grey.shade400
                                                      : Colors.grey.shade800,
                                                ),
                                              ),
                                          ],
                                        ).paddingOnly(right: 10, top: 4),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            getImageType(
                                                "assets/images/widget_images/exitenant.svg",
                                                fit: BoxFit.cover,
                                                height: 20,
                                                width: 20,
                                                colorFilter: ColorFilter.mode(
                                                  isDark
                                                      ? Colors.grey.shade400
                                                      : AcnooAppColors
                                                          .kNeutral900,
                                                  BlendMode.srcIn,
                                                )),
                                            5.width,
                                            if (proc.exitenants != null &&
                                                proc.exitenants!.isNotEmpty)
                                              Text(
                                                "${authorname(proc.exitenants![0])}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: isDark
                                                      ? Colors.grey.shade400
                                                      : Colors.grey.shade800,
                                                ),
                                              ),
                                            Spacer(),
                                          ],
                                        ).paddingOnly(top: 4, right: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        20.height,
                        Text(
                          "Merci d’avoir utilisé Jatai !"
                              .tr
                              .capitalizeFirstLetter(),
                          style: theme.textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        30.height,
                        inventoryAddButton(
                          context,
                          title: "Ok".tr,
                          icon: Icons.check_circle,
                          onPressed: () async {
                            Jks.reviewState.fetchReviews(refresh: true);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                        ).paddingOnly(bottom: 10).center(),
                      ],
                    ),
                  ),
                ))));
  }
}

import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/select_tile.dart';
import 'package:jatai_etadmin/app/providers/_proccuration_provider.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:jatai_etadmin/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etadmin/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/extensions/_build_context_extensions.dart';

class LocataireSortantAddress extends StatelessWidget {
  final Review? review;
  final Procuration? proccuration;
  const LocataireSortantAddress({super.key, this.review, this.proccuration});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    final reviewState = context.watch<ReviewProvider>();
    final proccurationState = context.watch<ProccurationProvider>();
    var thereview = review ?? proccurationState.editingProccuration;

    bool byprocuration = wizardState.reviewType == "procuration";
    if (thereview is Review) {
      byprocuration = (thereview.procuration != null);
    }

    var showfumal = thereview != null;
    if (showfumal) {
      showfumal = (!byprocuration || (!(review?.isTheAutor() ?? false)));
    }
    if (!byprocuration) {
      showfumal = true;
    }
    if (proccuration != null) {
      showfumal = false;
    }

    Jks.savereviewStep = () async {
      if (thereview != null) {
        try {
          if (wizardState.reviewType == "procuration") {
            var proc = thereview is Procuration
                ? thereview
                : Procuration.fromReview(thereview as Review);
            if (proc.source == 'new') return;

            wizardState.setloading(true);
            await proccurationState.updateTheproccuration(
              proc,
              "commentsection",
              wizardState: wizardState,
            );
          } else {
            wizardState.setloading(true);

            await reviewState.updateThereview(
              thereview as Review,
              "commentsection",
              wizardState: wizardState,
            );
          }

          wizardState.setloading(false);
        } catch (e) {
          my_inspect(e);
          show_common_toast(
              "Une erreur s'est produite, veuillez réessayer plus tard.".tr,
              context);
        }
      } else {}
    };
    final menuTitle = "${showfumal ? "Détecteur de fumée et " : ""}commentaire"
        .tr
        .capitalizeFirstLetter();
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primaryContainer,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: thereview != null
                      ? null
                      : wizardState.formKeys[WizardStep.values[4]],
                  child: ShadowContainer(
                    contentPadding: EdgeInsets.all(_padding / 2.75),
                    customHeader: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (review != null)
                          backbutton(() {
                            context.popRoute();
                          }, title: menuTitle)
                        else
                          Text(
                            menuTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        20.height,
                        if (showfumal) ...[
                          SelectGrid(
                            title: "Pésence de detecteur de fumée".tr,
                            entries: [
                              SelectionTile(
                                title: "Oui".tr,
                                isSelected:
                                    wizardState.formValues['security_smoke'] ==
                                        "yes",
                                onTap: () => wizardState.updateFormValue(
                                    'security_smoke', "yes"),
                              ),
                              SelectionTile(
                                title: "Non".tr,
                                isSelected:
                                    wizardState.formValues['security_smoke'] ==
                                        "no",
                                onTap: () => wizardState.updateFormValue(
                                    'security_smoke', "no"),
                              ),
                            ],
                          ),
                          if (wizardState.formValues['security_smoke'] ==
                              "yes") ...[
                            30.height,
                            editUserField(
                              title: "Fonctionnel ?".capitalizeFirstLetter(),
                              type: "select",
                              layout: 'simplerow',
                              items: yesnonotTested,
                              initialvalue: wizardState
                                  .formValues['security_smoke_functioning'],
                              onChanged: (text) {
                                wizardState.updateFormValue(
                                    'security_smoke_functioning', text);
                              },
                            ),
                          ],
                          20.height,
                          Divider(color: theme.dividerColor, height: 50),
                        ],
                        editUserField(
                          title: showfumal
                              ? "Commentaires/observations générales".tr
                              : "Instruction ou commentaire à destination des locataires"
                                  .tr,
                          type: "textarea",
                          minLines: 8,
                          initialvalue: wizardState.formValues['comments'],
                          placeholder:
                              "${_lang.enterThe} ${_lang.ownerfullname}",
                          onChanged: (text) {
                            wizardState.updateFormValue('comments', text);
                          },
                        ),
                      ],
                    ),
                  )))),
    );
  }
}

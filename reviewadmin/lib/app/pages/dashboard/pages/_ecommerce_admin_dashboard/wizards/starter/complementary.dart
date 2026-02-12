import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/providers/_proccuration_provider.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etadmin/generated/l10n.dart' as l;
import 'package:jatai_etadmin/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/theme/_app_colors.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';

class Complementary extends StatelessWidget {
  final Review? thereview;
  const Complementary({super.key, this.thereview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();
    final proccurationState = context.watch<ProccurationProvider>();
    final _lang = l.S.of(context);
    var review = reviewState.editingReview ??
        proccurationState.editingProccuration ??
        thereview;
    Jks.savereviewStep = () async {
      if (review != null) {
        try {
          wizardState.setloading(true);
          if (review is Review) {
            await reviewState.updateThereview(
              review,
              "complementary",
              wizardState: wizardState,
            );
          } else if (review is Procuration && review.source != 'new') {
            await proccurationState.updateTheproccuration(
              review,
              "complementary",
              wizardState: wizardState,
            );
          }

          wizardState.setloading(false);
        } catch (e) {
          show_common_toast(
              "Une erreur s'est produite, veuillez réessayer plus tard.".tr,
              context);
        }
      } else {}
    };

    return Scaffold(
      backgroundColor: review != null
          ? wizardState.isDarkTheme
              ? blackColor
              : whiteColor
          : null,
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
                      : wizardState.formKeys[WizardStep.values[3]],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      if (review != null)
                        backbutton(() => {context.popRoute()},
                            title: Text(
                              "Caractéristiques du logement"
                                  .capitalizeFirstLetter(),
                              style: theme.textTheme.titleLarge?.copyWith(),
                            ))
                      else
                        Text(
                          "Caractéristiques du logement"
                              .tr
                              .capitalizeFirstLetter(),
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),

                      // complementary information
                      20.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          editUserField(
                              title: _lang.heatingType,
                              initialvalue:
                                  wizardState.domaine.heatingType ?? "-",
                              placeholder:
                                  "${_lang.enterThe} ${_lang.heatingType}",
                              type: "select",
                              onChanged: (text) {
                                wizardState.domaine.heatingType = text;
                                wizardState.updateInventory(
                                  domaine: wizardState.domaine,
                                );
                              },
                              items: heatingTypes),
                          editUserField(
                            title: _lang.heatingMode,
                            type: "select",
                            items: heatingmODes,
                            initialvalue:
                                wizardState.domaine.heatingMode ?? "-",
                            placeholder:
                                "${_lang.enterThe} ${_lang.heatingMode}",
                            onChanged: (text) {
                              wizardState.domaine.heatingMode = text;
                              wizardState.updateInventory(
                                domaine: wizardState.domaine,
                              );
                            },
                          ),
                          editUserField(
                            title: _lang.hotWaterType,
                            type: "select",
                            initialvalue:
                                wizardState.domaine.hotWaterType ?? "-",
                            items: heatingTypes,
                            placeholder:
                                "${_lang.enterThe} ${_lang.hotWaterType}",
                            onChanged: (text) {
                              wizardState.domaine.hotWaterType = text;
                              wizardState.updateInventory(
                                domaine: wizardState.domaine,
                              );
                            },
                          ),
                          editUserField(
                            title: _lang.hotWaterMode,
                            type: "select",
                            items: heatingwatermODes,
                            initialvalue:
                                wizardState.domaine.hotWaterMode ?? "-",
                            placeholder:
                                "${_lang.enterThe} ${_lang.hotWaterMode}",
                            onChanged: (text) {
                              wizardState.domaine.hotWaterMode = text;
                              wizardState.updateInventory(
                                domaine: wizardState.domaine,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  )))),
    );
  }
}

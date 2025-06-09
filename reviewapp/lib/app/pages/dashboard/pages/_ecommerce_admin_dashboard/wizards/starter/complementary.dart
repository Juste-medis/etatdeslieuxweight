import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/_app_colors.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';

class Complementary extends StatelessWidget {
  final Review? review;
  const Complementary({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();
    final _lang = l.S.of(context);
    var review = reviewState.editingReview;
    Jks.savereviewStep = () async {
      if (review != null) {
        try {
          wizardState.setloading(true);
          await reviewState.updateThereview(
            review!,
            "complementary",
            wizardState: wizardState,
          );
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
      bottomNavigationBar: (review != null && wizardState.edited)
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: wizardState.loading ? null : Jks.savereviewStep,
                    icon: wizardState.loading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              color: AcnooAppColors.kWhiteColor,
                              strokeWidth: 2,
                            ),
                          )
                        : null,
                    label: Text("Enrégistrer les modifications".tr),
                  ),
                ],
              ),
            )
          : null,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: wizardState.formKeys[WizardStep.values[3]],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      if (review != null)
                        backbutton(() => {context.popRoute()},
                            title: Text(
                              _lang.additionalInfo.capitalizeFirstLetter(),
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ))
                      else
                        Text(
                          _lang.additionalInfo.capitalizeFirstLetter(),
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
                              initialvalue: review?.meta!['heatingType'],
                              placeholder:
                                  "${_lang.enterThe} ${_lang.heatingType}",
                              type: "select",
                              onChanged: (text) {
                                wizardState.updateFormValue(
                                    'complementary_heatingType', text);
                              },
                              items: heatingTypes),
                          editUserField(
                            title: _lang.heatingMode,
                            type: "select",
                            items: heatingmODes,
                            initialvalue: review?.meta!['heatingMode'],
                            placeholder:
                                "${_lang.enterThe} ${_lang.heatingMode}",
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'complementary_heatingMode', text);
                            },
                          ),
                          editUserField(
                            title: _lang.hotWaterType,
                            type: "select",
                            initialvalue: review?.meta!['hotWaterType'],
                            items: heatingTypes,
                            placeholder:
                                "${_lang.enterThe} ${_lang.hotWaterType}",
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'complementary_hotWaterType', text);
                            },
                          ),
                          editUserField(
                            title: _lang.hotWaterMode,
                            type: "select",
                            items: heatingwatermODes,
                            initialvalue: review?.meta!['hotWaterMode'],
                            placeholder:
                                "${_lang.enterThe} ${_lang.hotWaterMode}",
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'complementary_hotWaterMode', text);
                            },
                          ),
                          20.height,
                          // editUserField(
                          //   type: "numberandtext",
                          //   title: _lang.mailbox,
                          //   secondtitle: _lang.location,
                          //   placeholder: "${_lang.enterThe} ${_lang.mailbox}",
                          //   onChanged: (text, secondtext) {
                          //     if (text != null) {
                          //       wizardState.updateFormValue(
                          //           'complementary_mailbox', text);
                          //     }
                          //     if (secondtext != null && secondtext.isNotEmpty) {
                          //       wizardState.updateFormValue(
                          //           'complementary_mailboxlocation', secondtext);
                          //     }
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  )))),
    );
  }
}

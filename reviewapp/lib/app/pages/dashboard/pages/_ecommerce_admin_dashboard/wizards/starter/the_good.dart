import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/_components.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/_app_colors.dart';

class TheGood extends StatelessWidget {
  final Review? review;
  const TheGood({super.key, this.review});

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
            "the_good",
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
          primary: true,
          padding: const EdgeInsets.all(16.0),
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: wizardState.formKeys[WizardStep.values[2]],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Owner(s) information
                      20.height,
                      if (review != null)
                        backbutton(() => {context.popRoute()},
                            title: Text(
                              _lang.propertyLabel.capitalizeFirstLetter(),
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ))
                      else
                        Text(
                          _lang.propertyLabel.capitalizeFirstLetter(),
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),

                      // Property information
                      20.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          editUserField(
                            title: _lang.propertyAddress,
                            textEditingController: TextEditingController(
                              text:
                                  wizardState.formValues['property_address'] ??
                                      getRandomAddress(),
                            ),
                            placeholder:
                                "${_lang.enterThe} ${_lang.propertyAddress}",
                            type: "place",
                            initialvalue: review?.propertyDetails!.address,
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'property_address', text);
                            },
                            required: true,
                          ),
                          editUserField(
                            title: _lang.addressComplement,
                            placeholder:
                                "${_lang.enterThe} ${_lang.fullNameMandataire}",
                            initialvalue: review?.propertyDetails!.complement,
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'property_complement', text);
                            },
                          ),
                          editUserField(
                            type: "number",
                            title: _lang.floor,
                            placeholder: "${_lang.enterThe} ${_lang.floor}",
                            initialvalue: review?.propertyDetails!.floor,
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'property_floor', text);
                            },
                          ),
                          editUserField(
                            title: _lang.surface,
                            placeholder: "${_lang.enterThe} ${_lang.surface}",
                            initialvalue: review?.propertyDetails!.surface,
                            rightwidget: "m²",
                            type: "number",
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'property_surface', text);
                            },
                            required: true,
                          ),
                          editUserField(
                            type: "counterfield",
                            title: _lang.roomCount,
                            placeholder: "${_lang.enterThe} ${_lang.roomCount}",
                            initialvalue:
                                review?.propertyDetails!.roomCount ?? 1,
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'property_roomCount', text);
                            },
                          ),
                        ],
                      ),
                      // is it furnished?
                      SelectGrid(
                        entries: [
                          SelectionTile(
                            title: _lang.furnished,
                            isSelected:
                                wizardState.formValues['property_furnitured'] ==
                                    true,
                            onTap: () => wizardState.updateFormValue(
                                "property_furnitured", true),
                          ),
                          SelectionTile(
                            title: _lang.unfurnished,
                            isSelected:
                                wizardState.formValues['property_furnitured'] ==
                                    false,
                            onTap: () => wizardState.updateFormValue(
                                "property_furnitured", false),
                          ),
                        ],
                      ), // is it furnished?
                      20.height,
                      editUserField(
                        type: "number",
                        title: _lang.box,
                        initialvalue: review?.propertyDetails!.box,
                        placeholder: "${_lang.enterThe} ${_lang.box}",
                        onChanged: (text) {
                          wizardState.updateFormValue('property_box', text);
                        },
                      ),
                      editUserField(
                        type: "number",
                        title: _lang.cellar,
                        placeholder: "${_lang.enterThe} ${_lang.cellar}",
                        initialvalue: review?.propertyDetails!.cellar,
                        onChanged: (text) {
                          wizardState.updateFormValue('property_cellar', text);
                        },
                      ),
                      editUserField(
                        type: "number",
                        title: _lang.garage,
                        initialvalue: review?.propertyDetails!.garage,
                        placeholder: "${_lang.enterThe} ${_lang.garage}",
                        onChanged: (text) {
                          wizardState.updateFormValue('property_garage', text);
                        },
                      ),
                      editUserField(
                        type: "number",
                        title: _lang.parking,
                        initialvalue: review?.propertyDetails!.parking,
                        placeholder: "${_lang.enterThe} ${_lang.parking}",
                        onChanged: (text) {
                          wizardState.updateFormValue('property_parking', text);
                        },
                      ),
                    ],
                  )))),
    );
  }
}

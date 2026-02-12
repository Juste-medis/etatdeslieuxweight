import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/select_tile.dart';
import 'package:mon_etatsdeslieux/app/providers/_proccuration_provider.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;
import 'package:mon_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class TheGood extends StatelessWidget {
  final Review? thereview;
  const TheGood({super.key, this.thereview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final reviewState = context.watch<ReviewProvider>();
    final proccurationState = context.watch<ProccurationProvider>();
    final _lang = l.S.of(context);

    var review =
        reviewState.editingReview ??
        proccurationState.editingProccuration ??
        thereview;

    Jks.savereviewStep = () async {
      if (review != null) {
        try {
          if (review is Review) {
            await reviewState.updateThereview(
              review,
              "the_good",
              wizardState: wizardState,
            );
          } else if (review is Procuration) {
            if (review.source != 'new') {
              await proccurationState.updateTheproccuration(
                review,
                "the_good",
                wizardState: wizardState,
              );
            }
          }

          wizardState.setloading(false);
        } catch (e) {
          my_inspect(e);

          show_common_toast(
            "Une erreur s'est produite, veuillez réessayer plus tard.".tr,
            context,
          );
        }
      } else {}
    };

    return Scaffold(
      backgroundColor: thereview != null
          ? wizardState.isDarkTheme
                ? blackColor
                : whiteColor
          : null,
      body: SingleChildScrollView(
        primary: true,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: thereview != null
                ? null
                : wizardState.formKeys[WizardStep.values[2]],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (review != null)
                  backbutton(
                    () {
                      context.popRoute();
                    },
                    title: Text(
                      _lang.propertyLabel.capitalizeFirstLetter(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                // else
                //   Text(
                //     _lang.propertyLabel.capitalizeFirstLetter(),
                //     style: theme.textTheme.titleLarge
                //         ?.copyWith(fontWeight: FontWeight.bold),
                //   )

                // Property information
                20.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    editUserField(
                      title: _lang.propertyAddress,
                      textEditingController: TextEditingController(
                        text: wizardState.domaine.address ?? getRandomAddress(),
                      ),
                      placeholder: "${_lang.enterThe} ${_lang.propertyAddress}",
                      type: "place",
                      initialvalue: wizardState.domaine.address,
                      onChanged: (text) {
                        wizardState.domaine.address = text;
                        wizardState.updateInventory(
                          domaine: wizardState.domaine,
                        );
                      },
                      required: true,
                    ),
                    editUserField(
                      title: _lang.addressComplement,
                      placeholder:
                          "${_lang.enterThe} ${_lang.fullNameMandataire}",
                      initialvalue: wizardState.domaine.complement,
                      onChanged: (text) {
                        wizardState.domaine.complement = text;
                        wizardState.updateInventory(
                          domaine: wizardState.domaine,
                        );
                      },
                    ),
                    editUserField(
                      type: "number",
                      title: _lang.floor,
                      placeholder: "${_lang.enterThe} ${_lang.floor}",
                      initialvalue: wizardState.domaine.floor,
                      onChanged: (text) {
                        wizardState.domaine.floor = text;
                        wizardState.updateInventory(
                          domaine: wizardState.domaine,
                        );
                      },
                    ),
                    editUserField(
                      title: _lang.surface,
                      placeholder: "${_lang.enterThe} ${_lang.surface}",
                      initialvalue: wizardState.domaine.surface,
                      rightwidget: "m²",
                      type: "number",
                      onChanged: (text) {
                        wizardState.domaine.surface = text;
                        wizardState.updateInventory(
                          domaine: wizardState.domaine,
                        );
                      },
                      required: true,
                    ),
                    editUserField(
                      type: "counterfield",
                      title: _lang.roomCount,
                      placeholder: "${_lang.enterThe} ${_lang.roomCount}",
                      initialvalue: wizardState.domaine.roomCount ?? 1,
                      onChanged: (text) {
                        wizardState.domaine.roomCount = text;

                        wizardState.updateInventory(
                          domaine: wizardState.domaine,
                        );
                      },
                      required: true,
                    ),
                  ],
                ),
                // is it furnished?
                SelectGrid(
                  entries: [
                    SelectionTile(
                      title: _lang.furnished,
                      isSelected: wizardState.domaine.furnitured == true,
                      onTap: () {
                        wizardState.domaine.furnitured = true;
                        wizardState.updateInventory(
                          domaine: wizardState.domaine,
                        );
                      },
                    ),
                    SelectionTile(
                      title: _lang.unfurnished,
                      isSelected: wizardState.domaine.furnitured == false,
                      onTap: () {
                        wizardState.domaine.furnitured = false;
                        wizardState.updateInventory(
                          domaine: wizardState.domaine,
                        );
                      },
                    ),
                  ],
                ), // is it furnished?
                20.height,
                editUserField(
                  title: _lang.box,
                  initialvalue: wizardState.domaine.box,
                  placeholder: "${_lang.enterThe} ${_lang.box}",
                  onChanged: (text) {
                    wizardState.domaine.box = text;
                    wizardState.updateInventory(domaine: wizardState.domaine);
                  },
                ),
                editUserField(
                  title: _lang.cellar,
                  placeholder: "${_lang.enterThe} ${_lang.cellar}",
                  initialvalue: wizardState.domaine.cellar,
                  onChanged: (text) {
                    wizardState.domaine.cellar = text;
                    wizardState.updateInventory(domaine: wizardState.domaine);
                  },
                ),
                editUserField(
                  title: _lang.garage,
                  initialvalue: wizardState.domaine.garage,
                  placeholder: "${_lang.enterThe} ${_lang.garage}",
                  onChanged: (text) {
                    wizardState.domaine.garage = text;
                    wizardState.updateInventory(domaine: wizardState.domaine);
                  },
                ),
                editUserField(
                  title: _lang.parking,
                  initialvalue: wizardState.domaine.parking,
                  placeholder: "${_lang.enterThe} ${_lang.parking}",
                  onChanged: (text) {
                    wizardState.domaine.parking = text;
                    wizardState.updateInventory(domaine: wizardState.domaine);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

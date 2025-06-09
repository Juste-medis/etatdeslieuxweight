import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/signature.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/theme.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/dialogs/prompt_dialog.dart';
import 'package:jatai_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class PdfOffSummary extends StatelessWidget {
  final AppThemeProvider wizardState;
  const PdfOffSummary({super.key, required this.wizardState});

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

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: wizardState.formKeys[WizardStep.values[7]],
                child: ShadowContainer(
                  contentPadding: EdgeInsets.all(_padding / 2.75),
                  customHeader: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      Text(
                        "Vous pouvez maintenant telecharger vos procurations, une copie vous a été envoyé par e-mail à vous ainsi qu'à vos locataires mandaté"
                            .tr
                            .capitalizeFirstLetter(),
                        style: theme.textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      20.height,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 300,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.dividerColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ).center(),
                      30.height,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 300,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.dividerColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ).center(),
                      30.height,
                      inventoryAddButton(
                        context,
                        title: "Télécharger mes procurations".tr,
                        icon: Icons.download_outlined,
                        onPressed: () async {
                          sourceSelect(
                              context: context,
                              callback: (croppedFile) async {
                                // await uploadFile(croppedFile,
                                //     delete_id: delete_id,
                                //     update_id: update_id,
                                //     onfinish: onfinish,
                                //     isprofile: isprofile);
                              });
                        },
                      ).paddingOnly(bottom: 10).center(),
                    ],
                  ),
                ))));
  }
}

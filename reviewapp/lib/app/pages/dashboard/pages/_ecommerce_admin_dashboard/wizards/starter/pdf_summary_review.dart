import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/signature.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class PdfOffSummary extends StatelessWidget {
  final AppThemeProvider wizardState;
  const PdfOffSummary({super.key, required this.wizardState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
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
                key: wizardState.formKeys[WizardStep.values[8]],
                child: ShadowContainer(
                  contentPadding: EdgeInsets.all(_padding / 2.75),
                  customHeader: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      Text(
                        "Vous pouvez maintenant telecharger l’état des lieux, une copie vous à été envoyé par e-mail."
                            .tr
                            .capitalizeFirstLetter(),
                        style: theme.textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      20.height,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 200,
                        child: SignaturePadWidget(null),
                      ).center(),
                      30.height,
                      inventoryAddButton(
                        context,
                        title: "Télécharger l’état des lieux".tr,
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

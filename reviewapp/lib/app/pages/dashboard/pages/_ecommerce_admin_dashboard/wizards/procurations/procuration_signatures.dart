import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/signature.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class Signatures extends StatelessWidget {
  final AppThemeProvider wizardState;
  const Signatures({super.key, required this.wizardState});

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
                key: wizardState.formKeys[WizardStep.values[6]],
                child: ShadowContainer(
                  contentPadding: EdgeInsets.all(_padding / 2.75),
                  customHeader: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      Text(
                        "Signature".tr.capitalizeFirstLetter(),
                        style:
                            theme.textTheme.labelLarge?.copyWith(fontSize: 40),
                      ),
                      20.height,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 200,
                        child: SignaturePadWidget("procuration_signature"),
                      ).center(),
                      30.height,
                      inventoryAddButton(
                        context,
                        title:
                            "+ PHOTO Selfie Bailleur avec sa Pièce d’identité"
                                .tr,
                        icon: Icons.add_a_photo,
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
                      ).paddingOnly(bottom: 10),
                      SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.count(
                          crossAxisCount: responsiveValue<int>(
                            context,
                            xs: 2,
                            sm: 2,
                            md: 3,
                            lg: 4,
                          ),
                          childAspectRatio: 360 / 320,
                          mainAxisSpacing: _padding,
                          crossAxisSpacing: _padding,
                          children: List.generate(
                            defaultphotos["piece"]!.length,
                            (index) {
                              final _item = defaultphotos["piece"]![index];

                              return JataiGalleryImageCard(
                                item: _item,
                                onDelete: () {},
                              );
                            },
                          ),
                        ).paddingOnly(bottom: 10),
                      ),
                    ],
                  ),
                ))));
  }
}

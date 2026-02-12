import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';
import 'package:mon_etatsdeslieux/app/models/base_response_model.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/_select_tile.dart';
import 'package:mon_etatsdeslieux/app/providers/_proccuration_provider.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;
import 'package:mon_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class AuthorInventory extends StatelessWidget {
  final InventoryAuthorParam piece;
  const AuthorInventory({super.key, required this.piece});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    dynamic reviewState = piece.from == "procuration"
        ? context.watch<ProccurationProvider>()
        : context.watch<ReviewProvider>();

    final _lang = l.S.of(context);

    final isPhysical = reviewState.editingAuthor.type == "physique",
        addressifier = editUserField(
          textEditingController: TextEditingController(
            text: reviewState.editingAuthor.address ?? "",
          ),
          title: isPhysical ? "Adresse".tr : "Adresse de la société".tr,
          type: "place",
          onChanged: (text) {
            reviewState.editingAuthor.address = text;
            reviewState.seteditingAuthor(
              reviewState.editingAuthor,
              liveupdate: false,
            );
          },
          required: true,
        );

    return Scaffold(
      backgroundColor: wizardState.isDarkTheme ? blackColor : whiteColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: wizardState.formKeys[WizardStep.values[1]],
            child: Column(
              children: [
                AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.popRoute();
                    },
                  ),
                  title: Text(
                    "Modifier un auteur".tr,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectGrid(
                      entries: [
                        SelectionTile(
                          title: "Personne Physique".tr,
                          isSelected:
                              reviewState.editingAuthor.type == "physique",
                          onTap: () {
                            reviewState.editingAuthor.type = "physique";
                            reviewState.seteditingAuthor(
                              reviewState.editingAuthor,
                            );
                          },
                        ),
                        SelectionTile(
                          title: "Personne Morale".tr,
                          isSelected:
                              reviewState.editingAuthor.type == "morale",
                          onTap: () {
                            reviewState.editingAuthor.representant =
                                InventoryAuthor(
                                  firstname: "",
                                  lastName: "",
                                  email: "",
                                  denomination: "",
                                );
                            reviewState.editingAuthor.settype = "morale";
                            reviewState.seteditingAuthor(
                              reviewState.editingAuthor,
                            );
                          },
                        ),
                      ],
                    ),
                    30.height,
                    if (reviewState.editingAuthor.type == "physique")
                      Row(
                        children: [
                          Expanded(
                            child: editUserField(
                              title: "Nom",
                              placeholder: "${_lang.enterThe} Nom",
                              initialvalue: reviewState.editingAuthor.lastName,
                              onChanged: (text) {
                                reviewState.editingAuthor.lastName = text;
                                reviewState.seteditingAuthor(
                                  reviewState.editingAuthor,
                                  liveupdate: false,
                                );
                              },
                              required: true,
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: editUserField(
                              title: "Prénom",
                              placeholder: "${_lang.enterThe} Prénom",
                              initialvalue: reviewState.editingAuthor.firstname,
                              onChanged: (text) {
                                reviewState.editingAuthor.firstname = text;
                                reviewState.seteditingAuthor(
                                  reviewState.editingAuthor,
                                  liveupdate: false,
                                );
                              },
                              required: true,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          editUserField(
                            title: "Dénomination de la société".tr,
                            placeholder: "Dénomination de la société".tr,
                            initialvalue:
                                reviewState.editingAuthor.denomination,
                            onChanged: (text) {
                              reviewState.editingAuthor.denomination = text;
                              reviewState.seteditingAuthor(
                                reviewState.editingAuthor,
                                liveupdate: false,
                              );
                            },
                            required: true,
                          ),
                          addressifier,
                          dividerWithLabel(
                            label: "Le représentant".tr,
                          ).paddingSymmetric(vertical: 5),
                          Row(
                            children: [
                              Expanded(
                                child: editUserField(
                                  title: "Nom de famille".tr,
                                  placeholder: "Nom de famille".tr,
                                  initialvalue: reviewState
                                      .editingAuthor
                                      .representant!
                                      .lastName,
                                  onChanged: (text) {
                                    reviewState
                                            .editingAuthor
                                            .representant!
                                            .lastName =
                                        text;
                                    reviewState.seteditingAuthor(
                                      reviewState.editingAuthor,
                                      liveupdate: false,
                                    );
                                  },
                                  required: true,
                                ),
                              ),
                              16.width,
                              Expanded(
                                child: editUserField(
                                  title: "Prénom(s)".tr,
                                  placeholder: "Prénom(s)".tr,
                                  initialvalue: reviewState
                                      .editingAuthor
                                      .representant!
                                      .firstname,
                                  onChanged: (text) {
                                    reviewState
                                            .editingAuthor
                                            .representant!
                                            .firstname =
                                        text;
                                    reviewState.seteditingAuthor(
                                      reviewState.editingAuthor,
                                      liveupdate: false,
                                    );
                                  },
                                  required: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (reviewState.editingReview!.procuration != null) ...[
                      editUserField(
                        type: "date",
                        title: "Date de naissance".tr,
                        maximumDate: DateTime.now(),
                        onChanged: (text) {
                          reviewState.editingAuthor.dob = text;
                          reviewState.editingAuthor.representant?.dob = text;
                          reviewState.seteditingAuthor(
                            reviewState.editingAuthor,
                            liveupdate: false,
                          );
                        },
                        textEditingController: TextEditingController(
                          text: DateFormat('dd/MM/yyyy').format(
                            reviewState.editingAuthor.dob ?? DateTime.now(),
                          ),
                        ),
                        required: true,
                      ),
                      editUserField(
                        textEditingController: TextEditingController(
                          text: reviewState.editingAuthor.placeOfBirth,
                        ),
                        title: "Lieu de naissance".tr,
                        type: "place",
                        onChanged: (text) {
                          if (reviewState.editingAuthor.type == "morale") {
                            reviewState.editingAuthor.placeOfBirth = text;
                            reviewState
                                    .editingAuthor
                                    .representant!
                                    .placeOfBirth =
                                text;
                          } else {
                            reviewState.editingAuthor.placeOfBirth = text;
                          }
                          reviewState.seteditingAuthor(
                            reviewState.editingAuthor,
                            liveupdate: false,
                          );
                        },
                        required: true,
                      ),
                      editUserField(
                        title: "Numéro de téléphone".tr,
                        placeholder: "Entrez le numéro de téléphone".tr,
                        initialvalue: reviewState.editingAuthor.phone,
                        onChanged: (text) {
                          reviewState.editingAuthor.phone = text;
                          reviewState.editingAuthor.representant?.phone = text;
                          reviewState.seteditingAuthor(
                            reviewState.editingAuthor,
                            liveupdate: false,
                          );
                        },
                        type: "phone",
                        required: true,
                      ),
                    ],
                    if (isPhysical) addressifier,

                    editUserField(
                      title: 'Addresse email'.tr,
                      initialvalue: reviewState.editingAuthor.email,
                      type: "email",
                      enabled: true,
                      // piece.from == "proccuration" ? false : mrv(),
                      onChanged: (text) {
                        reviewState.editingAuthor.email = text;
                        reviewState.editingAuthor.representant?.email = text;
                        reviewState.seteditingAuthor(
                          reviewState.editingAuthor,
                          liveupdate: false,
                        );
                      },
                      email: true,
                    ),
                    if ((piece.canModifyMandataire ?? false)) 20.height,
                    if ((piece.canModifyMandataire ?? false))
                      dividerWithLabel(
                        label: "Le réalisateur".tr,
                      ).paddingSymmetric(vertical: 5),
                    if ((piece.canModifyMandataire ?? false)) 20.height,
                    if ((piece.canModifyMandataire ?? false))
                      SelectGrid(
                        title: _lang.whoDoesReview.capitalizeFirstLetter(),
                        entries: [
                          SelectionTile(
                            title: _lang.mandated,
                            isSelected: wizardState.isMandated == true,
                            onTap: () =>
                                wizardState.updateInventory(mandated: true),
                          ),
                          SelectionTile(
                            title: '${_lang.iam} ${_lang.owner}',
                            isSelected: wizardState.isMandated != true,
                            onTap: () =>
                                wizardState.updateInventory(mandated: false),
                          ),
                        ],
                      ),
                    // Owner(s) information
                    20.height,
                    if ((piece.canModifyMandataire ?? false) &&
                        wizardState.isMandated)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: editUserField(
                                  title: 'Nom',
                                  initialvalue:
                                      wizardState.mandataire!.lastName,
                                  onChanged: (text) {
                                    wizardState.mandataire!.lastName = text;
                                    wizardState.updateInventory(
                                      mandattairel: wizardState.mandataire,
                                      liveupdate: false,
                                    );
                                  },
                                  required: true,
                                ),
                              ),
                              16.width,
                              Expanded(
                                child: editUserField(
                                  title: "Prénom(s)",
                                  initialvalue:
                                      wizardState.mandataire!.firstname,
                                  onChanged: (text) {
                                    wizardState.mandataire!.firstname = text;
                                    wizardState.updateInventory(
                                      mandattairel: wizardState.mandataire,
                                      liveupdate: false,
                                    );
                                  },
                                  required: true,
                                ),
                              ),
                            ],
                          ),
                          if (reviewState.editingReview!.procuration !=
                              null) ...[
                            editUserField(
                              title: "Numéro de téléphone".tr,
                              initialvalue: wizardState.mandataire?.phone,
                              onChanged: (text) {
                                wizardState.mandataire?.phone = text;

                                wizardState.mandataire?.representant?.phone =
                                    text;

                                wizardState.updateInventory(
                                  mandattairel: wizardState.mandataire,
                                  liveupdate: false,
                                );
                              },
                              type: "phone",
                              required: true,
                            ),
                            editUserField(
                              type: "date",
                              maximumDate: DateTime.now(),
                              title: "Date de naissance".tr,
                              initialvalue: wizardState.mandataire?.dob != null
                                  ? DateFormat('dd-MM-yyyy').format(
                                      wizardState.mandataire?.dob ??
                                          DateTime.now(),
                                    )
                                  : getRandomDate(),
                              placeholder:
                                  "${_lang.enterThe} ${"Date de naissance".tr}",
                              onChanged: (text) {
                                wizardState.mandataire?.dob = text;
                                if (wizardState.mandataire?.type == "morale") {
                                  wizardState.mandataire?.representant?.dob =
                                      text;
                                }

                                wizardState.updateInventory(
                                  mandattairel: wizardState.mandataire,
                                  liveupdate: false,
                                );
                              },
                              textEditingController: TextEditingController(
                                text: wizardState.mandataire?.dob != null
                                    ? DateFormat('dd-MM-yyyy').format(
                                        wizardState.mandataire?.dob ??
                                            DateTime.now(),
                                      )
                                    : getRandomDate(),
                              ),
                              required: true,
                            ),
                            editUserField(
                              textEditingController: TextEditingController(
                                text:
                                    wizardState.mandataire?.placeOfBirth ?? "",
                              ),
                              title: "Lieu de naissance".tr,
                              type: "place",
                              onChanged: (text) {
                                wizardState.mandataire?.placeOfBirth = text;
                                if (wizardState.mandataire?.type == "morale") {
                                  wizardState
                                          .mandataire
                                          ?.representant
                                          ?.placeOfBirth =
                                      text;
                                }

                                wizardState.updateInventory(
                                  mandattairel: wizardState.mandataire,
                                  liveupdate: false,
                                );
                              },
                              required: true,
                            ),
                          ],
                          editUserField(
                            textEditingController: TextEditingController(
                              text: wizardState.mandataire?.address ?? "",
                            ),
                            initialvalue: wizardState.mandataire?.address,
                            title: "Adresse du mandataire".tr,
                            type: "place",
                            onChanged: (text) {
                              wizardState.mandataire?.address = text;
                              if (wizardState.mandataire?.type == "morale") {
                                wizardState.mandataire?.representant?.address =
                                    text;
                              }

                              wizardState.updateInventory(
                                mandattairel: wizardState.mandataire,
                                liveupdate: false,
                              );
                            },
                            required: true,
                          ),
                          editUserField(
                            title: "Addresse email".tr,
                            initialvalue: wizardState.mandataire?.email ?? "",
                            onChanged: (text) {
                              wizardState.mandataire?.email = text;
                              if (wizardState.mandataire?.type == "morale") {
                                wizardState.mandataire?.representant?.email =
                                    text;
                              }

                              wizardState.updateInventory(
                                mandattairel: wizardState.mandataire,
                                liveupdate: false,
                              );
                            },
                            email: true,
                          ),
                        ],
                      ),
                    20.height,
                    ElevatedButton.icon(
                      icon: reviewState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(_lang.save),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: reviewState.isLoading
                          ? null
                          : () {
                              if (wizardState
                                      .formKeys[WizardStep.values[1]]
                                      ?.currentState
                                      ?.validate() ??
                                  false) {
                                piece
                                    .cb(
                                      reviewState.editingAuthor,
                                      'updateAuthor',
                                    )
                                    .then((value) {
                                      Navigator.of(context).pop();
                                    });
                              } else {
                                show_common_toast(
                                  "Veuillez remplir tous les champs obligatoires.",
                                  context,
                                );
                              }
                            },
                    ).center(),
                    20.height,
                    if (reviewState.editingAuthor.id != "new")
                      OutlinedButton.icon(
                        icon: const Icon(Icons.delete_outline, color: redColor),
                        label: Text(
                          "Supprimer".tr,
                          style: const TextStyle(color: redColor),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Confirmer la suppression".tr),
                              content: Text(
                                "Êtes-vous sûr de vouloir supprimer cet auteur ?"
                                    .tr,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text("Annuler".tr),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text(
                                    "Supprimer".tr,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            piece
                                .cb(reviewState.editingAuthor, 'deleteauthor')
                                .then((value) {
                                  context.popRoute();
                                });
                          }
                        },
                      ).center(),
                    20.height,
                    Text(
                      "Les informations saisies seront utilisées pour générer les documents administratifs liés à l'auteur. \nSi vous avez des questions, n'hésitez pas à nous contacter. \nMerci de votre confiance !",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ).paddingSymmetric(vertical: 10),

                    20.height,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

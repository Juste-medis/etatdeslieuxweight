import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';
import 'package:mon_etatsdeslieux/app/models/base_response_model.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';

import 'package:mon_etatsdeslieux/app/pages/review/overview_card.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/select_tile.dart';

class InventoryReport extends StatelessWidget {
  final Review? review;
  const InventoryReport({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    Jks.wizardState = wizardState;
    final _lang = l.S.of(context);
    final reviewState = context.watch<ReviewProvider>();

    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);
    bool byprocuration =
        wizardState.reviewType == "procuration" ||
        (review != null && review!.procuration != null);

    return Scaffold(
      backgroundColor: review != null
          ? wizardState.isDarkTheme
                ? blackColor
                : whiteColor
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: review != null
                ? null
                : wizardState.formKeys[WizardStep.values[0]],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (review != null)
                  backbutton(() {
                    context.popRoute();
                  }),
                20.height,
                Text(
                  (byprocuration ? "Procuration" : "Etat des lieux").tr
                      .capitalizeFirstLetter(),
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 40),
                ),

                // Owner(s) information
                if (review == null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informations le(s) bailleur(s)"
                            .capitalizeFirstLetter(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...wizardState.inventoryProprietaires.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key, item = entry.value;
                        final isPhysical =
                                wizardState
                                    .inventoryProprietaires[index]
                                    .type ==
                                "physique",
                            addressifier = editUserField(
                              textEditingController: TextEditingController(
                                text:
                                    wizardState
                                        .inventoryProprietaires[index]
                                        .address ??
                                    wizardState
                                        .inventoryProprietaires[index]
                                        .representant
                                        ?.address ??
                                    getRandomAddress(),
                              ),
                              initialvalue: wizardState
                                  .inventoryProprietaires[index]
                                  .address,
                              title: "Adresse".tr,
                              type: "place",
                              onChanged: (text) {
                                wizardState
                                        .inventoryProprietaires[index]
                                        .address =
                                    text;
                              },
                              required: true,
                            );
                        return Column(
                          key: ValueKey('owner${item.id}'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                inventoryFormLabel(
                                  context,
                                  title:
                                      "${_lang.owner.capitalizeFirstLetter()} ${byprocuration ? "mandant" : ""} ${index + 1} :",
                                ).paddingOnly(bottom: 8),
                                if (wizardState.inventoryProprietaires.length >
                                    1)
                                  removeButton(
                                    context,
                                    item: item,
                                    wizardState: wizardState,
                                    onPressed: () {
                                      var list =
                                          wizardState.inventoryProprietaires;
                                      list.removeAt(index);
                                      wizardState.updateInventory(
                                        proprietaires: list,
                                      );
                                    },
                                  ),
                              ],
                            ),
                            SelectGrid(
                              entries: [
                                SelectionTile(
                                  title: "Personne Physique".tr,
                                  isSelected:
                                      wizardState
                                          .inventoryProprietaires[index]
                                          .type ==
                                      "physique",
                                  onTap: () =>
                                      wizardState
                                              .inventoryProprietaires[index]
                                              .settype =
                                          "physique",
                                ),
                                SelectionTile(
                                  title: "Personne Morale".tr,
                                  isSelected:
                                      wizardState
                                          .inventoryProprietaires[index]
                                          .type ==
                                      "morale",
                                  onTap: () {
                                    wizardState
                                        .inventoryProprietaires[index]
                                        .representant = InventoryAuthor(
                                      firstname: item.firstname,
                                      lastName: item.lastName,
                                      email: item.email,
                                      denomination: item.lastName,
                                    );
                                    wizardState
                                            .inventoryProprietaires[index]
                                            .settype =
                                        "morale";
                                  },
                                ),
                              ],
                            ),
                            30.height,
                            if (isPhysical)
                              Row(
                                children: [
                                  Expanded(
                                    child: editUserField(
                                      title: _lang.lastName,
                                      initialvalue: wizardState
                                          .inventoryProprietaires[index]
                                          .lastName,
                                      placeholder:
                                          "${_lang.enterThe} ${_lang.ownerfullname}",
                                      onChanged: (text) {
                                        wizardState
                                                .inventoryProprietaires[index]
                                                .lastName =
                                            text;
                                      },
                                      required: true,
                                    ),
                                  ),
                                  16.width,
                                  Expanded(
                                    child: editUserField(
                                      title: "${_lang.firstName}(s)",
                                      initialvalue: wizardState
                                          .inventoryProprietaires[index]
                                          .firstname,
                                      placeholder:
                                          "${_lang.enterThe} ${_lang.ownerfullname}",
                                      onChanged: (text) {
                                        wizardState
                                                .inventoryProprietaires[index]
                                                .firstname =
                                            text;
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
                                    placeholder:
                                        "Dénomination de la société".tr,
                                    initialvalue: wizardState
                                        .inventoryProprietaires[index]
                                        .denomination,
                                    onChanged: (text) {
                                      wizardState
                                              .inventoryProprietaires[index]
                                              .denomination =
                                          text;
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
                                          initialvalue:
                                              wizardState
                                                  .inventoryProprietaires[index]
                                                  .representant!
                                                  .lastName ??
                                              "",
                                          onChanged: (text) {
                                            wizardState
                                                    .inventoryProprietaires[index]
                                                    .representant!
                                                    .lastName =
                                                text;
                                          },
                                          required: true,
                                        ),
                                      ),
                                      16.width,
                                      Expanded(
                                        child: editUserField(
                                          title: "Prénom(s)".tr,
                                          placeholder: "Prénom(s)".tr,
                                          initialvalue:
                                              wizardState
                                                  .inventoryProprietaires[index]
                                                  .representant!
                                                  .firstname ??
                                              "",
                                          onChanged: (text) {
                                            wizardState
                                                    .inventoryProprietaires[index]
                                                    .representant!
                                                    .firstname =
                                                text;
                                          },
                                          required: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            if (wizardState.reviewType == "procuration") ...[
                              editUserField(
                                title: "Numéro de téléphone".tr,
                                placeholder: "Entrez le numéro de téléphone".tr,
                                initialvalue:
                                    wizardState
                                        .inventoryProprietaires[index]
                                        .phone ??
                                    "",
                                onChanged: (text) {
                                  wizardState
                                          .inventoryProprietaires[index]
                                          .phone =
                                      text;
                                  wizardState.updateFormValue("-", '-');
                                },
                                type: "phone",
                                required: true,
                              ),
                              editUserField(
                                type: "date",
                                maximumDate: DateTime.now(),
                                title: "Date de naissance".tr,
                                initialvalue:
                                    wizardState
                                            .inventoryProprietaires[index]
                                            .dob !=
                                        null
                                    ? DateFormat('dd-MM-yyyy')
                                          .format(
                                            wizardState
                                                .inventoryProprietaires[index]
                                                .dob!,
                                          )
                                          .toString()
                                    : getRandomDate(),
                                placeholder:
                                    "${_lang.enterThe} ${"Date de naissance".tr}",
                                onChanged: (text) {
                                  wizardState
                                          .inventoryProprietaires[index]
                                          .dob =
                                      text;
                                },
                                textEditingController: TextEditingController(
                                  text:
                                      wizardState
                                              .inventoryProprietaires[index]
                                              .dob !=
                                          null
                                      ? DateFormat('dd-MM-yyyy')
                                            .format(
                                              wizardState
                                                  .inventoryProprietaires[index]
                                                  .dob!,
                                            )
                                            .toString()
                                      : getRandomDate(),
                                ),
                                required: true,
                              ),
                              editUserField(
                                textEditingController: TextEditingController(
                                  text:
                                      wizardState
                                          .inventoryProprietaires[index]
                                          .placeOfBirth ??
                                      wizardState
                                          .inventoryProprietaires[index]
                                          .representant
                                          ?.placeOfBirth ??
                                      getRandomAddress(),
                                ),
                                title: "Lieu de naissance".tr,
                                initialvalue: wizardState
                                    .inventoryProprietaires[index]
                                    .placeOfBirth,
                                placeholder:
                                    "${_lang.enterThe} ${"Lieu de naissance".tr}",
                                type: "place",
                                onChanged: (text) {
                                  wizardState
                                          .inventoryProprietaires[index]
                                          .placeOfBirth =
                                      text;
                                },
                                required: true,
                              ),
                            ],
                            if (isPhysical) addressifier,
                            editUserField(
                              title: "Adresse email".tr,
                              initialvalue: wizardState
                                  .inventoryProprietaires[index]
                                  .email,
                              placeholder:
                                  "${_lang.enterThe} ${_lang.owneremail}",
                              onChanged: (text) {
                                wizardState
                                        .inventoryProprietaires[index]
                                        .email =
                                    text;
                                if (wizardState
                                        .inventoryProprietaires[index]
                                        .type ==
                                    "morale") {
                                  wizardState
                                          .inventoryProprietaires[index]
                                          .representant
                                          ?.email =
                                      text;
                                }
                              },
                              email: true,
                            ),
                          ],
                        ).paddingOnly(top: 20);
                      }),
                      inventoryAddButton(
                        context,
                        title: _lang.owner,
                        onPressed:
                            [
                              "completed",
                              "signing",
                            ].contains(Jks.reviewState.editingReview?.status)
                            ? null
                            : () {
                                var list = wizardState.inventoryProprietaires;
                                list.add(
                                  InventoryAuthor(
                                    order:
                                        wizardState
                                            .inventoryProprietaires
                                            .length +
                                        1,
                                    id: generateClientId("owner"),
                                  ),
                                );
                                wizardState.updateInventory(
                                  proprietaires: list,
                                );
                              },
                      ).paddingOnly(top: 8, bottom: 30),
                    ],
                  ),

                //===================================================================
                if (review != null)
                  Column(
                    children: [
                      Text(
                        "Informations de(s) bailleur(s)"
                            .capitalizeFirstLetter(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      20.height,
                      Column(
                        children: List.generate(
                          wizardState.inventoryProprietaires.length,
                          (index) {
                            final _data =
                                wizardState.inventoryProprietaires[index];
                            int jauge;
                            switch (_data.email != null &&
                                _data.address != null) {
                              case false:
                                jauge = 1;
                                break;
                              case true:
                                jauge = 2;
                                break;
                            }
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                top: 0,
                                start: _mqSize.width < 992 ? 6 : _padding / 2.5,
                                end: _mqSize.width < 992 ? 6 : _padding / 2.5,
                              ),
                              child: BorderOverviewCard(
                                onTap: () {
                                  reviewState.seteditingAuthor(_data);
                                  context.push(
                                    '/inventoryauthor-inventory/${_data.id}',
                                    extra: InventoryAuthorParam(
                                      cb: (data, action) async {
                                        wizardState.setloading(true);
                                        var rere = await reviewState
                                            .updateThereview(
                                              review!,
                                              action!,
                                              updateAuthor: data,
                                              wizardState: wizardState,
                                              canModifyMandataire: index == 0,
                                            );
                                        wizardState.setloading(false);
                                        wizardState.prefillReview(rere);
                                        return;
                                      },
                                      data: _data,
                                      canModifyMandataire: index == 0,
                                    ),
                                  );
                                },
                                iconPath: Icon(
                                  jauge == 0
                                      ? Icons.stop_circle
                                      : jauge == 1
                                      ? Icons.warning
                                      : Icons.check_circle,
                                  color: jauge == 0
                                      ? Colors.red
                                      : jauge == 1
                                      ? Colors.amber
                                      : Colors.green,
                                ),
                                border: Border(
                                  left: BorderSide(
                                    color: jauge == 0
                                        ? Colors.red
                                        : jauge == 1
                                        ? Colors.amber
                                        : Colors.green,
                                    width: 6,
                                  ),
                                ),
                                title: Text(
                                  _data.type == "morale"
                                      ? _data.denomination ?? ""
                                      : "${_data.firstname} ${_data.lastName}",
                                  style: _theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  _data.address ?? _data.email ?? "-",
                                  style: _theme.textTheme.bodyMedium
                                      ?.copyWith(),
                                ),
                                error: jauge != 2
                                    ? Text(
                                        "Informations manquantes".tr,
                                        style: _theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: jauge == 0
                                                  ? Colors.red
                                                  : jauge == 1
                                                  ? Colors.amber
                                                  : Colors.green,
                                            ),
                                      )
                                    : null,
                                cardType: BorderOverviewCardType.horizontal,
                              ),
                            );
                          },
                        ),
                      ),
                      20.height,
                      inventoryAddButton(
                        context,
                        title: _lang.owner,
                        onPressed:
                            [
                              "completed",
                              "signing",
                            ].contains(Jks.reviewState.editingReview?.status)
                            ? null
                            : () {
                                //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                                var _data = kReleaseMode
                                    ? InventoryAuthor()
                                    : InventoryAuthor(
                                        id: generateClientId("tenant"),
                                        email:
                                            '${generateRandomStrings(5)}@adidomedis.cloudsa',
                                        firstname: getRandomString(10),
                                        lastName: getRandomString(10),
                                        address: getRandomAddress(),
                                        type: 'physique',
                                        dob: DateTime.now(),
                                        placeOfBirth: getRandomAddress(),
                                      );
                                _data.representant = _data.copyWith(id: "rep");
                                var list = wizardState.inventoryProprietaires;
                                list.add(_data);
                                wizardState.updateInventory(
                                  proprietaires: list,
                                );
                                //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

                                reviewState.seteditingAuthor(_data);
                                context.push(
                                  '/inventoryauthor-inventory/${_data.id}',
                                  extra: InventoryAuthorParam(
                                    cb: (data, action) async {
                                      wizardState.setloading(true);
                                      var rere = await reviewState
                                          .updateThereview(
                                            review!,
                                            "addowner",
                                            updateAuthor: data,
                                            wizardState: wizardState,
                                          );
                                      wizardState.setloading(false);
                                      wizardState.prefillReview(rere);
                                      return;
                                    },
                                    data: _data,
                                  ),
                                );
                              },
                      ).paddingOnly(top: 8, bottom: 30),
                      //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      Text(
                        "${_lang.tenantInfo.capitalizeFirstLetter()} ${byprocuration ? "sortant(s)" : ""}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      20.height,
                      Column(
                        children: List.generate(
                          wizardState.inventoryLocatairesSortant.length,
                          (index) {
                            final _data =
                                wizardState.inventoryLocatairesSortant[index];
                            int jauge;
                            switch (_data.email != null &&
                                _data.address != null) {
                              case false:
                                jauge = 1;
                                break;
                              case true:
                                jauge = 2;
                                break;
                            }

                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                top: 0,
                                start: _mqSize.width < 992 ? 6 : _padding / 2.5,
                                end: _mqSize.width < 992 ? 6 : _padding / 2.5,
                              ),
                              child: BorderOverviewCard(
                                onTap: () {
                                  reviewState.seteditingAuthor(_data);
                                  context.push(
                                    '/inventoryauthor-inventory/${_data.id}',
                                    extra: InventoryAuthorParam(
                                      cb: (data, action) async {
                                        wizardState.setloading(true);
                                        await reviewState.updateThereview(
                                          review!,
                                          action!,
                                          updateAuthor: data,
                                          wizardState: wizardState,
                                        );
                                        wizardState.setloading(false);
                                        // Update or delete tenant based on action
                                        if (action.startsWith('delete')) {
                                          wizardState.updateInventory(
                                            locataires: wizardState
                                                .inventoryLocatairesSortant
                                                .where((e) => e.id != _data.id)
                                                .toList(),
                                          );
                                        } else {
                                          wizardState.updateInventory(
                                            locataires: wizardState
                                                .inventoryLocatairesSortant
                                                .map(
                                                  (e) => e.id == _data.id
                                                      ? data
                                                      : e,
                                                )
                                                .toList(),
                                          );
                                        }
                                        return;
                                      },
                                      data: _data,
                                    ),
                                  );
                                },
                                iconPath: Icon(
                                  jauge == 0
                                      ? Icons.stop_circle
                                      : jauge == 1
                                      ? Icons.warning
                                      : Icons.check_circle,
                                  color: jauge == 0
                                      ? Colors.red
                                      : jauge == 1
                                      ? Colors.amber
                                      : Colors.green,
                                ),
                                border: Border(
                                  left: BorderSide(
                                    color: jauge == 0
                                        ? Colors.red
                                        : jauge == 1
                                        ? Colors.amber
                                        : Colors.green,
                                    width: 6,
                                  ),
                                ),
                                title: Text(
                                  _data.type == "morale"
                                      ? _data.denomination ?? ""
                                      : "${_data.firstname} ${_data.lastName}",
                                  style: _theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  _data.address ?? _data.email ?? "-",
                                  style: _theme.textTheme.bodyMedium
                                      ?.copyWith(),
                                ),
                                error: jauge != 2
                                    ? Text(
                                        "Informations manquantes".tr,
                                        style: _theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: jauge == 0
                                                  ? Colors.red
                                                  : jauge == 1
                                                  ? Colors.amber
                                                  : Colors.green,
                                            ),
                                      )
                                    : null,
                                cardType: BorderOverviewCardType.horizontal,
                              ),
                            );
                          },
                        ),
                      ),
                      20.height,
                      inventoryAddButton(
                        context,
                        title: _lang.tenant,
                        onPressed:
                            [
                              "completed",
                              "signing",
                            ].contains(Jks.reviewState.editingReview?.status)
                            ? null
                            : () {
                                //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                                var _data = kReleaseMode
                                    ? InventoryAuthor()
                                    : InventoryAuthor(
                                        id: generateClientId("tenant"),
                                        email:
                                            '${generateRandomStrings(5)}@adidomedis.cloudsa',
                                        firstname: getRandomString(10),
                                        lastName: getRandomString(10),
                                        address: getRandomAddress(),
                                        type: 'physique',
                                        dob: DateTime.now(),
                                        placeOfBirth: getRandomAddress(),
                                      );
                                _data.representant = _data.copyWith(id: "rep");
                                var list =
                                    wizardState.inventoryLocatairesSortant;
                                list.add(_data);
                                wizardState.updateInventory(locataires: list);
                                //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

                                reviewState.seteditingAuthor(_data);
                                context.push(
                                  '/inventoryauthor-inventory/${_data.id}',
                                  extra: InventoryAuthorParam(
                                    cb: (data, action) async {
                                      wizardState.setloading(true);
                                      var rere = await reviewState
                                          .updateThereview(
                                            review!,
                                            "addsortantlocataire",
                                            updateAuthor: data,
                                            wizardState: wizardState,
                                          );
                                      wizardState.setloading(false);
                                      wizardState.prefillReview(rere);
                                      return;
                                    },
                                    data: _data,
                                  ),
                                );
                              },
                      ).paddingOnly(top: 8, bottom: 30),

                      //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      if (byprocuration)
                        Column(
                          children: [
                            Text(
                              "${_lang.tenantInfo.capitalizeFirstLetter()} entrant(s)",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            20.height,
                            Column(
                              children: List.generate(
                                wizardState.inventoryLocatairesEntrants.length,
                                (index) {
                                  final _data = wizardState
                                      .inventoryLocatairesEntrants[index];
                                  int jauge;
                                  switch (_data.email != null &&
                                      _data.address != null) {
                                    case false:
                                      jauge = 1;
                                      break;
                                    case true:
                                      jauge = 2;
                                      break;
                                  }

                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      top: 0,
                                      start: _mqSize.width < 992
                                          ? 6
                                          : _padding / 2.5,
                                      end: _mqSize.width < 992
                                          ? 6
                                          : _padding / 2.5,
                                    ),
                                    child: BorderOverviewCard(
                                      onTap: () {
                                        reviewState.seteditingAuthor(_data);
                                        context.push(
                                          '/inventoryauthor-inventory/${_data.id}',
                                          extra: InventoryAuthorParam(
                                            cb: (data, action) async {
                                              wizardState.setloading(true);
                                              await reviewState.updateThereview(
                                                review!,
                                                action!,
                                                updateAuthor: data,
                                                wizardState: wizardState,
                                              );
                                              wizardState.setloading(false);
                                              // Update or delete tenant based on action
                                              if (action.startsWith('delete')) {
                                                wizardState.updateInventory(
                                                  locataires: wizardState
                                                      .inventoryLocatairesEntrants
                                                      .where(
                                                        (e) => e.id != _data.id,
                                                      )
                                                      .toList(),
                                                );
                                              } else {
                                                wizardState.updateInventory(
                                                  locataires: wizardState
                                                      .inventoryLocatairesEntrants
                                                      .map(
                                                        (e) => e.id == _data.id
                                                            ? data
                                                            : e,
                                                      )
                                                      .toList(),
                                                );
                                              }
                                              return;
                                            },
                                            data: _data,
                                          ),
                                        );
                                      },
                                      iconPath: Icon(
                                        jauge == 0
                                            ? Icons.stop_circle
                                            : jauge == 1
                                            ? Icons.warning
                                            : Icons.check_circle,
                                        color: jauge == 0
                                            ? Colors.red
                                            : jauge == 1
                                            ? Colors.amber
                                            : Colors.green,
                                      ),
                                      border: Border(
                                        left: BorderSide(
                                          color: jauge == 0
                                              ? Colors.red
                                              : jauge == 1
                                              ? Colors.amber
                                              : Colors.green,
                                          width: 6,
                                        ),
                                      ),
                                      title: Text(
                                        _data.type == "morale"
                                            ? _data.denomination ?? ""
                                            : "${_data.firstname} ${_data.lastName}",
                                        style: _theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      subtitle: Text(
                                        _data.address ?? _data.email ?? "-",
                                        style: _theme.textTheme.bodyMedium
                                            ?.copyWith(),
                                      ),
                                      error: jauge != 2
                                          ? Text(
                                              "Informations manquantes".tr,
                                              style: _theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: jauge == 0
                                                        ? Colors.red
                                                        : jauge == 1
                                                        ? Colors.amber
                                                        : Colors.green,
                                                  ),
                                            )
                                          : null,
                                      cardType:
                                          BorderOverviewCardType.horizontal,
                                    ),
                                  );
                                },
                              ),
                            ),
                            20.height,
                            inventoryAddButton(
                              context,
                              title: _lang.tenant,
                              onPressed:
                                  ["completed", "signing"].contains(
                                    Jks.reviewState.editingReview?.status,
                                  )
                                  ? null
                                  : () {
                                      //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                                      var _data = kReleaseMode
                                          ? InventoryAuthor()
                                          : InventoryAuthor(
                                              id: generateClientId("tenant"),
                                              email:
                                                  '${generateRandomStrings(5)}@adidomedis.cloudsa',
                                              firstname: getRandomString(10),
                                              lastName: getRandomString(10),
                                              address: getRandomAddress(),
                                              type: 'physique',
                                              dob: DateTime.now(),
                                              placeOfBirth: getRandomAddress(),
                                            );
                                      _data.representant = _data.copyWith(
                                        id: "rep",
                                      );
                                      var list = wizardState
                                          .inventoryLocatairesEntrants;
                                      list.add(_data);
                                      wizardState.updateInventory(
                                        locataires: list,
                                      );
                                      //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

                                      reviewState.seteditingAuthor(_data);
                                      context.push(
                                        '/inventoryauthor-inventory/${_data.id}',
                                        extra: InventoryAuthorParam(
                                          cb: (data, action) async {
                                            wizardState.setloading(true);
                                            var rere = await reviewState
                                                .updateThereview(
                                                  review!,
                                                  "addentrantlocataire",
                                                  updateAuthor: data,
                                                  wizardState: wizardState,
                                                );
                                            wizardState.setloading(false);
                                            wizardState.prefillReview(rere);
                                            return;
                                          },
                                          data: _data,
                                        ),
                                      );
                                    },
                            ).paddingOnly(top: 8, bottom: 30),
                          ],
                        ),
                    ],
                  ),

                //===================================================================
                if (review == null && !byprocuration)
                  SelectGrid(
                    title: _lang.whoDoesReview.capitalizeFirstLetter(),
                    entries: [
                      SelectionTile(
                        title: _lang.mandated,
                        isSelected: wizardState.isMandated == true,
                        onTap: () {
                          wizardState.mandataire = InventoryAuthor();
                          wizardState.updateInventory(mandated: true);
                        },
                      ),
                      SelectionTile(
                        title: '${_lang.iam} ${_lang.owner}',
                        isSelected: wizardState.isMandated != true,
                        onTap: () {
                          wizardState.updateInventory(mandated: false);
                        },
                      ),
                    ],
                  ),
                // Owner(s) information
                if (review == null && !byprocuration) 20.height,
                if (review == null &&
                    !byprocuration &&
                    wizardState.isMandated == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: editUserField(
                              title: 'Nom de famille'.tr,
                              initialvalue: wizardState.mandataire!.lastName,
                              placeholder:
                                  "${_lang.enterThe} ${_lang.ownerfullname}",
                              onChanged: (text) {
                                wizardState.mandataire!.lastName = text;
                              },
                              required: true,
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: editUserField(
                              title: "${_lang.firstName}(s)",
                              initialvalue: wizardState.mandataire!.firstname,
                              placeholder:
                                  "${_lang.enterThe} ${_lang.ownerfullname}",
                              onChanged: (text) {
                                wizardState.mandataire!.firstname = text;
                              },
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      editUserField(
                        title: "Numéro de téléphone".tr,
                        initialvalue: wizardState.mandataire!.phone,
                        placeholder: "Entrez le numéro de téléphone".tr,
                        onChanged: (text) {
                          wizardState.mandataire!.phone = text;
                          wizardState.updateFormValue("-", '-');
                        },
                        type: "phone",
                        required: true,
                      ),
                      editUserField(
                        type: "date",
                        maximumDate: DateTime.now(),
                        title: "Date de naissance".tr,
                        initialvalue: wizardState.mandataire!.dob != null
                            ? DateFormat(
                                'dd-MM-yyyy',
                              ).format(wizardState.mandataire!.dob!).toString()
                            : getRandomDate(),
                        placeholder:
                            "${_lang.enterThe} ${"Date de naissance".tr}",
                        onChanged: (text) {
                          wizardState.mandataire!.dob = text;
                          if (wizardState.mandataire?.type == "morale") {
                            wizardState.mandataire!.representant!.dob = text;
                          }
                        },
                        textEditingController: TextEditingController(
                          text: wizardState.mandataire!.dob != null
                              ? DateFormat('dd-MM-yyyy')
                                    .format(wizardState.mandataire!.dob!)
                                    .toString()
                              : getRandomDate(),
                        ),
                        required: true,
                      ),
                      editUserField(
                        textEditingController: TextEditingController(
                          text:
                              wizardState
                                  .mandataire!
                                  .representant
                                  ?.placeOfBirth ??
                              wizardState.mandataire!.placeOfBirth ??
                              getRandomAddress(),
                        ),
                        title: "Lieu de naissance".tr,
                        placeholder:
                            "${_lang.enterThe} ${"Lieu de naissance".tr}",
                        type: "place",
                        initialvalue: wizardState.mandataire!.placeOfBirth,
                        onChanged: (text) {
                          wizardState.mandataire!.placeOfBirth = text;
                          if (wizardState.mandataire?.type == "morale") {
                            wizardState.mandataire!.representant!.placeOfBirth =
                                text;
                          }
                        },
                        required: true,
                      ),
                      editUserField(
                        textEditingController: TextEditingController(
                          text:
                              wizardState.mandataire!.address ??
                              getRandomAddress(),
                        ),
                        title: "Adresse".tr,
                        placeholder: "${_lang.enterThe} ${_lang.owneraddress}",
                        type: "place",
                        initialvalue: wizardState.mandataire!.address,
                        onChanged: (text) {
                          wizardState.mandataire!.address = text;
                          if (wizardState.mandataire?.type == "morale") {
                            wizardState.mandataire!.representant!.address =
                                text;
                          }
                        },
                        required: true,
                      ),
                      editUserField(
                        title: "Addresse email".tr,
                        initialvalue: wizardState.mandataire!.email,
                        placeholder: "${_lang.enterThe} ${_lang.owneremail}",
                        onChanged: (text) {
                          wizardState.mandataire!.email = text;
                          if (wizardState.mandataire?.type == "morale") {
                            wizardState.mandataire!.representant!.email = text;
                          }
                        },
                        email: true,
                      ),
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/base_response_model.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/_components.dart';
import 'package:jatai_etatsdeslieux/app/pages/pages.dart';
import 'package:jatai_etatsdeslieux/app/pages/review/overview_card.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';

class InventoryReport extends StatelessWidget {
  final Review? review;
  const InventoryReport({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);
    final reviewState = context.watch<ReviewProvider>();

    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);
    bool byprocuration = review != null && review!.procuration != null;
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
                  key: wizardState.formKeys[WizardStep.values[0]],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (review != null)
                        backbutton(
                          () => {context.popRoute()},
                        ),
                      // Owner(s) information
                      if (review == null)
                        Column(
                          children: [
                            20.height,
                            if (review != null)
                              backbutton(
                                () => {context.popRoute()},
                              ),
                            Text(
                              _lang.ownerinfo.capitalizeFirstLetter(),
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            20.height,
                            ...wizardState.inventoryProprietaires
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key, item = entry.value;
                              return Column(
                                key: ValueKey('owner${item.id}'),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      inventoryFormLabel(context,
                                              title:
                                                  "${_lang.owner.capitalizeFirstLetter()} ${index + 1} :")
                                          .paddingOnly(bottom: 8),
                                      if (wizardState
                                              .inventoryProprietaires.length >
                                          1)
                                        removeButton(context,
                                            item: item,
                                            wizardState: wizardState,
                                            onPressed: () {
                                          var list = wizardState
                                              .inventoryProprietaires;
                                          list.removeAt(index);
                                          wizardState.updateInventory(
                                              proprietaires: list);
                                        }),
                                    ],
                                  ),
                                  SelectGrid(
                                    entries: [
                                      SelectionTile(
                                        title: "Personne Physique".tr,
                                        isSelected: wizardState.formValues[
                                                'owner${index}_type'] ==
                                            "physique",
                                        onTap: () =>
                                            wizardState.updateFormValue(
                                                'owner${index}_type',
                                                "physique"),
                                      ),
                                      SelectionTile(
                                        title: "Personne Morale".tr,
                                        isSelected: wizardState.formValues[
                                                'owner${index}_type'] ==
                                            "morale",
                                        onTap: () =>
                                            wizardState.updateFormValue(
                                                'owner${index}_type', "morale"),
                                      ),
                                    ],
                                  ),
                                  30.height,
                                  if (wizardState
                                          .formValues['owner${index}_type'] !=
                                      "morale")
                                    Column(
                                      children: [
                                        editUserField(
                                          title: _lang.lastName,
                                          placeholder:
                                              "${_lang.enterThe} ${_lang.ownerfullname}",
                                          onChanged: (text) {
                                            wizardState.updateFormValue(
                                                'owner${index}_lastname', text);
                                          },
                                          required: true,
                                        ),
                                        editUserField(
                                          title: "${_lang.firstName}(s)",
                                          placeholder:
                                              "${_lang.enterThe} ${_lang.ownerfullname}",
                                          onChanged: (text) {
                                            wizardState.updateFormValue(
                                                'owner${index}_firstname',
                                                text);
                                          },
                                          required: true,
                                        )
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        editUserField(
                                          title:
                                              "Dénomination de la société".tr,
                                          placeholder:
                                              "Dénomination de la société".tr,
                                          onChanged: (text) {
                                            wizardState.updateFormValue(
                                                'owner${index}_denomination',
                                                text);
                                          },
                                          required: true,
                                        ),
                                        dividerWithLabel(
                                          label: "Le représentant".tr,
                                        ).paddingSymmetric(vertical: 5),
                                        editUserField(
                                          title: "Nom de famille".tr,
                                          placeholder: "Nom de famille".tr,
                                          onChanged: (text) {
                                            wizardState.updateFormValue(
                                                'owner${index}_representantlastname',
                                                text);
                                          },
                                          required: true,
                                        ),
                                        editUserField(
                                          title: "Prénom(s)".tr,
                                          placeholder: "Prénom(s)".tr,
                                          onChanged: (text) {
                                            wizardState.updateFormValue(
                                                'owner${index}_representantfirstname',
                                                text);
                                          },
                                          required: true,
                                        ),
                                      ],
                                    ),
                                  editUserField(
                                    title: "Numéro de téléphone".tr,
                                    placeholder:
                                        "Entrez le numéro de téléphone".tr,
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'owner${index}_representantphone',
                                          text);
                                    },
                                    type: "phone",
                                    required: true,
                                  ),
                                  editUserField(
                                    type: "date",
                                    title: "Date de naissance".tr,
                                    placeholder:
                                        "${_lang.enterThe} ${"Date de naissance".tr}",
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'owner${index}_dob', text);
                                    },
                                    textEditingController:
                                        TextEditingController(
                                      text: wizardState.formValues[
                                                  'owner${index}_dob'] !=
                                              null
                                          ? DateFormat('dd-MM-yyyy')
                                              .format(wizardState.formValues[
                                                  'owner${index}_dob'])
                                              .toString()
                                          : getRandomDate(),
                                    ),
                                    required: true,
                                  ),
                                  editUserField(
                                    textEditingController:
                                        TextEditingController(
                                      text: wizardState.formValues[
                                              'owner${index}_placeofbirth'] ??
                                          getRandomAddress(),
                                    ),
                                    title: "Lieu de naissance".tr,
                                    placeholder:
                                        "${_lang.enterThe} ${"Lieu de naissance".tr}",
                                    type: "place",
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'owner${index}_placeofbirth', text);
                                    },
                                    required: true,
                                  ),
                                  editUserField(
                                    textEditingController:
                                        TextEditingController(
                                      text: wizardState.formValues[
                                              'owner${index}_address'] ??
                                          getRandomAddress(),
                                    ),
                                    title: _lang.owneraddress,
                                    placeholder:
                                        "${_lang.enterThe} ${_lang.owneraddress}",
                                    type: "place",
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'owner${index}_address', text);
                                    },
                                    required: true,
                                  ),
                                  editUserField(
                                    title: _lang.owneremail,
                                    placeholder:
                                        "${_lang.enterThe} ${_lang.owneremail}",
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'owner${index}_representantemail',
                                          text);
                                    },
                                    email: true,
                                  ),
                                ],
                              );
                            }),
                            inventoryAddButton(
                              context,
                              title: _lang.owner,
                              onPressed: () {
                                var list = wizardState.inventoryProprietaires;
                                list.add(
                                  InventoryAuthor(
                                    order: wizardState
                                            .inventoryProprietaires.length +
                                        1,
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                  ),
                                );
                                wizardState.updateInventory(
                                    proprietaires: list);
                              },
                            ).paddingOnly(top: 8, bottom: 30),
                          ],
                        ),
                      //===================================================================

                      if (review != null)
                        Column(
                          children: [
                            Text(
                              "${_lang.ownerinfo.capitalizeFirstLetter()}",
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            20.height,
                            Column(
                              children: List.generate(
                                  wizardState.inventoryProprietaires.length,
                                  (index) {
                                final _data =
                                    wizardState.inventoryProprietaires[index];
                                var jauge;
                                switch (_data.email != null &&
                                    _data.address != null) {
                                  case false:
                                    jauge = 1;
                                    break;
                                  case true:
                                    jauge = 2;
                                    break;
                                  default:
                                    jauge = 0;
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
                                              var rere = await reviewState
                                                  .updateThereview(
                                                review!,
                                                action!,
                                                updateAuthor: data,
                                                wizardState: wizardState,
                                              );
                                              wizardState.setloading(false);
                                              wizardState.prefillReview(rere);
                                              return;
                                            },
                                            data: _data,
                                            canModifyMandataire: index == 0),
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
                                          width: 6),
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
                                    cardType: BorderOverviewCardType.horizontal,
                                  ),
                                );
                              }),
                            ),
                            20.height,
                            inventoryAddButton(
                              context,
                              title: _lang.owner,
                              onPressed: () {
                                //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                                var _data = InventoryAuthor(
                                  id: "new",
                                  email:
                                      '${generateRandomString(length: 5)}@jatai.frsa',
                                  firstname: getRandomString(10),
                                  lastName: getRandomString(10),
                                  address: getRandomAddress(),
                                  type: 'physique',
                                  dob: DateTime.now(),
                                  placeOfBirth: getRandomAddress(),
                                );
                                _data.representant = _data.copyWith(id: "rep");
                                //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

                                reviewState.seteditingAuthor(_data);
                                context.push(
                                  '/inventoryauthor-inventory/${_data.id}',
                                  extra: InventoryAuthorParam(
                                      cb: (data, action) async {
                                        wizardState.setloading(true);
                                        var rere =
                                            await reviewState.updateThereview(
                                          review!,
                                          "addowner",
                                          updateAuthor: data,
                                          wizardState: wizardState,
                                        );
                                        wizardState.setloading(false);
                                        wizardState.prefillReview(rere);
                                        return;
                                      },
                                      data: _data),
                                );
                              },
                            ).paddingOnly(top: 8, bottom: 30),
                            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                            Text(
                              "${_lang.tenantInfo.capitalizeFirstLetter()} ${byprocuration ? "sortants" : ""}",
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            20.height,
                            Column(
                              children: List.generate(
                                  wizardState.inventoryLocatairesSortant.length,
                                  (index) {
                                final _data = wizardState
                                    .inventoryLocatairesSortant[index];
                                var jauge;
                                switch (_data.email != null &&
                                    _data.address != null) {
                                  case false:
                                    jauge = 1;
                                    break;
                                  case true:
                                    jauge = 2;
                                    break;
                                  default:
                                    jauge = 0;
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
                                                      .inventoryLocatairesSortant
                                                      .where((e) =>
                                                          e.id != _data.id)
                                                      .toList(),
                                                );
                                              } else {
                                                wizardState.updateInventory(
                                                  locataires: wizardState
                                                      .inventoryLocatairesSortant
                                                      .map((e) =>
                                                          e.id == _data.id
                                                              ? data
                                                              : e)
                                                      .toList(),
                                                );
                                              }
                                              return;
                                            },
                                            data: _data),
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
                                          width: 6),
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
                                    cardType: BorderOverviewCardType.horizontal,
                                  ),
                                );
                              }),
                            ),
                            20.height,
                            inventoryAddButton(
                              context,
                              title: _lang.tenant,
                              onPressed: () {
                                //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                                var _data = InventoryAuthor(
                                  id: "new",
                                  email:
                                      '${generateRandomString(length: 5)}@jatai.frsa',
                                  firstname: getRandomString(10),
                                  lastName: getRandomString(10),
                                  address: getRandomAddress(),
                                  type: 'physique',
                                  dob: DateTime.now(),
                                  placeOfBirth: getRandomAddress(),
                                );
                                _data.representant = _data.copyWith(id: "rep");
                                //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

                                reviewState.seteditingAuthor(_data);
                                context.push(
                                  '/inventoryauthor-inventory/${_data.id}',
                                  extra: InventoryAuthorParam(
                                      cb: (data, action) async {
                                        wizardState.setloading(true);
                                        var rere =
                                            await reviewState.updateThereview(
                                          review!,
                                          "addsortantlocataire",
                                          updateAuthor: data,
                                          wizardState: wizardState,
                                        );
                                        wizardState.setloading(false);
                                        wizardState.prefillReview(rere);
                                        return;
                                      },
                                      data: _data),
                                );
                              },
                            ).paddingOnly(top: 8, bottom: 30),

                            //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                            if (byprocuration)
                              Column(children: [
                                Text(
                                  "${_lang.tenantInfo.capitalizeFirstLetter()} entrant",
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                20.height,
                                Column(
                                  children: List.generate(
                                      wizardState.inventoryLocatairesEntrants
                                          .length, (index) {
                                    final _data = wizardState
                                        .inventoryLocatairesEntrants[index];
                                    var jauge;
                                    switch (_data.email != null &&
                                        _data.address != null) {
                                      case false:
                                        jauge = 1;
                                        break;
                                      case true:
                                        jauge = 2;
                                        break;
                                      default:
                                        jauge = 0;
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
                                                  await reviewState
                                                      .updateThereview(
                                                    review!,
                                                    action!,
                                                    updateAuthor: data,
                                                    wizardState: wizardState,
                                                  );
                                                  wizardState.setloading(false);
                                                  // Update or delete tenant based on action
                                                  if (action
                                                      .startsWith('delete')) {
                                                    wizardState.updateInventory(
                                                      locataires: wizardState
                                                          .inventoryLocatairesEntrants
                                                          .where((e) =>
                                                              e.id != _data.id)
                                                          .toList(),
                                                    );
                                                  } else {
                                                    wizardState.updateInventory(
                                                      locataires: wizardState
                                                          .inventoryLocatairesEntrants
                                                          .map((e) =>
                                                              e.id == _data.id
                                                                  ? data
                                                                  : e)
                                                          .toList(),
                                                    );
                                                  }
                                                  return;
                                                },
                                                data: _data),
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
                                              width: 6),
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
                                                style: _theme
                                                    .textTheme.bodyMedium
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
                                  }),
                                ),
                                20.height,
                                inventoryAddButton(
                                  context,
                                  title: _lang.tenant,
                                  onPressed: () {
                                    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
                                    var _data = InventoryAuthor(
                                      id: "new",
                                      email:
                                          '${generateRandomString(length: 5)}@jatai.frsa',
                                      firstname: getRandomString(10),
                                      lastName: getRandomString(10),
                                      address: getRandomAddress(),
                                      type: 'physique',
                                      dob: DateTime.now(),
                                      placeOfBirth: getRandomAddress(),
                                    );
                                    _data.representant =
                                        _data.copyWith(id: "rep");
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
                                          data: _data),
                                    );
                                  },
                                ).paddingOnly(top: 8, bottom: 30),
                              ])
                          ],
                        ),

                      //===================================================================
                      if (review == null)
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
                      if (wizardState.isMandated == true && review == null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectGrid(
                              entries: [
                                SelectionTile(
                                  title: "Personne Physique".tr,
                                  isSelected: wizardState
                                          .formValues['mandataire_type'] ==
                                      "physique",
                                  onTap: () => wizardState.updateFormValue(
                                      'mandataire_type', "physique"),
                                ),
                                SelectionTile(
                                  title: "Personne Morale".tr,
                                  isSelected: wizardState
                                          .formValues['mandataire_type'] ==
                                      "morale",
                                  onTap: () => wizardState.updateFormValue(
                                      'mandataire_type', "morale"),
                                ),
                              ],
                            ),
                            30.height,
                            if (wizardState.formValues['mandataire_type'] !=
                                "morale")
                              Column(
                                children: [
                                  editUserField(
                                    title: 'Nom du mandataire: ',
                                    placeholder:
                                        "${_lang.enterThe} ${_lang.ownerfullname}",
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'mandataire_lastname', text);
                                    },
                                    required: true,
                                  ),
                                  editUserField(
                                    title: "${_lang.firstName}(s)",
                                    placeholder:
                                        "${_lang.enterThe} ${_lang.ownerfullname}",
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'mandataire_firstname', text);
                                    },
                                    required: true,
                                  )
                                ],
                              )
                            else
                              Column(
                                children: [
                                  editUserField(
                                    title:
                                        "Dénomination de la société mandataire"
                                            .tr,
                                    placeholder:
                                        "Dénomination de la société".tr,
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'mandataire_denomination', text);
                                    },
                                    required: true,
                                  ),
                                  dividerWithLabel(
                                    label: "Le représentant".tr,
                                  ).paddingSymmetric(vertical: 5),
                                  editUserField(
                                    title: "Nom de famille".tr,
                                    placeholder: "Nom de famille".tr,
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'mandataire_representantlastname',
                                          text);
                                    },
                                    required: true,
                                  ),
                                  editUserField(
                                    title: "Prénom(s)".tr,
                                    placeholder: "Prénom(s)".tr,
                                    onChanged: (text) {
                                      wizardState.updateFormValue(
                                          'mandataire_representantfirstname',
                                          text);
                                    },
                                    required: true,
                                  ),
                                ],
                              ),
                            editUserField(
                              title: "Numéro de téléphone".tr,
                              placeholder: "Entrez le numéro de téléphone".tr,
                              onChanged: (text) {
                                wizardState.updateFormValue(
                                    'mandataire_representantphone', text);
                              },
                              type: "phone",
                              required: true,
                            ),
                            editUserField(
                              type: "date",
                              title: "Date de naissance".tr,
                              placeholder:
                                  "${_lang.enterThe} ${"Date de naissance".tr}",
                              onChanged: (text) {
                                wizardState.updateFormValue(
                                    'mandataire_dob', text);
                              },
                              textEditingController: TextEditingController(
                                text:
                                    wizardState.formValues['mandataire_dob'] !=
                                            null
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(wizardState
                                                .formValues['mandataire_dob'])
                                            .toString()
                                        : getRandomDate(),
                              ),
                              required: true,
                            ),
                            editUserField(
                              textEditingController: TextEditingController(
                                text: wizardState.formValues[
                                        'mandataire_placeofbirth'] ??
                                    getRandomAddress(),
                              ),
                              title: "Lieu de naissance".tr,
                              placeholder:
                                  "${_lang.enterThe} ${"Lieu de naissance".tr}",
                              type: "place",
                              onChanged: (text) {
                                wizardState.updateFormValue(
                                    'mandataire_placeofbirth', text);
                              },
                              required: true,
                            ),
                            editUserField(
                              textEditingController: TextEditingController(
                                text: wizardState
                                        .formValues['mandataire_address'] ??
                                    getRandomAddress(),
                              ),
                              title: "Adresse du mandataire".tr,
                              placeholder:
                                  "${_lang.enterThe} ${_lang.owneraddress}",
                              type: "place",
                              onChanged: (text) {
                                wizardState.updateFormValue(
                                    'mandataire_address', text);
                              },
                              required: true,
                            ),
                            editUserField(
                              title: _lang.owneremail,
                              placeholder:
                                  "${_lang.enterThe} ${_lang.owneremail}",
                              onChanged: (text) {
                                wizardState.updateFormValue(
                                    'mandataire_email', text);
                              },
                              email: true,
                            ),
                          ],
                        ),
                    ],
                  )))),
    );
  }
}

import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/actions.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/prompt_dialog.dart';
import 'package:jatai_etadmin/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etadmin/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

class InventoryOfKeysCounter extends StatefulWidget {
  final AppThemeProvider wizardState;
  const InventoryOfKeysCounter({super.key, required this.wizardState});

  @override
  State<InventoryOfKeysCounter> createState() => _InventoryOfKeysCounterState();
}

class _InventoryOfKeysCounterState extends State<InventoryOfKeysCounter> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchControlcles = TextEditingController();
  List<Compteur> _filteredCompteurs = [];
  List<CleDePorte> _filteredCles = [];

  @override
  void initState() {
    super.initState();
    _filteredCompteurs = widget.wizardState.domaine?.compteurs ?? [];
    _filteredCles = widget.wizardState.domaine?.clesDePorte ?? [];
    _searchController.addListener(_filterItems);
    _searchControlcles.addListener(_filterItems2);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchControlcles.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCompteurs = (widget.wizardState.domaine?.compteurs ?? [])
          .where((thing) =>
              thing.name?.toLowerCase().contains(query) == true ||
              thing.comment?.toLowerCase().contains(query) == true ||
              thing.type?.toLowerCase().contains(query) == true)
          .toList();
    });
  }

  void _filterItems2() {
    final query = _searchControlcles.text.toLowerCase();
    setState(() {
      _filteredCles = (widget.wizardState.domaine?.clesDePorte ?? [])
          .where((thing) =>
              thing.name?.toLowerCase().contains(query) == true ||
              thing.location?.toLowerCase().contains(query) == true ||
              thing.type?.toLowerCase().contains(query) == true)
          .toList();
    });
  }

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
          key: wizardState.formKeys[WizardStep.inventoryOfKeysCounters],
          child: ShadowContainer(
            contentPadding: EdgeInsets.all(_padding / 2.75),
            customHeader: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.height,
                Text(
                  "${_lang.compteurs} ${_lang.and} ${_lang.cles}"
                      .capitalizeFirstLetter(),
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                20.height,
              ],
            ),
            child: Column(
              children: [
                ReorderableListView(
                  dragStartBehavior: DragStartBehavior.start,
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _lang.compteurs.capitalizeFirstLetter(),
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ).paddingOnly(bottom: 20),
                      TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: _lang.search,
                          prefixIcon: Icon(Icons.search,
                              color: theme.colorScheme.primary),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear,
                                      color: theme.colorScheme.error),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterItems();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      20.height,
                      Row(
                        children: [
                          Expanded(
                            child: inventoryAddButton(
                              context,
                              title: '${_lang.item}s',
                              onPressed: () async {
                                final formKey = GlobalKey<FormState>();
                                var name = "";
                                await showAwesomeFormDialog(
                                  context: context,
                                  submitText: _lang.add,
                                  title: "${_lang.add} ${_lang.item}",
                                  formContent: Column(
                                    key: const ValueKey('addthingofkeys'),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      editUserField(
                                        showplaceholder: true,
                                        title: _lang.item,
                                        placeholder:
                                            "${_lang.enterThe} ${_lang.item} ${_lang.name}",
                                        onChanged: (text) {
                                          name = text;
                                        },
                                        required: true,
                                      ),
                                    ],
                                  ),
                                  formKey: formKey,
                                );
                                if (name.isEmpty) return;

                                var domain = wizardState.domaine!;
                                domain.compteurs.insert(
                                    0,
                                    Compteur(
                                      name: name,
                                      order: wizardState
                                              .domaine!.compteurs.length +
                                          1,
                                    ));
                                wizardState.updateInventory(domaine: domain);
                                initState();
                                _filterItems();
                              },
                            ),
                          ),
                          10.width,
                          Text(
                            '${_filteredCompteurs.length}/${wizardState.domaine?.compteurs.length ?? 0} ${_lang.items}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) newIndex--;

                    final originalList = wizardState.domaine!.compteurs;
                    final filteredList = _filteredCompteurs;

                    // Find the actual index in the original list
                    final itemToMove = filteredList[oldIndex];
                    final originalOldIndex = originalList.indexOf(itemToMove);

                    // Calculate new index in original list
                    Compteur? newNeighbor;
                    if (newIndex < filteredList.length) {
                      newNeighbor = filteredList[newIndex];
                    }
                    final originalNewIndex = newNeighbor != null
                        ? originalList.indexOf(newNeighbor)
                        : originalList.length;

                    // Perform the move
                    originalList.removeAt(originalOldIndex);
                    originalList.insert(originalNewIndex, itemToMove);

                    wizardState.updateInventory(domaine: wizardState.domaine!);
                    _filterItems(); // Refresh search results
                  },
                  children: [
                    ..._filteredCompteurs.asMap().entries.map((entry) {
                      final index2 = entry.key;
                      final compteur = entry.value;
                      final originalIndex =
                          wizardState.domaine!.compteurs.indexOf(compteur);

                      return Column(
                        key: ValueKey('compteur${compteur.order}'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionWidget(
                            expandedAlignment: Alignment.topLeft,
                            initiallyExpanded: index2 == 0,
                            titleBuilder: (animationValue, easeInValue,
                                    isExpanded, toggleFunction) =>
                                InkWell(
                              onTap: () => toggleFunction(animated: true),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  border: BorderDirectional(
                                    bottom: BorderSide(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ReorderableDragStartListener(
                                            index: index2,
                                            child: SvgPicture.asset(
                                              'assets/images/sidebar_icons/arrows-move.svg',
                                              colorFilter: ColorFilter.mode(
                                                theme.colorScheme.primary,
                                                BlendMode.srcIn,
                                              ),
                                              width: 20,
                                              height: 20,
                                            )),
                                        20.width,
                                        Text(
                                          compteur.name!,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    AnimatedRotation(
                                      turns: isExpanded ? 0.25 : 0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: AcnooAppColors.kPrimary700,
                                      ),
                                    ),
                                  ],
                                ).paddingSymmetric(vertical: 5),
                              ),
                            ),
                            content: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                        child: CustomDropdownButton(
                                      onclose: () =>
                                          {wizardState.updateInventory()},
                                      buttonTitle: "${compteur.count ?? 1} ",
                                      buttonIcon: Icons.onetwothree_sharp,
                                      items: [...defaultcountNumber.entries]
                                          .map((e) => {
                                                'label': e.value,
                                                'value': e.key,
                                              })
                                          .toList(),
                                      onChanged: (value) {
                                        var domain = wizardState.domaine;

                                        var updatedThing = compteur.copyWith(
                                            count: value is int
                                                ? value
                                                : int.parse(value));

                                        final actualindex = domain!.compteurs
                                            .indexWhere((c) =>
                                                c.order == compteur.order);

                                        if (actualindex != -1) {
                                          domain.compteurs[actualindex] =
                                              updatedThing;
                                          wizardState.updateInventory(
                                              domaine: domain,
                                              liveupdate: false);
                                        }
                                      },
                                    )),
                                    10.width,
                                    Flexible(
                                        child: CustomDropdownButton(
                                      onclose: () =>
                                          {wizardState.updateInventory()},
                                      buttonTitle:
                                          "${compteur.serialNumber ?? 1}",
                                      buttonIcon: Icons.width_wide,
                                      items: [...fairplaymap.entries]
                                          .map((e) => {
                                                'label': e.value,
                                                'value': e.key,
                                              })
                                          .toList(),
                                      onChanged: (value) {
                                        var domain = wizardState.domaine;

                                        var updatedThing = compteur.copyWith(
                                            serialNumber: value);

                                        domain!.compteurs[originalIndex] =
                                            updatedThing;

                                        wizardState.updateInventory(
                                            domaine: domain, liveupdate: false);
                                      },
                                    )),
                                    10.width,
                                    10.width,
                                    //use chat more button instead

                                    Flexible(
                                      child: inventoryActionButton(
                                        context,
                                        title: const Icon(Icons.more_horiz),
                                        onPressed: () {
                                          context.push(
                                            '/thing-inventory',
                                            extra: {
                                              "thing": compteur.order,
                                              "piece": wizardState.domaine
                                            },
                                          );
                                        },
                                      ).withWidth(56),
                                    ),
                                    10.width,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    if (_filteredCompteurs.isEmpty)
                      Center(
                        key: const ValueKey('nofound'),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _lang.noItemsFound,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                50.height,
                ReorderableListView(
                  dragStartBehavior: DragStartBehavior.start,
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _lang.cles.capitalizeFirstLetter(),
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      // Text(
                      //   _lang.roomInventoriesDescription,
                      //   style: theme.textTheme.labelLarge
                      //       ?.copyWith(color: theme.colorScheme.onSurface),
                      // ),
                      20.height,
                      TextFormField(
                        controller: _searchControlcles,
                        decoration: InputDecoration(
                          hintText: _lang.search,
                          prefixIcon: Icon(Icons.search,
                              color: theme.colorScheme.primary),
                          suffixIcon: _searchControlcles.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear,
                                      color: theme.colorScheme.error),
                                  onPressed: () {
                                    _searchControlcles.clear();
                                    _filterItems2();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      20.height,
                      Row(
                        children: [
                          Expanded(
                            child: inventoryAddButton2(
                              context,
                              title: '${_lang.item}s',
                              onPressed: () async {
                                final formKey = GlobalKey<FormState>();
                                var name = "";
                                await showAwesomeFormDialog(
                                  context: context,
                                  submitText: _lang.add,
                                  title: "${_lang.add} ${_lang.item}",
                                  formContent: Column(
                                    key: const ValueKey('addthingofkeys'),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      editUserField(
                                        showplaceholder: true,
                                        title: _lang.item,
                                        placeholder:
                                            "${_lang.enterThe} ${_lang.item} ${_lang.name}",
                                        onChanged: (text) {
                                          name = text;
                                        },
                                        required: true,
                                      ),
                                    ],
                                  ),
                                  formKey: formKey,
                                );
                                if (name.isEmpty) return;

                                var domain = wizardState.domaine!;
                                domain.clesDePorte
                                    .insert(0, CleDePorte(name: name));
                                wizardState.updateInventory(domaine: domain);
                                initState();
                                _filterItems2();
                              },
                            ),
                          ),
                          10.width,
                          Text(
                            '${_filteredCles.length}/${wizardState.domaine?.clesDePorte.length ?? 0} ${_lang.cles}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) newIndex--;

                    final originalList = wizardState.domaine!.clesDePorte;
                    final filteredList = _filteredCles;

                    // Find the actual index in the original list
                    final itemToMove = filteredList[oldIndex];
                    final originalOldIndex = originalList.indexOf(itemToMove);

                    // Calculate new index in original list
                    CleDePorte? newNeighbor;
                    if (newIndex < filteredList.length) {
                      newNeighbor = filteredList[newIndex];
                    }
                    final originalNewIndex = newNeighbor != null
                        ? originalList.indexOf(newNeighbor)
                        : originalList.length;

                    // Perform the move
                    originalList.removeAt(originalOldIndex);
                    originalList.insert(originalNewIndex, itemToMove);

                    wizardState.updateInventory(domaine: wizardState.domaine!);
                    _filterItems2(); // Refresh search results
                  },
                  children: [
                    ..._filteredCles.asMap().entries.map((entry) {
                      final index2 = entry.key;
                      final cledeporte = entry.value;
                      final originalIndex =
                          wizardState.domaine!.clesDePorte.indexOf(cledeporte);

                      return Column(
                        key: ValueKey('cledeporte$originalIndex'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionWidget(
                            expandedAlignment: Alignment.topLeft,
                            initiallyExpanded: index2 == 0,
                            titleBuilder: (animationValue, easeInValue,
                                    isExpanded, toggleFunction) =>
                                InkWell(
                              onTap: () => toggleFunction(animated: true),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  border: BorderDirectional(
                                    bottom: BorderSide(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ReorderableDragStartListener(
                                            index: index2,
                                            child: SvgPicture.asset(
                                              'assets/images/sidebar_icons/arrows-move.svg',
                                              colorFilter: ColorFilter.mode(
                                                theme.colorScheme.primary,
                                                BlendMode.srcIn,
                                              ),
                                              width: 20,
                                              height: 20,
                                            )),
                                        20.width,
                                        Text(
                                          cledeporte.name!,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    AnimatedRotation(
                                      turns: isExpanded ? 0.25 : 0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: AcnooAppColors.kPrimary700,
                                      ),
                                    ),
                                  ],
                                ).paddingSymmetric(vertical: 5),
                              ),
                            ),
                            content: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                        child: CustomDropdownButton(
                                      onclose: () =>
                                          {wizardState.updateInventory()},
                                      buttonTitle: "${cledeporte.count ?? 1} ",
                                      buttonIcon: Icons.onetwothree_sharp,
                                      items: [...defaultcountNumber.entries]
                                          .map((e) => {
                                                'label': e.value,
                                                'value': e.key,
                                              })
                                          .toList(),
                                      onChanged: (value) {
                                        var domain = wizardState.domaine;

                                        var updatedThing = cledeporte.copyWith(
                                            count: value is int
                                                ? value
                                                : int.parse(value));

                                        final actualindex = domain!.clesDePorte
                                            .indexWhere((c) =>
                                                c.order == cledeporte.order);
                                        if (actualindex != -1) {
                                          domain.clesDePorte[actualindex] =
                                              updatedThing;
                                          wizardState.updateInventory(
                                              domaine: domain,
                                              liveupdate: false);
                                        }
                                      },
                                    )),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                    ),
                                    //use chat more button instead

                                    Flexible(
                                      child: inventoryActionButton(
                                        context,
                                        title: const Icon(Icons.more_horiz),
                                        onPressed: () {
                                          context.push(
                                            '/thing-inventory',
                                            extra: {
                                              "thing": cledeporte.order,
                                              "piece": wizardState.domaine
                                            },
                                          );
                                        },
                                      ).withWidth(56),
                                    ),
                                    10.width,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    if (_filteredCles.isEmpty)
                      Center(
                        key: const ValueKey('nofound'),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _lang.noItemsFound,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
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

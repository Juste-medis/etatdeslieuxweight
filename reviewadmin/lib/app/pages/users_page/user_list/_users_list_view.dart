// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole3.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_user_model.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import 'package:jatai_etadmin/app/widgets/shadow_container/_shadow_container.dart';
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/helpers.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../widgets/widgets.dart';
import 'add_user_popup.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  late final List<User> _filteredData = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  int _rowsPerPage = 10;
  String _searchQuery = '';
  bool _selectAll = false;
  bool _isLoading = false;
  int totalItems = 0;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchUsers(refresh: true);
  }

  void fetchUsers({bool refresh = false}) async {
    setState(() {
      _isLoading = true;
    });

    if (refresh) {
      _currentPage = 0;
      _rowsPerPage = 10;
      _searchQuery = '';
      _selectAll = false;
    }

    try {
      final response = await getuserslist(
          page: _currentPage,
          limit: "$_rowsPerPage",
          filter: {
            "q": _searchQuery,
          });

      if (response.status == true) {
        _filteredData.clear();

        if (refresh) {
          setState(() {
            _filteredData.clear();
          });
        }
        setState(() {
          _filteredData.addAll(response.list);
          _isLoading = false;
          totalItems = response.totalItems;
          totalPages = response.totalPages;
        });
      }
    } catch (err) {
      debugPrint('Error fetching users: $err');
      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  deleteUser(User user) {
    showAwesomeConfirmDialog(
        context: context,
        title: 'Confirmer la suppression',
        description: 'Êtes-vous sûr de vouloir supprimer cet utilisateur ?',
        onpositive: () async {
          try {
            setState(() {
              _isLoading = true;
            });
            final response = await deleteTheUser("${user.iid}");
            if (response.status == true) {
              simulateScreenBottomRightTap(Jks.context!);
              toast("Utilisateur supprimé avec succès", bgColor: Colors.green);

              setState(() {
                _filteredData.removeWhere((u) => u.iid == user.iid);
                totalItems -= 1;
                if (_filteredData.isEmpty && _currentPage > 0) {
                  _currentPage -= 1;
                }
              });
            } else {
              toast(
                  response.message ??
                      "Échec de la suppression  de l'utilisateur",
                  bgColor: Colors.red);
            }
            setState(() {
              _isLoading = false;
            });
          } catch (e) {
            myprint(e);
          }
        });
  }

  addOreditUser({User? user}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AddUserDialog(
              onSuccessAction: () {
                fetchUsers(refresh: true);
              },
              user: user,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    final _showingText =
        '${l.S.of(context).showing} ${(_currentPage * _rowsPerPage) + 1} ${l.S.of(context).to} ${(_currentPage * _rowsPerPage) + _filteredData.length} ${l.S.of(context).oF} $totalItems ${l.S.of(context).entries}';

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet =
                    constraints.maxWidth < 992 && constraints.maxWidth >= 481;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isMobile
                        ? Padding(
                            padding: _sizeInfo.padding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: showingValueDropDown(
                                          isTablet: isTablet,
                                          isMobile: isMobile,
                                          textTheme: textTheme),
                                    ),
                                    const Spacer(),
                                    addUserButton(textTheme),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                searchFormField(textTheme: textTheme),
                              ],
                            ),
                          )
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: showingValueDropDown(
                                      isTablet: isTablet,
                                      isMobile: isMobile,
                                      textTheme: textTheme),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  flex: isTablet || isMobile ? 2 : 3,
                                  child: searchFormField(textTheme: textTheme),
                                ),
                                Spacer(flex: isTablet || isMobile ? 1 : 2),
                                addUserButton(textTheme),
                              ],
                            ),
                          ),

                    //__________________________Data_table__________________
                    isMobile || isTablet
                        ? RawScrollbar(
                            padding: const EdgeInsets.only(left: 18),
                            trackBorderColor: theme.colorScheme.surface,
                            trackVisibility: true,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 8.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                    ),
                                    child: userListDataTable(context),
                                  ),
                                ),
                                Padding(
                                  padding: _sizeInfo.padding,
                                  child: Text(
                                    _showingText,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(16.0),
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: userListDataTable(context),
                            ),
                          ),

                    //__________________________footer__________________
                    isTablet || isMobile
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _showingText,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                DataTablePaginator(
                                  currentPage: _currentPage + 1,
                                  totalPages: totalPages,
                                  onPreviousTap: _goToPreviousPage,
                                  onNextTap: _goToNextPage,
                                )
                              ],
                            )),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ///_________________________add_user_button___________________________
  ElevatedButton addUserButton(TextTheme textTheme) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          addOreditUser();
        });
      },
      label: Text(
        lang.addNewUser,
        //'Add New User',
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  ///_____________________________________select_dropdown_val_________
  void _setRowsPerPage(int value) {
    setState(() {
      _rowsPerPage = value;
      _currentPage = 0;
    });
    fetchUsers();
  }

  ///_____________________________________go_next_page________________
  void _goToNextPage() {
    if (_currentPage < totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
    fetchUsers();
  }

  ///_____________________________________go_previous_page____________
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
    fetchUsers();
  }

  ///___________________Search_Field___________________________________
  TextFormField searchFormField({required TextTheme textTheme}) {
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Au moins 3 caractères',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child:
              const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: (value) {
        // 3 lenght minimum to start search
        if (value.length < 3 && value.isNotEmpty) return;
        setState(() {
          _searchQuery = value;
          _currentPage = 0;
        });
        fetchUsers();
      },
    );
  }

  ///___________________DropDownList___________________________________
  Container showingValueDropDown(
      {required bool isTablet,
      required bool isMobile,
      required TextTheme textTheme}) {
    final _dropdownStyle = AcnooDropdownStyle(context);
    //final theme = Theme.of(context);
    final lang = l.S.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<int>(
        style: _dropdownStyle.textStyle,
        iconStyleData: _dropdownStyle.iconStyle,
        buttonStyleData: _dropdownStyle.buttonStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle,
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: _rowsPerPage,
        items: [10, 20, 30, 40, 50].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              //isTablet || isMobile ? '$value' :
              '${lang.show} $value',
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            _setRowsPerPage(value);
          }
        },
      ),
    );
  }

  Widget userListDataTable(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return MyDataTable(
      isLoading: _isLoading,
      columns: [
        DataColumn(
          label: Row(
            children: [
              Checkbox(
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                value: _selectAll,
                onChanged: (value) {
                  setState(() {
                    for (var data in _filteredData) {
                      data.isSelected = value ?? false;
                    }
                    _selectAll = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
        DataColumn(label: Text(lang.registeredOn)),
        DataColumn(label: Text("Nom et Prénom")),
        DataColumn(label: Text(lang.email)),
        DataColumn(label: Text(lang.phone)),
        DataColumn(label: Text("Rôle")),
        DataColumn(label: Text(lang.status)),
        DataColumn(label: Text(lang.actions)),
      ],
      rows: _filteredData.map(
        (data) {
          return DataRow(
            color: WidgetStateColor.transparent,
            selected: data.isSelected,
            cells: [
              DataCell(
                Row(
                  children: [
                    Checkbox(
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      value: data.isSelected,
                      onChanged: (selected) {
                        setState(() {
                          data.isSelected = selected ?? false;
                          _selectAll = _filteredData.every((d) => d.isSelected);
                        });
                      },
                    ),
                  ],
                ),
              ),
              DataCell(
                Text(DateFormat('d MMM yyyy')
                    .format(data.createdAt ?? DateTime.now())),
              ),
              DataCell(
                Text('${data.firstName} ${data.lastName}'),
              ),
              DataCell(Text(data.email ?? '')),
              DataCell(Text(data.phoneNumber ?? '')),
              DataCell(Text(getUserRoleName(data.level ?? ''))),
              DataCell(
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: (data.isActive ?? false)
                        ? AcnooAppColors.kSuccess.withOpacity(0.2)
                        : AcnooAppColors.kError.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    data.isActive == true ? 'Active' : 'Inactive',
                    style: textTheme.bodySmall?.copyWith(
                      color: data.isActive == true
                          ? AcnooAppColors.kSuccess
                          : AcnooAppColors.kError,
                    ),
                  ),
                ),
              ),
              DataCell(
                PopupMenuButton(
                  color: theme.colorScheme.primaryContainer,
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Modifier')
                        ],
                      ),
                      onTap: () {
                        addOreditUser(user: data);
                      },
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('Supprimer')
                        ],
                      ),
                      onTap: () {
                        deleteUser(data);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ).toList(),
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}

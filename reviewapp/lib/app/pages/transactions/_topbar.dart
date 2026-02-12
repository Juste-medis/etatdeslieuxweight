// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';

class Topbar extends StatefulWidget {
  const Topbar({
    super.key,
    required this.scaffoldKey,
    this.showDesktop = true,
    this.selectedLayout = ProductLayoutType.tile,
    this.onLayoutSelect,
    this.perPage = 10,
    this.onPerpageChange,
    this.onFilterChange,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showDesktop;
  final ProductLayoutType selectedLayout;
  final void Function(ProductLayoutType value)? onLayoutSelect;
  final int perPage;
  final void Function(int? value)? onPerpageChange;

  final void Function(String? value)? onFilterChange;

  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  //--------------------Search Field Props--------------------//
  late final searchFieldFocus = FocusNode();

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return _buildMobileFilter(context);
  }

  Widget _buildSearchField(BuildContext context) {
    return editUserField(
      title: "Recherche",
      placeholder: "Rechercher un état des lieux",
      // clearButton: true,
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
        if (widget.onFilterChange != null) {
          widget.onFilterChange!(value);
        }
      },
      initialvalue: searchText,
      showplaceholder: true,
      // prefixIcon: const Icon(Icons.search),
      showLabel: false,
    );
  }

  Widget _buildMobileFilter(BuildContext context) {
    final _theme = Theme.of(context);

    return Material(
      color: _theme.colorScheme.primaryContainer,
      clipBehavior: Clip.antiAlias,
      borderRadius: const BorderRadiusDirectional.vertical(
        bottom: Radius.circular(4),
      ),
      child: Container(
        padding: const EdgeInsetsDirectional.all(10),
        decoration: BoxDecoration(
          color: _theme.colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
              color: _theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildSearchField(context),
      ),
    );
  }
}

enum ProductLayoutType {
  tile(icon: Icons.menu, label: 'Tile'),
  grid(icon: Icons.grid_view, label: 'Grid'),
  border(icon: Icons.window_outlined, label: 'Border');

  final IconData icon;
  final String? label;
  const ProductLayoutType({required this.icon, this.label});
}

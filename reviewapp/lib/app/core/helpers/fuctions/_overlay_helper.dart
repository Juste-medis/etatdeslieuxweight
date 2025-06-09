import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/providers/_theme_provider.dart';

class OverlayHelper {
  OverlayHelper(this.context);

  final BuildContext context;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void showOverlay({
    required Widget child,
    Offset offset = const Offset(0, 0),
  }) {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry(child: child, offset: offset);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry({
    required Widget child,
    Offset offset = const Offset(0, 0),
  }) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height) + offset,
          child: child,
        ),
      ),
    );
  }

  LayerLink get layerLink => _layerLink;
  OverlayEntry? get overlayEntry => _overlayEntry;
}

dynamic extracthings(Map<String, dynamic> formData, String property,
    AppThemeProvider wizardState) {
  final owners = [];
  formData.forEach((key, value) {
    if (key.startsWith(property)) {
      final parts = key.split('_');
      final ownerId = parts[0].replaceAll(property, '');
      final field = parts[1];
      if (owners.length <= int.parse(ownerId)) {
        owners.add({'id': ownerId});
      }
      if (value is DateTime) {
        owners[int.parse(ownerId)][field] = value.toIso8601String();
      } else {
        owners[int.parse(ownerId)][field] = "$value";
      }

      if (property == "owner") {
        owners[int.parse(ownerId)]['id'] =
            wizardState.inventoryProprietaires[int.parse(ownerId)].id;
      }
      if (property == "exittenant") {
        owners[int.parse(ownerId)]['id'] =
            wizardState.inventoryLocatairesSortant[int.parse(ownerId)].id;
      }

      if (property == "entranttenant") {
        owners[int.parse(ownerId)]['id'] =
            wizardState.inventoryLocatairesEntrants[int.parse(ownerId)].id;
      }
    }
  });
  return owners;
}

import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';

import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

class AddKeyForm extends StatefulWidget {
  final Function(dynamic text) onChanged;
  final Function(dynamic text, dynamic name) onChangedName;

  const AddKeyForm({
    super.key,
    required this.onChanged,
    required this.onChangedName,
  });

  @override
  State<AddKeyForm> createState() => _AddKeyFormState();
}

class _AddKeyFormState extends State<AddKeyForm> {
  String? selectedType;
  @override
  Widget build(BuildContext context) {
    final _lang = l.S.of(context);

    return Column(
      key: const ValueKey('addthingofkeys'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        editUserField(
          required: true,
          title: "Type de clé".tr,
          type: "select",
          layout: 'column',
          items: defaulcles,
          placeholder: "${_lang.enterThe} ${_lang.heatingMode}",
          onChanged: (text) {
            widget.onChanged(text);
            setState(() {
              selectedType = text;
            });
          },
        ),
        if (selectedType == "other")
          editUserField(
            required: true,
            title: "Nom de la clé".tr,
            type: "text",
            layout: 'column',
            placeholder: "${_lang.enterThe} ${_lang.heatingMode}",
            onChanged: (text) {
              widget.onChangedName(selectedType, text);
            },
          ),
      ],
    );
  }
}

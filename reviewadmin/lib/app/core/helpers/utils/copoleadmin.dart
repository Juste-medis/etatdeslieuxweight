// ignore_for_file: empty_catches, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/helpers.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/signature.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/network_utils.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/widgets/checkbox_form_field/_checkbox_form_field.dart';
import 'package:jatai_etadmin/generated/l10n.dart' as l;
import 'package:image_picker/image_picker.dart';
import 'package:jatai_etadmin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';

admin_title(String title, {BuildContext? context}) {
  context ??= Jks.context!;

  return Text(
    title,
    style: context.theme.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: context.theme.primaryColor,
    ),
  );
}

class RowCol extends StatelessWidget {
  final bool isLaptop;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const RowCol({
    Key? key,
    required this.isLaptop,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLaptop) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    } else {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    }
  }
}

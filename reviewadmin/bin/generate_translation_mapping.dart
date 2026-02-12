import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

void main() {
  final l10nFile = File('lib/generated/l10n.dart');

  final content = l10nFile.readAsStringSync();

  // Extract all translation keys using regex (e.g., `String get title => ...`)
  final keys = RegExp(r'String get (\w+)')
      .allMatches(content)
      .map((match) => match.group(1))
      .where((key) => key != 'localeName')
      .toList();

  // Generate the extension with dynamic key mapping
  var code = '''
// AUTO-GENERATED FILE - DO NOT EDIT
import 'package:jatai_etadmin/generated/l10n.dart' as l;
import 'package:flutter/material.dart';

extension ValueLocalization on Map<String, String> {
  Map<String, String> translatedValues(BuildContext context) {
    final t = l.S.of(context);
    return this.map((key, value) {
      switch (key) {
        ${keys.map((k) => "case '$k': return MapEntry(key, t.$k);").join('\n        ')}
        default: return MapEntry(key, value);
      }
    });
  }
}
''';

  // Save to a file
  File('lib/app/core/helpers/utils/translation_extension.dart')
      .writeAsStringSync(code);

  //-------------------------fr----------------------------

  // 1. Lire le fichier ARB français
  final arbFile = File('lib/l10n/intl_fr.arb');
  final arbContent = arbFile.readAsStringSync();
  final arbData = Map<String, dynamic>.from(json.decode(arbContent));

  // 2. Extraire les paires valeur française → clé ARB
  final translations = arbData.entries
      .where((e) => !e.key.startsWith('@'))
      .map((e) => MapEntry(e.value.toString(), e.key))
      .toList();

  // 3. Générer l'extension
  code = '''
// AUTO-GENERATED - NE PAS MODIFIER MANUELLEMENT
import 'package:jatai_etadmin/generated/l10n.dart' as l;

extension FrenchToLocalized on String {
  /// Traduit une valeur française vers la langue actuelle
  String get tr {
    switch (this) {
      ${translations.map((e) => "case '${e.key.replaceAll("'", "\\'").replaceAll(r'$', r'\$')}': return l.S.current.${e.value};").join('\n      ')}
      default: return this;
    }
  }
}
''';

  // 4. Sauvegarder
  File('lib/app/core/helpers/utils/french_translations.dart')
      .writeAsStringSync(code);
}

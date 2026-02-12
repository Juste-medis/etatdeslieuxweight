// ignore_for_file: inference_failure_on_untyped_parameter, non_constant_identifier_names, avoid_print, type_annotate_public_apis

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/app_config/app_config.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:mon_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/_inventory.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/thing_inventory.dart';
import 'package:mon_etatsdeslieux/app/providers/_theme_provider.dart';
import 'package:mon_etatsdeslieux/app/widgets/toasts/mytoast.dart';
import 'package:mon_etatsdeslieux/main.dart';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import "package:universal_html/html.dart" as html;
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, rootBundle;
import 'package:path_provider/path_provider.dart';

bool get isLoginTypeUser => appStore.loginType == LOGIN_TYPE_USER;
ThemeMode get appThemeMode =>
    appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light;

Future<void> commonLaunchUrl(
  String address, {
  LaunchMode launchMode = LaunchMode.inAppWebView,
}) async {
  await launchUrl(
    Uri.parse(address),
    mode: launchMode,
    webViewConfiguration: WebViewConfiguration(
      enableJavaScript: true,
      enableDomStorage: true,
    ),
  ).catchError((e) {
    toast('Invalid URL: $address');
    return false;
  });
}

String getActualDeviceType() {
  String deviceType = "unknown";
  if (isWeb) {
    deviceType = "web";
  }

  // Mobile platforms
  if (isAndroid) deviceType = "android";
  if (isIOS) deviceType = "ios";

  // Desktop platforms
  if (isMacOS) deviceType = "macos";
  if (isWindows) deviceType = "windows";
  if (isLinux) deviceType = "linux";

  // Other runtimes
  if (isGoogle && !isAndroid) deviceType = "google_os";

  // Fallback to OS name when available
  final os = operatingSystemName;
  deviceType = os.isNotEmpty ? os.toLowerCase() : "unknown";

  return "$deviceType-$operatingSystemVersion";
}

bool checksortantnewaddress(Review review) {
  bool hasNewAddress = true;
  for (final l in review.exitenants ?? []) {
    if (l.meta == null ||
        l.meta!["new_address"] == null ||
        l.meta!["new_address"] == "") {
      hasNewAddress = false;
      break;
    }
  }
  return hasNewAddress;
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS) {
      commonLaunchUrl(
        'tel://${url!}',
        launchMode: LaunchMode.externalApplication,
      );
    } else {
      commonLaunchUrl(
        'tel:${url!}',
        launchMode: LaunchMode.externalApplication,
      );
    }
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(
      GOOGLE_MAP_PREFIX + url!,
      launchMode: LaunchMode.externalApplication,
    );
  }
}

void launchMail(String url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('$MAIL_TO$url', launchMode: LaunchMode.externalApplication);
  }
}

void show_common_toast(String? text, BuildContext context) {
  AwfulToast.show(
    context: context,
    message: "$text",
    textColor: Colors.red,
    fontSize: 12,
    icon: Icons.warning_amber_rounded,
    duration: const Duration(seconds: 5),
    blinking: true,
  );
}

/// Partage tout-en-un: texte, lien et/ou fichiers (via share_plus).
Future<void> shareAny({
  BuildContext? context,
  String? text,
  String? subject,
  String? url,
  String? message,
  List<String>? filePaths,
}) async {
  try {
    final origin = _shareOriginFromContext(context);

    // Construit le message final
    final parts = <String>[];
    if ((text ?? '').trim().isNotEmpty) parts.add(text!.trim());
    if ((message ?? '').trim().isNotEmpty) parts.add(message!.trim());
    if ((url ?? '').trim().isNotEmpty) parts.add(url!.trim());
    final combined = parts.join('\n');

    // Construit la liste de fichiers
    final files = (filePaths ?? [])
        .where((p) => (p).trim().isNotEmpty)
        .map((p) => XFile(p))
        .toList();

    if (files.isNotEmpty) {
      await SharePlus.instance.share(
        ShareParams(
          files: files,
          text: combined.isNotEmpty ? combined : null,
          subject: subject,
          sharePositionOrigin: origin,
        ),
      );
    } else {
      if (combined.isEmpty) {
        my_print_err('Rien à partager.');
        return;
      }
      await Share.share(
        combined,
        subject: subject,
        sharePositionOrigin: origin,
      );
    }
  } catch (e) {
    my_print_err('Erreur de partage: $e');
  }
}

/// Alias: partage de texte (avec sujet optionnel).
Future<void> shareTextData(
  BuildContext? context,
  String text, {
  String? subject,
}) {
  return shareAny(context: context, text: text, subject: subject);
}

/// Alias: partage d’un lien (message et sujet optionnels).
Future<void> shareLinkData(
  BuildContext? context,
  String url, {
  String? subject,
  String? message,
}) {
  return shareAny(
    context: context,
    url: url,
    message: message,
    subject: subject,
  );
}

/// Alias: partage de fichiers (avec texte/sujet optionnels).
Future<void> shareFilesData(
  BuildContext? context,
  List<String> filePaths, {
  String? text,
  String? subject,
}) {
  return shareAny(
    context: context,
    filePaths: filePaths,
    text: text,
    subject: subject,
  );
}

/// Calcule la zone d’ancrage du popup de partage (utile iPad).
Rect? _shareOriginFromContext(BuildContext? context) {
  try {
    if (context == null) return null;
    final obj = context.findRenderObject();
    if (obj is RenderBox) {
      final offset = obj.localToGlobal(Offset.zero);
      return offset & obj.size;
    }
  } catch (_) {}
  return null;
}

void show_success_toast(String? text, BuildContext context) {
  AwfulToast.show(
    context: context,
    message: "$text",
    toastType: ToastType.success,
    fontSize: 12,
    icon: Icons.warning_amber_rounded,
    duration: const Duration(seconds: 5),
    blinking: true,
  );
}

InputDecoration inputDecoration(
  BuildContext context, {
  String? labelText,
  String? hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Color? fillColor,
  double borderRadius = 8.0,
  bool isDense = true,
  bool floatingLabel = true,
  EdgeInsetsGeometry? contentPadding,
  Color? focusedBorderColor,
  String? errorText,
  int? errorMaxLines,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  // Default colors
  final defaultFillColor = isDark
      ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.5)
      : gray.withOpacity(0.1);

  final defaultFocusColor = theme.colorScheme.primary;
  final defaultErrorColor = theme.colorScheme.error;
  //thee text color is set with labelStyle and hintStyle
  return InputDecoration(
    // Content
    labelText: labelText,
    hintText: hintText,
    alignLabelWithHint: true,
    floatingLabelBehavior: floatingLabel
        ? FloatingLabelBehavior.auto
        : FloatingLabelBehavior.never,

    // Icons
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    prefixIconConstraints: const BoxConstraints(minWidth: 40, maxHeight: 24),
    suffixIconConstraints: const BoxConstraints(minWidth: 40, maxHeight: 24),

    // Layout
    isDense: isDense,
    contentPadding:
        contentPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

    // Borders
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: focusedBorderColor ?? defaultFocusColor,
        width: 1.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: defaultErrorColor, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: defaultErrorColor, width: 1.5),
    ),

    // Colors
    filled: true,
    fillColor: fillColor ?? defaultFillColor,
    hoverColor: theme.colorScheme.primary.withOpacity(0.05),

    // Label styles
    labelStyle: theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.6),
    ),
    hintStyle: theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withOpacity(0.4),
    ),
    floatingLabelStyle: theme.textTheme.bodyMedium?.copyWith(
      color: focusedBorderColor ?? defaultFocusColor,
    ),

    // Error handling
    errorText: errorText,
    errorMaxLines: errorMaxLines ?? 2,
    errorStyle: theme.textTheme.bodySmall?.copyWith(color: defaultErrorColor),
  );
}

InputDecoration inputDecoration2(
  BuildContext context, {
  Widget? prefixIcon,
  String? labelText,
  double? borderRadius,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(
      left: 12,
      bottom: 10,
      top: 10,
      right: 10,
    ),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius != null
          ? radius(borderRadius)
          : BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.grey, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: borderRadius != null
          ? radius(borderRadius)
          : BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.grey, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: borderRadius != null
          ? radius(borderRadius)
          : BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius != null
          ? radius(borderRadius)
          : BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.grey, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(width: 20),
    ),
  );
}

// String parseHtmlString(String? htmlString) {
//   return parse(parse(htmlString).body!.text).documentElement!.text;
// }

String formatDate(
  String? dateTime, {
  String format = DATE_FORMAT_3,
  bool isFromMicrosecondsSinceEpoch = false,
}) {
  if (isFromMicrosecondsSinceEpoch) {
    return DateFormat(format, "fr_FR").format(
      DateTime.fromMicrosecondsSinceEpoch(dateTime.validate().toInt() * 1000),
    );
  } else {
    return DateFormat(
      format,
      "fr_FR",
    ).format(DateTime.parse(dateTime.validate()));
  }
}

String formatPassDate(
  String? dateTime, {
  String format = DATE_FORMAT_1,
  bool isFromMicrosecondsSinceEpoch = false,
}) {
  // Il y a 5 minutes/sec/jours/heures/mois/ans
  if (isFromMicrosecondsSinceEpoch) {
    return DateFormat(format, "fr_FR").format(
      DateTime.fromMicrosecondsSinceEpoch(dateTime.validate().toInt() * 1000),
    );
  } else {
    DateTime tempDate = DateTime.parse(dateTime.validate());
    Duration diff = DateTime.now().difference(tempDate);

    if (diff.inSeconds < 60) {
      return 'Il y a ${diff.inSeconds} seconde${diff.inSeconds > 1 ? 's' : ''}';
    } else if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''}';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours} heure${diff.inHours > 1 ? 's' : ''}';
    } else {
      return formatDate(dateTime, format: format);
    }
  }
}

int getAge(DateTime selecteddate) {
  return ((DateTime.now().difference(selecteddate).inDays) / 365.2425)
      .truncate();
}

String getEllipsisText(String text, {int maxLength = 15}) {
  if (text.length > maxLength) {
    return '${text.substring(0, maxLength)}...';
  } else {
    return text;
  }
}

final _random = Random();

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String formatTimedecount(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

/// Generates a positive random integer uniformly distributed on the range
/// from [min], inclusive, to [max], exclusive.
int my_Random(int min, int max) => min + _random.nextInt(max - min);

// Random string generator
String getRandomString(int length) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random();
  return List.generate(
    length,
    (index) => chars[rand.nextInt(chars.length)],
  ).join();
}

// Random address example
String getRandomAddress() {
  if (kReleaseMode) return "";
  List<String> streets = ['Main St', 'Highway Rd', 'Palm Ave', 'Elm St'];
  int number = Random().nextInt(999) + 1;
  String street = streets[Random().nextInt(streets.length)];
  return '$number $street';
}

// Random date (e.g., between 2010 and 2025)
String? getRandomDate() {
  if (kReleaseMode) return null;

  final random = Random();
  int year = 2010 + random.nextInt(16); // 2010–2025
  int month = 1 + random.nextInt(12);
  int day = 1 + random.nextInt(28); // avoid invalid dates
  return DateFormat('dd/MM/yyyy').format(DateTime(year, month, day)).toString();
}

double my_DoubleRandom(int min, int max) => min + _random.nextDouble() * max;

//bb is the bounding box, (ix,iy) are its top-left coordinates,
//and (ax,ay) its bottom-right coordinates. p is the point and (x,y)
//its coordinates.
//bbox = min Longitude , min Latitude , max Longitude , max Latitude
//[1.86735, -1.93359, 3.43099, 9.257474]

double generateBorderRadius() => Random().nextDouble() * 64;
double generateMargin() => Random().nextDouble() * 64;
Color generateColor() => Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));

// Function to check if it's an image
bool isImage(String extension) {
  // You can expand this list as needed
  return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(extension);
}

String imageUrl(var text) {
  String profil_url = """${AppConfig.baseUrl}$text""";
  return (text.startsWith("http") || text.startsWith("offline://"))
      ? text
      : profil_url;
}

String uploadUrl(var text) {
  String profil_url = """${AppConfig.baseUrl}uploads/$text""";
  return profil_url;
}

// Function to check if it's a video
bool isVideo(String extension) {
  // You can expand this list as needed
  return ['.mp4', '.mov', '.avi', '.mkv', '.flv', '.webm'].contains(extension);
}

void simulateScreenTap() {
  try {
    GestureBinding.instance.handlePointerEvent(
      const PointerDownEvent(position: Offset(0, 0)),
    );
    GestureBinding.instance.handlePointerEvent(
      const PointerUpEvent(position: Offset(0, 0)),
    );
  } catch (e) {
    my_print_err("simulateRightCenterTap error: $e");
  }
}

void simulateScreenBottomRightTap(BuildContext context) {
  try {
    Size screenSize = MediaQuery.of(context).size;
    Offset bottomRight = Offset(screenSize.width - 1, screenSize.height - 1);
    GestureBinding.instance.handlePointerEvent(
      PointerDownEvent(position: bottomRight),
    );
    GestureBinding.instance.handlePointerEvent(
      PointerUpEvent(position: bottomRight),
    );
  } catch (e) {
    my_print_err("simulateRightCenterTap error: $e");
  }
}

void simulateRightCenterTap(BuildContext context) {
  try {
    // Get the screen size
    Size screenSize = MediaQuery.of(context).size;

    // Calculate the right center position
    Offset rightCenter = Offset(screenSize.width - 1, screenSize.height / 2);

    // Simulate the PointerDown event at the right center
    GestureBinding.instance.handlePointerEvent(
      PointerDownEvent(position: rightCenter),
    );

    // Simulate the PointerUp event at the right center
    GestureBinding.instance.handlePointerEvent(
      PointerUpEvent(position: rightCenter),
    );
  } catch (e) {
    my_print_err("simulateRightCenterTap error: $e");
  }
}

String getmesssageDate(String? date) {
  if (date == null || date.isEmpty) return "";

  DateTime messageDate = DateTime.parse(date);
  DateTime today = DateTime.now();

  if (messageDate.year == today.year &&
      messageDate.month == today.month &&
      messageDate.day == today.day) {
    // Retourner uniquement l'heure si c'est aujourd'hui
    return DateFormat.jm('en_US').format(messageDate);
  } else {
    // Retourner la date complète sinon
    return DateFormat.yMMMd('en_US').add_jm().format(messageDate);
  }
}

K? getRelativeKey<K, V>(Map<K, V> map, K key, int offset) {
  List<K> keys = map.keys.toList();
  int index = keys.indexOf(key);

  int targetIndex = index + offset;
  if (targetIndex >= 0 && targetIndex < keys.length) {
    return keys[targetIndex];
  }
  return null; // Return null if no valid key at the relative position
}

T? getNextElement<T>(List<T> list, int index) {
  return (index >= 0 && index < list.length - 1) ? list[index + 1] : null;
}

T? getPrevElement<T>(List<T> list, int index) {
  if ((index - 1) < 0) {
    return list[0];
  }
  return (index >= 0) ? list[index - 1] : null;
}

void my_print(var ______________________) {
  //print('\x1B[32m${StackTrace.current}\x1B[0m');
  print('\x1B[32m$______________________\x1B[0m');
}

void my_print_err(var text) {
  print('\x1B[33m$text\x1B[0m');
}

String? documentUrl(var id, {bool jaipaye = false}) {
  if (id == null) return null;
  if (id.toString().contains("storage/emulated") ||
      id.toString().contains("mon_etatsdeslieux/")) {
    return id.toString();
  }
  String profil_url = """${AppConfig.baseUrl}file/$id""";
  return profil_url;
}

void my_inspect(var text) {
  // print('\x1B[32m${StackTrace.current}\x1B[0m');
  if (kIsWeb) {
    myprint3(text.toString());
    return;
  }
  try {
    if (isAndroid || isIOS) {
      writeToFile('inspect_log.txt', text.toString(), append: true);
      // alse the stack trace if exists
      writeToFile(
        'inspect_log.txt',
        text.stackTrace?.toString() ?? '',
        append: true,
      );
    }
  } catch (e) {
    e;
  }

  inspect(text);
}
//bb is the bounding box, (ix,iy) are its top-left coordinates,
//and (ax,ay) its bottom-right coordinates. p is the point and (x,y)
//its coordinates.
//bbox = min Longitude , min Latitude , max Longitude , max Latitude
//[1.86735, -1.93359, 3.43099, 9.257474]

String generateRandomStrings(int length) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random rnd = Random();

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );
}

int countVideos(List<String> privates) {
  return privates.where((item) => item.startsWith("fed")).length;
}

String getPlatform() {
  if (isAndroid) {
    return "android";
  } else if (isIOS) {
    return "ios";
  } else {
    return "web";
  }
}

String getthingtype(thing) {
  if (thing is Compteur) {
    return "compteur";
  } else if (thing is InventoryPiece) {
    return "piece";
  } else if (thing is InventoryAuthor) {
    return "reviewauthor";
  } else if (thing is InventoryOfThing) {
    return "thing";
  } else if (thing is InventoryAuthor) {
    return "proprietaire";
  } else if (thing is Review) {
    return "review";
  } else if (thing is CleDePorte) {
    return "cledeporte";
  } else if (thing is String) {
    return thing;
  }
  return "thing";
}

int countImages(List<String> privates) {
  return privates.where((item) => !item.startsWith("fed")).length;
}

void myprint(var text) {
  print('\x1B[33m---------------------------------------\x1B[0m');
  print('\x1B[33m$text\x1B[0m');
  print('\x1B[33m---------------------------------------\x1B[0m');
}

void myprint3(var text) {
  //en vert
  print('\x1B[32m---------------------------------------\x1B[0m');
  print('\x1B[32m$text\x1B[0m');
  print('\x1B[32m---------------------------------------\x1B[0m');
}

bool isVideofed(String text) {
  return text.contains("fed");
}

void myprintnet(var text) {
  print('\x1B[35m$text\x1B[0m');
}

void myprint2(var text) {
  print('\x1B[37m$text\x1B[0m');
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? requiredforminput(value, lang) {
  if (value == null || value.isEmpty) {
    return lang;
  }
  return null;
}

String? validateEmail(value, lang, lang2) {
  if (value == null || value.isEmpty) {
    return lang; // Message for empty email
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return lang2; // Message for invalid email format
  }
  return null;
}

String? checkpassword(value, lang, lang2) {
  if (value == null || value.isEmpty) {
    // return 'Please enter your first name';
    return lang;
  }
  if (value.length < 6) return lang2;

  return null;
}

Future<void> downloadWithHttp(
  String url, {
  String fileName = 'downloaded_file.pdf',
}) async {
  if (kIsWeb) {
    displayPdfInIframe(url, fileNAme: fileName);
    return;
  }
  try {
    // Demande de permission uniquement sur Android
    if (!await _ensureStoragePermission()) {
      print('Permission stockage refusée');
      return;
    }

    // Choix du dossier de destination par l'utilisateur
    final String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath();

    if (selectedDirectory == null) {
      print('Sélection du dossier annulée par l’utilisateur');
      return;
    }

    // Téléchargement du fichier
    final response = await http.get(
      Uri.parse(url),
      headers: buildHeaderTokens(),
    );

    if (response.statusCode != 200) {
      print('Échec du téléchargement: ${response.statusCode}');
      return;
    }

    final filePath = p.join(selectedDirectory, fileName);
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    print('Fichier enregistré dans : $filePath');

    // Ouvre le fichier téléchargé
    final openResult = await OpenFile.open(filePath);
    print('Résultat ouverture: ${openResult.message}');
  } catch (e, st) {
    print('Erreur lors du téléchargement: $e');
    print(st);
  }
}

void displayPdfInIframe(String url, {String? fileNAme = 'edl'}) async {
  try {
    if (!kIsWeb) {
      throw Exception('Cette fonction est uniquement disponible sur le web.');
    }
    // 1. Téléchargement du PDF avec les en-têtes d'authentification
    final response = await http.get(
      Uri.parse(url),
      headers: buildHeaderTokens(), // Votre fonction pour les en-têtes
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode} - Échec du téléchargement');
    }

    // Création d'un blob URL pour le téléchargement
    final blob = html.Blob([response.bodyBytes]);
    final blobUrl = html.Url.createObjectUrl(blob);

    // Création d'un lien de téléchargement invisible
    final anchor = html.AnchorElement()
      ..href = blobUrl
      ..download =
          fileNAme ??
          'document.pdf' // Nom du fichier
      ..style.display = 'none';

    // Ajout au DOM et déclenchement du clic
    html.document.body?.children.add(anchor);
    anchor.click();

    // Nettoyage
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(blobUrl);

    myprintnet('PDF prêt à être affiché dans l\'iframe avec URL: $blobUrl');
  } catch (e, stackTrace) {
    print('Erreur lors de l\'affichage du PDF: $e');
    print(stackTrace);

    rethrow; // Propage l'erreur si nécessaire
  } finally {
    // Note: Ne pas revoquer blobUrl ici car l'iframe en a encore besoin
    // Une meilleure approche serait de le faire quand l'iframe est détruit
  }
}

String getReviewExplicitName(String type, {bool reverse = false}) {
  if (reverse) {
    return type != "exit" ? "sortant" : "entran";
  }
  return type == "exit" ? "sortant" : "entran";
}

Future<bool> _ensureStoragePermission() async {
  if (Platform.isAndroid) {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      return true;
    } else {
      // Redirige vers les paramètres si refus
      await openAppSettings();
      return false;
    }
  }
  return true;
}

String getStatusText(String status) {
  switch (status) {
    case 'pending':
      return 'En attente';
    case 'approved':
      return 'Approuvé';
    case 'rejected':
      return 'Rejeté';
    case 'in_progress':
      return 'En cours';
    case 'signing':
      return 'En cours de signature';
    case 'completed':
      return 'Terminé';
    case 'draft':
      return 'A compléter';
    default:
      return status;
  }
}

String getUserTypeName(String status) {
  switch (status) {
    case 'owner':
      return 'Bailleur';
    case 'tenant':
      return 'Locataire';
    case 'admin':
      return 'Administrateur';
    case 'super_admin':
      return 'Super Administrateur';
    case 'root':
      return 'Root';
    case 'owner_representative':
      return 'Représentant du Bailleur';
    case 'tenant_representative':
      return 'Représentant du Locataire';
    case 'mandataire':
      return 'Mandataire';
    default:
      return status;
  }
}

String slugify(
  String text, {
  String delimiter = '_',
  bool lowercase = true,
  bool stripBrackets = true,
}) {
  // Initial cleanup
  String slug = text.trim();
  if (lowercase) slug = slug.toLowerCase();

  // Character replacements
  final replacements = {
    'à|á|â|ã|ä|å': 'a',
    'è|é|ê|ë': 'e',
    'ì|í|î|ï': 'i',
    'ò|ó|ô|õ|ö': 'o',
    'ù|ú|û|ü': 'u',
    'ý|ÿ': 'y',
    'ñ': 'n',
    'ç': 'c',
  };

  replacements.forEach((pattern, replacement) {
    slug = slug.replaceAll(RegExp(pattern), replacement);
  });

  // Optional: Remove content in brackets
  if (stripBrackets) {
    slug = slug.replaceAll(RegExp(r'\[.*?\]|\(.*?\)'), '');
  }

  // Final cleanup
  slug = slug
      .replaceAll(RegExp(r'[^a-z0-9\-_\s]'), '')
      .replaceAll(RegExp(r'[\s_]+'), delimiter)
      .replaceAll(RegExp('^$delimiter|$delimiter\$'), '');

  return slug;
}

List<InventoryAuthor> getReviewAllAuthors(AppThemeProvider wizardState) {
  List<InventoryAuthor> allauthors = [
    ...wizardState.inventoryLocatairesEntrants,
    ...wizardState.inventoryLocatairesSortant,
    if (!wizardState.isMandated && wizardState.mandataire?.id == null)
      ...(!Jks.reviewState.editingReview!.isThegrantedAcces()
          ? wizardState.inventoryProprietaires
          : []),
    if (wizardState.isMandated && wizardState.mandataire != null)
      wizardState.mandataire!,
  ];

  return allauthors;
}

List<InventoryAuthor> getAllProcurationAuthors(
  AppThemeProvider wizardState, {
  bool ownerOnly = false,
}) {
  List<InventoryAuthor> allauthors = [
    ...wizardState.inventoryProprietaires,
    if (!ownerOnly) ...wizardState.inventoryLocatairesEntrants,
    if (!ownerOnly) ...wizardState.inventoryLocatairesSortant,
  ];

  return allauthors;
}

bool mrv() {
  return [
    "canEditReview",
    // "canSignReview",
  ].contains(Jks.canEditReview);
}

String generateOfflineId({String? jsObjectId}) {
  if (jsObjectId != null) {
    return "local_$jsObjectId";
  }
  String randomString = getRandomString(4);
  return "offline_$randomString${UniqueKey().toString().replaceAll("[<'#>", "").trim()}";
}

bool checkUniqueKey(List<dynamic> arr, dynamic key, String label) {
  List<dynamic> values = [];
  if (key is! List) {
    for (var obj in arr) {
      if (obj[key] != null) {
        values.add(obj[key]);
      }
    }
  } else {
    for (var obj in arr) {
      for (var k in key) {
        if (obj[k] != null) {
          values.add(obj[k]);
        }
      }
    }
  }
  final uniqueValues = values.toSet();
  if (uniqueValues.length != values.length) {
    throw Exception(label);
  }
  return true;
}

void validateTenant(Map<String, dynamic> tenant) {
  if (tenant['lastname'] == null ||
      (tenant['lastname'] as String).trim().isEmpty) {
    throw Exception("Le nom de famille est requis");
  }

  if (tenant['firstname'] == null ||
      (tenant['firstname'] as String).trim().isEmpty) {
    throw Exception("Le prénom est requis");
  }

  final email = tenant['email'] ?? '';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(email)) {
    throw Exception("Format d'email invalide");
  }
  if (tenant['type'] != 'morale' && tenant['type'] != 'physique') {
    throw Exception("Type invalide");
  }
}

void validateMoralTenant(Map<String, dynamic> tenant) {
  final email = tenant['email'] ?? '';
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(email)) {
    throw Exception("Format d'email invalide");
  }
  if (tenant['type'] != 'morale' && tenant['type'] != 'physique') {
    throw Exception("Type invalide");
  }
}

void validateAutor(InventoryAuthor? author) {
  if (author == null) {
    throw Exception("Auteur invalide");
  }
  if (author.type == "morale") {
    try {
      validateTenant(author.representant?.toJson() ?? {});
    } catch (e) {
      throw e;
    }

    try {
      validateMoralTenant(author.toJson());
    } catch (e) {
      throw e;
    }
  } else {
    try {
      validateTenant(author.toJson());
    } catch (e) {
      throw e;
    }
  }
}

String generateClientId(String type) {
  return "${type}_${getRandomString(8)}_${DateTime.now().millisecondsSinceEpoch}";
}

String getmatchingRemotekey(String localkey) {
  String remotekey = localkey;
  if (Jks.remoteIds.containsKey(localkey)) {
    remotekey = Jks.remoteIds[localkey]!;
  }
  return remotekey;
}

String getState(String condition) {
  return defaultStates[condition] ?? condition;
}

String getTestingStates(String testingStage) {
  return defaultTestingStates[testingStage] ?? testingStage;
}

String getcompteurName(String type) {
  return defaulcompteurs[type]?['name'] ?? type;
}

String authorname(InventoryAuthor author) {
  String result = author.type == "morale"
      ? "${author.denomination}".capitalizeFirstLetter()
      : "${author.firstname.capitalizeFirstLetter()} ${author.lastName.capitalizeFirstLetter()}"
            .trim();

  return result.isEmpty ? "Auteur inconnu" : result;
}

String authorname2(Map<String, dynamic> author) {
  if (author['type'] == 'morale') {
    return author['denomination'] ?? '';
  } else {
    return '${author['firstname'] ?? ''} ${author['lastname'] ?? ''}'.trim();
  }
}

String getFullDate(dynamic thedate, {bool withHour = true}) {
  final dt = _parseToDateTime(thedate);
  if (dt == null) return '';

  final date = DateFormat('dd/MM/yyyy', 'fr_FR').format(dt);
  if (!withHour) return date;

  final hour = DateFormat('HH:mm', 'fr_FR').format(dt);
  return '$date à $hour';
}

DateTime? _parseToDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;

  if (v is num) {
    var ms = v.toInt();
    if (ms < 1000000000000) ms *= 1000; // seconds -> ms
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  final s = v.toString().trim();
  if (s.isEmpty) return null;

  final parsed = DateTime.tryParse(s);
  if (parsed != null) return parsed;

  final n = int.tryParse(s);
  if (n != null) {
    var ms = n;
    if (ms < 1000000000000) ms *= 1000;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  return null;
}

Future<String> assetToDataUri(String assetPath) async {
  final bytes = await rootBundle.load(assetPath);
  final b64 = base64Encode(bytes.buffer.asUint8List());
  final mime = assetPath.toLowerCase().endsWith('.png')
      ? 'image/png'
      : assetPath.toLowerCase().endsWith('.jpg') ||
            assetPath.toLowerCase().endsWith('.jpeg')
      ? 'image/jpeg'
      : 'application/octet-stream';
  return 'data:$mime;base64,$b64';
}

String uint8ListtoDataUri(Uint8List bytes, {String? mimeType}) {
  final b64 = base64Encode(bytes);
  final mime = mimeType ?? 'application/octet-stream';
  return 'data:$mime;base64,$b64';
}

String pil(String url) {
  final isOfflineImage = url.startsWith('offline://');
  if (isOfflineImage) {
    final imageObject = getJSONAsync(url.replaceFirst('offline://', ''));
    final itDataUrl = uint8ListtoDataUri(
      base64Decode(imageObject['base64'] ?? ''),
      mimeType: imageObject['mimeType'] ?? 'image/png',
    );
    return itDataUrl;
  }
  var offlinesphotos = getJSONAsync('offlinesphotos', defaultValue: {});
  if (offlinesphotos.containsKey(url)) {
    final imageObject = offlinesphotos[url];
    final itDataUrl = uint8ListtoDataUri(
      base64Decode(imageObject ?? ''),
      mimeType: 'image/png',
    );
    return itDataUrl;
  }

  return imageUrl(url);
}

void writeToFile(String fileName, String content, {bool append = false}) async {
  if (kIsWeb) {
    return;
  }
  final directory = await getExternalStorageDirectory();
  final filePath = p.join(directory!.path, fileName);
  final file = File(filePath);
  // Always end with a newline
  final data = '$content\n\n\n';

  if (append) {
    await file.writeAsString(data, mode: FileMode.append);
  } else {
    await file.writeAsString(data);
  }
}

void copyDataToClipboard(dynamic content) async {
  // get content of inspect_log.txt and copy to clipboard
  String logContent;
  if (content != null) {
    logContent = content.toString();
  } else {
    final directory = await getExternalStorageDirectory();
    final filePath = p.join(directory!.path, 'inspect_log.txt');
    final file = File(filePath);
    logContent = await file.readAsString();
  }

  await Clipboard.setData(ClipboardData(text: logContent));
  // copied successfully
}

Future<Uint8List> loadPdfFromNetwork(
  String url, {
  Map<String, String>? headers,
}) async {
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception("Impossible de charger le PDF : ${response.statusCode}");
  }
}

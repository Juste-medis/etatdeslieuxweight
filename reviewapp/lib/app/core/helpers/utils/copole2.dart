// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/helpers.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/signature.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/services/offlineStorage.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/widgets/checkbox_form_field/_checkbox_form_field.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;
import 'package:image_picker/image_picker.dart';
import 'package:mon_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Widget sourceSelect({required BuildContext context, callback}) {
  final theme = Theme.of(context);
  final primaryColor = theme.colorScheme.primary;
  if (kReleaseMode) {
    getImage(ImageSource.camera, context, callback: callback);
    return const SizedBox();
  }
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choisir une option'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera, context, callback: callback);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery, context, callback: callback);
                  },
                  icon: const Icon(Icons.photo_library),
                  label: Text('Gallery'.tr),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
  return Column(
    children: [
      Text('Select Source'.tr),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Camera Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    getImage(ImageSource.camera, context, callback: callback);
                    return Center(
                      child: const LinearProgressIndicator(
                        color: whiteColor,
                      ).paddingSymmetric(horizontal: 16),
                    );
                  },
                );
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                color: white, // Background color
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.photo_camera, size: 20, color: primaryColor),
                      1.height,
                      Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    getImage(ImageSource.gallery, context, callback: callback);
                    return const Center(
                      child: LinearProgressIndicator(color: whiteColor),
                    ).paddingSymmetric(horizontal: 16);
                  },
                );
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                color: white, // Background color
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.photo_library, size: 20, color: primaryColor),
                      1.height,
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Future<void> getImage(
  ImageSource imageSource,
  BuildContext context, {
  Function? callback,
  bool cropcircle = false,
}) async {
  try {
    if (kIsWeb) {
      await _handleWebImage(callback);
    } else {
      await _handleMobileImage(imageSource, callback);
    }
  } catch (e) {
    my_inspect(e);
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}

Future<void> _handleWebImage(Function? callback) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
    compressionQuality: 80,
  );

  if (result != null && result.files.single.bytes != null) {
    Uint8List fileBytes = result.files.single.bytes!;
    String fileName = result.files.single.name;
    String? fileExtension = extension(fileName).toLowerCase();

    // 🔧 Compression intelligente pour le web
    final compressedBytes = await _compressImageWeb(fileBytes, maxSizeKB: 1000);

    Jks.pSp!["f_type"] = "image_web";
    Jks.pSp!["f_conten"] = compressedBytes;
    Jks.pSp!["f_name"] = fileName;
    Jks.pSp!["f_extension"] = fileExtension;

    if (callback != null) callback(compressedBytes);
  }
}

Future<void> _handleMobileImage(
  ImageSource imageSource,
  Function? callback,
) async {
  final ImagePicker imagePicker = ImagePicker();

  // 📱 Paramètres optimisés selon la source
  final ImagePickerOptions options = ImagePickerOptions(
    imageQuality: 70,
    maxWidth: 1920,
    maxHeight: 1920,
  );

  XFile? image = await imagePicker.pickImage(
    source: imageSource,
    imageQuality: options.imageQuality,
    maxWidth: options.maxWidth,
    maxHeight: options.maxHeight,
  );

  if (image != null) {
    final file = File(image.path);
    var bytes = await file.readAsBytes();

    // 🔧 Compression avancée sans perte visible
    final compressedBytes = await _compressImageMobile(
      bytes,
      quality: 75,
      maxFileSizeKB: 800,
    );

    String? fileExtension = extension(image.path).toLowerCase();

    Jks.pSp!["f_type"] = "image_mobile";
    Jks.pSp!["f_conten"] = compressedBytes;
    Jks.pSp!["f_name"] = basename(image.path);
    Jks.pSp!["f_extension"] = fileExtension;

    if (callback != null) callback(compressedBytes);
  }
}

// 🎯 **Compression Intelligente pour Web**
Future<Uint8List> _compressImageWeb(
  Uint8List originalBytes, {
  int maxSizeKB = 500,
  int maxWidth = 1920,
}) async {
  try {
    // Décoder l'image
    final image = img.decodeImage(originalBytes);
    if (image == null) return originalBytes;

    // Redimensionner si nécessaire
    final resizedImage = _resizeImageIfNeeded(image, maxWidth: maxWidth);

    // Encoder en JPEG/PNG avec qualité optimisée
    final compressedBytes = _encodeWithOptimalFormat(
      resizedImage,
      maxSizeKB: maxSizeKB,
    );
    _logCompressionStats(
      originalBytes,
      compressedBytes,
      "Intelligent Web Compression",
    );
    return compressedBytes;
  } catch (e) {
    // Fallback: compression basique
    return _basicCompression(originalBytes, maxSizeKB: maxSizeKB);
  }
}

// 📱 **Compression Avancée pour Mobile**
Future<Uint8List> _compressImageMobile(
  Uint8List originalBytes, {
  int quality = 80,
  int maxFileSizeKB = 500,
}) async {
  if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return originalBytes;
  }
  try {
    // Vérifier la taille actuelle
    final currentSizeKB = originalBytes.lengthInBytes ~/ 1024;

    if (currentSizeKB <= maxFileSizeKB) return originalBytes;

    // Décoder l'image
    final image = img.decodeImage(originalBytes);
    if (image == null) return originalBytes;

    // Redimensionner progressivement jusqu'à atteindre la taille cible
    Uint8List compressedBytes = originalBytes;
    int currentQuality = quality;
    double scaleFactor = 1.0;

    while (compressedBytes.lengthInBytes ~/ 1024 > maxFileSizeKB &&
        currentQuality > 40) {
      final resizedImage = _resizeImageProportional(
        image,
        scaleFactor: scaleFactor,
      );
      compressedBytes = img.encodeJpg(resizedImage, quality: currentQuality);

      // Ajustements progressifs
      currentQuality -= 5;
      scaleFactor *= 0.9;
    }
    _logCompressionStats(
      originalBytes,
      compressedBytes,
      "Advanced Mobile Compression",
    );
    return compressedBytes;
  } catch (e) {
    // Fallback: utiliser la compression native

    return _basicCompression(originalBytes, maxSizeKB: maxFileSizeKB);
  }
}

// 🖼️ **Redimensionnement Intelligent**
img.Image _resizeImageIfNeeded(img.Image image, {int maxWidth = 1920}) {
  if (image.width <= maxWidth) return image;

  final ratio = image.height / image.width;
  final targetHeight = (maxWidth * ratio).round();

  return img.copyResize(
    image,
    width: maxWidth,
    height: targetHeight,
    interpolation: img.Interpolation.cubic, // ✅ Meilleure qualité
  );
}

img.Image _resizeImageProportional(
  img.Image image, {
  double scaleFactor = 1.0,
}) {
  final newWidth = (image.width * scaleFactor).round();
  final newHeight = (image.height * scaleFactor).round();

  return img.copyResize(
    image,
    width: newWidth.clamp(300, image.width), // ✅ Taille minimale
    height: newHeight.clamp(300, image.height),
    interpolation: img.Interpolation.cubic,
  );
}

// 🎨 **Encodage Format Optimal**
Uint8List _encodeWithOptimalFormat(img.Image image, {int maxSizeKB = 500}) {
  Uint8List compressedBytes;
  int currentQuality = 90;

  do {
    compressedBytes = img.encodeJpg(image, quality: currentQuality);

    currentQuality -= 10;
  } while (compressedBytes.lengthInBytes ~/ 1024 > maxSizeKB &&
      currentQuality > 40);
  _logCompressionStats(
    img.encodeJpg(image),
    compressedBytes,
    "Optimal Format Encoding",
  );
  return compressedBytes;
}

// 🔄 **Compression de Base (Fallback)**
Future<Uint8List> _basicCompression(
  Uint8List originalBytes, {
  int maxSizeKB = 500,
  int stepQuality = 5,
}) async {
  Uint8List compressedBytes = originalBytes;
  int quality = 90;

  while (compressedBytes.lengthInBytes ~/ 1024 > maxSizeKB && quality > 40) {
    try {
      final image = img.decodeImage(compressedBytes);
      if (image != null) {
        compressedBytes = img.encodeJpg(image, quality: quality);
      }
    } catch (e) {
      break;
    }
    quality -= stepQuality;
  }
  _logCompressionStats(originalBytes, compressedBytes, "Basic Compression");
  return compressedBytes;
}

// ⚙️ **Configuration de Compression**
class ImagePickerOptions {
  final int imageQuality;
  final double maxWidth;
  final double maxHeight;

  const ImagePickerOptions({
    this.imageQuality = 80,
    this.maxWidth = 1920,
    this.maxHeight = 1920,
  });
}

// 📊 **Utilitaires de Debug**
void _logCompressionStats(
  Uint8List original,
  Uint8List compressed,
  String context,
) {
  final originalSize = original.lengthInBytes ~/ 1024;
  final compressedSize = compressed.lengthInBytes ~/ 1024;
  final ratio = ((1 - compressedSize / originalSize) * 100).toStringAsFixed(1);

  myprint3('📸 $context: ${originalSize}KB → ${compressedSize}KB (-$ratio%)');
}

// Widget parent qui gère l'état partagé
class GalleryProvider extends InheritedWidget {
  final String currentItem;

  const GalleryProvider({
    super.key,
    required this.currentItem,
    required super.child,
  });

  static GalleryProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GalleryProvider>();
  }

  @override
  bool updateShouldNotify(GalleryProvider oldWidget) {
    return currentItem != oldWidget.currentItem;
  }
}

// Usage dans le parent

class JataiGalleryImageCard extends StatefulWidget {
  const JataiGalleryImageCard({
    super.key,
    this.thingtype,
    this.height,
    this.width,
    required this.item,
    required this.onDelete,
  });
  final dynamic thingtype;
  final String item;
  final VoidCallback onDelete;
  final double? height;
  final double? width;

  @override
  State<JataiGalleryImageCard> createState() => JataiGalleryImageCardState();
}

class JataiGalleryImageCardState extends State<JataiGalleryImageCard> {
  bool isHovering = false;

  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return MouseRegion(
      key: Key("mouse_region_${widget.item}"),
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onLongPress: () {
          showSimpleDialog(
            context: context,
            child: ElevatedButton(
              onPressed: () {
                Jks.pSp!["f_conten"] = widget.item;
                Jks.pSp!["f_type"] = "image";
                showConfirmDialog(
                  context,
                  "êtes-vous sûr de vouloir supprimer cette image ?".tr,
                  negativeText: "Non".tr,
                  positiveText: "Oui".tr,
                ).then((value) async {
                  //attendre 2 s et simulateScreenTap
                  Future.delayed(
                    const Duration(milliseconds: 500),
                  ).then((value) => simulateScreenTap());

                  if (value != null && value == true) {
                    uploadFile(
                      null,
                      deleteid: widget.item,
                      thing: widget.thingtype,
                      cb: () {
                        widget.onDelete();
                      },
                    );
                  }
                });
              },
              child: Text("Supprimer l'image".tr),
            ),
          );
        },
        onTap: () => showImageViewer(
          context,
          widget.item,
          useSafeArea: true,
          swipeDismissible: true,
          doubleTapZoomable: true,
          barrierColor: Colors.black.withOpacity(0.75),
        ),
        child: Material(
          color: _theme.colorScheme.primaryContainer,
          elevation: isHovering ? 4.75 : 0,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: cachedGetImageType(
                  widget.item,
                  height: widget.height,
                  width: widget.width,
                  fit: BoxFit.cover,
                ),
              ),
              if (isHovering)
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.225),
                      BlendMode.overlay,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Voir".tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: _theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: _theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isHovering)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      Jks.pSp!["f_conten"] = widget.item;
                      Jks.pSp!["f_type"] = "image";
                      showConfirmDialog(
                        context,
                        "êtes-vous sûr de vouloir supprimer cette image ?".tr,
                        negativeText: "Non".tr,
                        positiveText: "Oui".tr,
                      ).then((value) {
                        if (value != null && value == true) {
                          uploadFile(
                            null,
                            deleteid: widget.item,
                            thing: widget.thingtype,
                            cb: () {
                              widget.onDelete();
                            },
                          );
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: _theme.colorScheme.primary.withOpacity(
                        0.75,
                      ),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void showImageViewer(
  BuildContext context,
  String imageUrl, {
  bool useSafeArea = true,
  bool swipeDismissible = true,
  bool doubleTapZoomable = true,
  Color barrierColor = const Color(0xAA000000),
}) {
  showDialog(
    context: context,
    barrierColor: barrierColor,
    builder: (context) => SafeArea(
      top: useSafeArea,
      bottom: useSafeArea,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        onVerticalDragEnd: swipeDismissible
            ? (details) => Navigator.pop(context)
            : null,
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: cachedGetImageType(
              imageUrl,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
        ),
      ),
    ),
  );
}

class _ReviewTypeOption extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ReviewTypeOption({
    required this.theme,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: theme.colorScheme.primary),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectReviewType extends StatefulWidget {
  const SelectReviewType({super.key});

  @override
  State<SelectReviewType> createState() => _SelectReviewTypeState();
}

class _SelectReviewTypeState extends State<SelectReviewType> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool? _copyFromExisting;
  String? _selectedReviewType;
  String? copyErrorText;
  Review? _choosedReview;
  final TextEditingController _searchController = TextEditingController();
  List<Review> _filteredReviews = [];
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    _filteredReviews = Jks.reviewState.reviews;
  }

  @override
  void dispose() {
    _searchController.dispose();

    _pageController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep++);
  }

  void _goToPreviousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 520,
            minHeight: _selectedReviewType == null
                ? MediaQuery.of(context).size.height * 0.2
                : MediaQuery.of(context).size.height * 0.5,
          ),
          child: Center(
            child: SizedBox(
              height: _selectedReviewType == null
                  ? 320
                  : MediaQuery.of(context).size.height *
                        ((_copyFromExisting ?? false) ? 0.75 : 0.62),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang.selectreviewtype,
                          style: _theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Entrance Review Option
                            _ReviewTypeOption(
                              theme: _theme,
                              title: lang.entrance,
                              icon: Icons.login,
                              onTap: () {
                                setState(
                                  () => _selectedReviewType = "entrance",
                                );
                                _goToNextStep();
                              },
                            ),
                            _ReviewTypeOption(
                              theme: _theme,
                              title: lang.exitreview,
                              icon: Icons.logout,
                              onTap: () {
                                setState(() => _selectedReviewType = "exit");
                                _goToNextStep();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          lang.pleaseselecttype,
                          style: _theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Préremplir l'état des lieux ?".tr,
                          style: _theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                        10.height,
                        Text(
                          "Gagnez du temps en reprenant les informations d'un état des lieux réalisé précédemment avec jatai."
                              .tr,
                          style: _theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        15.height,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: 5),
                            _OptionCard(
                              title: "Créer un état des lieux vierge",
                              description: "",
                              icon: Icons.add,
                              isSelected: _copyFromExisting == false,
                              onTap: () {
                                setState(() => _copyFromExisting = false);
                              },
                              theme: _theme,
                              thevalue: "create",
                            ),
                            _OptionCard(
                              title: "Copier un état des lieux",
                              description:
                                  "Les informations copiées pourront être modifiées par la suite.",
                              icon: Icons.add,
                              isSelected: _copyFromExisting == true,
                              errorText: _copyFromExisting == true
                                  ? copyErrorText
                                  : null,
                              onTap: () {
                                setState(() {
                                  setState(() => _copyFromExisting = true);
                                  copyErrorText = null;
                                });
                              },
                              theme: _theme,
                              thevalue: "copy",
                              subWidget: _copyFromExisting != true
                                  ? null
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        if (_choosedReview != null)
                                          Text(
                                            _choosedReview!
                                                    .propertyDetails
                                                    ?.address ??
                                                'Adresse non disponible',
                                            style: _theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        SizedBox(
                                          height: _choosedReview != null
                                              ? 8
                                              : 0,
                                        ),
                                        if (_choosedReview == null)
                                          const SizedBox(height: 8),
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            elevation: 0,
                                            side: BorderSide(
                                              color: _theme.colorScheme.primary,
                                            ),
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  context
                                                          .theme
                                                          .colorScheme
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey[900]
                                                  : Colors.white,
                                              constraints: BoxConstraints(
                                                minHeight:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.7,
                                              ),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            16,
                                                          ),
                                                        ),
                                                  ),
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder:
                                                      (
                                                        BuildContext context,
                                                        StateSetter
                                                        setModalState,
                                                      ) {
                                                        return Column(
                                                          children: [
                                                            Text(
                                                              "Sélectionnez un état des lieux existant à copier"
                                                                  .tr,
                                                              style: _theme
                                                                  .textTheme
                                                                  .titleLarge
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ).paddingSymmetric(
                                                              horizontal: 16,
                                                              vertical: 8,
                                                            ),
                                                            TextField(
                                                              onChanged: (value) => setModalState(() {
                                                                _searchQuery =
                                                                    _searchController
                                                                        .text
                                                                        .toLowerCase();
                                                                _filteredReviews =
                                                                    (Jks.reviewState.reviews
                                                                            as List<
                                                                              Review
                                                                            >)
                                                                        .where((
                                                                          review,
                                                                        ) {
                                                                          final address =
                                                                              review.propertyDetails?.address?.toLowerCase() ??
                                                                              '';
                                                                          return address.contains(
                                                                            _searchQuery,
                                                                          );
                                                                        })
                                                                        .toList();
                                                              }),
                                                              controller:
                                                                  _searchController,
                                                              decoration: InputDecoration(
                                                                prefixIcon:
                                                                    const Icon(
                                                                      Icons
                                                                          .search,
                                                                    ),
                                                                hintText:
                                                                    'Rechercher par adresse...',
                                                                border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                                contentPadding:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                              ),
                                                            ).paddingSymmetric(
                                                              horizontal: 16,
                                                              vertical: 8,
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  (_filteredReviews
                                                                      .isEmpty)
                                                                  ? Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                            24,
                                                                          ),
                                                                      child: Column(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.search_off,
                                                                            size:
                                                                                48,
                                                                            color:
                                                                                Colors.grey[400],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                16,
                                                                          ),
                                                                          Text(
                                                                            _searchQuery.isEmpty
                                                                                ? 'Aucun état des lieux disponible'
                                                                                : 'Aucun résultat pour "$_searchQuery"',
                                                                            style: _theme.textTheme.bodyMedium?.copyWith(
                                                                              color: Colors.grey[600],
                                                                            ),
                                                                          ),
                                                                          if (_searchQuery
                                                                              .isNotEmpty)
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                _searchController.clear();
                                                                              },
                                                                              child: const Text(
                                                                                'Réinitialiser la recherche',
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : ListView.builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      itemCount:
                                                                          _filteredReviews
                                                                              .length,
                                                                      itemBuilder:
                                                                          (
                                                                            context,
                                                                            index,
                                                                          ) {
                                                                            final review =
                                                                                _filteredReviews[index];
                                                                            return ListTile(
                                                                              contentPadding: const EdgeInsets.symmetric(
                                                                                horizontal: 16,
                                                                                vertical: 8,
                                                                              ),
                                                                              leading: Icon(
                                                                                review.reviewType ==
                                                                                        'entrance'
                                                                                    ? Icons.login
                                                                                    : Icons.logout,
                                                                                color: _theme.colorScheme.primary,
                                                                              ),
                                                                              title: Text(
                                                                                review.propertyDetails?.address ??
                                                                                    'Adresse non disponible',
                                                                                style: _theme.textTheme.bodyMedium?.copyWith(
                                                                                  fontSize: 14,
                                                                                  color: Colors.grey[600],
                                                                                ),
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                              trailing: Icon(
                                                                                Icons.chevron_right,
                                                                                color: _theme.colorScheme.primary,
                                                                              ),
                                                                              onTap: () {
                                                                                setState(
                                                                                  () {
                                                                                    _choosedReview = review;
                                                                                    copyErrorText = null;
                                                                                    _copyFromExisting = true;
                                                                                  },
                                                                                );
                                                                                Navigator.pop(
                                                                                  context,
                                                                                  review,
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                    ),
                                                            ),
                                                          ],
                                                        ).paddingSymmetric(
                                                          horizontal: 16,
                                                          vertical: 16,
                                                        );
                                                      },
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            _choosedReview != null
                                                ? Icons.swap_horiz
                                                : Icons.upload_file,
                                          ),
                                          label: Text(
                                            _choosedReview != null
                                                ? "changer l'état des lieux".tr
                                                : 'Choisir un état des lieux'
                                                      .tr,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        if (copyErrorText != null && _copyFromExisting == null)
                          Text(
                            copyErrorText!,
                            style: _theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                _selectedReviewType = null;
                                _goToPreviousStep();
                              },
                              child: Text("Retour".tr),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_copyFromExisting == null) {
                                  setState(
                                    () => copyErrorText =
                                        "Veuillez sélectionner une option".tr,
                                  );
                                  return;
                                }
                                if (_copyFromExisting == true) {
                                  if (_choosedReview == null) {
                                    setState(
                                      () => copyErrorText =
                                          "Veuillez choisir un état des lieux"
                                              .tr,
                                    );
                                    return;
                                  }
                                } else {
                                  Navigator.pop(context, {
                                    "type": _selectedReviewType,
                                  });
                                  return;
                                }
                                _goToNextStep();
                              },
                              child: Text("Suivant".tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Step 2: Conditional content based on previous choice
                  if (_copyFromExisting == true)
                    _CopyOptionsStep(
                      theme: _theme,
                      onBack: _goToPreviousStep,
                      onComplete: (selectedOptions) {
                        Navigator.pop(context, {
                          'copyFromExisting': true,
                          'copyOptions': selectedOptions,
                          "reviewId": _choosedReview?.id,
                          "type": _selectedReviewType,
                        });
                      },
                    ),
                ],
              ).paddingAll(12),
            ),
          ),
        ),
      ),
    );
  }
}

class _CopyOptionsStep extends StatefulWidget {
  final ThemeData theme;
  final VoidCallback onBack;
  final Function(List<String>) onComplete;

  const _CopyOptionsStep({
    required this.theme,
    required this.onBack,
    required this.onComplete,
  });

  @override
  State<_CopyOptionsStep> createState() => _CopyOptionsStepState();
}

class _CopyOptionsStepState extends State<_CopyOptionsStep> {
  final List<String> _selectedOptions = [
    "pieces",
    "compteurs",
    "states",
    if (Jks.isNetworkAvailable) "photos",
  ];

  void _toggleOption(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quelles informations souhaitez-vous copier ?".tr,
            style: widget.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Sélectionnez les informations que vous souhaitez copier depuis l'état des lieux précédent. Vous pourrez les modifier par la suite."
                .tr,
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // List of copy options
          _CopyOptionItem(
            title: "Pièces et élements",
            isSelected: _selectedOptions.contains('pieces'),
            onTap: () => _toggleOption('pieces'),
          ),
          _CopyOptionItem(
            title: "Etat des dégradations des éléments",
            isSelected: _selectedOptions.contains('states'),
            onTap: () => _toggleOption('states'),
          ),
          _CopyOptionItem(
            title: "Compteurs",
            isSelected: _selectedOptions.contains('compteurs'),
            onTap: () => _toggleOption('compteurs'),
          ),
          _CopyOptionItem(
            title: "Clés",
            isSelected: _selectedOptions.contains('cles'),
            onTap: () => _toggleOption('cles'),
          ),
          _CopyOptionItem(
            title: "Observations générales",
            isSelected: _selectedOptions.contains('observations'),
            onTap: () => _toggleOption('observations'),
          ),
          if (Jks.isNetworkAvailable)
            _CopyOptionItem(
              title: "Photos",
              description:
                  "Copier toutes les photos de l'état des lieux choisi",
              isSelected: _selectedOptions.contains('photos'),
              onTap: () => _toggleOption('photos'),
            ),

          _CopyOptionItem(
            title: "Locataires",
            description: "Copier les informations des locataires",
            isSelected: _selectedOptions.contains('tenants'),
            onTap: () => _toggleOption('tenants'),
          ),

          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: widget.onBack, child: Text("Retour".tr)),
              ElevatedButton(
                onPressed: _selectedOptions.isEmpty
                    ? null
                    : () => widget.onComplete(_selectedOptions),
                child: Text("Suivant".tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Step 2b Widget: Choose review type (if not copying)
class _ReviewTypeSelectionStep extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onBack;
  final Function(String) onTypeSelected;

  const _ReviewTypeSelectionStep({
    required this.theme,
    required this.onBack,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            " lang.selectreviewtype",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Entrance Review Option
              _ReviewTypeOption(
                theme: theme,
                title: " lang.entrance",
                icon: Icons.login,
                onTap: () => onTypeSelected("entrance"),
              ),

              // Exit Review Option
              _ReviewTypeOption(
                theme: theme,
                title: " lang.exitreview",
                icon: Icons.logout,
                onTap: () => onTypeSelected("exit"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            " lang.pleaseselecttype",
            style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [TextButton(onPressed: onBack, child: Text("lang.back"))],
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  final String thevalue;
  final String? errorText;
  final Widget? subWidget;

  const _OptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    required this.thevalue,
    this.errorText,
    this.subWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? theme.colorScheme.primaryContainer : null,
        border: Border.all(
          color: errorText != null
              ? Colors.red
              : isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withAlpha(150),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (description.isNotEmpty) Text(description),
                    if (subWidget != null) subWidget!,
                    if (errorText != null)
                      Text(
                        errorText!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CopyOptionItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final String? description;
  const _CopyOptionItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[400]!,
          width: 4,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: description != null
            ? Text(
                description ?? "",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        value: isSelected,
        onChanged: (_) => onTap(),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

// Your existing _ReviewTypeOption widget can remain the same

Future uploadFile(
  Uint8List? image, {
  deleteid,
  updateid,
  onfinish,
  isprofile,
  isVideoparam,
  thing,
  cb,
}) async {
  final thingtype = getthingtype(thing);
  var payload = {
    "delete_id": deleteid,
    "update_id": updateid,
    "thingtype": thingtype,
    "review_id": Jks.reviewState?.editingReview?.id,
    "proccuration_id":
        Jks.proccurationState?.editingProccuration?.id ??
        Jks.wizardState.formValues['procurationId'] ??
        "",
    "${(isVideoparam ?? false) ? "video" : "image"}Id": updateid,
  };

  if (deleteid != null || image == null) {
  } else {
    if (Jks.pSp!["f_conten"] != null) {
      MultipartRequest multiPartRequest = await getMultiPartRequest(
        'upload/image/$thingtype/${thing?.id}',
      );

      multiPartRequest.files.add(
        MultipartFile.fromBytes(
          "image",
          image,
          filename: "${thing?.id}_image${Jks.pSp!["f_extension"]}",
          contentType: MediaType(
            isVideoparam ?? false ? "video" : "image",
            Jks.pSp!["f_extension"]!.replaceAll('.', ''),
          ),
        ),
      );
      if (isprofile != null) {
        multiPartRequest.fields["profile"] = "set";
      }

      multiPartRequest.fields["review_id"] =
          "${Jks.reviewState?.editingReview?.id ?? ""}";
      multiPartRequest.fields["proccuration_id"] =
          "${Jks.proccurationState?.editingProccuration?.id ?? Jks.wizardState.formValues['procurationId'] ?? ""}";
      multiPartRequest.headers.addAll(buildHeaderTokens());

      Jks.wizardState?.setloading(true);
      Jks.wizardState?.setPhotoloading(true);

      try {
        await sendMultiPartRequest(
          multiPartRequest,
          onSuccess: (data) async {
            if (data != null) {
              if ((data as String).isJson()) {
                data = json.decode(data) as Map<String, dynamic>?;
                if (cb != null) {
                  cb(data["data"]["photoUrl"]);
                  var offlinesphotos = getJSONAsync(
                    'offlinesphotos',
                    defaultValue: {},
                  );
                  offlinesphotos[data["data"]["photoUrl"]] = base64Encode(
                    image,
                  );
                  setValue('offlinesphotos', offlinesphotos);
                }
              }
            }
            Jks.wizardState?.setloading(false);
            Jks.wizardState?.setPhotoloading(false);
          },
          onError: (error) {
            myprint2(error);
            toast(error.toString(), print: true);
            Jks.wizardState?.setloading(false);
            Jks.wizardState?.setPhotoloading(false);
          },
        );
      } catch (e) {
        if (e.toString() == "no_internet") {
          try {
            var offlinePhotoUrl = await OfflineStorageService.saveOfflinePhoto(
              image,
              thingtype,
              thing?.id,
              Jks.reviewState?.editingReview?.id,
              Jks.proccurationState?.editingProccuration?.id ??
                  Jks.wizardState.formValues['procurationId'] ??
                  "",
              Jks.pSp!["f_extension"],
            );
            if (cb != null) {
              cb(offlinePhotoUrl);
            }
          } catch (err) {
            my_inspect(err);
            toast('Impossible d’enregistrer la photo hors-ligne.', print: true);
          }
        }

        Jks.wizardState?.setloading(false);
        Jks.wizardState?.setPhotoloading(false);
        my_inspect(e);
      }

      Jks.initPsp();
    }
  }

  if (isprofile == null && deleteid != null) {
    try {
      var value = await deleteImages(thingtype, payload, thing!.id);

      if (cb != null) {
        cb();
      }

      return value;
    } catch (e) {
      if (e.toString() == "no_internet") {
        try {
          await OfflineStorageService.delephoto(thingtype, payload, thing!.id);
          if (cb != null) {
            cb();
          }
        } catch (err) {
          my_inspect(err);
          toast('Impossible de supprimer la photo en hors-ligne.', print: true);
        }
      }
      appStore.setLoading(true);
      myprint(e);
    }
  }
  appStore.setLoading(false);
  if (onfinish != null) {
    onfinish();
  }
  // await Rks.update_current_user();

  // setState(() {});
}

class SignatureSection extends StatelessWidget {
  final String userkey;
  final String title;
  final String acceptText;
  final String signatureKey;
  final bool showApproval;
  final ValueChanged<bool>? onApprovalChanged;
  final GlobalKey<FormState>? formKey;
  const SignatureSection({
    super.key,
    this.formKey,
    this.acceptText = "Lu et approuvé",
    required this.title,
    required this.userkey,
    required this.signatureKey,
    this.showApproval = false,
    this.onApprovalChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "${userkey.tr} :  ",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Text(title, style: theme.textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 200,
          child: SignaturePadWidget(signatureKey, username: title),
        ),
        if (showApproval) ...[
          const SizedBox(height: 16),
          Form(
            key: formKey ?? GlobalKey<FormState>(),
            child: AcnooCheckBoxFormField(
              title: Text(acceptText),
              validator: (value) {
                // Validate the checkbox
                if (onApprovalChanged != null) {
                  onApprovalChanged!(value ?? false);
                }

                if (value == null || !value) {
                  return "Veuillez cocher la mention pour continuer".tr;
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
        ],
      ],
    );
  }
}

Widget signatureDivider() {
  final theme = Theme.of(Jks.context!);
  return Divider(
    color: theme.colorScheme.outline.withOpacity(0.5),
    thickness: 3,
    height: 32,
  );
}

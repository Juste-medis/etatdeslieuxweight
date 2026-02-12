// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
import 'package:responsive_grid/responsive_grid.dart';

Widget sourceSelect(
    {required BuildContext context, isProfilePicture = false, callback}) {
  final theme = Theme.of(context);
  final primaryColor = theme.colorScheme.primary;
  if (kReleaseMode) {
    getImage(ImageSource.camera, context, isProfilePicture, callback: callback);
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera, context, isProfilePicture,
                        callback: callback);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery, context, isProfilePicture,
                        callback: callback);
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
                    getImage(ImageSource.camera, context, isProfilePicture,
                        callback: callback);
                    return Center(
                        child: const LinearProgressIndicator(
                      color: whiteColor,
                    ).paddingSymmetric(horizontal: 16));
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
                      Icon(
                        Icons.photo_camera,
                        size: 20,
                        color: primaryColor,
                      ),
                      1.height,
                      Text(
                        'Camera',
                        style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
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
                    getImage(ImageSource.gallery, context, isProfilePicture,
                        callback: callback);
                    return const Center(
                        child: LinearProgressIndicator(
                      color: whiteColor,
                    )).paddingSymmetric(horizontal: 16);
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
                      Icon(
                        Icons.photo_library,
                        size: 20,
                        color: primaryColor,
                      ),
                      1.height,
                      Text(
                        'Gallery',
                        style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
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

Future getImage(
  ImageSource imageSource,
  BuildContext context,
  bool isProfilePicture, {
  Function? callback,
  bool cropcircle = false,
}) async {
  try {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        Uint8List fileBytes = result.files.single.bytes!;
        String fileName = result.files.single.name;

        //guess the extension
        String? fileExtension = extension(fileName).toLowerCase();

        // Stocker dans ton objet Jks si besoin
        Jks.pSp!["f_type"] = "image_web";
        Jks.pSp!["f_conten"] = fileBytes;
        Jks.pSp!["f_name"] = fileName;
        Jks.pSp!["f_extension"] = fileExtension; //.heic

        // Callback avec les bytes
        if (callback != null) callback(fileBytes);
      }
    } else {
      // 📱 Mobile: Use image_picker
      final ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: imageSource);

      if (image != null) {
        final file = File(image.path);

        var bytes = await file.readAsBytes();
        // guess the extension
        String? fileExtension = extension(image.path).toLowerCase();

        Jks.pSp!["f_type"] = "image_mobile";
        Jks.pSp!["f_conten"] = bytes;
        Jks.pSp!["f_name"] = basename(image.path);
        Jks.pSp!["f_extension"] = fileExtension;

        if (callback != null) callback(bytes); // Tu reçois un File
      }
    }
  } catch (e) {
    my_inspect(e);
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}

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
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => showImageViewer(
          context,
          imageUrl(widget.item),
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
                  child: getImageType(
                imageUrl(widget.item),
                height: widget.height,
                width: widget.width,
                fit: BoxFit.cover,
              )),
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
                              "êtes-vous sûr de vouloir supprimer cette image ?"
                                  .tr,
                              negativeText: "Non".tr,
                              positiveText: "Oui".tr)
                          .then((value) {
                        if (value != null && value == true) {
                          uploadFile(
                            null,
                            deleteid: widget.item,
                            thing: widget.thingtype,
                            cb: (data) {
                              widget.onDelete();
                            },
                          );
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          _theme.colorScheme.primary.withOpacity(0.75),
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
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 30,
              color: theme.colorScheme.primary,
            ),
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
                              fontWeight: FontWeight.w700, fontSize: 24),
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
                                    () => _selectedReviewType = "entrance");
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
                              fontSize: 15, fontWeight: FontWeight.w500),
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
                              fontWeight: FontWeight.w700, fontSize: 22),
                        ),
                        10.height,
                        Text(
                          "Gagnez du temps en reprenant les informations d'un état des lieux réalisé précédemment avec jatai."
                              .tr,
                          style: _theme.textTheme.headlineMedium
                              ?.copyWith(fontSize: 14),
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
                                                    .propertyDetails?.address ??
                                                'Adresse non disponible',
                                            style: _theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        SizedBox(
                                            height:
                                                _choosedReview != null ? 8 : 0),
                                        if (_choosedReview == null)
                                          const SizedBox(height: 8),
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            elevation: 0,
                                            side: BorderSide(
                                                color:
                                                    _theme.colorScheme.primary),
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: context
                                                          .theme
                                                          .colorScheme
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey[900]
                                                  : Colors.white,
                                              constraints: BoxConstraints(
                                                minHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.7,
                                              ),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            16)),
                                              ),
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setModalState) {
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
                                                                          .bold),
                                                        ).paddingSymmetric(
                                                          horizontal: 16,
                                                          vertical: 8,
                                                        ),
                                                        TextField(
                                                          onChanged: (value) =>
                                                              setModalState(() {
                                                            _searchQuery =
                                                                _searchController
                                                                    .text
                                                                    .toLowerCase();
                                                            _filteredReviews = (Jks
                                                                        .reviewState
                                                                        .reviews
                                                                    as List<
                                                                        Review>)
                                                                .where(
                                                                    (review) {
                                                              final address = review
                                                                      .propertyDetails
                                                                      ?.address
                                                                      ?.toLowerCase() ??
                                                                  '';
                                                              return address
                                                                  .contains(
                                                                      _searchQuery);
                                                            }).toList();
                                                          }),
                                                          controller:
                                                              _searchController,
                                                          decoration:
                                                              InputDecoration(
                                                            prefixIcon:
                                                                const Icon(Icons
                                                                    .search),
                                                            hintText:
                                                                'Rechercher par adresse...',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12),
                                                          ),
                                                        ).paddingSymmetric(
                                                            horizontal: 16,
                                                            vertical: 8),
                                                        Expanded(
                                                            child:
                                                                (_filteredReviews
                                                                        .isEmpty)
                                                                    ? Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            24),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.search_off,
                                                                              size: 48,
                                                                              color: Colors.grey[400],
                                                                            ),
                                                                            const SizedBox(height: 16),
                                                                            Text(
                                                                              _searchQuery.isEmpty ? 'Aucun état des lieux disponible' : 'Aucun résultat pour "$_searchQuery"',
                                                                              style: _theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                                                                            ),
                                                                            if (_searchQuery.isNotEmpty)
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  _searchController.clear();
                                                                                },
                                                                                child: const Text('Réinitialiser la recherche'),
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : ListView
                                                                        .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        itemCount:
                                                                            _filteredReviews.length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          final review =
                                                                              _filteredReviews[index];
                                                                          return ListTile(
                                                                            contentPadding:
                                                                                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                                            leading:
                                                                                Icon(
                                                                              review.reviewType == 'entrance' ? Icons.login : Icons.logout,
                                                                              color: _theme.colorScheme.primary,
                                                                            ),
                                                                            title:
                                                                                Text(
                                                                              review.propertyDetails?.address ?? 'Adresse non disponible',
                                                                              style: _theme.textTheme.bodyMedium?.copyWith(
                                                                                fontSize: 14,
                                                                                color: Colors.grey[600],
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            trailing:
                                                                                Icon(
                                                                              Icons.chevron_right,
                                                                              color: _theme.colorScheme.primary,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                _choosedReview = review;
                                                                                copyErrorText = null;
                                                                                _copyFromExisting = true;
                                                                              });
                                                                              Navigator.pop(context, review);
                                                                            },
                                                                          );
                                                                        },
                                                                      ))
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
                                          icon: Icon(_choosedReview != null
                                              ? Icons.swap_horiz
                                              : Icons.upload_file),
                                          label: Text(_choosedReview != null
                                              ? "changer l'état des lieux".tr
                                              : 'Choisir un état des lieux'.tr),
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
                                  setState(() => copyErrorText =
                                      "Veuillez sélectionner une option".tr);
                                  return;
                                }
                                if (_copyFromExisting == true) {
                                  if (_choosedReview == null) {
                                    setState(() => copyErrorText =
                                        "Veuillez choisir un état des lieux"
                                            .tr);
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
                        )
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
                    )
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
    "photos"
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

          _CopyOptionItem(
            title: "Photos",
            description: "Copier toutes les photos de l'état des lieux choisi",
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
              TextButton(
                onPressed: widget.onBack,
                child: Text("Retour".tr),
              ),
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
            style: theme.textTheme.bodyMedium!
                .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onBack,
                child: Text("lang.back"),
              ),
            ],
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
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
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
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: theme.colorScheme.primary),
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
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16)),
        subtitle: description != null
            ? Text(
                description ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14, color: Colors.grey[600]),
              )
            : null,
        value: isSelected,
        onChanged: (_) => onTap(),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

Future uploadFile(
  File? image, {
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
    "proccuration_id": Jks.wizardState.formValues['procurationId'] ??
        Jks.proccurationState?.editingProccuration?.id ??
        "",
    "${(isVideoparam ?? false) ? "video" : "image"}Id": updateid,
  };
  myprint(payload);

  if (deleteid != null || image == null) {
  } else {
    String fileExtension = extension(image.path).toLowerCase();

    if (!image.existsSync()) {
      toast("Image is not available", print: true);
      return;
    }

    String path = "";

    if (isImage(fileExtension)) {
      path = "image";
    } else if (isVideo(fileExtension)) {
      path = "video";
      // user["videou"] = "${data[path]["_id"]}";
    } else {
      toast("Unsupported file type: $fileExtension");
    }

    if (Jks.pSp!["f_conten"] != null) {
      MultipartRequest multiPartRequest = await getMultiPartRequest(
        'upload/$path/$thingtype/${thing?.id}',
      );

      multiPartRequest.files.add(
        await MultipartFile.fromPath(path, image.path),
      );

      if (isprofile != null) {
        multiPartRequest.fields["profile"] = "set";
      }

      multiPartRequest.fields["review_id"] =
          "${Jks.reviewState?.editingReview?.id ?? ""}";
      multiPartRequest.fields["proccuration_id"] =
          "${Jks.wizardState.formValues['procurationId'] ?? Jks.proccurationState?.editingProccuration?.id ?? ""}";
      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          if (data != null) {
            if ((data as String).isJson()) {
              data = json.decode(data) as Map<String, dynamic>?;
              // payload["${path}s"] = "${data["data"]}";
              if (cb != null) {
                cb(data["data"]["photoUrl"]);
              }
            }
          }
        },
        onError: (error) {
          myprint2(error);
          toast(error.toString(), print: true);
        },
      ).catchError((e) {
        toast(e.toString(), print: true);
      });

      Jks.initPsp();
    }
  }

  if (isprofile == null && deleteid != null) {
    try {
      var value = await updateThingImages(thingtype, payload, thing!.id);

      if (cb != null) {
        cb(value);
      }

      return value;
    } catch (e) {
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
        onVerticalDragEnd:
            swipeDismissible ? (details) => Navigator.pop(context) : null,
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(child: Image.network(imageUrl)),
        ),
      ),
    ),
  );
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

class CustomOffcanvas extends StatefulWidget {
  final Widget child;
  final double width;
  final Color backgroundColor;
  final bool showCloseButton;
  final Alignment alignment;
  final Curve animationCurve;
  final Duration animationDuration;
  final BoxShadow? shadow;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;
  final Function()? onClose;

  const CustomOffcanvas({
    Key? key,
    required this.child,
    this.width = 300,
    this.backgroundColor = Colors.white,
    this.showCloseButton = true,
    this.alignment = Alignment.centerRight,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 300),
    this.shadow,
    this.borderRadius,
    this.padding = const EdgeInsets.all(20),
    this.onClose,
  }) : super(key: key);

  @override
  _CustomOffcanvasState createState() => _CustomOffcanvasState();
}

class _CustomOffcanvasState extends State<CustomOffcanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((_) {
      if (widget.onClose != null) widget.onClose!();
      Navigator.of(Jks.context!).pop();
    });
  }

  AlignmentGeometry get _alignment {
    if (widget.alignment == Alignment.topCenter) return Alignment.topCenter;
    if (widget.alignment == Alignment.bottomCenter)
      return Alignment.bottomCenter;
    if (widget.alignment == Alignment.centerLeft) return Alignment.centerLeft;
    if (widget.alignment == Alignment.centerRight) return Alignment.centerRight;
    return widget.alignment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Backdrop
          GestureDetector(
            onTap: _close,
            child: Container(
              color: Colors.black.withOpacity(0.5 * _animation.value),
            ),
          ),

          // Offcanvas content
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double offsetX = 0;
              double offsetY = 0;

              if (widget.alignment == Alignment.centerRight) {
                offsetX = (1 - _animation.value) * widget.width;
              } else if (widget.alignment == Alignment.centerLeft) {
                offsetX = -(1 - _animation.value) * widget.width;
              } else if (widget.alignment == Alignment.topCenter) {
                offsetY = -(1 - _animation.value) *
                    MediaQuery.of(context).size.height;
              } else if (widget.alignment == Alignment.bottomCenter) {
                offsetY =
                    (1 - _animation.value) * MediaQuery.of(context).size.height;
              }

              return Transform.translate(
                offset: Offset(offsetX, offsetY),
                child: child,
              );
            },
            child: Align(
              alignment: _alignment,
              child: Container(
                width: widget.width,
                height: widget.alignment == Alignment.topCenter ||
                        widget.alignment == Alignment.bottomCenter
                    ? null
                    : double.infinity,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: widget.borderRadius ?? _defaultBorderRadius(),
                  boxShadow: [
                    widget.shadow ??
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 0),
                        ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.showCloseButton)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _close,
                        ),
                      ),
                    Expanded(child: SingleChildScrollView(child: widget.child)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius _defaultBorderRadius() {
    if (widget.alignment == Alignment.topCenter) {
      return const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      );
    } else if (widget.alignment == Alignment.bottomCenter) {
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      );
    } else if (widget.alignment == Alignment.centerLeft) {
      return const BorderRadius.only(
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      );
    } else {
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      );
    }
  }
}

void openRightOffcanvas(BuildContext context, {required Widget child}) {
  final screen = responsiveValue<double>(
    context,
    xs: 300,
    sm: 350,
    md: 400,
    lg: 500,
  );

  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => CustomOffcanvas(
        shadow: BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 2,
          offset: const Offset(0, 0),
        ),
        width: screen,
        child: child,
      ),
    ),
  );
}

void _openLeftOffcanvas(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => CustomOffcanvas(
        alignment: Alignment.centerLeft,
        backgroundColor: Colors.indigo[50]!,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            _buildListTile(Icons.home, 'Home'),
            _buildListTile(Icons.shopping_cart, 'Cart'),
            _buildListTile(Icons.favorite, 'Wishlist'),
            _buildListTile(Icons.history, 'Order History'),
            _buildListTile(Icons.settings, 'Settings'),
          ],
        ),
      ),
    ),
  );
}

void openBottomOffcanvas(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => CustomOffcanvas(
        alignment: Alignment.bottomCenter,
        width: double.infinity,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _buildListTile(Icons.share, 'Share'),
            _buildListTile(Icons.save, 'Save'),
            _buildListTile(Icons.report, 'Report'),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    ),
  );
}

ListTile _buildListTile(IconData icon, String title) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      // Handle item tap
      print('$title tapped');
    },
  );
}

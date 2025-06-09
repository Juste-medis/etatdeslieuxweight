// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/helpers.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/mylocale.dart';
import 'package:country_flags/country_flags.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:image_picker/image_picker.dart';
import 'package:jatai_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';

Widget sourceSelect(
    {required BuildContext context, isProfilePicture = false, callback}) {
  final theme = Theme.of(context);
  final primaryColor = theme.colorScheme.primary;
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

Future getImage(ImageSource imageSource, context, isProfilePicture,
    {callback, cropcircle = false}) async {
  ImagePicker imagePicker = ImagePicker();
  try {
    var image = await imagePicker.pickImage(source: imageSource);

    if (image != null) {
      Jks.pSp!["f_type"] = "image";
      Jks.pSp!["f_conten"] = image;

      callback(File(Jks.pSp!["f_conten"].path));
    }
  } catch (e) {
    my_inspect(e);
    Navigator.pop(context);
  }
}

class JataiGalleryImageCard extends StatefulWidget {
  const JataiGalleryImageCard({
    super.key,
    this.thingtype,
    required this.item,
    required this.onDelete,
  });
  final dynamic thingtype;
  final String item;
  final VoidCallback onDelete;

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
                      fit: BoxFit.cover,
                    ) ??
                    const SizedBox.square(),
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

class SelectReviewType extends StatelessWidget {
  const SelectReviewType({super.key});

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
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.selectreviewtype,
                  style: _theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Entrance Review Option
                    _ReviewTypeOption(
                      theme: _theme,
                      title: lang.entrance,
                      icon: Icons.login,
                      onTap: () {
                        Navigator.pop(context, "entrance");
                      },
                    ),

                    // Exit Review Option
                    _ReviewTypeOption(
                      theme: _theme,
                      title: lang.exitreview,
                      icon: Icons.logout,
                      onTap: () {
                        Navigator.pop(context, "exit");
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  lang.pleaseselecttype,
                  style: _theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future uploadFile(File? image,
    {deleteid, updateid, onfinish, isprofile, isVideoparam, thing, cb}) async {
  final thingtype = getthingtype(thing);
  var payload = {
    "delete_id": deleteid,
    "update_id": updateid,
    "thingtype": thingtype,
    "review_id": Jks.reviewState?.editingReview?.id,
    "${(isVideoparam ?? false) ? "video" : "image"}Id": updateid,
  };

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
      MultipartRequest multiPartRequest =
          await getMultiPartRequest('upload/$path/$thingtype/${thing?.id}');

      multiPartRequest.files
          .add(await MultipartFile.fromPath(path, image.path));

      if (isprofile != null) {
        multiPartRequest.fields["profile"] = "set";
      }

      multiPartRequest.fields["review_id"] = Jks.reviewState?.editingReview?.id;
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
          child: Center(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    ),
  );
}

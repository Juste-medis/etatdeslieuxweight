// 🐦 Flutter imports:
import 'dart:convert';

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:nb_utils/nb_utils.dart';

// 🌎 Project imports:
import '../../../widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';

Widget cachedGetImageType(
  String? imagePath, {
  double? height = 40,
  double? width = 40,
  BoxFit fit = BoxFit.contain,
  Alignment alignment = Alignment.center,
  ColorFilter? colorFilter,
}) {
  if (imagePath != null && Jks.ldImages.containsKey(imagePath)) {
    return Jks.ldImages[imagePath];
  }
  Widget result;

  if (imagePath == null || imagePath.isEmpty) return 1.width;

  final _extension = imagePath.split('.').lastOrNull?.toLowerCase();
  if (_extension == null) return 1.width;

  final isNetworkImage = imagePath.startsWith(RegExp(r'https?://'));
  final isOfflineImage = imagePath.startsWith('offline://');
  final isUploadmage = imagePath.startsWith('uploads/');
  assert(
    _extension == 'svg' || colorFilter == null,
    'ColorFilter can only be used with SVG images',
  );

  if (_extension == 'svg') {
    if (isNetworkImage) {
      result = SvgPicture.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        colorFilter: colorFilter,
      );
    } else {
      result = SvgPicture.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        colorFilter: colorFilter,
      );
    }
  }

  if (isUploadmage || isNetworkImage) {
    var offlinesphotos = getJSONAsync('offlinesphotos', defaultValue: {});
    if (offlinesphotos.containsKey(imagePath)) {
      final imageObject = offlinesphotos[imagePath];
      final bytes = base64Decode(imageObject);
      result = Image.memory(
        bytes,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
      );
    }
    imagePath = imageUrl(imagePath);

    result = CachedNetworkImage(
      imageUrl: imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  } else if (isOfflineImage) {
    final imageObject =
        getJSONAsync(imagePath.replaceFirst('offline://', '')) ?? {};
    final bytes = base64Decode(imageObject['base64'] ?? '');
    result = Image.memory(
      bytes,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  } else {
    result = Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  }
  Jks.ldImages[imagePath] = result;

  return result;
}

Widget getImageType(
  String? imagePath, {
  double? height = 40,
  double? width = 40,
  BoxFit fit = BoxFit.contain,
  Alignment alignment = Alignment.center,
  ColorFilter? colorFilter,
}) {
  if (imagePath == null || imagePath.isEmpty) return 1.width;

  final _extension = imagePath.split('.').lastOrNull?.toLowerCase();
  if (_extension == null) return 1.width;

  final isNetworkImage = imagePath.startsWith(RegExp(r'https?://'));
  final isOfflineImage = imagePath.startsWith('offline://');
  final isUploadmage = imagePath.startsWith('uploads/');
  assert(
    _extension == 'svg' || colorFilter == null,
    'ColorFilter can only be used with SVG images',
  );

  if (_extension == 'svg') {
    if (isNetworkImage) {
      return SvgPicture.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        colorFilter: colorFilter,
      );
    } else {
      return SvgPicture.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        colorFilter: colorFilter,
      );
    }
  }

  if (isUploadmage || isNetworkImage) {
    var offlinesphotos = getJSONAsync('offlinesphotos', defaultValue: {});
    if (offlinesphotos.containsKey(imagePath)) {
      final imageObject = offlinesphotos[imagePath];
      final bytes = base64Decode(imageObject);
      return Image.memory(
        bytes,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
      );
    }
    imagePath = imageUrl(imagePath);

    return CachedNetworkImage(
      imageUrl: imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  } else if (isOfflineImage) {
    final imageObject =
        getJSONAsync(imagePath.replaceFirst('offline://', '')) ?? {};
    final bytes = base64Decode(imageObject['base64'] ?? '');
    return Image.memory(
      bytes,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  } else {
    return Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  }
}

class AnimageWidget extends StatelessWidget {
  const AnimageWidget({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.colorFilter,
  });

  final String? imagePath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Alignment alignment;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    if (imagePath == null || (imagePath?.isEmpty == true)) {
      return ColoredBox(color: _theme.colorScheme.tertiaryContainer);
    }

    final _imagePath = imagePath!;
    final _extension = _imagePath.split('.').last.toLowerCase();
    final _isNetworkImage = _imagePath.startsWith(RegExp(r'https?://'));
    assert(
      _extension == 'svg' || colorFilter == null,
      'ColorFilter can only be used with SVG images',
    );

    if (_extension == 'svg') {
      if (_isNetworkImage) {
        return SvgPicture.network(
          _imagePath,
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
        );
      } else {
        return SvgPicture.asset(
          _imagePath,
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
        );
      }
    }

    if (_isNetworkImage) {
      return Image.network(
        _imagePath,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        loadingBuilder: (ctx, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return _buildLoadingPlaceholder(context);
        },
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: _theme.colorScheme.errorContainer,
            child: SizedBox(
              height: height,
              width: width,
              child: const Icon(Icons.broken_image),
            ),
          );
        },
      );
    }

    return Image.asset(
      _imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  }
}

Widget _buildLoadingPlaceholder(BuildContext context) {
  final _theme = Theme.of(context);
  return ShimmerPlaceholder(
    decoration: BoxDecoration(color: _theme.colorScheme.surfaceContainer),
  );
}

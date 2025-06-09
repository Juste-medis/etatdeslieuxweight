import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

Future<bool?> showAwesomeConfirmDialog(
    {required BuildContext context,
    required String title,
    String? description,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    Color? cancelColor,
    IconData? confirmIcon,
    IconData? cancelIcon,
    bool barrierDismissible = true,
    bool forceHorizontalButtons = false,
    onpositive,
    bool? shownegative = true,
    onnegative}) async {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final mediaQuery = MediaQuery.of(context);
  final isSmallScreen = mediaQuery.size.width < 600;
  final isPortrait = mediaQuery.orientation == Orientation.portrait;
  const _buttonPadding = EdgeInsetsDirectional.symmetric(
    horizontal: 18,
    vertical: 12,
  );
  final _buttonTextStyle = theme.textTheme.bodyLarge?.copyWith(
    fontWeight: FontWeight.w600,
  );

  return await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      // Calculate dialog width based on screen size
      final dialogWidth = isSmallScreen
          ? mediaQuery.size.width * 0.9
          : (isPortrait
              ? mediaQuery.size.width * 0.5
              : mediaQuery.size.width * 0.3);

      return Dialog(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
            maxHeight: mediaQuery.size.height * 0.8,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with optional close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen
                              ? 20
                              : theme.textTheme.headlineSmall?.fontSize,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (barrierDismissible)
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        onPressed: () {
                          if (onnegative != null) {
                            onnegative();
                          }
                          Navigator.pop(context, false);
                        },
                      ),
                  ],
                ),

                // Description
                if (description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Responsive buttons - vertical on small screens or when forced
                if (!(forceHorizontalButtons || !isSmallScreen))
                  Column(
                    children: [
                      // Confirm button (comes first in vertical layout)
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (onpositive != null) {
                              onpositive();
                            }
                            Navigator.pop(context, true);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                confirmColor ?? theme.colorScheme.primary,
                            foregroundColor:
                                confirmColor?.withOpacity(0.1) != null
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onPrimary,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (confirmIcon != null) ...[
                                Icon(confirmIcon, size: 18),
                                const SizedBox(width: 8),
                              ],
                              Text(confirmText),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Cancel button
                      if (shownegative == true)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonal(
                            onPressed: () => Navigator.pop(context, false),
                            style: FilledButton.styleFrom(
                              backgroundColor: cancelColor ??
                                  (isDark
                                      ? theme.colorScheme.surfaceVariant
                                      : theme.colorScheme.surfaceVariant),
                              foregroundColor: cancelColor ??
                                  theme.colorScheme.onSurfaceVariant,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (cancelIcon != null) ...[
                                  Icon(cancelIcon, size: 18),
                                  const SizedBox(width: 8),
                                ],
                                Text(cancelText),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Cancel button
                      if (shownegative == true)
                        OutlinedButton(
                          onPressed: () {
                            if (onnegative != null) {
                              onnegative();
                            }
                            Navigator.pop(context, false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                theme.colorScheme.onTertiaryContainer,
                            side: BorderSide(
                              color: theme.colorScheme.outline ??
                                  Colors.transparent,
                            ),
                            shadowColor: Colors.transparent,
                            padding: _buttonPadding,
                            textStyle: _buttonTextStyle,
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (cancelIcon != null) ...[
                                Icon(cancelIcon, size: 18),
                                const SizedBox(width: 8),
                              ],
                              Text(cancelText),
                            ],
                          ),
                        ),
                      const SizedBox(width: 12),

                      // Confirm button
                      ElevatedButton(
                        onPressed: () {
                          if (onpositive != null) {
                            onpositive();
                          }
                          Navigator.pop(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: _buttonPadding,
                          backgroundColor:
                              confirmColor ?? theme.colorScheme.primary,
                          foregroundColor:
                              confirmColor?.withOpacity(0.1) != null
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onPrimary,
                          textStyle: _buttonTextStyle,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (confirmIcon != null) ...[
                              Icon(confirmIcon, size: 18),
                              const SizedBox(width: 8),
                            ],
                            Text(confirmText),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CustomPopover extends StatefulWidget {
  final Widget child;
  final Widget popoverContent;
  final PopoverDirection direction;
  final double arrowHeight;
  final Color backgroundColor;
  final double radius;
  final double elevation;
  final double padding;

  const CustomPopover({
    Key? key,
    required this.child,
    required this.popoverContent,
    this.direction = PopoverDirection.bottom,
    this.arrowHeight = 8,
    this.backgroundColor = Colors.white,
    this.radius = 8,
    this.elevation = 4,
    this.padding = 16,
  }) : super(key: key);

  @override
  _CustomPopoverState createState() => _CustomPopoverState();
}

enum PopoverDirection { top, bottom, left, right }

class _CustomPopoverState extends State<CustomPopover> {
  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;
  @override
  void initState() {
    Jks.overlayentriesClosers.add(hidePopover);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _childKey,
      onTap: togglePopover,
      child: widget.child,
    );
  }

  void togglePopover() {
    if (_isVisible) {
      hidePopover();
    } else {
      showPopover();
    }
  }

  void showPopover() {
    final RenderBox renderBox =
        _childKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: hidePopover,
        child: Stack(
          children: [
            Positioned(
              left: _calculateLeft(offset, size),
              top: _calculateTop(offset, size),
              child: Material(
                elevation: widget.elevation,
                color: Colors.transparent,
                child: CustomPaint(
                  painter: _ArrowPainter(
                    direction: widget.direction,
                    color: widget.backgroundColor,
                    arrowHeight: widget.arrowHeight,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(widget.padding),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(widget.radius),
                    ),
                    child: widget.popoverContent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(Jks.context!).insert(_overlayEntry!);
    setState(() => _isVisible = true);
  }

  double _calculateLeft(Offset offset, Size size) {
    switch (widget.direction) {
      case PopoverDirection.left:
        return offset.dx - widget.padding - 8;
      case PopoverDirection.right:
        return offset.dx + size.width + widget.padding;
      case PopoverDirection.top:
      case PopoverDirection.bottom:
        return offset.dx + size.width / 2 - widget.padding;
    }
  }

  double _calculateTop(Offset offset, Size size) {
    switch (widget.direction) {
      case PopoverDirection.top:
        return offset.dy - widget.padding - 8;
      case PopoverDirection.bottom:
        return offset.dy + size.height + widget.padding;
      case PopoverDirection.left:
      case PopoverDirection.right:
        return offset.dy + size.height / 2 - widget.padding;
    }
  }

  void hidePopover() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isVisible = false);
  }

  @override
  void dispose() {
    hidePopover();
    super.dispose();
  }
}

class _ArrowPainter extends CustomPainter {
  final PopoverDirection direction;
  final Color color;
  final double arrowHeight;

  _ArrowPainter({
    required this.direction,
    required this.color,
    required this.arrowHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    switch (direction) {
      case PopoverDirection.bottom:
        path.moveTo(0, 0);
        path.lineTo(arrowHeight * 2, 0);
        path.lineTo(arrowHeight, arrowHeight);
        break;
      case PopoverDirection.top:
        path.moveTo(0, size.height);
        path.lineTo(arrowHeight * 2, size.height);
        path.lineTo(arrowHeight, size.height - arrowHeight);
        break;
      case PopoverDirection.left:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, arrowHeight * 2);
        path.lineTo(size.width - arrowHeight, arrowHeight);
        break;
      case PopoverDirection.right:
        path.moveTo(0, 0);
        path.lineTo(0, arrowHeight * 2);
        path.lineTo(arrowHeight, arrowHeight);
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> showFullScreenSuccessDialog(
  BuildContext context, {
  VoidCallback? onOk,
  String? title,
  String? message,
  String? okText,
}) async {
  final _theme = Theme.of(context);

  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Success',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: _theme.colorScheme.surface,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: _theme.colorScheme.primary,
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title ?? 'Succès !',
                      textAlign: TextAlign.center,
                      style: _theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _theme.textTheme.headlineMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message ??
                          'Votre création a été enregistrée\navec succès.',
                      textAlign: TextAlign.center,
                      style: _theme.textTheme.bodyLarge?.copyWith(
                        color: _theme.textTheme.bodyLarge?.color
                            ?.withOpacity(0.75),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onOk != null) onOk();
                      },
                      icon: const Icon(Icons.check),
                      label: Text(okText ?? "OK"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ).paddingAll(10),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close,
                      size: 30,
                      color: _theme.iconTheme.color?.withOpacity(0.6)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

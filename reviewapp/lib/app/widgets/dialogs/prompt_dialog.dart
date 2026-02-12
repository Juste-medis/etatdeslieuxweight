import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;

Future<T?> showAwesomeFormDialog<T>({
  required BuildContext context,
  required String title,
  String? description,
  Widget? bottomWidget,
  required Widget formContent,
  String? submitText,
  String? cancelText,
  Color? submitColor,
  Color? cancelColor,
  IconData? submitIcon,
  IconData? cancelIcon,
  bool barrierDismissible = true,
  bool forceVerticalButtons = false,
  required GlobalKey<FormState> formKey,
}) async {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final mediaQuery = MediaQuery.of(context);
  final isSmallScreen = mediaQuery.size.width < 600;
  final isPortrait = mediaQuery.orientation == Orientation.portrait;
  final _lang = l.S.of(context);
  submitText = submitText ?? _lang.submit;
  cancelText = cancelText ?? _lang.cancel;

  return await showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      // Calculate dialog width based on screen size
      final dialogWidth = isSmallScreen
          ? mediaQuery.size.width * 0.9
          : (isPortrait
                ? mediaQuery.size.width * 0.6
                : mediaQuery.size.width * 0.4);

      return Dialog(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
            maxHeight: mediaQuery.size.height * 0.8,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
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
                          onPressed: () => Navigator.pop(context),
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

                  // Form content (passed as parameter)
                  formContent,

                  const SizedBox(height: 24),

                  // Responsive buttons - vertical on small screens or when forced
                  if (isSmallScreen || forceVerticalButtons)
                    Column(
                      children: [
                        // Submit button (comes first in vertical layout)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                Navigator.pop(context, true);
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  submitColor ?? theme.colorScheme.primary,
                              foregroundColor:
                                  submitColor?.withOpacity(0.1) != null
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onPrimary,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (submitIcon != null) ...[
                                  Icon(submitIcon, size: 18),
                                  const SizedBox(width: 8),
                                ],
                                Text(submitText!),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Cancel button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonal(
                            onPressed: () => Navigator.pop(context),
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  cancelColor ??
                                  (isDark
                                      ? theme
                                            .colorScheme
                                            .surfaceContainerHighest
                                      : theme
                                            .colorScheme
                                            .surfaceContainerHighest),
                              foregroundColor:
                                  cancelColor ??
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
                                Text(cancelText!),
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
                        FilledButton.tonal(
                          onPressed: () => Navigator.pop(context),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                cancelColor ??
                                (isDark
                                    ? theme.colorScheme.surfaceContainerHighest
                                    : theme
                                          .colorScheme
                                          .surfaceContainerHighest),
                            foregroundColor:
                                cancelColor ??
                                theme.colorScheme.onSurfaceVariant,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (cancelIcon != null) ...[
                                Icon(cancelIcon, size: 18),
                                const SizedBox(width: 8),
                              ],
                              Text(cancelText!),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Submit button
                        FilledButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              Navigator.pop(context, true);
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                submitColor ?? theme.colorScheme.primary,
                            foregroundColor:
                                submitColor?.withOpacity(0.1) != null
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onPrimary,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (submitIcon != null) ...[
                                Icon(submitIcon, size: 18),
                                const SizedBox(width: 8),
                              ],
                              Text(submitText!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (bottomWidget != null) ...[bottomWidget],
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

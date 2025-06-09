import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectGrid extends StatelessWidget {
  final List<Widget> entries;
  final String? title;
  const SelectGrid({super.key, required this.entries, this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isdesktop = MediaQuery.sizeOf(context).width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title.capitalizeFirstLetter(),
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        if (title != null) const SizedBox(height: 16),

        // Multi-column grid selector
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: isdesktop ? 6 : 2,
          childAspectRatio: isdesktop ? 2 : 1.8,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: entries,
        ),
      ],
    );
  }
}

class SelectionTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionTile({
    super.key,
    required this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.05)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border(
            bottom: BorderSide(
              width: 7.2,
              color: isSelected
                  ? Jks.canEditReview == "canEditReview"
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withOpacity(0.4)
                  : theme.colorScheme.outline,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon),
            if (icon != null) 3.height,
            Text(title,
                style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: isDesktop ? 16 : 14)),
          ],
        ).paddingAll(20),
      ),
    );
  }
}

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copoleadmin.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_plan.dart';
import 'package:jatai_etadmin/app/providers/_settings_provider.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/prompt_dialog.dart';

import 'package:provider/provider.dart';
import 'settingsconponents.dart';

class PriceSettings extends StatefulWidget {
  const PriceSettings({
    super.key,
    required this.section,
  });

  final String section;

  @override
  State<PriceSettings> createState() => _PriceSettingsState();
}

class _PriceSettingsState extends State<PriceSettings> {
  SettingsProvider settingState = Jks.settingState;
  // @override
  // void didUpdateWidget(PriceSettings oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.section != widget.section) {
  //     Jks.settingState.fetchPlans(refresh: true);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    settingState = context.watch<SettingsProvider>();
    Jks.settingState = settingState;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              admin_title("Plans et prix", context: context),
              inventoryAddButton(
                context,
                onPressed: () => _showPlanEditor(context),
                title: 'Ajouter un plan',
              )
            ],
          ),
          const SizedBox(height: 24),
          if (Jks.settingState.isLoading) ...[
            Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            ),
          ] else if (Jks.settingState.plans.isEmpty) ...[
            Center(
              child: Text(
                'Aucun plan trouvé',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ] else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 0.6,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: Jks.settingState.plans.length,
              itemBuilder: (context, index) {
                final plan = Jks.settingState.plans[index];
                return _buildPlanCard(context, plan, theme);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, dynamic plan, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              height: 150,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.onPrimary,
                    child: Icon(
                      plan.icon != null ? Icons.star : Icons.business,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          plan.status.toUpperCase(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    color: theme.colorScheme.primaryContainer,
                    icon: Icon(Icons.more_vert,
                        color: theme.colorScheme.onPrimary),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Modifier')
                          ],
                        ),
                        onTap: () => Future.delayed(
                          Duration.zero,
                          () => _showPlanEditor(context, plan: plan),
                        ),
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('Supprimer')
                          ],
                        ),
                        onTap: () => _deletePlan(context, plan),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plan.description.isNotEmpty) ...[
                      Text(
                        plan.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (plan.features.isNotEmpty) ...[
                      Text(
                        'Avantages',
                        style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: ListView.builder(
                          itemCount: plan.features.length.clamp(0, 3),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    plan.features[index],
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (plan.features.length > 3)
                        Text(
                          '+${plan.features.length - 3} plus...',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],

                    const SizedBox(height: 12),

                    // Prices
                    if (plan.prices.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'A partir de',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              '${plan.prices.first.price} ${plan.prices.first.currency}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlanEditor(BuildContext context, {Plan? plan}) async {
    Jks.plan = plan ??= Plan();
    Jks.formState?.fieldErrors?.clear();

    final formKey = GlobalKey<FormState>();

    Jks.context = context;
    if (Jks.plan.id != null) {
      openRightOffcanvas(context,
          child: EditPriceForm(
            plan: Jks.plan,
            onSubmit: () async {
              Jks.settingState.editPlan(Jks.plan);
              Navigator.pop(context);
            },
          ));
    } else {
      await showAwesomeFormDialog(
          context: context,
          persistantaction: true,
          submitText: "Ajouter un plan".tr,
          title: "Ajouter un plan".tr,
          onSubmit: () async {
            Jks.context = context;
            var result = false;
            result = await Jks.settingState.addPlan(Jks.plan);

            if (result == true) {
              Jks.plan = Plan();
              simulateScreenTap();
            }
          },
          formContent: EditPriceForm(
            plan: plan,
          ),
          formKey: formKey);
    }
    plan = Jks.plan;
  }

  void _deletePlan(BuildContext context, dynamic plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plan'),
        content: Text('Are you sure you want to delete "${plan.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle delete logic
              Navigator.pop(context);
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

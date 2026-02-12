// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:jatai_etadmin/app/core/helpers/fuctions/helper_functions.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/core/theme/theme.dart';
import 'package:jatai_etadmin/app/models/_plan.dart';
import 'package:jatai_etadmin/app/providers/_payment_provider.dart';
import 'package:jatai_etadmin/app/providers/_theme_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';

part 'data/_pricing_mock_data.dart';

class PricingView extends StatelessWidget {
  final String? source;
  final VoidCallback? onConfirmed;
  PricingView({super.key, this.source, this.onConfirmed}) {
    // fetch plans when the view is created
    Future.microtask(
        () => Jks.context!.read<PaymentProvider>().fetchPlans(refresh: true));
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 20,
      sm: 16 / 2,
      md: 16 / 2,
      lg: 24 / 2,
    );
    final textTheme = _theme.textTheme;
    final isDark = _theme.colorScheme.brightness == Brightness.dark;

    PaymentProvider paymentProvider = context.watch<PaymentProvider>();
    AppThemeProvider appstate = context.watch<AppThemeProvider>();

    return Scaffold(
        backgroundColor:
            isDark ? AcnooAppColors.kNeutral900 : AcnooAppColors.kWhiteColor,
        body: Consumer<PaymentProvider>(
          builder: (context, lang, child) {
            Jks.context = context;

            return SingleChildScrollView(
              padding: source != null
                  ? EdgeInsets.zero
                  : EdgeInsets.all(_padding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Soldes".tr,
                          style: textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _theme.colorScheme.primary))
                      .paddingLeft(_padding),
                  Padding(
                    padding: EdgeInsets.all(_padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet_rounded,
                                color: _theme.colorScheme.primary, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              "Crédits disponibles".tr,
                              style: _theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    _theme.colorScheme.primary.withOpacity(.12),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.stacked_line_chart,
                                      size: 14,
                                      color: _theme.colorScheme.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${(appstate.currentUser.balance?.procurement ?? 0) + (appstate.currentUser.balance?.simple ?? 0)}",
                                    style: _theme.textTheme.labelMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: _theme.colorScheme.primary),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _CreditStatTile(
                                icon: Icons.description_outlined,
                                label: "Procurations + Etats des lieux".tr,
                                value: (appstate
                                            .currentUser.balance?.procurement ??
                                        0)
                                    .toString(),
                                color: AcnooAppColors.kPrimary600,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _CreditStatTile(
                                icon: Icons.home_work_outlined,
                                label: "Etat des lieux simple".tr,
                                value:
                                    (appstate.currentUser.balance?.simple ?? 0)
                                        .toString(),
                                color: greenColor,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ShadowContainer(
                    child: paymentProvider.isLoading
                        ? Center(child: CircularProgressIndicator())
                            .paddingAll(16)
                        : paymentProvider.plans.isEmpty
                            ? Text("Aucun plan disponible pour le moment.".tr,
                                style: textTheme.bodyMedium)
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Acheter des crédits".tr,
                                        style: textTheme.titleLarge!.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      if (source != null)
                                        IconButton(
                                          icon: Icon(Icons.close,
                                              color:
                                                  _theme.colorScheme.primary),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                    ],
                                  ),
                                  12.height,
                                  Column(
                                      children:
                                          paymentProvider.plans.map((plan) {
                                    return PlanCard(plan: plan);
                                  }).toList()),

                                  // Champ pour appliquer un coupon
                                  _buildCouponArea(context),

                                  // Total et bouton de paiement
                                  Container(
                                    margin: EdgeInsets.only(top: 30),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.grey.shade700
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total".tr,
                                              style: textTheme.titleLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              paymentProvider.hasCoupon
                                                  ? "€ ${paymentProvider.couponPrice.toStringAsFixed(2)}"
                                                  : "€ ${paymentProvider.plans.fold(0.0, (sum, plan) => sum + plan.computedprice).toStringAsFixed(2)}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.titleLarge
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AcnooAppColors.kPrimary600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        16.height,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            if (paymentProvider
                                                .couponData.isNotEmpty) ...[
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Coupons appliqués".tr,
                                                  style: textTheme.titleMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: paymentProvider
                                                    .couponData.entries
                                                    .map((e) => Chip(
                                                          color: WidgetStateProperty
                                                              .all(context
                                                                  .theme
                                                                  .colorScheme
                                                                  .primaryContainer),
                                                          deleteIcon:
                                                              Icon(Icons.close),
                                                          onDeleted: () {
                                                            paymentProvider
                                                                .couponData
                                                                .remove(e.key);
                                                            paymentProvider
                                                                .updateCouponData(
                                                                    paymentProvider
                                                                        .couponData);
                                                          },
                                                          avatar: const Icon(
                                                            Icons.local_offer,
                                                            size: 16,
                                                            color: AcnooAppColors
                                                                .kPrimary600,
                                                          ),
                                                          label: Text(
                                                            '${e.key} - €${e.value[0].toStringAsFixed(2)} → €${e.value[1].toStringAsFixed(2)}',
                                                            style: textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                              const SizedBox(height: 12),
                                            ]
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 48,
                                          child: ElevatedButton(
                                            onPressed: paymentProvider.plans.fold(
                                                        0,
                                                        (sum, plan) =>
                                                            sum +
                                                            plan.actualquantity) ==
                                                    0
                                                ? null
                                                : () {
                                                    paymentProvider
                                                        .initializePayment(
                                                      onConfirmed: onConfirmed,
                                                    );
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AcnooAppColors.kPrimary600,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              "Procéder au paiement".tr,
                                              style:
                                                  textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildCouponArea(
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.grey.shade700
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Code promo",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          12.height,
          Row(
            children: [
              Expanded(
                  child: editUserField(
                title: "code promo",
                leftwidget: const Icon(
                  Icons.card_giftcard_rounded,
                ),
                placeholder: "code promo",
                showLabel: false,
                showplaceholder: true,
                initialvalue: Jks.paymentState.couponCode,
                onChanged: (text) {
                  Jks.paymentState.couponCode = text;
                },
                required: true,
              )),
              const SizedBox(width: 12),
              SizedBox(
                height: 44,
                child: IconButton(
                  onPressed: Jks.paymentState.isLoadingCoupon
                      ? null
                      : () {
                          if (Jks.paymentState.couponCode.isEmpty) {
                            show_common_toast(
                                "Veuillez entrer un code promo.".tr,
                                Jks.context!);
                            return;
                          }
                          context
                              .read<PaymentProvider>()
                              .applyCoupon(Jks.paymentState.couponCode);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcnooAppColors.kPrimary600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Jks.paymentState.isLoadingCoupon
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final Plan plan;

  const PlanCard({
    Key? key,
    required this.plan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final paymentProvider = context.watch<PaymentProvider>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AcnooAppColors.kPrimary900,
            width: 1,
          )),
      color: isDark ? AcnooAppColors.kNeutral800 : AcnooAppColors.kWhiteColor,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            _buildHeader(theme, isDark),
            const SizedBox(height: 16),

            // Features list
            _buildFeaturesList(theme, isDark),
            const SizedBox(height: 20),

            // Price and quantity section
            _buildPriceSection(theme, isDark, paymentProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Row(
      children: [
        // Icon container
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary600.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
          ),
          child: getImageType(
            plan.icon ?? "assets/images/widget_images/documentsign.svg",
            colorFilter: ColorFilter.mode(
              AcnooAppColors.kPrimary600,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Title
        Expanded(
          child: Text(
            plan.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fonctionnalités incluses :',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        ...plan.features
            .map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AcnooAppColors.kPrimary600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildPriceSection(
      ThemeData theme, bool isDark, PaymentProvider paymentProvider) {
    return Row(
      children: [
        // Quantity selector
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quantité',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              CounterField(
                initialValue: "${plan.actualquantity}",
                onChanged: (value) {
                  paymentProvider.couponData.clear();
                  plan.updatePlanQuantity(int.tryParse("$value") ?? 1);
                  paymentProvider.updatePlanById(plan);
                },
              ),
            ],
          ),
        ),

        const Spacer(),

        // Price
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Total',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '€${plan.computedprice.toStringAsFixed(2)}',
              style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AcnooAppColors.kPrimary600,
                  fontSize: 20),
            ),
            PricePopupMenuCompact(
              prices: plan.prices.map((e) => e.toJson()).toList(),
              selectedPriceId: plan.selectedPriceId,
              onPriceSelected: (priceId) {},
            ),
          ],
        ),
      ],
    );
  }
}

class PricePopupMenuCompact extends StatelessWidget {
  final List<dynamic> prices;
  final String? selectedPriceId;
  final ValueChanged<String>? onPriceSelected;

  const PricePopupMenuCompact({
    Key? key,
    required this.prices,
    this.selectedPriceId,
    this.onPriceSelected,
  }) : super(key: key);

  String get _selectedPriceText {
    if (selectedPriceId == null) return 'Tarifs';

    final selectedPrice = prices.firstWhere(
      (price) => price['_id'] == selectedPriceId,
      orElse: () => {"_id": "", "price": "0"},
    );

    if (selectedPrice.isEmpty) return 'Tarifs';

    return '${selectedPrice['price']}€';
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      menuPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      onSelected: onPriceSelected,
      color: context.theme.colorScheme.primaryContainer,
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grille tarifaire',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "L'unité",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AcnooAppColors.kPrimary600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...prices.map((price) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: 4, left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price['isInterval']
                              ? '${price['inf']}-${price['sup']}'
                              : '${price['qty']}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                fontWeight: price['_id'] == selectedPriceId
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize:
                                    price['_id'] == selectedPriceId ? 18 : 12,
                              ),
                        ),
                        Text(
                          '${price['price']}€',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontWeight: price['_id'] == selectedPriceId
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize:
                                    price['_id'] == selectedPriceId ? 18 : 12,
                                color: AcnooAppColors.kPrimary600,
                              ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          Text(
            "Unité / $_selectedPriceText",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AcnooAppColors.kPrimary600,
                ),
          ),
          const Icon(
            Icons.info,
            size: 16,
            color: AcnooAppColors.kPrimary600,
          ),
        ],
      ),
    );
  }
}

class _CreditStatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _CreditStatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            color.withAlpha(isDark ? 46 : 31),
            color.withAlpha(isDark ? 20 : 13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: color.withAlpha(56),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

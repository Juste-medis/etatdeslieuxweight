import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_plan.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/_select_tile.dart';
import 'package:jatai_etadmin/app/providers/_settings_provider.dart';
import 'package:nb_utils/nb_utils.dart';

class EditPriceForm extends StatefulWidget {
  final Plan? plan;
  final void Function()? onSubmit;
  const EditPriceForm({super.key, this.plan, this.onSubmit});

  @override
  State<EditPriceForm> createState() => _EditPriceFormState();
}

class _EditPriceFormState extends State<EditPriceForm> {
  SettingsProvider settingState = Jks.settingState;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildFeatureItem(int index, String feature) {
    return Padding(
      key: ValueKey('feature_$index'),
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: TextEditingController(text: feature),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => {
                Jks.plan = Jks.plan.copyWith(
                  features: List.from(Jks.plan.features)..[index] = value,
                )
              },
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              final updatedFeatures = List<String>.from(Jks.plan.features);
              updatedFeatures.removeAt(index);
              Jks.plan = Jks.plan.copyWith(features: updatedFeatures);
            }),
            icon: const Icon(
              Icons.clear,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(entry) {
    final index = entry.key;
    final price = entry.value;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        key: ValueKey('price_$index'),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    onTapOutside: (event) {
                      setState(() {});
                    },
                    onTap: () => setState(() {}),
                    controller:
                        TextEditingController(text: price.price.toString()),
                    decoration: const InputDecoration(
                      labelText: 'Prix',
                      border: OutlineInputBorder(),
                      suffix: Text('€'),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final newPrice = double.tryParse(value) ?? 0.0;
                      final updatedPrices = Jks.plan.prices;
                      updatedPrices[index] = price.copyWith(price: newPrice);
                      Jks.plan = Jks.plan.copyWith(prices: updatedPrices);
                    },
                  ),
                ),
                8.width,
                if (Jks.plan.prices[index].isInterval) ...[
                  Expanded(
                    child: TextFormField(
                      onTapOutside: (event) {
                        setState(() {});
                      },
                      onTap: () => setState(() {}),
                      controller: TextEditingController(
                          text: price.inf?.toString() ?? ''),
                      decoration: const InputDecoration(
                        labelText: 'Min',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final newInf =
                            value.isEmpty ? null : double.tryParse(value);
                        final updatedPrices = (Jks.plan.prices);
                        updatedPrices[index] = price.copyWith(inf: newInf);
                        Jks.plan = Jks.plan.copyWith(prices: updatedPrices);
                      },
                    ),
                  ),
                  8.width,
                  Expanded(
                    child: TextFormField(
                      onTapOutside: (event) {
                        setState(() {});
                      },
                      onTap: () => setState(() {}),
                      controller: TextEditingController(
                          text: price.sup?.toString() ?? ''),
                      decoration: const InputDecoration(
                        labelText: 'Max',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final newSup =
                            value.isEmpty ? null : double.tryParse(value);
                        final updatedPrices = (Jks.plan.prices);
                        updatedPrices[index] = price.copyWith(sup: newSup);
                        Jks.plan = Jks.plan.copyWith(prices: updatedPrices);
                      },
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: TextFormField(
                      onTapOutside: (event) {
                        setState(() {});
                      },
                      onTap: () => setState(() {}),
                      controller: TextEditingController(
                          text: price.qty?.toString() ?? ''),
                      decoration: const InputDecoration(
                        labelText: 'Qté',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final newQty =
                            value.isEmpty ? null : int.tryParse(value);
                        final updatedPrices = (Jks.plan.prices);
                        updatedPrices[index] = price.copyWith(qty: newQty);
                        Jks.plan = Jks.plan.copyWith(prices: updatedPrices);
                      },
                    ),
                  ),
                ],
                8.width,
                IconButton(
                  onPressed: () =>
                      setState(() => Jks.plan.prices.removeAt(index)),
                  icon: const Icon(Icons.clear, size: 15),
                )
              ],
            ),
            Row(
              children: [
                Text('Type: '),
                Expanded(
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: price.isInterval,
                        onChanged: (value) {
                          if (value != null) {
                            final updatedPrices = (Jks.plan.prices);
                            updatedPrices[index] =
                                price.copyWith(isInterval: value);
                            Jks.plan = Jks.plan.copyWith(prices: updatedPrices);
                            setState(() {});
                          }
                        },
                      ),
                      Text('Fixe'),
                      Radio<bool>(
                        value: true,
                        groupValue: price.isInterval,
                        onChanged: (value) {
                          if (value != null) {
                            final updatedPrices = (Jks.plan.prices);
                            updatedPrices[index] =
                                price.copyWith(isInterval: value);
                            Jks.plan = Jks.plan.copyWith(prices: updatedPrices);
                            setState(() {});
                          }
                        },
                      ),
                      Text('Intervalle'),
                    ],
                  ),
                ),
              ],
            ),
            8.height,
            errorText("prices.$index.qty", context),
            errorText("prices.$index.price", context),
            errorText("prices.$index.inf", context),
            errorText("prices.$index.sup", context),
          ],
        ),
      ),
    );
  }

  void _addFeature() {
    setState(() => Jks.plan = Jks.plan.copyWith(
          features: List.from(Jks.plan.features)..add(''),
        ));
  }

  void _addPrice() {
    // Add a basic price structure - adjust according to your Price model
    setState(() => Jks.plan = Jks.plan.copyWith(
          prices: List.from(Jks.plan.prices)
            ..add(Price(id: '', price: 0.0, currency: 'EUR', isInterval: true)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        editUserField(
          title: "Nom du plan".tr,
          placeholder: "Nom du plan".tr,
          initialvalue: Jks.plan.name,
          onChanged: (text) {
            Jks.plan = Jks.plan.copyWith(name: text);
          },
          required: true,
          showplaceholder: true,
          showLabel: false,
          key: "name",
        ),
        editUserField(
          title: "description".tr,
          type: "textarea",
          placeholder: "Description du coupon".tr,
          initialvalue: Jks.plan.description,
          onChanged: (text) {
            Jks.plan = Jks.plan.copyWith(description: text);
          },
          showplaceholder: true,
          showLabel: false,
          key: "description",
        ),
        16.height,
        Text(
          "Fonctionnalités du plan".tr,
          style: context.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        8.height,
        ...(Jks.plan.features)
            .asMap()
            .entries
            .map((entry) => _buildFeatureItem(entry.key, entry.value)),
        errorText("features", context),
        TextButton.icon(
          onPressed: _addFeature,
          icon: const Icon(Icons.add),
          label: const Text('Ajouter une fonctionnalité'),
          style: TextButton.styleFrom(
            textStyle: context.textTheme.bodyMedium,
            padding: const EdgeInsets.all(0),
          ),
        ),
        16.height,
        Text(
          "Prix du plan".tr,
          style: context.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        8.height,
        ...(Jks.plan.prices)
            .asMap()
            .entries
            .map((entry) => _buildPriceItem(entry)),
        errorText("prices", context),
        TextButton.icon(
          onPressed: _addPrice,
          icon: const Icon(Icons.add),
          label: const Text('Ajouter un prix'),
          style: TextButton.styleFrom(
            textStyle: context.textTheme.bodyMedium,
            padding: const EdgeInsets.all(0),
          ),
        ),
        20.height,
        SelectGrid(
          title: "Statut du plan".tr,
          entries: [
            SelectionTile(
                title: "Active".tr,
                isSelected:
                    (settingState.settings["planstatus"] ?? Jks.plan.status) ==
                        "active",
                onTap: () {
                  Jks.plan.copyWith(status: "active");
                  settingState.updateSettings("planstatus", "active");
                }),
            SelectionTile(
                title: "Inactif".tr,
                activeColor: Colors.black,
                isSelected:
                    (settingState.settings["planstatus"] ?? Jks.plan.status) ==
                        "inactive",
                onTap: () {
                  Jks.plan.copyWith(status: "inactive");
                  settingState.updateSettings("planstatus", "inactive");
                }),
          ],
        ),
        20.height,
        if (widget.onSubmit != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Annuler".tr),
              ),
              16.width,
              ElevatedButton(
                onPressed: widget.onSubmit,
                child: Text("Enregistrer".tr),
              ),
            ],
          ),
        ]
      ],
    );
  }
}

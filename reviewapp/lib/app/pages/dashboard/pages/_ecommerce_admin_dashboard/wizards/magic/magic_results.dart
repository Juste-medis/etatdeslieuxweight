import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/actions.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/core/theme/theme.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:go_router/go_router.dart';

class MagicResult extends StatelessWidget {
  final String? piece;
  final String afterDate;

  const MagicResult({super.key, this.piece, required this.afterDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    var topSelectedPiece = wizardState.inventoryofPieces.firstWhere(
      (element) => element.id == piece,
      orElse: () => wizardState.inventoryofPieces[0],
    );
    final TextStyle _buttonTextStyle = theme.textTheme.titleLarge!.copyWith(
      fontSize: 14,
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.w600,
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 0,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: Text("Terminer".tr, style: _buttonTextStyle),
        backgroundColor: context.primaryColor,
      ),
      body: SingleChildScrollView(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Liste des éléments détectés".tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
              ...(topSelectedPiece.things ?? []).asMap().entries.map((entry) {
                final index2 = entry.key, thing = entry.value;

                if (thing.meta != null &&
                    thing.meta!['analyzedByAI'] == true &&
                    DateTime.parse(
                      thing.meta!['analyzedAt'],
                    ).isAfter(DateTime.parse(Jks.thingsAfterDate))) {
                  return Column(
                    key: ValueKey('thing$index2'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionWidget(
                        expandedAlignment: Alignment.topLeft,
                        initiallyExpanded: true,
                        titleBuilder:
                            (
                              animationValue,
                              easeInValue,
                              isExpanded,
                              toggleFunction,
                            ) => InkWell(
                              onTap: () => toggleFunction(animated: true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        AnimatedRotation(
                                          turns: isExpanded ? 0.25 : 0,
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: AcnooAppColors.kPrimary700,
                                          ),
                                        ),
                                        20.width,
                                        Text(
                                          thing.name!,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        topSelectedPiece.things!.removeAt(
                                          index2,
                                        );
                                        wizardState.updateInventory(
                                          iop: wizardState.inventoryofPieces
                                              .map((actpiece) {
                                                if (actpiece.order == piece) {
                                                  return topSelectedPiece;
                                                }
                                                return actpiece;
                                              })
                                              .toList(),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: AcnooAppColors.kPrimary700,
                                      ),
                                    ),
                                  ],
                                ).paddingSymmetric(vertical: 5),
                              ),
                            ),
                        content: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: CustomDropdownButton(
                                    buttonTitle: "${thing.count ?? 1}",
                                    buttonIcon: Icons.onetwothree_sharp,
                                    items: [...defaultcountNumber.entries]
                                        .map(
                                          (e) => {
                                            'label': e.value,
                                            'value': e.key,
                                          },
                                        )
                                        .toList(),
                                    changeOnlyOnClose: true,
                                    onChanged: (value) {
                                      var list = wizardState.inventoryofPieces;
                                      var updatedThing = thing.copyWith(
                                        count: value is int
                                            ? value
                                            : int.parse(value),
                                      );
                                      topSelectedPiece.things![index2] =
                                          updatedThing;

                                      wizardState.updateInventory(
                                        iop: list.map((piece) {
                                          if (piece.order ==
                                              topSelectedPiece.order) {
                                            return topSelectedPiece;
                                          }
                                          return piece;
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                                10.width,
                                Flexible(
                                  child: CustomDropdownButton(
                                    buttonTitle:
                                        defaultStates[thing.condition] ??
                                        defaultStates.entries.first.value,
                                    buttonIcon: Icons.star,
                                    items: [...defaultStates.entries]
                                        .map(
                                          (e) => {
                                            'label': e.value,
                                            'value': e.key,
                                          },
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      var list = wizardState.inventoryofPieces;
                                      var updatedThing = thing.copyWith(
                                        condition: value,
                                      );
                                      topSelectedPiece.things![index2] =
                                          updatedThing;
                                      wizardState.updateInventory(
                                        iop: list.map((piece) {
                                          if (piece.order ==
                                              topSelectedPiece.order) {
                                            return topSelectedPiece;
                                          }
                                          return piece;
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                                10.width,
                                Flexible(
                                  child: CustomDropdownButton(
                                    buttonTitle:
                                        defaultTestingStates[thing
                                            .testingStage] ??
                                        defaultTestingStates
                                            .entries
                                            .first
                                            .value,
                                    buttonIcon: Icons.star,
                                    items: [...defaultTestingStates.entries]
                                        .map(
                                          (e) => {
                                            'label': e.value,
                                            'value': e.key,
                                          },
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      var list = wizardState.inventoryofPieces;
                                      var updatedThing = thing.copyWith(
                                        testingStage: value,
                                      );

                                      topSelectedPiece.things![index2] =
                                          updatedThing;

                                      wizardState.updateInventory(
                                        iop: list.map((piece) {
                                          if (piece.order ==
                                              topSelectedPiece.order) {
                                            return topSelectedPiece;
                                          }
                                          return piece;
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                                10.width,

                                //use chat more button instead
                                Flexible(
                                  child: inventoryActionButton(
                                    context,
                                    title: const Icon(Icons.more_horiz),
                                    onPressed: () {
                                      context.push(
                                        '/thing-inventory',
                                        extra: {
                                          "thing": thing.order,
                                          "piece": piece,
                                          "thingid": thing.id,
                                          "frommagic": true,
                                        },
                                      );
                                    },
                                  ).withWidth(56),
                                ),
                                10.width,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return 0.width;
              }),
            ],
          ),
        ).paddingSymmetric(horizontal: _padding),
      ),
    );
  }
}

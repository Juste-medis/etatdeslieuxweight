// 🐦 Flutter imports:
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/_plan.dart';
import 'package:jatai_etadmin/app/models/_user_balence.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/confirm_dialog.dart';
import 'package:jatai_etadmin/main.dart';

class PaymentProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoadingCoupon = false;
  String paymentMade = "";
  List<Plan> _plans = [];
  List<Plan> get plans => _plans;
  double couponPrice = 0.0;
  Map<String, List<double>> couponData = {};
  String couponCode = "";

  bool get hasCoupon => couponData.isNotEmpty;

  Future<void> updatePlanById(Plan plan) async {
    try {
      _plans = _plans.map((p) {
        if (p.id == plan.id) {
          return plan;
        }
        return p;
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Plan with id ${plan.id} not found: $e');
    }
  }

  void updateCouponData(Map<String, List<double>> newCouponData) {
    couponData = newCouponData;
    if (couponData.isEmpty) {
      couponPrice = 0.0;
    }
    notifyListeners();
  }

  Future<void> fetchPlans({bool refresh = false, String type = ""}) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }
    if (refresh) {
      _plans.clear();
      notifyListeners();
    }

    try {
      final response = await getplans(page: 1, limit: "10", filter: {});

      if (response.status == true) {
        if (refresh) {
          _plans.clear();
        }
        _plans.addAll(response.list);
        isLoading = false;

        notifyListeners();
      }
    } catch (err) {
      isLoading = false;

      notifyListeners();
      debugPrint('Error fetching plans: $err');
      my_inspect(err);
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  void setPaidStatus(String status) {
    paymentMade = status;
    notifyListeners();
  }

  Future<String> useOneCredit(Map request) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }
    try {
      final response = await useacredit(request);

      if (response.status == true) {
        // _plans.addAll(response.list);

        await appStore.setBalence(response.data);
        Jks.wizardState.currentUser = Jks.currentUser = Jks.currentUser!
            .copyWith(balance: UserBalence.fromJson(response.data));

        isLoading = false;
        paymentMade = "done";

        notifyListeners();
        return "done";
      }
      return "error";
    } catch (err) {
      isLoading = false;

      notifyListeners();
      debugPrint('Error fetching plans: $err');
      my_inspect(err);
      return "error";
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  clearCart() {
    for (var plan in _plans) {
      plan.updatePlanQuantity(0);
      updatePlanById(plan);
    }
    couponData.clear();
    couponPrice = 0.0;
    couponCode = "";
    notifyListeners();
  }

  void setloading(bool l) {
    isLoading = l;
    notifyListeners();
  }

  Future<void> applyCoupon(
    String couponCode, {
    Function? onSuccess,
  }) async {
    if (couponData.containsKey(couponCode)) {
      show_common_toast("Le code coupon a déjà été appliqué.".tr, Jks.context!);
      return;
    }
    if (!isLoadingCoupon) {
      isLoadingCoupon = true;
      notifyListeners();
    }
    try {
      final response = await applycouponcode({
        "code": couponCode,
        "ammount": plans.fold(
            0.0,
            (sum, plan) =>
                sum +
                plan.computedprice) //plans.fold(0.0, (sum, plan) => sum + plan.computedprice).toStringAsFixed(2)
      });

      if (response.status == true) {
        if (onSuccess != null) {
          onSuccess(response.data);
        }
        var data = response.data;
        if (data != null) {
          couponPrice = data["newAmmount"] ?? 0.0;
          couponData[couponCode] = [
            data["originalAmmount"]?.toDouble() ?? 0.0,
            data["newAmmount"]?.toDouble() ?? 0.0
          ];
          couponCode = "";
        }
      } else {
        show_common_toast(
            response.message ?? "Erreur lors de l'application du coupon".tr,
            Jks.context!);
      }
      isLoadingCoupon = false;
      notifyListeners();
      return;
    } catch (err) {
      isLoadingCoupon = false;
      my_inspect(err);
    } finally {
      isLoadingCoupon = false;
      notifyListeners();
    }
  }

  Future<void> initializePayment({
    Function? onConfirmed,
  }) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
    }

    final totalCents = hasCoupon
        ? (couponPrice * 100).round()
        : plans.fold(
            0, (sum, plan) => sum + (plan.computedprice * 100).round());

    final dispersions = plans
        .map((plan) => {
              "id": plan.id,
              "dis_quantity": plan.actualquantity,
              "dis_price": plan.computedprice,
            })
        .toList();
    try {
      if (kIsWeb ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        var payement = await createPaymentLink({
          "amount": totalCents,
          "email": Jks.currentUser?.email,
          "hasCoupon": hasCoupon,
          "coupons": couponData.keys.toList(),
          "dispersions": dispersions
        });
        // Démarre un polling régulier pour vérifier le statut du paiement (style setInterval)
        if (payement.status == true && payement.data != null) {
          final intentId = payement.data["paymentId"] ?? payement.data["id"];
          bool active = true;
          int attempts = 0;
          const int maxAttempts = 75;
          const interval = Duration(seconds: 4);

          Future<void> poll() async {
            if (!active) return;
            attempts++;

            try {
              final res = await checkPaymentSheet({"paymentId": intentId});

              if (res.status == true &&
                  (res.data?["paymentStatus"] == "succeeded")) {
                active = false;

                if (res.data?["newBalance"] != null) {
                  await appStore.setBalence(res.data["newBalance"]);
                  Jks.wizardState.currentUser = Jks.currentUser =
                      Jks.currentUser!.copyWith(
                          balance:
                              UserBalence.fromJson(res.data["newBalance"]));
                }
                showFullScreenSuccessDialog(
                  Jks.context!,
                  title: 'Paiement réussi'.tr,
                  message:
                      'Votre paiement a été confirmé. Merci pour votre achat.'
                          .tr,
                  okText: 'Continuer'.tr,
                  onOk: () {},
                );

                if (onConfirmed != null) onConfirmed();
                isLoading = false;
                clearCart();
                Navigator.of(Jks.context!).pop();

                return;
              }
            } catch (e) {
              // Arrêt en cas d'erreur réseau répétée
              active = false;
              show_common_toast("Erreur lors de la vérification du paiement".tr,
                  Jks.context!);
              return;
            }

            if (active && attempts >= maxAttempts) {
              active = false;
              show_common_toast(
                  "Temps de confirmation dépassé".tr, Jks.context!);
              Navigator.of(Jks.context!).pop();
              return;
            }

            if (active) {
              await Future.delayed(interval);
              await poll();
            }
          }

          showWaitingPayementDialog(
            Jks.context!,
            onCancel: () {
              active = false;
              Navigator.of(Jks.context!).pop();
            },
            source: payement.data["url"],
            onConfirmed: () {
              if (onConfirmed != null) {
                onConfirmed();
              }
              clearCart();
            },
          );
          await commonLaunchUrl(payement.data["url"]);
          unawaited(poll());
        } else {
          show_common_toast(
              "Une erreur est survenue, veuillez réessayer.".tr, Jks.context!);
          return;
        }

        return;
      }
      var value = await createTestPaymentSheet({
        "amount": totalCents,
        "dispersions": dispersions,
        "hasCoupon": hasCoupon,
        "coupons": couponData.keys.toList()
      });
      if (value.status == true) {
        var paymentIntent = value.data;
        final billingDetails = BillingDetails(
          name: "${Jks.currentUser?.firstName} ${Jks.currentUser?.lastName}",
          email: Jks.currentUser?.email,
          phone: Jks.currentUser?.phoneNumber,
          address: Address(
            city: '',
            country: '',
            line1: Jks.currentUser?.address ?? '',
            line2: '',
            state: '',
            postalCode: '',
          ),
        );

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            // Main params
            paymentIntentClientSecret: paymentIntent['paymentIntent'],
            merchantDisplayName: 'Jatai - États des lieux',
            preferredNetworks: [CardBrand.Visa, CardBrand.Mastercard],
            customerId: paymentIntent['customer'],
            customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
            returnURL: 'flutterstripe://redirect',
            primaryButtonLabel: 'Acheter',
            applePay: (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.macOS)
                ? PaymentSheetApplePay(
                    merchantCountryCode: 'FR',
                  )
                : null,
            googlePay: PaymentSheetGooglePay(
              merchantCountryCode: 'FR',
              testEnv: true,
              buttonType: PlatformButtonType.book,
            ),
            style: ThemeMode.dark,
            // appearance: PaymentSheetAppearance(
            //   colors: PaymentSheetAppearanceColors(
            //     background: Colors.lightBlue,
            //     primary: Colors.blue,
            //     componentBorder: Colors.red,
            //   ),
            //   shapes: PaymentSheetShape(
            //     borderWidth: 4,
            //     shadow: PaymentSheetShadowParams(color: Colors.red),
            //   ),
            //   primaryButton: PaymentSheetPrimaryButtonAppearance(
            //     shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
            //     colors: PaymentSheetPrimaryButtonTheme(
            //       light: PaymentSheetPrimaryButtonThemeColors(
            //         background: Color.fromARGB(255, 231, 235, 30),
            //         text: Color.fromARGB(255, 235, 92, 30),
            //         border: Color.fromARGB(255, 235, 92, 30),
            //       ),
            //     ),
            //   ),
            // ),
            billingDetails: billingDetails,
          ),
        );

        await Stripe.instance.presentPaymentSheet();
        var checker =
            await checkPaymentSheet({"intentId": paymentIntent['intentId']});

        if (checker.status == true &&
            (checker.data?["paymentStatus"] == "succeeded")) {
          Jks.languageState.showAppNotification(
            title: "Nouvel achat réussi!".tr,
            message: "Paiement réussi! Merci pour votre achat.".tr,
          );
          // Update user subscription status
          if (checker.data["newBalance"] != null) {
            await appStore.setBalence(checker.data["newBalance"]);
            Jks.wizardState.currentUser = Jks.currentUser = Jks.currentUser!
                .copyWith(
                    balance: UserBalence.fromJson(checker.data["newBalance"]));
          }

          Jks.languageState.showAppNotification(
            title: "Vouvel achat réussi!".tr,
            message: "Paiement confirmé".tr,
          );

          if (onConfirmed != null) {
            onConfirmed();
          }
          isLoading = false;

          clearCart();

          // await updateUser(user.id, user.toJson());
          // Jks.currentUser = user;
          // appStore.setUser(Jks.currentUser!);
          // // Navigate to home or another page
          // context.go(RouteNames.home);
        } else {
          // Handle payment verification failure
          show_common_toast(
              "Échec de la vérification du paiement, veuillez réessayer.".tr,
              Jks.context!);
          isLoading = false;
          notifyListeners();
          return;
        }
      } else {
        // Handle payment failure
        show_common_toast(
            "Échec du paiement, veuillez réessayer.".tr, Jks.context!);

        isLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      if (e is StripeException) {
        show_common_toast(
            "Échec du paiement, veuillez réessayer.".tr, Jks.context!);
        my_inspect(e.error);
      } else {
        show_common_toast("Erreur inattendue", Jks.context!);
        my_inspect(e);
      }

      isLoading = false;
      notifyListeners();
      return;
    }
  }
}

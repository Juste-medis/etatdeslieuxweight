// 🐦 Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/models/couponmodel.dart';
import 'package:nb_utils/nb_utils.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';

class AddCouponDialog extends StatefulWidget {
  final Function()? onSuccessAction;
  final CouponModel? coupon;
  const AddCouponDialog({super.key, this.onSuccessAction, this.coupon});

  @override
  State<AddCouponDialog> createState() => _AddCouponDialogState();
}

class _AddCouponDialogState extends State<AddCouponDialog> {
  CouponModel coupon = CouponModel(
    code: '',
    discount: 0,
    type: 'fixed',
    expiryDate: DateTime.now(),
    isActive: true,
    usageunique: false,
    createdBy: '',
  );
  bool couponActive = true;
  bool usageunique = false;

  @override
  void initState() {
    super.initState();
    if (widget.coupon != null) {
      setState(() {
        coupon = widget.coupon!;
      });
    }
    couponActive = coupon.isActive;
    usageunique = coupon.usageunique;
  }

  void _saveCouppon() {
    if (coupon.code.trim().isEmpty) {
      toast("Le code du coupon est requis".tr, bgColor: Colors.red);
      return;
    }
    if (coupon.discount <= 0) {
      toast("La réduction doit être supérieure à zéro".tr, bgColor: Colors.red);
      return;
    }
    if (coupon.expiryDate.isBefore(DateTime.now())) {
      toast("La date d'expiration doit être dans le futur".tr,
          bgColor: Colors.red);
      return;
    }
    coupon = coupon.copyWith(isActive: couponActive);

    if (widget.coupon != null) {
      // Update existing coupon
      updateCoupon(coupon.toJson()).then((value) {
        if (value.status == true) {
          if (widget.onSuccessAction != null) {
            widget.onSuccessAction!();
          }
          simulateScreenTap();
        } else {
          toast(value.message ?? "Échec de la mise à jour du coupon".tr,
              bgColor: Colors.red);
        }
      }).catchError((error) {
        toast("Échec de la mise à jour du coupon".tr, bgColor: Colors.red);

        debugPrint('Error updating coupon: $error');
      });
      return;
    }

    createCoupon(coupon.toJson()).then((value) {
      if (value.status == true) {
        if (widget.onSuccessAction != null) {
          widget.onSuccessAction!();
        }
        simulateScreenTap();
      } else {
        toast(value.message ?? "Échec de l'ajout du coupon".tr,
            bgColor: Colors.red);
      }
    }).catchError((error) {
      toast("Échec de l'ajout du coupon".tr, bgColor: Colors.red);

      debugPrint('Error creating coupon: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(
        vertical: _sizeInfo.padding.vertical,
        horizontal: _sizeInfo.padding.horizontal,
      ),
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 606,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // const Text('Form Dialog'),
                          Text("Ajouter un coupon".tr,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              )),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              color: AcnooAppColors.kError,
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.height,
                    editUserField(
                      title: "Code du coupon".tr,
                      initialvalue: coupon.code,
                      placeholder: "Code du coupon",
                      onChanged: (text) {
                        coupon = coupon.copyWith(code: text);
                      },
                      required: true,
                    ),
                    editUserField(
                      title: "Réduction".tr,
                      type: "number",
                      initialvalue: coupon.discount.toString(),
                      placeholder: "Réduction",
                      onChanged: (text) {
                        coupon = coupon.copyWith(
                            discount: double.tryParse(text) ?? 0);
                      },
                      required: true,
                    ),
                    editUserField(
                        title: "Type de coupon".tr,
                        initialvalue: coupon.type,
                        type: "select",
                        centerTitle: false,
                        onChanged: (text) {
                          coupon = coupon.copyWith(type: text);
                        },
                        showplaceholder: true,
                        showLabel: false,
                        items: coupponTypes),
                    editUserField(
                      title: "Montant minimum de la commande".tr,
                      type: "number",
                      initialvalue: (coupon.minimumAmount ?? 0).toString(),
                      placeholder: "Minimum",
                      onChanged: (text) {
                        coupon = coupon.copyWith(
                            minimumAmount: double.tryParse(text) ?? 0);
                      },
                      required: true,
                    ),
                    editUserField(
                      type: "date",
                      title: "Date d'expiration".tr,
                      minimumDate: DateTime.now(),
                      initialvalue: DateFormat('dd-MM-yyyy')
                          .format(coupon.expiryDate)
                          .toString(),
                      onChanged: (text) {
                        coupon = coupon.copyWith(expiryDate: text);
                      },
                      textEditingController: TextEditingController(
                          text: DateFormat('dd-MM-yyyy')
                              .format(coupon.expiryDate)
                              .toString()),
                      required: true,
                    ),
                    const SizedBox(height: 20),
                    editUserField(
                      type: "textarea",
                      title: "Note".tr,
                      initialvalue: coupon.comments,
                      minLines: 3,
                      onChanged: (text) {
                        coupon = coupon.copyWith(comments: text);
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        userRadio(
                          theme: theme,
                          thevalue: true,
                          label: "Active".tr,
                        ),
                        30.width,
                        userRadio(
                          theme: theme,
                          thevalue: false,
                          label: "Inactive".tr,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Usage unique".tr,
                          style: textTheme.labelLarge,
                        ),
                        30.width,
                        Checkbox.adaptive(
                            value: usageunique,
                            onChanged: (bool? value) {
                              setState(() {
                                usageunique = value ?? false;
                              });
                              coupon =
                                  coupon.copyWith(usageunique: usageunique);
                            }),
                      ],
                    ),
                    30.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cancelButton(
                          context,
                          title: null,
                          sizeInfo: _sizeInfo,
                        ), // null = use default 'Cancel'
                        SizedBox(width: _sizeInfo.innerSpacing),
                        inventoryAddButton(context,
                            title: lang.save, onPressed: _saveCouppon),
                      ],
                    ).paddingSymmetric(horizontal: _sizeInfo.innerSpacing),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget userRadio({theme, bool thevalue = false, label}) {
    return Flexible(
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: SizedBox.square(
                  dimension: 16,
                  child: Radio(
                    value: thevalue,
                    groupValue: couponActive,
                    activeColor: theme.colorScheme.primary,
                    fillColor:
                        WidgetStateProperty.all(theme.colorScheme.primary),
                    onChanged: couponActive == thevalue
                        ? null
                        : (bool? value) {
                            setState(() {
                              couponActive = value!;
                            });
                          },
                  )),
            ),
            const WidgetSpan(
              child: SizedBox(width: 6),
            ),
            TextSpan(
              text: label,
              mouseCursor: SystemMouseCursors.click,
              recognizer: TapGestureRecognizer()
                ..onTap = () => setState(
                      () => couponActive = thevalue,
                    ),
            ),
          ],
        ),
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.checkboxTheme.side?.color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}

// -------------------Dotted Border

class DottedBorderContainer extends StatelessWidget {
  final Widget child;

  const DottedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          DottedBorderPainter(color: Theme.of(context).colorScheme.outline),
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 120,
        width: 120,
        child: Center(child: child),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;

  DottedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const radius = Radius.circular(5.0);
    const rect = Rect.fromLTWH(0, 0, 120, 120);
    final rrect = RRect.fromRectAndRadius(rect, radius);

    final path = Path()..addRRect(rrect);

    const dashWidth = 4.0;
    const dashSpace = 4.0;

    double distance = 0.0;
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      while (distance < pathMetric.length) {
        final start = distance;
        final end = distance + dashWidth;

        final lineSegment = pathMetric.extractPath(start, end);
        canvas.drawPath(lineSegment, paint);

        distance += dashWidth + dashSpace;
      }
      distance = 0.0; // Reset distance for the next segment
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

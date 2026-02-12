// 🐦 Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/field_styles/_dropdown_styles.dart';
import 'package:jatai_etadmin/app/core/helpers/field_styles/field_styles.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/models.dart';
import 'package:jatai_etadmin/app/widgets/textfield_wrapper/_textfield_wrapper.dart';
import 'package:nb_utils/nb_utils.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/theme/_app_colors.dart';

class AddUserDialog extends StatefulWidget {
  final User? user;
  final VoidCallback? onSuccessAction;
  const AddUserDialog({super.key, this.user, this.onSuccessAction});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  String? _selectedPosition;
  bool userActive = true;
  String countryCode = "+33";
  String country = "France";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late User user = widget.user ??
      User(
        isActive: true,
      );

  @override
  void initState() {
    if (widget.user != null) {
      userActive = widget.user!.isActive ?? true;
      country = widget.user!.country ?? "France";
      countryCode = countryCodes[country]?.dialCode ?? "+33";
    }
    super.initState();
  }

  void _saveUser() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    user = user.copyWith(
        isActive: userActive, country: country, countryCode: countryCode);

    if (user.lastName!.trim().isEmpty) {
      toast("Le nom de l'utilisateur est requis".tr, bgColor: Colors.red);
      return;
    }
    if (user.firstName!.trim().isEmpty) {
      toast("Le prénom de l'utilisateur est requis".tr, bgColor: Colors.red);
      return;
    }
    if (user.email!.trim().isEmpty) {
      toast("L'email de l'utilisateur est requis".tr, bgColor: Colors.red);
      return;
    }
    if (user.level == null || user.level!.trim().isEmpty) {
      toast("Le type de l'utilisateur est requis".tr, bgColor: Colors.red);
      return;
    }
    if (user.phoneNumber == null || user.phoneNumber!.trim().isEmpty) {
      toast("Le numéro de téléphone est requis".tr, bgColor: Colors.red);
      return;
    }
    if (user.password != null &&
        user.password != "" &&
        user.password!.isNotEmpty) {
      if (user.password != user.passwordc) {
        toast("Les mots de passe ne correspondent pas".tr, bgColor: Colors.red);
        return;
      }
    }

    if (widget.user != null) {
      var request = user.toJson();

      modifyUser(user.toJson()).then((value) {
        if (value.status == true) {
          if (widget.onSuccessAction != null) {
            widget.onSuccessAction!();
          }
          simulateScreenTap();
        } else {
          toast(value.message ?? "Échec de la mise à jour de l'utilisateur".tr,
              bgColor: Colors.red);
        }
      }).catchError((error) {
        toast("Échec de la mise à jour de l'utilisateur".tr,
            bgColor: Colors.red);

        myprint('Error updating user: $error');
      });
      return;
    }
    addUser(user.toJson()).then((value) {
      if (value.status == true) {
        if (widget.onSuccessAction != null) {
          widget.onSuccessAction!();
        }
        simulateScreenTap();
      } else {
        toast(value.message ?? "Échec de l'ajout de l'utilisateur".tr,
            bgColor: Colors.red);
      }
    }).catchError((error) {
      toast("Échec de l'ajout de l'utilisateur".tr, bgColor: Colors.red);

      myprint('Error creating user: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    final lang = l.S.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    final _item = countryCodes.entries
        .map((item) => DropdownMenuItem<String>(
              value: item.value.dialCode,
              child: buildDropdownForPhode(context, item: item),
            ))
        .toList();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Text('Form Dialog'),
                Text("Ajouter un utilisateur".tr,
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
            SizedBox(
              width: 606,
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    editUserField(
                      title: "Nom de l'utilisateur".tr,
                      initialvalue: user.lastName,
                      placeholder: "Entrez le nom",
                      onChanged: (text) {
                        user = user.copyWith(lastName: text);
                      },
                      required: true,
                    ),
                    editUserField(
                      title: "Prénom de l'utilisateur".tr,
                      initialvalue: user.firstName,
                      placeholder: "Entrez le prénom",
                      onChanged: (text) {
                        user = user.copyWith(firstName: text);
                      },
                      required: true,
                    ),
                    editUserField(
                      title: "Addresse e-mail".tr,
                      initialvalue: user.email,
                      placeholder: "Entrez l 'email",
                      email: true,
                      onChanged: (text) {
                        user = user.copyWith(email: text);
                      },
                      required: true,
                    ),
                    editUserField(
                        title: "Type de l'utilisateur".tr,
                        initialvalue: user.level,
                        type: "select",
                        centerTitle: false,
                        onChanged: (text) {
                          user = user.copyWith(level: text);
                        },
                        showplaceholder: true,
                        showLabel: false,
                        items: userLevels),
                    16.height,
                    TextFieldLabelWrapper(
                      labelText: "${lang.phoneNumber} ${user.phoneNumber}",
                      inputField: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: user.phoneNumber,
                        onChanged: (value) {
                          user = user.copyWith(phoneNumber: value);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          prefixIcon: DropdownButton2<String>(
                            underline: const SizedBox.shrink(),
                            isDense: true,
                            isExpanded: true,
                            style: theme.textTheme.bodyMedium,
                            iconStyleData: _dropdownStyle.iconStyle,
                            dropdownStyleData: _dropdownStyle.dropdownStyle
                                .copyWith(width: 150),
                            menuItemStyleData: _dropdownStyle.menuItemStyle,
                            value: countryCode,
                            items: _item,
                            onChanged: (String? value) {
                              if (value == null) return;
                              setState(() {
                                countryCode = value;
                                country = countryCodes.entries
                                    .firstWhere((entry) =>
                                        entry.value.dialCode == value)
                                    .key;
                              });
                            },
                          ).paddingOnly(left: 10, right: 10),
                          prefixIconConstraints:
                              AcnooInputFieldStyles(context).iconConstraints2,
                          hintText: lang.enterYourPhoneNumber,
                        ),
                        validator: (value) {
                          return requiredforminput(
                              value, lang.pleaseEnterYourPhoneNumber);
                        },
                      ),
                    ).paddingOnly(bottom: 12),
                    const SizedBox(height: 20),
                    ExpansionWidget(
                      expandedAlignment: Alignment.topLeft,
                      initiallyExpanded: false,
                      titleBuilder: (animationValue, easeInValue, isExpanded,
                              toggleFunction) =>
                          InkWell(
                        onTap: () => toggleFunction(animated: true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            border: BorderDirectional(
                              bottom: BorderSide(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Informtions complémentaires".tr,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              AnimatedRotation(
                                turns: isExpanded ? 0.25 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: AcnooAppColors.kPrimary700,
                                ),
                              ),
                            ],
                          ).paddingSymmetric(vertical: 5),
                        ),
                      ),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          editUserField(
                            type: "date",
                            title: "Date de naissance".tr,
                            placeholder: "Sélectionnez la date de naissance",
                            // maximumDate: DateTime.now(),
                            onChanged: (text) {
                              user = user.copyWith(dob: text);
                            },
                            textEditingController: TextEditingController(
                                text: DateFormat('dd-MM-yyyy')
                                    .format(user.dob ?? DateTime.now())
                                    .toString()),
                            required: true,
                          ),
                          editUserField(
                            title: "Addresse".tr,
                            type: "place",
                            initialvalue: user.placeOfBirth,
                            placeholder: "Entrez l'addresse de l'utilisateur",
                            onChanged: (text) {
                              user = user.copyWith(address: text);
                            },
                          ),
                          editUserField(
                            title: "Lieu de naissance".tr,
                            type: "place",
                            initialvalue: user.placeOfBirth,
                            placeholder: "Entrez le lieu de naissance",
                            onChanged: (text) {
                              user = user.copyWith(placeOfBirth: text);
                            },
                          ),
                          editUserField(
                            title: "À propos".tr,
                            type: "textarea",
                            initialvalue: user.about,
                            placeholder: "Décrivez l'utilisateur",
                            minLines: 4,
                            onChanged: (text) {
                              user = user.copyWith(about: text);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    editUserField(
                      title: "Mot de passe".tr,
                      type: "password",
                      initialvalue: user.password,
                      placeholder: "Entrez le nom",
                      onChanged: (text) {
                        user = user.copyWith(password: text);
                      },
                    ),
                    editUserField(
                      title: "Confirmer le mot de passe".tr,
                      type: "password",
                      initialvalue: user.passwordc,
                      placeholder: "Confirmez le mot de passe",
                      onChanged: (text) {
                        user = user.copyWith(passwordc: text);
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
                            title: lang.save, onPressed: _saveUser),
                      ],
                    ).paddingSymmetric(horizontal: _sizeInfo.innerSpacing),
                  ],
                ),
              ),
            ).paddingAll(16)
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
                    groupValue: userActive,
                    activeColor: theme.colorScheme.primary,
                    fillColor:
                        WidgetStateProperty.all(theme.colorScheme.primary),
                    onChanged: userActive == thevalue
                        ? null
                        : (bool? value) {
                            setState(() {
                              userActive = value!;
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
                      () => userActive = thevalue,
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

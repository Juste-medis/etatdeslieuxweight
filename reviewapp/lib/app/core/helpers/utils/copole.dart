// ignore_for_file: empty_catches

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/helpers.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/string_extensions.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/mylocale.dart';
import 'package:mon_etatsdeslieux/app/pages/pricing/pricing_view.dart';
import 'package:mon_etatsdeslieux/app/providers/_payment_provider.dart';
import 'package:mon_etatsdeslieux/app/providers/_theme_provider.dart';
import 'package:mon_etatsdeslieux/app/widgets/autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:mon_etatsdeslieux/app/widgets/counter_field/_counter_field.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/prompt_dialog.dart';
import 'package:mon_etatsdeslieux/app/widgets/textfield_wrapper/_textfield_wrapper.dart';
import 'package:mon_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:country_flags/country_flags.dart';
import 'package:mon_etatsdeslieux/generated/l10n.dart' as l;
import 'package:provider/provider.dart';

Widget editUserField({
  required title,
  onFieldSubmitted,
  secondtitle,
  initialvalue,
  textEditingController,
  placeholder,
  onChanged,
  onTapOutside,
  widget,
  onmapTap,
  type = TextFieldType.NAME,
  context,
  dynamic onTap,
  showLabel = true,
  showplaceholder = false,
  validator,
  bool required = false,
  email = false,
  bool? enabled,
  Map<String, dynamic>? items,
  leftwidget,
  rightwidget,
  contentPadding,
  maximumDate,
  onTitleModified,
  minimumDate,
  minLines = 1,
  String? layout,
}) {
  context ??= Jks.context!;
  final _lang = l.S.of(context);

  validator ??= (required || email)
      ? (value) {
          if (email) {
            return validateEmail(
              value,
              _lang.requiredInfo,
              _lang.pleaseentervalidEmail,
            );
          }
          return requiredforminput(value, _lang.requiredInfo);
        }
      : (value) => null;
  final theme = Theme.of(context);

  var titleW = Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
    ),
  ).paddingSymmetric(vertical: 5);
  final screenWidth = MediaQuery.of(context).size.width;
  final isDarkMode = theme.brightness == Brightness.dark;

  switch (type) {
    case "select":
      final _dropdownStyle = AcnooDropdownStyle(context);
      if (layout == 'row') {
        return Row(
          children: [
            if (showLabel) titleW.withWidth(150),
            Expanded(
              child: DropdownButtonFormField2(
                buttonStyleData: _dropdownStyle.buttonStyle,
                menuItemStyleData: _dropdownStyle.menuItemStyle,
                iconStyleData: _dropdownStyle.iconStyle,
                dropdownStyleData: _dropdownStyle.dropdownStyle,
                value: items!.entries.toList().indexWhere(
                              (entry) => entry.key == initialvalue,
                            ) >=
                        0
                    ? items.entries.toList().indexWhere(
                          (entry) => entry.key == initialvalue,
                        )
                    : 0,
                decoration: inputDecoration(
                  context,
                  labelText: showplaceholder ? placeholder : null,
                ),
                items: List.generate(
                  items.length,
                  (index) => DropdownMenuItem(
                    enabled: (enabled ?? mrv()),
                    value: index,
                    child: Row(
                      children: [
                        if (items.entries.elementAt(index).value["icon"] !=
                            null)
                          getImageType(
                            items.entries.elementAt(index).value["icon"],
                            height: 24,
                            width: 24,
                            fit: BoxFit.contain,
                          ),
                        8.width,
                        Text('${items.entries.elementAt(index).value["name"]}'),
                      ],
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (onChanged != null) {
                    onChanged(items.entries.elementAt(value!).key);
                  }
                },
              ),
            ),
          ],
        );
      }
      if (layout == 'column') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showLabel) titleW,
            DropdownButtonFormField2(
              buttonStyleData: _dropdownStyle.buttonStyle,
              menuItemStyleData: _dropdownStyle.menuItemStyle,
              iconStyleData: _dropdownStyle.iconStyle,
              dropdownStyleData: _dropdownStyle.dropdownStyle,
              value: items!.entries.toList().indexWhere(
                            (entry) => entry.key == initialvalue,
                          ) >=
                      0
                  ? items.entries.toList().indexWhere(
                        (entry) => entry.key == initialvalue,
                      )
                  : 0,
              decoration: inputDecoration(
                context,
                labelText: showplaceholder ? placeholder : null,
              ),
              items: List.generate(
                items.length,
                (index) => DropdownMenuItem(
                  enabled: (enabled ?? mrv()),
                  value: index,
                  child: Row(
                    children: [
                      if (items.entries.elementAt(index).value["icon"] != null)
                        getImageType(
                          items.entries.elementAt(index).value["icon"],
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                      if (items.entries.elementAt(index).value["icon"] != null)
                        8.width,
                      Text('${items.entries.elementAt(index).value["name"]}'),
                    ],
                  ),
                ),
              ),
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged(items.entries.elementAt(value!).key);
                }
              },
            ),
          ],
        );
      }
      if (layout == 'simplerow') {
        return Row(
          children: [
            if (showLabel) titleW.withWidth(150),
            Expanded(
              child: DropdownButtonFormField2(
                buttonStyleData: _dropdownStyle.buttonStyle,
                menuItemStyleData: _dropdownStyle.menuItemStyle,
                iconStyleData: _dropdownStyle.iconStyle,
                dropdownStyleData: _dropdownStyle.dropdownStyle,
                value: items!.entries.toList().indexWhere(
                              (entry) => entry.key == initialvalue,
                            ) >=
                        0
                    ? items.entries.toList().indexWhere(
                          (entry) => entry.key == initialvalue,
                        )
                    : 0,
                decoration: inputDecoration(
                  context,
                  labelText: showplaceholder ? placeholder : null,
                ),
                items: List.generate(items.length, (index) {
                  return DropdownMenuItem(
                    enabled: (enabled ?? mrv()),
                    value: index,
                    child: Row(
                      children: [
                        Text('${items.entries.elementAt(index).value}'),
                      ],
                    ),
                  );
                }),
                onChanged: (value) {
                  if (onChanged != null) {
                    onChanged(items.entries.elementAt(value!).key);
                  }
                },
              ),
            ),
          ],
        );
      }
      return ListTile(
        contentPadding: const EdgeInsets.all(0),
        enabled: (enabled ?? mrv()),
        subtitle: TextFieldLabelWrapper(
          enabled: (enabled ?? mrv()),
          labelText: "",
          label: titleW.center(),
          inputField: DropdownButtonFormField2(
            value: items!.entries.toList().indexWhere(
                          (entry) => entry.key == initialvalue,
                        ) >=
                    0
                ? items.entries.toList().indexWhere(
                      (entry) => entry.key == initialvalue,
                    )
                : 0,
            buttonStyleData: _dropdownStyle.buttonStyle,
            menuItemStyleData: _dropdownStyle.menuItemStyle,
            iconStyleData: _dropdownStyle.iconStyle,
            dropdownStyleData: _dropdownStyle.dropdownStyle,
            decoration: inputDecoration(
              context,
              labelText: showplaceholder ? placeholder : null,
            ),
            items: List.generate(
              items.length,
              (index) => DropdownMenuItem(
                enabled: (enabled ?? mrv()),
                value: index,
                child: Text('${items.entries.elementAt(index).value}'),
              ),
            ),
            onChanged: (value) {
              if (onChanged != null) {
                onChanged(items.entries.elementAt(value!).key);
              }
            },
          ),
        ),
      );

    case "place":
    case "city":
      return ListTile(
        title: titleW,
        contentPadding: const EdgeInsets.all(0),
        subtitle: AppTextField(
          enabled: (enabled ?? mrv()),
          textFieldType: TextFieldType.NAME,
          controller: textEditingController,
          cursorColor: Jks.context!.theme.primaryColor,
          validator: validator,
          onChanged: onChanged ?? (text) {},
          decoration: inputDecoration(
            context,
            labelText: showplaceholder ? placeholder : null,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapBoxAutoCompleteWidget(
                language: 'fr',
                closeOnSelect: true,
                city: type,
                limit: 10,
                hint: _lang.whereSearching,
                onSelect: (place) {
                  try {
                    if (onChanged != null) {
                      if (type == "city") {
                        String cityName = (place.placeName ?? "Paris,")
                            .split(',')
                            .first
                            .trim();
                        onChanged(cityName);
                        textEditingController.text = cityName;
                      } else {
                        onChanged(place.placeName);
                        textEditingController.text = place.placeName;
                      }
                      Jks.wizardState.updateFormValue("_", "_");
                    }
                  } catch (e) {}
                },
              ),
            ),
          ),
        ),
      );

    case "textarea":
      return ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: showLabel ? titleW : null,
        subtitle: AppTextField(
          onTapOutside: onTapOutside ?? (text) {},
          enabled: (enabled ?? mrv()),
          textFieldType: TextFieldType.MULTILINE,
          controller: textEditingController,
          cursorColor: Jks.context!.theme.primaryColor,
          maxLines: 10,
          minLines: minLines,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          onChanged: onChanged ?? (text) {},
          decoration: inputDecoration(
            context,
            labelText: showplaceholder ? placeholder : null,
            contentPadding: contentPadding,
          ),
          initialValue: initialvalue ?? "",
          errorInvalidEmail: _lang.pleaseentervalidEmail,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
        ),
      );

    case "date":
      void taptap() {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            DateTime selectedDate =
                DateTime.now(); // Variable pour stocker la date sélectionnée

            return Container(
              height: 350, // Augmenté pour accommoder le bouton
              color: Jks.context!.theme.colorScheme.primaryContainer,
              child: Column(
                children: [
                  // Bouton OK en haut
                  Container(
                    decoration: BoxDecoration(
                      color: Jks.context!.theme.colorScheme.primaryContainer,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          child: Text(
                            'OK',
                            style: TextStyle(color: theme.primaryColor),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            if (onChanged != null) {
                              onChanged(selectedDate);
                            }
                            textEditingController.text =
                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      backgroundColor:
                          Jks.context!.theme.colorScheme.primaryContainer,
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDate) {
                        selectedDate = newDate;
                        // Jks.wizardState.updateFormValue("_", "_");
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
      return ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: (showLabel ?? false) ? titleW : null,
        subtitle: AppTextField(
          enabled: (enabled ?? mrv()),
          textFieldType: TextFieldType.NAME,
          controller: textEditingController,
          cursorColor: Jks.context!.theme.primaryColor,
          validator: validator,
          onChanged: onChanged ?? (text) {},
          decoration: inputDecoration(
            context,
            labelText: showplaceholder ? placeholder : null,
            prefixIcon: Icon(
              Icons.calendar_today,
              color: theme.primaryColor,
            ),
          ).copyWith(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 18,
            ),
          ), // Set padding here
          readOnly: true,
          onTap: taptap,
        ),
      );

    case "daterange":
      void taptap() async {
        DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: minimumDate ?? DateTime(2000),
          lastDate: maximumDate ?? DateTime(2100),
        );
        if (picked != null) {
          if (onChanged != null) {
            onChanged(
              "${picked.start.day}/${picked.start.month}/${picked.start.year} - ${picked.end.day}/${picked.end.month}/${picked.end.year}",
            );
          }
          textEditingController.text =
              "${picked.start.day}/${picked.start.month}/${picked.start.year} - ${picked.end.day}/${picked.end.month}/${picked.end.year}";
        }
      }
      return ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: showLabel ? titleW : null,
        subtitle: AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: textEditingController,
          cursorColor: Jks.context!.theme.primaryColor,
          validator: validator,
          onChanged: onChanged ?? (text) {},
          decoration: inputDecoration(
            context,
            labelText: showplaceholder ? placeholder : null,
          ).copyWith(
            prefixIcon: const Icon(Icons.date_range),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 18,
            ),
          ), // Set padding here
          readOnly: true,
          onTap: taptap,
        ),
      );

    case "phone":
      String countryCode = "+44"; // Default country code

      return ListTile(
        title: titleW,
        contentPadding: const EdgeInsets.all(0),
        subtitle: Row(
          children: [
            Expanded(
              child: AppTextField(
                enabled: (enabled ?? mrv()),
                textFieldType: TextFieldType.NUMBER,
                controller: textEditingController,
                cursorColor: Jks.context!.theme.primaryColor,
                initialValue: initialvalue ?? "",
                keyboardType: TextInputType.phone,
                onChanged: onChanged ?? (text) {},
                decoration: inputDecoration(
                  context,
                  labelText: showplaceholder ? placeholder : null,
                ),
              ),
            ),
          ],
        ),
      );

    case "password":
      bool isPasswordVisible = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: titleW,
            subtitle: AppTextField(
              textFieldType: TextFieldType.PASSWORD,
              keyboardType: TextInputType.visiblePassword,
              controller: textEditingController,
              cursorColor: Jks.context!.theme.primaryColor,
              validator: validator,
              isPassword: true,
              suffixPasswordInvisibleWidget: Icon(
                Icons.visibility_off,
              ).paddingOnly(right: 10),
              suffixPasswordVisibleWidget: Icon(
                Icons.visibility,
              ).paddingOnly(right: 10),
              obscureText: !isPasswordVisible, // Toggle visibility
              onChanged: onChanged ?? (text) {},
              decoration: inputDecoration(
                context,
                labelText: showplaceholder ? placeholder : null,
                contentPadding: contentPadding,
              ),
            ),
          );
        },
      );

    case "widget":
      return StatefulBuilder(
        builder: (context, setState) {
          return ListTile(title: titleW, subtitle: widget);
        },
      );

    case "numberandtext":
      return Card(
        color: Colors.white,
        elevation: 3,
        child: ListTile(
          title: showLabel
              ? Column(
                  children: [
                    titleW,
                    CounterField(
                      onChanged: (value) {
                        if (onChanged != null && mrv()) {
                          onChanged(value, null);
                        }
                      },
                    ).paddingOnly(top: 10).withWidth(200),
                  ],
                ).paddingOnly(bottom: 20)
              : null,
          contentPadding: const EdgeInsets.all(0),
          subtitle: AppTextField(
            title: secondtitle,
            titleTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.text,
            textFieldType: TextFieldType.NAME,
            controller: textEditingController,
            errorInvalidEmail: _lang.pleaseentervalidEmail,
            cursorColor: Jks.context!.theme.primaryColor,
            validator: validator,
            onChanged: (text) {
              onChanged(null, text);
            },
            decoration: inputDecoration(
              context,
              labelText: showplaceholder ? placeholder : null,
            ),
          ),
        ).paddingAll(25),
      );

    case "counterfield":
      if (layout == "row") {
        return Row(
          children: [
            if (showLabel) titleW.withWidth(150),

            // CounterField takes remaining space
            Flexible(
              child: CounterField(
                initialValue: "$initialvalue",
                onChanged: (value) => onChanged?.call(value),
              ).withWidth(200),
            ),
          ],
        );
      }
      return ListTile(
        title: showLabel
            ? Column(
                children: [
                  titleW,
                  CounterField(
                    initialValue: "$initialvalue",
                    onChanged: (value) {
                      if (onChanged != null && mrv()) {
                        onChanged(value);
                      }
                    },
                  ).paddingOnly(top: 10).withWidth(200),
                ],
              ).paddingOnly(bottom: 20)
            : null,
        contentPadding: const EdgeInsets.all(0),
      );
    default:
      if (layout == "row") {
        return Row(
          children: [
            if (showLabel) titleW.withWidth(150),
            Expanded(
              child: AppTextField(
                enabled: (enabled ?? mrv()),
                keyboardType: email
                    ? TextInputType.emailAddress
                    : type == "number"
                        ? TextInputType.number
                        : TextInputType.text,
                textFieldType: email
                    ? TextFieldType.EMAIL
                    : type == "number"
                        ? TextFieldType.NUMBER
                        : TextFieldType.NAME,
                controller: textEditingController,
                initialValue: initialvalue ?? "",
                errorInvalidEmail: _lang.pleaseentervalidEmail,
                cursorColor: Jks.context!.theme.primaryColor,
                onFieldSubmitted: onFieldSubmitted,
                validator: validator,
                onChanged: onChanged ?? (text) {},
                decoration: inputDecoration(
                  context,
                  labelText: showplaceholder ? placeholder : null,
                  contentPadding: contentPadding,
                  fillColor: !isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      }
      return ListTile(
        title: rightwidget != null
            ? SizedBox(
                width: double.infinity,
                child: SizedBox(
                  height: 60,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(right: 10, top: 75, child: Text(rightwidget)),
                      Positioned(left: 0, right: 20, top: 20, child: titleW),
                    ],
                  ),
                ),
              )
            : leftwidget != null
                ? SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      height: showLabel ? 60 : 0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: showLabel ? 10 : 10,
                            top: showLabel ? 75 : 15,
                            child: leftwidget,
                          ),
                          if (showLabel)
                            Positioned(
                                left: 0, right: 20, top: 20, child: titleW),
                        ],
                      ),
                    ),
                  )
                : (showLabel ? titleW : null),
        contentPadding: const EdgeInsets.all(0),
        //
        subtitle: AppTextField(
          onTapOutside: onTapOutside ?? (text) {},
          enabled: (enabled ?? mrv()),
          keyboardType: email
              ? TextInputType.emailAddress
              : type == "number"
                  ? TextInputType.number
                  : TextInputType.text,
          textFieldType: email
              ? TextFieldType.EMAIL
              : type == "number"
                  ? TextFieldType.NUMBER
                  : TextFieldType.NAME,
          controller: textEditingController,
          initialValue: "${initialvalue ?? ""}",
          errorInvalidEmail: _lang.pleaseentervalidEmail,
          cursorColor: Jks.context!.theme.primaryColor,
          // Customize input text color here
          textStyle: TextStyle(
            color: (enabled ?? mrv())
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).disabledColor,
          ),
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          onChanged: onChanged ?? (text) {},
          decoration: inputDecoration(
            context,
            labelText: showplaceholder ? placeholder : null,
            contentPadding: showLabel
                ? contentPadding
                : const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          ).copyWith(
            // Optional: customize hint/placeholder color too
            hintStyle: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      );
  }
}

Widget buildDropdownTile(
  BuildContext context, {
  required MapEntry<String, Locale> item,
}) {
  final _size = MediaQuery.sizeOf(context);
  return Row(
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: CountryFlag.fromCountryCode(
          item.value.countryCode ?? 'us',
          theme: ImageTheme(height: 20, width: 26),
        ),
      ),
      Text(item.key),
    ],
  );
}

Widget buildDropdownForPhode(
  BuildContext context, {
  required MapEntry<String, MyLocale> item,
}) {
  final _size = MediaQuery.sizeOf(context);
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: CountryFlag.fromCountryCode(
            item.value.countryCode,
            theme: ImageTheme(height: 20, width: 26),
          ),
        ),
        Text(item.key),
      ],
    ),
  );
}

Widget inventoryInput(
  BuildContext context, {
  String lang = "",
  TextFieldType type = TextFieldType.NAME,
}) {
  return AppTextField(
    textFieldType: type,
    // controller: emailCont,
    cursorColor: redColor,
    // focus: emailFocus,
    errorThisFieldRequired: "required",
    // nextFocus: passwordFocus,
    decoration: inputDecoration(context, labelText: lang),
    // suffix: ic_message
    //     .iconImage(padding: 3, color: primaryColor)
    //     .paddingAll(14),
  ).paddingBottom(16);
}

Widget inventoryAddButton(
  BuildContext context, {
  title,
  icon,
  onPressed,
  isLoading = false,
}) {
  final theme = Theme.of(context);

  final _buttonTextStyle = theme.textTheme.bodyLarge?.copyWith(
    fontWeight: FontWeight.w800,
    fontSize: 13,
    height: 1.2,
  );
  const _buttonPadding = EdgeInsetsDirectional.symmetric(
    horizontal: 10,
    vertical: 4,
  );
  return ElevatedButton.icon(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      shadowColor: Colors.transparent,
      padding: _buttonPadding,
      elevation: 0,
      textStyle: _buttonTextStyle,
    ),
    icon: isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: theme.colorScheme.onPrimary,
              strokeWidth: 2,
            ),
          )
        : Icon(icon ?? Icons.add),
    label: Text(title),
  );
}

Widget inventoryAddButton2(BuildContext context, {title, onPressed}) {
  final theme = Theme.of(context);

  final _buttonTextStyle = theme.textTheme.bodyLarge?.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
  const _buttonPadding = EdgeInsetsDirectional.symmetric(
    horizontal: 12,
    vertical: 1,
  );
  return ElevatedButton.icon(
    onPressed: !mrv() ? null : onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary.withOpacity(.1),
      foregroundColor: theme.colorScheme.primary,
      shadowColor: Colors.transparent,
      padding: _buttonPadding,
      elevation: 0,
      textStyle: _buttonTextStyle,
      side: BorderSide(color: theme.colorScheme.onPrimary, width: 2), // Outline
    ),
    icon: Icon(Icons.add),
    label: Text(title),
  );
}

Widget inventoryActionButton(
  BuildContext context, {
  title,
  VoidCallback? onPressed,
  IconData? icon,
}) {
  final theme = Theme.of(context);

  final _buttonTextStyle = theme.textTheme.bodyLarge?.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  const _buttonPadding = EdgeInsetsDirectional.symmetric(
    horizontal: 12,
    vertical: 1,
  );

  // Define colors (same for enabled/disabled states)
  final bgColor = theme.colorScheme.primary.withOpacity(.1);
  final fgColor = theme.colorScheme.primary;

  return ElevatedButton.icon(
    onPressed: onPressed, // Fallback to empty function
    style: ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      shadowColor: Colors.transparent,
      disabledBackgroundColor: bgColor, // Same as enabled
      disabledForegroundColor: fgColor, // Same as enabled
      disabledIconColor: fgColor, // Same as enabled
      padding: _buttonPadding,
      elevation: 0,
      enableFeedback: false,
      textStyle: _buttonTextStyle,
      side: BorderSide(color: theme.colorScheme.onPrimary, width: 2),
    ),
    icon: icon != null ? Icon(icon) : null,
    label: title is Widget ? title : Text(title ?? ''),
  );
}

Widget inventoryFormLabel(BuildContext context, {title, Color? color}) {
  final theme = Theme.of(context);
  color ??= theme.primaryColor;
  return Text(
    "$title",
    style: theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );
}

Widget removeButton(
  BuildContext context, {
  required item,
  required wizardState,
  onPressed,
}) {
  return IconButton(icon: const Icon(Icons.close), onPressed: onPressed);
}

class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  const KeepAliveWidget({super.key, required this.child});

  @override
  State<KeepAliveWidget> createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

Widget backbutton(VoidCallback onPressed, {title = ""}) {
  return AppBar(
    backgroundColor: transparentColor,
    leading: Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onPressed,
      ),
    ),
    title: title is Widget ? title : Text(title),
  );
}

Widget dividerWithLabel({label = ""}) {
  return Row(
    children: [
      Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
      ),
      Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400)),
    ],
  );
}

void showpayementDialog(
  context, {
  required String source,
  VoidCallback? onConfirmed,
}) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return PricingView(source: source, onConfirmed: onConfirmed);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}

void showpayementIntentDialog(
  context, {
  required String source,
  VoidCallback? onConfirmed,
  VoidCallback? onConsumption,
  necessaryCredits = 1,
  availableCredits = 0,
  dialogTitle = "",
  dialogDescription = "",
  balence = 0,
}) {
  final theme = Theme.of(context);
  final wizardState = Jks.wizardState;

  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Consumer2<AppThemeProvider, PaymentProvider>(
          builder: (context, appTheme, appState, child) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mode de paiement",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Solde actuel:",
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        "$balence Crédit(s)",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  Text(
                    "Nombre de crédit nécessaire: 1",
                    style: theme.textTheme.bodyLarge,
                  ),
                  20.height,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: ((appState.isLoading) || (balence) < 1)
                            ? null
                            : () async {
                                final confirmed =
                                    await showAwesomeConfirmDialog(
                                  forceHorizontalButtons: true,
                                  cancelText: 'Annuler'.tr,
                                  confirmText: 'confirmer'.tr,
                                  context: context,
                                  title: dialogTitle,
                                  description: dialogDescription,
                                );
                                if (confirmed ?? false) {
                                  if (onConsumption != null) {
                                    onConsumption();
                                  }
                                }
                              },
                        icon: appState.isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              )
                            : const Icon(Icons.payment),
                        label: Text("Utiliser 1 crédit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                      ),
                      8.height,
                      OutlinedButton(
                        onPressed: appState.isLoading
                            ? null
                            : () {
                                // if (Jks.isNetworkAvailable == false) {
                                //   Jks.languageState.showAppNotification(
                                //     title: "Pas de connexion Internet".tr,
                                //     message:
                                //         "Vérifiez votre connexion Internet et réessayez."
                                //             .tr,
                                //   );
                                //   return;
                                // }
                                showpayementDialog(
                                  context,
                                  source: source,
                                  onConfirmed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    showpayementIntentDialog(
                                      context,
                                      source: source,
                                      onConfirmed: onConfirmed,
                                      onConsumption: onConsumption,
                                      necessaryCredits: necessaryCredits,
                                      availableCredits: availableCredits,
                                      dialogTitle: dialogTitle,
                                      dialogDescription: dialogDescription,
                                      balence: source == "reviewcreated"
                                          ? Jks.wizardState.currentUser.balance
                                                  ?.simple ??
                                              0
                                          : Jks.wizardState.currentUser.balance
                                                  ?.procurement ??
                                              0,
                                    );
                                  },
                                );
                              },
                        child: Text("Acheter des crédits"),
                      ),
                      8.height,
                      TextButton(
                        onPressed: appState.isLoading
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        child: Text("Régler plus tard"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Vous pourrez signer le document après avoir effectué le paiement.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            wizardState.isDarkTheme ? whiteColor : blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}

void showWaitingPayementDialog(
  context, {
  required String source,
  VoidCallback? onConfirmed,
  VoidCallback? onCancel,
}) {
  final theme = Theme.of(context);
  final wizardState = Jks.wizardState;

  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Consumer2<AppThemeProvider, PaymentProvider>(
          builder: (context, appTheme, appState, child) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(500),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payement en cours",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          if (onCancel != null) {
                            onCancel();
                          }
                        },
                      ),
                    ],
                  ),
                  200.height,
                  Text(
                    "En attente de la confirmation du payement...",
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  20.height,
                  SizedBox(
                    key: const ValueKey('loader'),
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  20.height,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          if (onCancel != null) {
                            onCancel();
                          }
                        },
                        child: Text("Annuler le payement"),
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16.0),
                  //   child: Text(
                  //     "Vous pourrez signer le document après avoir effectué le paiement.",
                  //     style: theme.textTheme.bodySmall?.copyWith(
                  //       color:
                  //           wizardState.isDarkTheme ? whiteColor : blackColor,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}

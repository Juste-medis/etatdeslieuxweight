// 🐦 Flutter imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/field_styles/field_styles.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/_user_model.dart';
import 'package:jatai_etatsdeslieux/app/pages/authentication/components/components.dart';
import 'package:jatai_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool showPassword = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  String userType = "";
  String countryCode = "+33";
  String country = "France";

  void registerUser() async {
    Jks.context = context;

    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map<String, dynamic> request = {
        UserKeys.firstName: fNameCont.text.trim(),
        UserKeys.lastName: lNameCont.text.trim(),
        UserKeys.email: emailCont.text.trim(),
        UserKeys.userType: userType,
        UserKeys.contactNumber: phoneNumController.text,
        UserKeys.password: passwordCont.text.trim(),
        UserKeys.country: country,
        "country_code": countryCode,
      };
      await createUser(request).then((res) async {
        await saveUserData(User(email: res.data!.email), token: res.token);
        context.push(
          '/otp',
          extra: {
            "email": res.data!.email,
            "userId": res.data!.iid,
            UserKeys.password: request[UserKeys.password],
          },
        );
      }).catchError((e) {
        my_inspect(e);
        // toast(e.toString());
      });
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _screenWidth = MediaQuery.sizeOf(context).width;

    final _desktopView = _screenWidth >= 1200;
    final _screenHeight = MediaQuery.sizeOf(context).height;
    final _dropdownStyle = AcnooDropdownStyle(context);
    final _item = countryCodes.entries
        .map((item) => DropdownMenuItem<String>(
              value: item.value.dialCode,
              child: buildDropdownForPhode(context, item: item),
            ))
        .toList();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Row(
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: _desktopView ? (_screenWidth * 0.45) : _screenWidth,
                ),
                decoration: BoxDecoration(
                  color: _theme.colorScheme.primaryContainer,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      if (!_desktopView)
                        AuthHeader(
                          screenHeight: _screenHeight,
                          screenWidth: _screenWidth,
                        ),
                      80.height,
                      if (_desktopView)
                        Text.rich(
                          TextSpan(
                            //text: 'Already have an account? ',
                            text: "Votre Etat des lieux",
                            children: [
                              TextSpan(
                                text: " Pas cher",
                                style: _theme.textTheme.labelLarge?.copyWith(
                                  color: _theme.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 45,
                                ),
                              ),
                            ],
                          ),
                          style: _theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 45,
                          ),
                        ).paddingSymmetric(horizontal: 20),

                      // Sign up form
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  lang.signUp,
                                  //'Sign up',
                                  style:
                                      _theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Form(
                                  key: formKey,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child: SingleChildScrollView(
                                    // ignore: prefer_const_constructors
                                    padding: EdgeInsets.fromLTRB(36, 1, 36, 1),
                                    child: Column(
                                      children: [
                                        // Full Name Field
                                        TextFieldLabelWrapper(
                                          labelText: lang.lastName,
                                          inputField: TextFormField(
                                            controller: lNameCont,
                                            decoration: InputDecoration(
                                              hintText: lang.enterYourLastName,
                                            ),
                                            validator: (value) {
                                              return requiredforminput(value,
                                                  lang.pleaseEnterYourLastName);
                                            },
                                          ),
                                        ),
                                        20.height,
                                        TextFieldLabelWrapper(
                                          labelText: lang.firstName,
                                          inputField: TextFormField(
                                            controller: fNameCont,
                                            decoration: InputDecoration(
                                              hintText: lang.enterYourFirstName,
                                            ),
                                            validator: (value) {
                                              return requiredforminput(value,
                                                  lang.pleaseEnterYourFirstName);
                                            },
                                          ),
                                        ),
                                        20.height,

                                        // Email Field
                                        TextFieldLabelWrapper(
                                          // labelText: 'Email',
                                          labelText: lang.email,
                                          inputField: TextFormField(
                                            controller: emailCont,
                                            decoration: InputDecoration(
                                              //hintText: 'Enter email address',
                                              hintText: lang.enterEmailAddress,
                                            ),
                                            validator: (value) {
                                              return requiredforminput(value,
                                                  lang.pleaseEnterYourEmail);
                                            },
                                          ),
                                        ),
                                        20.height,
                                        TextFieldLabelWrapper(
                                          labelText: lang.phoneNumber,
                                          inputField: TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller: phoneNumController,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  DropdownButton2<String>(
                                                underline:
                                                    const SizedBox.shrink(),
                                                isDense: true,
                                                isExpanded: true,
                                                style:
                                                    _theme.textTheme.bodyMedium,
                                                iconStyleData:
                                                    _dropdownStyle.iconStyle,
                                                dropdownStyleData:
                                                    _dropdownStyle.dropdownStyle
                                                        .copyWith(width: 150),
                                                menuItemStyleData:
                                                    _dropdownStyle
                                                        .menuItemStyle,
                                                value: countryCode,
                                                items: _item,
                                                onChanged: (String? value) {
                                                  if (value == null) return;
                                                  setState(() {
                                                    countryCode = value;
                                                    country = countryCodes
                                                        .entries
                                                        .firstWhere((entry) =>
                                                            entry.value
                                                                .dialCode ==
                                                            value)
                                                        .key;
                                                  });
                                                },
                                              ).paddingOnly(
                                                      left: 10, right: 10),
                                              prefixIconConstraints:
                                                  AcnooInputFieldStyles(context)
                                                      .iconConstraints2,
                                              hintText:
                                                  lang.enterYourPhoneNumber,
                                            ),
                                            validator: (value) {
                                              return requiredforminput(value,
                                                  lang.pleaseEnterYourPhoneNumber);
                                            },
                                          ),
                                        ),
                                        20.height,

                                        // Password Field
                                        TextFieldLabelWrapper(
                                          //labelText: 'Password',
                                          labelText: lang.password,
                                          inputField: TextFormField(
                                            obscureText: !showPassword,
                                            controller: passwordCont,
                                            decoration: InputDecoration(
                                              //hintText: 'Enter your password',
                                              hintText: lang.enterYourPassword,
                                              suffixIcon: IconButton(
                                                onPressed: () => setState(
                                                  () => showPassword =
                                                      !showPassword,
                                                ),
                                                icon: Icon(
                                                  showPassword
                                                      ? FeatherIcons.eye
                                                      : FeatherIcons.eyeOff,
                                                ),
                                              ),
                                            ),
                                            validator: (value) {
                                              return checkpassword(
                                                value,
                                                lang.pleaseEnterYourPassword,
                                                lang.passmustbeatleastsixcharaters,
                                              );
                                            },
                                          ),
                                        ),
                                        20.height,

                                        Row(
                                          children: [
                                            Text(
                                              lang.iam,
                                              style: _theme.inputDecorationTheme
                                                  .floatingLabelStyle,
                                            ),
                                          ],
                                        ),
                                        8.height,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            userRadio(
                                              theme: _theme,
                                              thevalue: "tenant",
                                              label: lang.tenant,
                                            ),
                                            30.width,
                                            userRadio(
                                              theme: _theme,
                                              thevalue: "owner",
                                              label: lang.owner,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Submit Button
                                SizedBox(
                                  width: double.maxFinite,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      registerUser();
                                    },
                                    //child: const Text('Sign Up'),
                                    child: Text(lang.signUp),
                                  ),
                                ).paddingSymmetric(
                                  horizontal: 30,
                                  vertical: 8,
                                ),
                                30.height,
                                Text.rich(
                                  TextSpan(
                                    //text: 'Already have an account? ',
                                    text: lang.alreadyHaveAnAccount,
                                    children: [
                                      TextSpan(
                                        // text: 'Sign in',
                                        text: " ${lang.signIn}",
                                        style: _theme.textTheme.labelLarge
                                            ?.copyWith(
                                          color: _theme.colorScheme.primary,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.push(
                                              '/authentication/signin',
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                  style: _theme.textTheme.labelLarge?.copyWith(
                                    color: _theme.checkboxTheme.side?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cover Image
            if (_desktopView)
              Container(
                constraints: BoxConstraints(
                  maxWidth: _screenWidth * 0.55,
                  maxHeight: double.infinity,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/images/static_images/welcome.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: _screenHeight * .45,
                      left: -(_screenWidth * .12),
                      right: 0,
                      child: Image.asset(
                        'assets/app_icons/app_icon_main.png',
                        height: 250,
                        width: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget userRadio({theme, String thevalue = "", label}) {
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
                    groupValue: userType,
                    activeColor: theme.colorScheme.primary,
                    fillColor:
                        WidgetStateProperty.all(theme.colorScheme.primary),
                    onChanged: userType == thevalue
                        ? null
                        : (String? value) {
                            setState(() {
                              userType = value!;
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
                      () => userType = thevalue,
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

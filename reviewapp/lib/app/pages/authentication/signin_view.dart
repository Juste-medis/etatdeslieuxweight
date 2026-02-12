// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/pages/authentication/components/components.dart';
import 'package:mon_etatsdeslieux/app/pages/shell_route_wrapper/components/_components.dart';
import 'package:mon_etatsdeslieux/app/providers/_theme_provider.dart';
import 'package:mon_etatsdeslieux/main.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../../dev_utils/dev_utils.dart';
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  bool rememberMe = false;
  bool showPassword = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  bool isLoading = false;

  void registerUser() async {
    Jks.context = context;
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> request = {
        UserKeys.email: emailCont.text.trim(),
        UserKeys.password: passwordCont.text.trim(),
      };

      await loginUser(request)
          .then((res) async {
            setState(() {
              isLoading = false;
            });
            if (res.data?.verifiedAt == null) {
              context.go(
                '/otp',
                extra: {
                  "email": res.data!.email,
                  "userId": res.data!.iid,
                  UserKeys.password: request[UserKeys.password],
                },
              );
            } else {
              await initializeApp(res.data!, res.token);
              context.go('/dashboard', extra: res.data);
            }
          })
          .catchError((e) {
            if (e.toString() == "no_internet") {
              Jks.languageState!.showAppNotification(
                message:
                    "Vous êtes hors ligne. Veuillez vérifier votre connexion Internet."
                        .tr,
              );
            } else {}
            setState(() {
              isLoading = false;
            });
            my_inspect(e);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Jks.context = context;

    final lang = l.S.of(context);
    final _theme = Theme.of(context);

    final _screenWidth = MediaQuery.sizeOf(context).width;
    final _screenHeight = MediaQuery.sizeOf(context).height;

    final _desktopView = _screenWidth >= 1200;

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
                      //si ce n'est pas la vue desktop et que le clavier n'est pas ouvert
                      authHeader(
                        context,
                        screenHeight: _screenHeight,
                        screenWidth: _screenWidth,
                        desktopView: _desktopView,
                        themeswitcher: Consumer<AppThemeProvider>(
                          builder: (context, appTheme, child) => ThemeToggler(
                            isDarkMode: appTheme.isDarkTheme,
                            onChanged: appTheme.toggleTheme,
                          ).center(),
                        ),
                      ),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Center(
                            child: Form(
                              key: formKey,
                              autovalidateMode: AutovalidateMode.disabled,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!_desktopView)
                                      20.height
                                    else
                                      100.height,

                                    Text(
                                      lang.welcome,
                                      style: _theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 10),

                                    Text.rich(
                                      TextSpan(text: lang.signIn),
                                      style: _theme.textTheme.labelLarge
                                          ?.copyWith(),
                                    ),
                                    const SizedBox(height: 16),

                                    // Email Field
                                    TextFieldLabelWrapper(
                                      //labelText: 'Email',
                                      labelText: lang.email,

                                      inputField: TextFormField(
                                        controller: emailCont,
                                        validator: (value) {
                                          return requiredforminput(
                                            value,
                                            lang.pleaseEnterYourEmail,
                                          );
                                        },
                                        decoration: InputDecoration(
                                          //hintText: 'Enter your email address',
                                          hintText: lang.enterYourEmailAddress,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Password Field
                                    TextFieldLabelWrapper(
                                      //labelText: 'Password',
                                      labelText: lang.password,
                                      inputField: TextFormField(
                                        controller: passwordCont,
                                        obscureText: !showPassword,
                                        validator: (value) {
                                          return checkpassword(
                                            value,
                                            lang.pleaseEnterYourPassword,
                                            lang.passmustbeatleastsixcharaters,
                                          );
                                        },
                                        decoration: InputDecoration(
                                          //hintText: 'Enter your password',
                                          hintText: lang.enterYourPassword,
                                          suffixIcon: IconButton(
                                            onPressed: () => setState(
                                              () =>
                                                  showPassword = !showPassword,
                                            ),
                                            icon: Icon(
                                              showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Remember Me / Forgot Password
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: SizedBox.square(
                                                    dimension: 16,
                                                    child: Checkbox(
                                                      value: rememberMe,
                                                      onChanged: (value) =>
                                                          setState(
                                                            () => rememberMe =
                                                                value!,
                                                          ),
                                                      visualDensity:
                                                          const VisualDensity(
                                                            horizontal: -4,
                                                            vertical: -2,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(width: 6),
                                                ),
                                                TextSpan(
                                                  // text: 'Remember Me',
                                                  text: lang.rememberMe,
                                                  mouseCursor:
                                                      SystemMouseCursors.click,
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () =>
                                                            setState(
                                                              () => rememberMe =
                                                                  !rememberMe,
                                                            ),
                                                ),
                                              ],
                                            ),
                                            style: _theme.textTheme.labelLarge
                                                ?.copyWith(
                                                  color: _theme
                                                      .checkboxTheme
                                                      .side
                                                      ?.color,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        // Forgot Password
                                        Text.rich(
                                          TextSpan(
                                            //text: 'Forgot Password?',
                                            text: lang.forgotPassword,
                                            mouseCursor:
                                                SystemMouseCursors.click,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () =>
                                                  _handleForgotPassword(
                                                    context,
                                                    emailCont.text.trim(),
                                                  ),
                                          ),
                                          style: _theme.textTheme.labelLarge
                                              ?.copyWith(
                                                color: _theme.primaryColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                    25.height,
                                    Text.rich(
                                      TextSpan(
                                        // text: 'Need an account? ',
                                        text: lang.needAnAccount,
                                        children: [
                                          TextSpan(
                                            // text: 'Sign up',
                                            text: "  ${lang.signUp}",
                                            style: _theme.textTheme.labelLarge
                                                ?.copyWith(
                                                  color: _theme
                                                      .colorScheme
                                                      .primary,
                                                ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                context.push(
                                                  '/authentication/signup',
                                                );
                                              },
                                          ),
                                        ],
                                      ),
                                      style: _theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: _theme
                                                .checkboxTheme
                                                .side
                                                ?.color,
                                          ),
                                    ).center(),
                                    20.height,
                                    // Submit Button
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                registerUser();
                                              },
                                        child: Text(lang.signIn),
                                      ),
                                    ),
                                    20.height,
                                    Container(
                                      width: double.maxFinite,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          emailCont.text =
                                              "vanessaseban@adidomedis.cloud";
                                          passwordCont.text = "123456";
                                        },
                                        child: const Text("Vanessa"),
                                      ),
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          emailCont.text = "mucoper@gmail.com";
                                          passwordCont.text = "123456";
                                        },
                                        child: const Text("Romuald"),
                                      ),
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          emailCont.text =
                                              "tomgrimaud@adidomedis.cloud";
                                          passwordCont.text = "123456";
                                        },
                                        child: const Text("Tom"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                    image: AssetImage(
                      'assets/images/static_images/welcome.jpg',
                    ),
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

  void _handleForgotPassword(BuildContext context, String? enteredEmail) async {
    // context!.push(
    //   '/resetpassword',
    //   extra: {
    //     "email": "mucoper@gmail.com",
    //   },
    // );
    // return;
    final _result = await showDialog(
      context: context,
      builder: (context) {
        return ForgotPasswordDialog(enteredEmail: enteredEmail);
      },
    );
    devLogger(_result.toString());
  }
}

class ForgotPasswordDialog extends StatelessWidget {
  final String? enteredEmail;

  const ForgotPasswordDialog({super.key, this.enteredEmail});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    String email = enteredEmail ?? '';
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lang.forgotPassword,
                    style: _theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  editUserField(
                    title: "Votre adresse email".tr,
                    email: true,
                    initialvalue: enteredEmail,
                    onChanged: (text) {
                      email = text;
                    },
                    required: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            simulateScreenTap();
                            forgotPassword({"email": email})
                                .then((value) {
                                  if (value.status == true) {
                                    Jks.context!.push(
                                      '/resetpassword',
                                      extra: {"email": email},
                                    );
                                  }
                                })
                                .catchError((e) {
                                  myprint(e);
                                });
                          }
                        } catch (e) {
                          myprint(e);
                        }
                      },
                      child: Text(lang.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

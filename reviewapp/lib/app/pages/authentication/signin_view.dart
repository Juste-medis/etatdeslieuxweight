// 🐦 Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/pages/authentication/components/components.dart';
import 'package:jatai_etatsdeslieux/main.dart';

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

  void registerUser() async {
    Jks.context = context;
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map<String, dynamic> request = {
        UserKeys.email: emailCont.text.trim(),
        UserKeys.password: passwordCont.text.trim(),
      };

      await loginUser(request).then((res) async {
        if (res.data!.verifiedAt == null) {
          context.go(
            '/otp',
            extra: {
              "email": res.data!.email,
              "userId": res.data!.iid,
              UserKeys.password: request[UserKeys.password],
            },
          );
        } else {
          await saveUserData(res.data!, token: res.token);
          context.go(
            '/dashboard',
            extra: res.data,
          );
        }
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
                      if (!_desktopView)
                        AuthHeader(
                          screenHeight: _screenHeight,
                          screenWidth: _screenWidth,
                        ),
                      if (!_desktopView) 80.height else 100.height,
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Center(
                              child: Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang.welcome,
                                    style: _theme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Text.rich(
                                    TextSpan(
                                      text: lang.signIn,
                                    ),
                                    style:
                                        _theme.textTheme.labelLarge?.copyWith(
                                      color: _theme.colorScheme.onSecondary,
                                    ),
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
                                            value, lang.pleaseEnterYourEmail);
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
                                            () => showPassword = !showPassword,
                                          ),
                                          icon: Icon(
                                            showPassword
                                                ? FeatherIcons.eye
                                                : FeatherIcons.eyeOff,
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
                                                    PlaceholderAlignment.middle,
                                                child: SizedBox.square(
                                                  dimension: 16,
                                                  child: Checkbox(
                                                    value: rememberMe,
                                                    onChanged: (value) =>
                                                        setState(
                                                      () => rememberMe = value!,
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
                                                      ..onTap = () => setState(
                                                            () => rememberMe =
                                                                !rememberMe,
                                                          ),
                                              ),
                                            ],
                                          ),
                                          style: _theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: _theme
                                                .checkboxTheme.side?.color,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      // Forgot Password
                                      Text.rich(
                                        TextSpan(
                                          //text: 'Forgot Password?',
                                          text: lang.forgotPassword,
                                          mouseCursor: SystemMouseCursors.click,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                _handleForgotPassword(context),
                                        ),
                                        style: _theme.textTheme.labelLarge
                                            ?.copyWith(
                                          color: _theme.primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  50.height,
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
                                            color: _theme.colorScheme.primary,
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
                                    style:
                                        _theme.textTheme.labelLarge?.copyWith(
                                      color: _theme.checkboxTheme.side?.color,
                                    ),
                                  ).center(),
                                  50.height,
                                  // Submit Button
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        registerUser();
                                      },
                                      child: Text(lang.signIn),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
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

  void _handleForgotPassword(BuildContext context) async {
    final _result = await showDialog(
      context: context,
      builder: (context) {
        return const ForgotPasswordDialog();
      },
    );
    devLogger(_result.toString());
  }
}

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.forgotPassword,
                  //'Forgot Password?',
                  style: _theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  lang.enterYourEmailWeWillSendYouALinkToResetYourPassword,
                  //'Enter your email, we will send you a link to Reset your password',
                  style: _theme.textTheme.bodyLarge?.copyWith(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFieldLabelWrapper(
                  // labelText: 'Email',
                  labelText: lang.email,
                  inputField: TextFormField(
                    decoration: InputDecoration(
                      //hintText: 'Enter your email address',
                      hintText: lang.enterYourEmailAddress,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {},
                    //child: const Text('Send'),
                    child: Text(lang.send),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

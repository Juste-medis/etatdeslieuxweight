// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/helpers.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/pages/authentication/otp_verification_view.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:mon_etatsdeslieux/main.dart';

import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class RessetPassView extends StatefulWidget {
  final String? otp;
  final String? email;

  const RessetPassView({super.key, this.otp, this.email});

  @override
  State<RessetPassView> createState() => _RessetPassViewState();
}

class _RessetPassViewState extends State<RessetPassView> {
  bool showPassword = false;
  bool showPasswordc = false;
  String theOtp = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordConttroller = TextEditingController();
  final PageController _pageController = PageController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.otp != null) {
      theOtp = widget.otp!;
    }
  }

  void returnToApp() {
    try {
      context.popRoute();
    } catch (e) {
      Jks.checkingAuth = false;
      context.go('/');
    }
  }

  void registerUser() async {
    Jks.context = context;
    setState(() {
      isLoading = true;
    });
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      Map<String, dynamic> request = {
        UserKeys.email: widget.email,
        "newPassword": passwordcontroller.text,
        "passwordConfirmation": confirmpasswordConttroller.text,
        'otp': theOtp,
      };

      await changeUserPassword(request)
          .then((res) async {
            if (res.status == true) {
              context.pushReplacement('/authentication/signin');
              showFullScreenSuccessDialog(
                context,
                title: 'Votre mot de passe a été changé avec succès !'.tr,
                message:
                    'Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.'
                        .tr,
                okText: 'Continuer',
                onOk: () {
                  context.go('/authentication/signin');
                },
              );
            }
            setState(() {
              isLoading = false;
            });
          })
          .catchError((e) {
            setState(() {
              isLoading = false;
            });
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
                      backbutton(() {
                        returnToApp();
                      }, title: "Jatai Etat des Lieux"),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Center(
                            child: PageView(
                              controller: _pageController,
                              physics:
                                  const NeverScrollableScrollPhysics(), // Disable swipe
                              onPageChanged: (index) {
                                // setState(() {
                                //   wizardState.updateInventory(
                                //     step: WizardStep.values[index],
                                //     liveupdate: false,
                                //   );
                                // });
                              },
                              children: [
                                if (widget.otp == null)
                                  OtpVerificationView(
                                    email: widget.email,
                                    onVerified: (String otp) {
                                      setState(() {
                                        theOtp = otp;
                                      });
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                Center(
                                  child: Form(
                                    key: formKey,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          50.height,
                                          Text(
                                            "Changement de mot de passe".tr,
                                            style: _theme
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 30),
                                          TextFieldLabelWrapper(
                                            labelText: "Nouveau mot de passe",
                                            inputField: TextFormField(
                                              controller: passwordcontroller,
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
                                                hintText:
                                                    lang.enterYourPassword,
                                                suffixIcon: IconButton(
                                                  onPressed: () => setState(
                                                    () => showPassword =
                                                        !showPassword,
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
                                          TextFieldLabelWrapper(
                                            labelText:
                                                "Confirmer le nouveau mot de passe",
                                            inputField: TextFormField(
                                              controller:
                                                  confirmpasswordConttroller,
                                              obscureText: !showPasswordc,
                                              validator: (value) {
                                                return checkpassword(
                                                  value,
                                                  lang.pleaseEnterYourPassword,
                                                  lang.passmustbeatleastsixcharaters,
                                                );
                                              },
                                              decoration: InputDecoration(
                                                hintText:
                                                    "entrez à nouveau le mot de passe",
                                                suffixIcon: IconButton(
                                                  onPressed: () => setState(
                                                    () => showPasswordc =
                                                        !showPasswordc,
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

                                          Text.rich(
                                            TextSpan(
                                              text: "Retourner et".tr,
                                              children: [
                                                TextSpan(
                                                  text: " se connecter".tr,
                                                  style: _theme
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(
                                                        color: _theme
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      context.pushReplacement(
                                                        '/authentication/signin',
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

                                          if (kDebugMode)
                                            Container(
                                              width: double.maxFinite,
                                              margin: const EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  passwordcontroller.text =
                                                      "123456";
                                                  confirmpasswordConttroller
                                                          .text =
                                                      "123456";
                                                },
                                                child: const Text("admin"),
                                              ),
                                            ),
                                          25.height,
                                          // Submit Button
                                          SizedBox(
                                            width: double.maxFinite,
                                            child: ElevatedButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () {
                                                      registerUser();
                                                    },
                                              child: Text(
                                                "Changer le mot de passe",
                                              ),
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
                      bottom: _screenHeight * .2,
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
}

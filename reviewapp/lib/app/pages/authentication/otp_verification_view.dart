// 🐦 Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:mon_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/core/theme/theme.dart';
import 'package:mon_etatsdeslieux/app/pages/authentication/components/components.dart';
import 'package:mon_etatsdeslieux/main.dart';

import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationView extends StatefulWidget {
  final String? email;
  final String? userId;
  final String? password;
  final String? ressetPassword;
  final void Function(String)? onVerified;

  const OtpVerificationView({
    super.key,
    this.email,
    this.password,
    this.userId,
    this.ressetPassword,
    this.onVerified,
  });

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  bool rememberMe = false;
  bool showPassword = false;
  String _otpCode = ''; // To store the OTP code
  bool _canResendOtp = false;
  int _resendCountdown = 120; // 2 minutes in seconds
  late Timer _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  Future<void> _verifyOtp(BuildContext context) async {
    Jks.context = context;
    final lang = l.S.of(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return LoadingScreen(message: lang.verificationInprogress);
      },
    );

    var request = {
      "otp": _otpCode,
      "password": widget.password,
      "email": widget.email,
      "id": widget.userId,
    };

    await verifyCode(request)
        .then((res) async {
          if (res.status ?? false) {
            if (widget.onVerified != null) {
              widget.onVerified!(_otpCode);
              return;
            }
            await loginUser(request).then((res) async {
              await initializeApp(res.data!, res.token);
              Future.delayed(const Duration(seconds: 2));
              Jks.checkingAuth = false;
              context.go('/', extra: res.data);
            });
          } else {}
        })
        .catchError((e) {
          my_inspect(e);
        });
    if (mounted) {
      context.popRoute();
    }
  }

  @override
  void dispose() {
    _resendTimer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResendOtp = false;
      _resendCountdown = 120;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResendOtp = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    if (!_canResendOtp) return;
    try {
      var request = {"email": widget.email, "id": widget.userId};

      await resendOtpCode(request).then((res) {
        if (res.status ?? false) {
          // toast(l.S.of(context).otpResendSuccess);
          _startResendTimer(); // Restart the countdown
        }
      });
    } catch (e) {
      toast("Une erreur a survecue !");
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    const _buttonPadding = EdgeInsetsDirectional.symmetric(
      horizontal: 24,
      vertical: 12,
    );
    final _buttonTextStyle = _theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final _screenWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: _theme.colorScheme.primaryContainer,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.otpverification,
                            style: _theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          10.height,
                          Text.rich(
                            TextSpan(
                              text: lang.wesendandotpto,
                              children: [
                                TextSpan(
                                  text: "  ${widget.email}",
                                  style: _theme.textTheme.labelLarge?.copyWith(
                                    color: _theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            style: _theme.textTheme.labelLarge,
                          ),
                          Text.rich(
                            TextSpan(text: lang.entertoconfirm),
                            style: _theme.textTheme.labelLarge,
                          ),

                          16.height,

                          // OTP Field
                          Center(
                            child: AwesomeOtpField(
                              length: 6,
                              onCompleted: (code) {
                                setState(() {
                                  _otpCode = code;
                                });
                              },
                              activeColor: _theme.colorScheme.primary,
                              inactiveColor: _theme.colorScheme.outline,
                              fillColor: _theme.colorScheme.surface,
                              textStyle: _theme.textTheme.headlineSmall!
                                  .copyWith(
                                    color: _theme.colorScheme.onSurface,
                                  ),
                            ),
                          ),
                          20.height,
                          // Resend OTP Button
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: _canResendOtp ? _resendOtp : null,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _canResendOtp
                                    ? AcnooAppColors.kPrimary600
                                    : AcnooAppColors.kPrimary600.withOpacity(
                                        0.5,
                                      ),
                                side: BorderSide(
                                  color: _canResendOtp
                                      ? AcnooAppColors.kPrimary600
                                      : AcnooAppColors.kPrimary600.withOpacity(
                                          0.5,
                                        ),
                                  width: .0001,
                                ),
                                shadowColor: Colors.transparent,
                                padding: _buttonPadding,
                                textStyle: _buttonTextStyle,
                                elevation: 0,
                              ),
                              icon: _canResendOtp
                                  ? const Icon(Icons.refresh, size: 20)
                                  : SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        value: 1 - (_resendCountdown / 120),
                                        color: AcnooAppColors.kPrimary600,
                                        strokeWidth: 2,
                                      ),
                                    ),
                              label: Text(
                                _canResendOtp
                                    ? l.S.of(context).resendotp
                                    : '${_resendCountdown ~/ 60}:${(_resendCountdown % 60).toString().padLeft(2, '0')}',
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Submit Button
                          SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: _otpCode.length == 6
                                  ? () {
                                      _verifyOtp(context);
                                    }
                                  : null,
                              child: Text(lang.vevrify),
                            ),
                          ),
                          20.height,
                          // Back to login option
                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.popRoute();

                                // if (widget.userId != null) {
                                //   context.go("/authentication/signup");
                                // } else {
                                //   context.go("/authentication/signin");
                                // }
                              },
                              child: Text(
                                lang.goBack,
                                style: _theme.textTheme.bodyMedium?.copyWith(
                                  color: _theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                authHeaderOtp(screenHeight: 150, screenWidth: _screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

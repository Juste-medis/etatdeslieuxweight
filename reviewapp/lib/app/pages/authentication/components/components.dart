import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/theme.dart';

class AwesomeOtpField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final Color activeColor;
  final Color inactiveColor;
  final Color fillColor;
  final double fieldSize;
  final double borderRadius;
  final TextStyle textStyle;
  final bool obscureText;
  final String obscuringCharacter;
  final TextInputType keyboardType;
  final bool autoFocus;

  const AwesomeOtpField({
    Key? key,
    this.length = 6,
    required this.onCompleted,
    this.activeColor = AcnooAppColors.kPrimary500,
    this.inactiveColor = AcnooAppColors.kNeutral300,
    this.fillColor = AcnooAppColors.kNeutral50,
    this.fieldSize = 38,
    this.borderRadius = 12,
    this.textStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AcnooAppColors.kDark1,
    ),
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.keyboardType = TextInputType.number,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  _AwesomeOtpFieldState createState() => _AwesomeOtpFieldState();
}

class _AwesomeOtpFieldState extends State<AwesomeOtpField> {
  late List<String> _otp;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _otp = List.filled(widget.length, '');
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNodes[0]);
      });
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // Handle pasted code
      if (value.length == widget.length) {
        for (int i = 0; i < widget.length; i++) {
          _otp[i] = value[i];
          _controllers[i].text = value[i];
          if (i == widget.length - 1) {
            _focusNodes[i].unfocus();
          } else {
            _focusNodes[i].unfocus();
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          }
        }
        widget.onCompleted(_otp.join());
        return;
      }
      return;
    }

    setState(() {
      _otp[index] = value;
      _currentIndex = value.isEmpty ? (index > 0 ? index - 1 : 0) : index + 1;
    });

    if (value.isNotEmpty) {
      if (index == widget.length - 1) {
        _focusNodes[index].unfocus();
        widget.onCompleted(_otp.join());
      } else {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else {
      if (index > 0) {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  void _onKey(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_otp[index].isEmpty && index > 0) {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) => _onKey(event, _currentIndex),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.length,
          (index) => _buildOtpField(index),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: widget.fieldSize,
      height: widget.fieldSize,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: widget.fillColor,
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: widget.keyboardType,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          obscureText: widget.obscureText,
          obscuringCharacter: widget.obscuringCharacter,
          style: widget.textStyle,
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => _onChanged(value, index),
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

Widget AuthHeader({double screenHeight = 0, double screenWidth = 0}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Image.asset(
        'assets/images/static_images/welcome.jpg',
        height: screenHeight * 0.35,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Positioned(
        bottom: -70,
        left: screenWidth * 0.5 - 100,
        right: screenWidth * 0.5 - 100,
        child: Image.asset(
          'assets/app_icons/logoplein.png',
          height: 100,
          width: 10,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}

Widget AuthHeaderOtp({double screenHeight = 0, double screenWidth = 0}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      SizedBox(
        height: screenHeight * 0.1,
        width: double.infinity,
      ),
      Positioned(
        bottom: -70,
        left: screenWidth * 0.5 - 100,
        right: screenWidth * 0.5 - 100,
        child: Image.asset(
          'assets/app_icons/app_icon_main.png',
          height: 100,
          width: 10,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}

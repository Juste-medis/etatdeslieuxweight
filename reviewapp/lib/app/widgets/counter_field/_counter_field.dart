import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class CounterField extends StatefulWidget {
  const CounterField({
    super.key,
    this.validator,
    this.onChanged,
    this.initialValue = "0",
  });

  final String? Function(String? value)? validator;
  final void Function(int value)? onChanged;
  final String initialValue;

  @override
  State<CounterField> createState() => _CounterFieldState();
}

class _CounterFieldState extends State<CounterField> {
  int count = 0;

  final _iconConstraint = BoxConstraints.tight(const Size.square(44));

  @override
  void initState() {
    count = int.tryParse(widget.initialValue) ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateCount(int newCount) {
    setState(() => count = newCount);
    if (widget.onChanged != null) {
      widget.onChanged!(count);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return TextFormField(
      clipBehavior: Clip.antiAlias,
      controller: TextEditingController(text: "${count ?? 0}"),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: "0",
        contentPadding: const EdgeInsets.all(13.53),
        prefixIcon: _ActionButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (count > 0) {
              _updateCount(count - 1);
            }
          },
        ),
        prefixIconConstraints: _iconConstraint,
        suffixIcon: _ActionButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _updateCount(count + 1);
          },
        ),
        suffixIconConstraints: _iconConstraint,
      ),
      onChanged: (value) {
        final _v = int.tryParse(value) ?? 0;
        _updateCount(_v);
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: widget.validator,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    this.borderRadius = BorderRadius.zero,
    this.onPressed,
    required this.icon,
  });
  final BorderRadiusGeometry borderRadius;
  final void Function()? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return IconButton.outlined(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        side: BorderSide(
          width: 0,
          color: _theme.colorScheme.outline,
        ),
        backgroundColor: _theme.colorScheme.surface,
      ),
      icon: icon,
    );
  }
}

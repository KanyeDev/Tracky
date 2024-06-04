import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required TextEditingController controller,
    required this.hintText,
    this.icon = const SizedBox(),
    required this.keyboardType,
    required this.isObscured, this.prefixIcon = const SizedBox(), this.textToHintInput = ""
  }) : _controller = controller;

  final TextEditingController _controller;
  final String hintText;
  final Widget icon;
  final Widget prefixIcon;
  final TextInputType keyboardType;
  final bool isObscured;
  final String textToHintInput;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.surface,
        keyboardType: keyboardType,
        obscureText: isObscured,
        enabled: true,
        validator: (value) {
          if (value!.isEmpty) {
            return hintText;
          }
          return null;
        },
        controller: _controller,
        decoration: InputDecoration(prefixIcon: prefixIcon, hintText: textToHintInput, hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: Theme.of(context).colorScheme.primary, focusedBorder: OutlineInputBorder(borderSide:   BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
              style: BorderStyle.solid,
            ),
                borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
                borderSide:   BorderSide(
                  color: Theme.of(context).colorScheme.tertiary,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20)),
            suffixIcon: icon));
  }
}
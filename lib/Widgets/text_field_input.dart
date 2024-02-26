import 'package:flutter/material.dart';
class TextfieldInput extends StatelessWidget {
  const TextfieldInput({
    super.key,
    required this.hintText,
    required this.isPass,
    required this.inputType,
    required this.textEditingController
  });
  final bool isPass;
  final String hintText;
  final TextInputType inputType;
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.all(8),
          hintText: hintText,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder
        ),
      keyboardType: inputType,
      obscureText: isPass,
    );
  }
}

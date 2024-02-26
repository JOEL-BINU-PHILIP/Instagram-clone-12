import 'package:flutter/material.dart';
class AccessButton extends StatelessWidget {
  const AccessButton(
      {super.key, required this.buttonText, required this.onPressed});
  final Function() onPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(4)),
        child: Center(child: Text(buttonText)),
      ),
    );
  }
}
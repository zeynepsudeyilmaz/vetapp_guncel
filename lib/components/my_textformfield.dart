import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextStyle? textStyle;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboarType;

  const MyTextFormField(
      {super.key,
      this.controller,
      this.hintText,
      this.obscureText = true,
      this.textStyle,
      this.validator,
      this.prefixIcon,
      this.keyboarType,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        keyboardType: keyboarType,
        controller: controller,
        obscureText: obscureText,
        style: textStyle,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          fillColor: const Color(0xFF66D0A4),
          filled: true,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
      ),
    );
  }
}

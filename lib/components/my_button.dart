import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? imagePath;
  final EdgeInsetsGeometry? padding;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF757EFA),
    this.foregroundColor = const Color(0xFFFFFFFF),
    this.fontSize,
    this.fontWeight,
    this.imagePath,
    this.padding = const EdgeInsets.symmetric(horizontal: 25.0),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                imagePath!,
                height: 32,
                width: 32,
              ),
            ),
          Text(
            text,
            style: GoogleFonts.inter(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

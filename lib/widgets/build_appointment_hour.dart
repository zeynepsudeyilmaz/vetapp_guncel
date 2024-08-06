import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HourBox extends StatelessWidget {
  final String hour;
  final bool isSelected;
  final Function(String) onSelected;

  const HourBox({
    super.key,
    required this.hour,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(hour),
      child: Container(
        width: 80,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            hour,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

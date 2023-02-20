// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.label,
    required this.fontsize,
    this.color,
    this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontsize;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      style: GoogleFonts.inter(
        color: color ?? Colors.white,
        fontSize: fontsize,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}

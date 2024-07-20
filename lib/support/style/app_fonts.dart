import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  AppFonts._();

  static TextStyle robotoRegular(double size, [Color? color]) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle robotoSemiBold(double size, [Color? color]) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle robotoBold(double size, [Color? color]) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle robotoExtraBold(double size, [Color? color]) {
    return GoogleFonts.roboto(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w800,
    );
  }
}

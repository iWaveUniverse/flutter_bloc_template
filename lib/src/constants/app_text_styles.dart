import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:boilerplate/src/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final AppTextStyles _instance = AppTextStyles._();

  static AppTextStyles get instance => _instance;
}

Color get _textColor => AppColors.instance.text;
double get _height => 1.2;
TextStyle _fontWrap({required TextStyle textStyle}) {
  return GoogleFonts.outfit(textStyle: textStyle);
}

TextStyle w100TextStyle(
    {Color? color,
    FontStyle? fontStyle,
    double? height,
    double fontSize = 14,
    TextStyle? style,
    TextDecoration? decoration}) {
  return _fontWrap(
      textStyle: TextStyle(
              fontStyle: fontStyle,
              fontSize: fontSize,
              fontWeight: FontWeight.w100,
              color: color ?? _textColor,
              decoration: decoration,
              height: height ?? _height)
          .merge(style));
}

TextStyle w200TextStyle(
    {Color? color,
    FontStyle? fontStyle,
    double? height,
    double fontSize = 14,
    TextStyle? style,
    TextDecoration? decoration}) {
  return _fontWrap(
      textStyle: TextStyle(
              fontStyle: fontStyle,
              fontSize: fontSize,
              fontWeight: FontWeight.w200,
              color: color ?? _textColor,
              decoration: decoration,
              height: height ?? _height)
          .merge(style));
}

TextStyle w300TextStyle(
    {Color? color,
    FontStyle? fontStyle,
    double? height,
    double fontSize = 14,
    TextStyle? style,
    TextDecoration? decoration}) {
  return _fontWrap(
      textStyle: TextStyle(
              fontStyle: fontStyle,
              fontSize: fontSize,
              fontWeight: FontWeight.w300,
              color: color ?? _textColor,
              decoration: decoration,
              height: height ?? _height)
          .merge(style));
}

TextStyle w400TextStyle(
    {Color? color,
    FontStyle? fontStyle,
    double? height,
    double fontSize = 14,
    TextStyle? style,
    TextDecoration? decoration}) {
  return _fontWrap(
      textStyle: TextStyle(
              fontStyle: fontStyle,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: color ?? _textColor,
              decoration: decoration,
              height: height ?? _height)
          .merge(style));
}

TextStyle w500TextStyle(
    {Color? color,
    FontStyle? fontStyle,
    double? height,
    double fontSize = 14,
    TextStyle? style,
    TextDecoration? decoration}) {
  return _fontWrap(
      textStyle: TextStyle(
              fontStyle: fontStyle,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: color ?? _textColor,
              decoration: decoration,
              height: height ?? _height)
          .merge(style));
}

TextStyle w600TextStyle(
    {Color? color,
    FontStyle? fontStyle,
    double? height,
    double fontSize = 14,
    TextStyle? style,
    TextDecoration? decoration}) {
  return _fontWrap(
      textStyle: TextStyle(
              fontStyle: fontStyle,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color ?? _textColor,
              decoration: decoration,
              height: height ?? _height)
          .merge(style));
}

TextStyle w700TextStyle(
    {Color? color,
    FontStyle? fontStyle,
    double? height,
    double fontSize = 14,
    TextStyle? style,
    TextDecoration? decoration}) {
  return _fontWrap(
      textStyle: TextStyle(
              fontStyle: fontStyle,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: color ?? _textColor,
              decoration: decoration,
              height: height ?? _height)
          .merge(style));
}

TextStyle w800TextStyle(
    {Color? color,
    FontStyle? fontStyle,
    double? height,
    double fontSize = 14,
    TextStyle? style,
    TextDecoration? decoration}) {
  return _fontWrap(
      textStyle: TextStyle(
              fontStyle: fontStyle,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: color ?? _textColor,
              decoration: decoration,
              height: height ?? _height)
          .merge(style));
}

TextStyle w900TextStyle(
    {Color? color,
    FontStyle? fontStyle,
    double? height,
    double fontSize = 14,
    TextStyle? style,
    TextDecoration? decoration}) {
  return _fontWrap(
      textStyle: TextStyle(
              fontStyle: fontStyle,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: color ?? _textColor,
              decoration: decoration,
              height: height ?? _height)
          .merge(style));
}

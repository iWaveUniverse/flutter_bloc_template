import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/material.dart';
import 'package:temp_package_name/src/base/theme_bloc/widgets/widget_theme_wraper.dart';

class AppColors extends AppColorsBase {
  AppColors._();

  static final AppColors _instance = AppColors._();

  static AppColors get instance => _instance;

  @override
  Color get text => byTheme(Colors.black, kdark: Colors.white);

  @override
  Color get background => byTheme(Colors.white, kdark: Colors.black);

  @override
  Color get element => byTheme(Colors.grey[200]!, kdark: Colors.grey[200]!);

  @override
  Color get primary => byTheme(hexColor('00BDF9'));

  @override
  Color get shimerHighlightColor => byTheme(hexColor('#1C222C'));

  @override
  Color get shimmerBaseColor => byTheme(hexColor('#1C222C'));
}

byTheme(klight, {kdark}) {
  if (AppThemeProvider.isDarkMode()) {
    return kdark ?? klight;
  }
  return klight;
}

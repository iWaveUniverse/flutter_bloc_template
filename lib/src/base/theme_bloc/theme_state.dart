part of 'theme_bloc.dart';

class ThemeState {
  bool isDark;

  ThemeState({this.isDark = false});

  ThemeMode get mode => isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeData get theme {
    return (isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
      primaryColor: appColorPrimary,
      scaffoldBackgroundColor: appColorBackground,
    );
  }

  ThemeState update({bool? isDark}) {
    return ThemeState(
      isDark: isDark ?? this.isDark,
    );
  }
}

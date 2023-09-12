import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_package_name/src/utils/utils.dart';

import '../theme_bloc.dart';

class WidgetThemeWraper extends StatelessWidget {
  final Widget Function(ThemeState) builder;
  const WidgetThemeWraper({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      bloc: findInstance<ThemeBloc>(),
      builder: (context, themeState) {
        return AppThemeProvider(
          isDark: themeState.isDark,
          child: builder(themeState),
        );
      },
    );
  }
}

class AppThemeProvider extends InheritedWidget {
  const AppThemeProvider({
    super.key,
    required this.isDark,
    required super.child,
  });

  final bool isDark;

  static AppThemeProvider? maybeOf([context]) {
    return (context ?? appNavigatorKey.currentContext)
        ?.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
  }

  static bool isDarkMode([context]) => maybeOf(context)?.isDark ?? false;

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) =>
      isDark != oldWidget.isDark;
}

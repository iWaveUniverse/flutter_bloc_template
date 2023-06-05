part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class InitThemeEvent extends ThemeEvent {}

class ChangedThemeEvent extends ThemeEvent {
  final bool isDark;
  final bool isNeedUpdateStatusbar;
  const ChangedThemeEvent(
      {required this.isDark, this.isNeedUpdateStatusbar = true});
}

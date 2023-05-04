part of 'bloc.dart';

class NavigationState {
  int currentTab;

  NavigationState({
    this.currentTab = 0,
  });

  NavigationState update({int? currentTab}) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
    );
  }
}

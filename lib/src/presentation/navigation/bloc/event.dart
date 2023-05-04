part of 'bloc.dart';

@immutable
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigationInit extends NavigationEvent {
  const NavigationInit();
}

class NavigationChangeTab extends NavigationEvent {
  int currentTab;
  NavigationChangeTab(this.currentTab);
}

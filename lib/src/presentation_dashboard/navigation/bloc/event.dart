part of 'bloc.dart';

@immutable
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class InitNavigation extends NavigationEvent {}

class DisposeNavigation extends NavigationEvent {}

class OnChangedNavigationEvent extends NavigationEvent {
  final AppMenuBar? menu;
  final bool? isEndDrawerNotification;
  final AppTabPage? tabPage;
  final AppDashboardVersion? dashboardVersion;
  const OnChangedNavigationEvent({
    this.menu,
    this.isEndDrawerNotification,
    this.tabPage,
    this.dashboardVersion,
  });
}

part of 'bloc.dart';

const List<AppTabPage> solucalcTabs = [
  AppTabPage.solucalcDashboard,
  AppTabPage.solucalcUsers,
  AppTabPage.solucalcDevices,
  AppTabPage.solucalcPush,
  AppTabPage.solucalcParamater,
  AppTabPage.legal,
  AppTabPage.systemPictures,
];
const List<AppTabPage> travelmeitTabs = [
  AppTabPage.travelmeitDashboard,
  AppTabPage.travelmeitPoints,
  // AppTabPage.travelmeitCategories,
  AppTabPage.travelmeitTours,
  AppTabPage.travelmeitUsers,
  AppTabPage.legal,
  AppTabPage.systemPictures,
];
const List<AppTabPage> arckipelTabs = [
  AppTabPage.home,
  AppTabPage.contacts,
  AppTabPage.calendar,
  AppTabPage.notifications,
  AppTabPage.cms,
  AppTabPage.screens,
  AppTabPage.alcatrazSystem,
  AppTabPage.security,
  AppTabPage.help,
  AppTabPage.usermanagement,
  AppTabPage.systemPictures,
  AppTabPage.productmanagement,
  AppTabPage.marketplace,
  AppTabPage.ai,
  AppTabPage.applicants,
  AppTabPage.agencies,
];

class NavigationState {
  DashboardConfig? dashboardConfig;
  AppDashboardVersion dashboardVersion;
  bool loaded;

  bool isEndDrawerNotification;

  AppTabPage tabPage;
  List<AppMenuBar> menusbar;
  AppMenuBar menusbarSelected;

  NavigationState({
    this.dashboardVersion = AppDashboardVersion.travelmeit,
    this.tabPage = kDebugMode
        ? AppTabPage.travelmeitPoints
        : AppTabPage.travelmeitDashboard,
    this.loaded = false,
    this.isEndDrawerNotification = false,
    this.dashboardConfig,
    required this.menusbar,
    required this.menusbarSelected,
  });

  NavigationState update({
    AppDashboardVersion? dashboardVersion,
    AppTabPage? tabPage,
    bool? loaded,
    bool? isEndDrawerNotification,
    DashboardConfig? dashboardConfig,
    List<AppMenuBar>? menusbar,
    AppMenuBar? menusbarSelected,
  }) {
    return NavigationState(
      dashboardVersion: dashboardVersion ?? this.dashboardVersion,
      loaded: loaded ?? this.loaded,
      isEndDrawerNotification:
          isEndDrawerNotification ?? this.isEndDrawerNotification,
      dashboardConfig: dashboardConfig ?? this.dashboardConfig,
      tabPage: tabPage ?? this.tabPage,
      menusbar: menusbar ?? this.menusbar,
      menusbarSelected: menusbarSelected ?? this.menusbarSelected,
    );
  }
}

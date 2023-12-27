import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_package_name/src/base/bloc.dart';

import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/presentation/my_profile/my_profile_screen.dart';
import 'package:temp_package_name/src/presentation/navigation/widgets/widget_app_bar.dart';
import 'package:temp_package_name/src/utils/app_map_helper.dart';

import '../presentation.dart';
import '../solucalc_dashboard/solucalc_dashboard_screen.dart';
import '../solucalc_devices/solucalc_devices_screen.dart';
import '../solucalc_paramaters/solucalc_paramaters_screen.dart';
import '../solucalc_push/solucalc_push_screen.dart';
import '../solucalc_users/solucalc_users_screen.dart';
import '../system_pictures/system_pictures_screen.dart';
import '../travelmeit_categories/travelmeit_categories_screen.dart';
import '../travelmeit_dashboard/travelmeit_dashboard_screen.dart';
import '../legal/legal_screen.dart';
import '../travelmeit_points/travelmeit_points_screen.dart';
import '../travelmeit_tours/travelmeit_tours_screen.dart';
import '../travelmeit_users/travelmeit_users_screen.dart';
import 'bloc/bloc.dart';
import 'widgets/widget_end_drawer.dart';
import 'widgets/widget_left_menu.dart';

export 'bloc/bloc.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  void initState() {
    super.initState();
    if (!navigationBloc.state.loaded) {
      navigationBloc.add(InitNavigation());
    }
    AppMapHelper.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    navigationBloc.add(DisposeNavigation());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onLongPress: () async {
      //   navigationBloc.add(OnChangedNavigationEvent(
      //       dashboardVersion: navigationBloc.state.dashboardVersion.index + 1 ==
      //               AppDashboardVersion.values.length
      //           ? AppDashboardVersion.values[0]
      //           : AppDashboardVersion
      //               .values[navigationBloc.state.dashboardVersion.index + 1]));
      // },
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, authState) {
          return BlocBuilder<NavigationBloc, NavigationState>(
            bloc: navigationBloc,
            buildWhen: (previous, current) =>
                previous.loaded != current.loaded ||
                previous.tabPage != current.tabPage ||
                previous.dashboardVersion != current.dashboardVersion ||
                previous.isEndDrawerNotification !=
                    current.isEndDrawerNotification,
            builder: (context, state) {
              if (!authBloc.isLogged) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: WidgetAppSVG(
                      assetsvg('loginpoweredbyarckipelLogo'),
                      package: '_private_core',
                      color: appColorPrimary1,
                      width: 200,
                    ),
                  ),
                );
              }

              return Scaffold(
                endDrawer: const WidgetEndDrawer(),
                backgroundColor: const Color(0xFFF4F4F4),
                body: Row(
                  children: [
                    const WidgetLeftMenu(),
                    Container(
                      height: context.height,
                      width: 1.sw,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const WidgetAppBar(),
                          Container(
                            height: 1.sw,
                            width: context.width,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: state.tabPage.screen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

extension AppTabPageExt on AppTabPage {
  Widget get screen {
    switch (this) {
      case AppTabPage.systemPictures:
        return const SystemPicturesScreen();
      case AppTabPage.myProfile:
        return const MyProfileScreen();

      case AppTabPage.solucalcDashboard:
        return const SolucalcDashboardScreen();
      case AppTabPage.solucalcUsers:
        return const SolucalcUsersScreen();
      case AppTabPage.solucalcDevices:
        return const SolucalcDevicesScreen();
      case AppTabPage.solucalcPush:
        return const SolucalcPushScreen();
      case AppTabPage.solucalcParamater:
        return const SolucalcParamatersScreen();

      case AppTabPage.travelmeitDashboard:
        return const TravelmeitDashboardScreen();
      case AppTabPage.travelmeitTours:
        return const TravelmeitToursScreen();
      case AppTabPage.travelmeitCategories:
        return const TravelmeitCategoryManagerScreen();
      case AppTabPage.travelmeitPoints:
        return const TravelmeitPointsScreen();
      case AppTabPage.legal:
        return const LegalScreen();
      case AppTabPage.travelmeitUsers:
        return const TravelmeitUsersScreen();

      default:
        return const SizedBox();
    }
  }
}

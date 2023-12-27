import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/presentation/solucalc_notifications/widget_end_drawer.dart';
import 'package:temp_package_name/src/presentation/travelmeit_categories/widgets/widget_end_drawer.dart';
import 'package:temp_package_name/src/presentation/travelmeit_tours/widgets/widget_end_drawer.dart';

import '../bloc/bloc.dart';

class WidgetEndDrawer extends StatelessWidget {
  const WidgetEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      bloc: navigationBloc,
      buildWhen: (previous, current) =>
          previous.tabPage != current.tabPage ||
          previous.dashboardVersion != current.dashboardVersion ||
          previous.isEndDrawerNotification != current.isEndDrawerNotification,
      builder: (context, state) {
        if (state.isEndDrawerNotification) {
          switch (state.dashboardVersion) {
            case AppDashboardVersion.solucalc:
              return const WidgetSolucalcNotificationEndDrawer();
            default:
              return const WidgetSolucalcNotificationEndDrawer();
          }
        } else {
          switch (state.tabPage) {
            case AppTabPage.travelmeitCategories:
              return const WidgetTravelmeitCategoriesEndDrawer();
            case AppTabPage.travelmeitTours:
              return const WidgetTravelmeitToursEndDrawer();
            default:
              return const SizedBox();
          }
        }
      },
    );
  }
}

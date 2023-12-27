import 'dart:async';

import 'package:_private_core/_private_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/utils/utils.dart';
import 'package:_private_core_network/network_resources/resources.dart';

part 'event.dart';

part 'state.dart';

NavigationBloc get navigationBloc => findInstance<NavigationBloc>();

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc()
      : super(NavigationState(
            menusbar: [], menusbarSelected: AppMenuBar.values.first)) {
    on<InitNavigation>(_onInit);
    on<DisposeNavigation>(_onDispose);
    on<OnChangedNavigationEvent>(_onChangeMenubar);
  }
  _onChangeMenubar(
      OnChangedNavigationEvent event, Emitter<NavigationState> emit) async {
    emit(state.update(
        menusbarSelected: event.menu,
        isEndDrawerNotification: event.isEndDrawerNotification));
    if (event.tabPage != null) {
      List<AppMenuBar> menus = getAppMenuBarsTab(event.tabPage!);
      state.menusbar = menus;
      if (menus.isNotEmpty) {
        state.menusbarSelected = state.menusbar.first;
      }
      emit(state.update(tabPage: event.tabPage));
      // html.window.history
      //     .replaceState(null, 'nav', 'nav/${friendlyUrlTabName(event.tabPage)}');
    }
    if (event.dashboardVersion != null &&
        event.dashboardVersion != state.dashboardVersion) {
      emit(state.update(
          tabPage: appTabs(event.dashboardVersion).first,
          dashboardVersion: event.dashboardVersion));
      WidgetsFlutterBinding.ensureInitialized().performReassemble();
    }
  }

  _onDispose(event, Emitter<NavigationState> emit) async {}

  _onInit(InitNavigation event, Emitter<NavigationState> emit) async {
    onRefreshConfigs();
  }
}

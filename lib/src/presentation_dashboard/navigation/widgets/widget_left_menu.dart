import 'dart:math';

import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/presentation/navigation/navigation_screen.dart';
import 'package:temp_package_name/src/presentation/travelmeit_points/widgets/widget_appbar_child.dart';
import 'package:temp_package_name/src/presentation/travelmeit_tours/widgets/widget_appbar_child.dart';
import 'package:temp_package_name/src/presentation/widgets/homelido_popup_content.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_hover_builder.dart';
import 'package:temp_package_name/src/utils/utils.dart';

class WidgetLeftMenu extends StatefulWidget {
  const WidgetLeftMenu({super.key});

  @override
  State<WidgetLeftMenu> createState() => _WidgetLeftMenuState();
}

class _WidgetLeftMenuState extends State<WidgetLeftMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      bloc: navigationBloc,
      buildWhen: (previous, current) =>
          previous.dashboardVersion != current.dashboardVersion ||
          previous.tabPage != current.tabPage,
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: 90.sw,
              width: 110.sw,
              child: state.dashboardVersion == AppDashboardVersion.travelmeit
                  ? Center(
                      child: WidgetAssetImage.png(
                        'travelmeit_logo',
                        width: 100.sw,
                        fit: BoxFit.scaleDown,
                      ),
                    )
                  : const SizedBox(),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(24.sw, 0, 24.sw, 24.sw),
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.00, -1.00),
                    end: Alignment(0, 1),
                    colors: [Color(0xFFF1F1F1), Color(0x00EBE7E7)],
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 40,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                width: 110.sw,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.sw - 20.sw, bottom: 24.sw),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        AppTabPage e = appTabs()[index];
                        bool isSelected = state.tabPage == e;
                        return _WidgetButton(
                          e: e,
                          isSelected: isSelected,
                        );
                      },
                      itemCount: appTabs().length,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WidgetButton extends StatelessWidget {
  final AppTabPage e;
  final bool isSelected;
  const _WidgetButton({
    required this.e,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetInkWellTransparent(
      onTap: () {
        navigationBloc.add(OnChangedNavigationEvent(tabPage: e));
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20.sw),
        child: WidgetHoverBuilder(
          builder: (isHover) {
            return PortalTarget(
              visible: isHover,
              anchor: const Aligned(
                  follower: Alignment.centerLeft,
                  target: Alignment.centerRight,
                  offset: Offset(8, 0)),
              portalFollower: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(left: 4.sw),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.sw, vertical: 5.sw),
                    decoration: BoxDecoration(
                        boxShadow: appPopupShadow(context),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.sw)),
                    child: Text(
                      getButtonByType(e).title,
                      textAlign: TextAlign.center,
                      style: w400TextStyle(
                          fontSize: fs12(context),
                          height: 1.3,
                          color: appColorPrimary1),
                    ),
                  ),
                  Transform.rotate(
                    angle: pi / 4,
                    child: Container(
                      height: 8.sw,
                      width: 8.sw,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // portalFollower:  WidgetPopupContainer(
              //   backgroundColor: Colors.white,
              //   width: 100.sw,
              //   alignmentTail: Alignment.centerLeft,
              //   padding: EdgeInsets.zero,
              //   child: Text(
              //     getButtonByType(e).title,
              //     textAlign: TextAlign.center,
              //     style: w400TextStyle(
              //         fontSize: fs14(context),
              //         height: 1.3,
              //         color: appColorPrimary1),
              //   ),
              // ),
              child: WidgetAppSVG(
                getButtonByType(e).icon,
                width: 24.sw,
                color: isSelected || isHover
                    ? appColorPrimary1
                    : hexColor('#9499AD'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ButtonMenuInfo {
  String title;
  Widget? appBarChild;
  String icon;
  Function()? onTap;

  ButtonMenuInfo({
    required this.title,
    required this.icon,
    this.appBarChild,
  });
}

ButtonMenuInfo getButtonByType(AppTabPage page) {
  switch (page) {
    case AppTabPage.solucalcDashboard:
      return ButtonMenuInfo(title: "Dashboard", icon: 'tab_dashboard');
    case AppTabPage.solucalcUsers:
      return ButtonMenuInfo(title: "Users", icon: 'tab_users');
    case AppTabPage.solucalcDevices:
      return ButtonMenuInfo(title: "Devices", icon: 'solucalc_tab_devices');
    case AppTabPage.solucalcPush:
      return ButtonMenuInfo(title: "Push", icon: 'solucalc_tab_push');
    case AppTabPage.solucalcParamater:
      return ButtonMenuInfo(title: "Paramaters", icon: 'solucalc_tab_params');

    case AppTabPage.travelmeitDashboard:
      return ButtonMenuInfo(title: "Dashboard", icon: 'tab_dashboard');
    case AppTabPage.travelmeitCategories:
      return ButtonMenuInfo(
        title: "Category manager",
        icon: 'tab_gps',
      );
    case AppTabPage.travelmeitTours:
      return ButtonMenuInfo(
        title: "Tour manager",
        icon: 'tab_routing',
        appBarChild: const WidgetTravelmeitToursAppBarChild(),
      );
    case AppTabPage.travelmeitPoints:
      return ButtonMenuInfo(
        title: "Point of interest",
        icon: 'tab_gps',
        appBarChild: const WidgetTravelmeitPointAppBarChild(),
      );
    case AppTabPage.travelmeitUsers:
      return ButtonMenuInfo(title: "Users", icon: 'tab_users');

    case AppTabPage.legal:
      return ButtonMenuInfo(title: "Legal", icon: 'tab_legal');
    case AppTabPage.systemPictures:
      return ButtonMenuInfo(
        title: "System pictures",
        icon: 'tab_image',
      );
    case AppTabPage.myProfile:
      return ButtonMenuInfo(
        title: "My Profile",
        icon: '',
      );

    default:
      return ButtonMenuInfo(title: "Unknow", icon: 'tab_dashboard_home');
  }
}

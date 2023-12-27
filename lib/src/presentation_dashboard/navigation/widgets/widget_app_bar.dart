import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:_private_core_network/network_resources/language/models/language_available.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:temp_package_name/src/base/bloc.dart';

import 'package:temp_package_name/src/base/main/bloc/main_bloc.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_drop_selector.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_popup_container.dart';
import 'package:temp_package_name/src/utils/utils.dart';
import 'package:gap/gap.dart';

import '../navigation_screen.dart';
import 'widget_left_menu.dart';

class WidgetAppBar extends StatelessWidget {
  const WidgetAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
        bloc: navigationBloc,
        builder: (_, state) {
          return SizedBox(
            height: 90.sw,
            child: Row(
              children: [
                Gap(24.sw),
                Text(
                  getButtonByType(state.tabPage).title,
                  style: w600TextStyle(fontSize: fs24()),
                ),
                Expanded(
                  child: getButtonByType(state.tabPage).appBarChild ??
                      const SizedBox(),
                ),
                const WidgetAvatarProfile(),
                Container(
                  height: 24.sw,
                  width: 1.sw,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 32.sw),
                ),
                const _WidgetMenuLanguage(),
                Gap(12.sw),
                WidgetInkWellTransparent(
                  onTap: () {
                    navigationBloc.add(const OnChangedNavigationEvent(
                        isEndDrawerNotification: true));
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.sw),
                    child: WidgetAppSVG(
                      'solucalc_bell',
                      width: 24.sw,
                    ),
                  ),
                ),
                Gap(12.sw),
              ],
            ),
          );
        });
  }
}

class _WidgetMenuLanguage extends StatelessWidget {
  const _WidgetMenuLanguage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      bloc: mainBloc,
      builder: (context, state) {
        return WidgetOverlayActions(
          gestureType: state.languagesAvailable != null
              ? GestureType.onTap
              : GestureType.none,
          childBuilder: (isPopupShowing) => Ink(
            child: Row(
              children: [
                WidgetAppFlag.languageCode(
                  languageCode: getLocale().languageCode,
                  height: 24.sw,
                ),
                Gap(12.sw),
                WidgetAppSVG(
                  'ic_arrow_down',
                  width: 24.sw,
                  color: hexColor('#363853'),
                )
              ],
            ),
          ),
          builder: (child, size, childPosition, pointerPosition, animationValue,
              hide, context) {
            return Positioned(
              right: context.width - childPosition.dx - size.width,
              top: childPosition.dy + size.height + 12,
              child: Transform.scale(
                alignment: const Alignment(0.8, -1.0),
                scale: animationValue,
                child: WidgetPopupContainer(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: BlocBuilder<MainBloc, MainState>(
                      bloc: mainBloc,
                      builder: (context, state) {
                        return IntrinsicWidth(
                          child: Column(
                            children: state.languagesAvailable!
                                .map((e) => _buildLanguageItem(hide, e))
                                .toList(),
                          ),
                        );
                      }),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageItem(hide, LanguageAvailable m) {
    final isSelected = getLocale().languageCode == m.code;
    return WidgetDropSelectorItem(
      onTap: () async {
        await hide();
        mainBloc.add(ChangedFilterMainEvent(language: m));
      },
      isSelected: isSelected,
      icon: Row(children: [
        WidgetAppFlag.languageCode(
          languageCode: m.code,
          height: 22.sw,
        ),
        Gap(12.sw),
      ]),
      label: m.language!,
    ).opacity(isSelected ? .6 : 1);
  }
}

class WidgetAvatarProfile extends StatefulWidget {
  const WidgetAvatarProfile({super.key});

  @override
  State<WidgetAvatarProfile> createState() => _WidgetAvatarProfileState();
}

class _WidgetAvatarProfileState extends State<WidgetAvatarProfile> {
  @override
  Widget build(BuildContext context) {
    return WidgetOverlayActions(
      child: StreamBuilder<BoxEvent>(
        stream: AppPrefs.instance.watch('user_info'),
        builder: (context, snapshot) {
          return WidgetAvatar.withoutBorder(
            key: ValueKey(AppPrefs.instance.loginUser?.thumbnail),
            imageUrl: AppPrefs.instance.loginUser?.thumbnail,
            radius: 36.sw / 2,
          );
        },
      ),
      builder: (child, size, childPosition, rightClickPosition, animationValue,
          hide, context) {
        return Positioned(
          right: context.width - childPosition.dx - size.width - 12,
          top: childPosition.dy + size.height + 8.sw,
          child: Transform.scale(
            alignment: const Alignment(0.8, -1.0),
            scale: animationValue,
            child: WidgetPopupContainer(
              width: 165.sw,
              padding: EdgeInsets.only(top: 12.sw, bottom: 12.sw),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetDropSelectorItem(
                    isSelected: false,
                    icon: Row(
                      children: [
                        WidgetAppSVG(
                          'ic_person',
                          width: 24.sw,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                    label: 'My Profile'.tr(),
                    onTap: () {
                      hide();
                      setState(() {});
                      navigationBloc.add(const OnChangedNavigationEvent(
                          tabPage: AppTabPage.myProfile));
                    },
                  ),
                  WidgetDropSelectorItem(
                    isSelected: false,
                    icon: Row(
                      children: [
                        WidgetAppSVG(
                          'ic_logout',
                          width: 24.sw,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                    label: 'Logout'.tr(),
                    onTap: () {
                      findInstance<AuthBloc>().add(LogoutAuthEvent());
                      hide();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

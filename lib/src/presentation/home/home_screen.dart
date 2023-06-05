import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gap/gap.dart';
import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:temp_package_name/src/base/bloc.dart';
import 'package:temp_package_name/src/base/theme_bloc/widgets/widget_theme_wraper.dart';
import 'package:temp_package_name/src/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: Column(
        children: [
          const Gap(32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Gap(32),
              WidgetAppSVG(
                'flutter',
                width: 32,
                color: appColorText,
              ),
              const Gap(20),
              Expanded(
                child: Text(
                  AppThemeProvider.isDarkMode()
                      ? 'DEMO isDarkMode'
                      : 'DEMO isNotDarkMode',
                  style: w600TextStyle(fontSize: 22),
                ),
              ),
              const Gap(16),
              WidgetRippleButton(
                onTap: () {
                  context.push('/page1');
                },
                color: appColorText,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                  child: Text(
                    'Next page',
                    style: w400TextStyle(color: appColorBackground),
                  ),
                ),
              ),
              const Gap(32),
            ],
          ),
          const Gap(20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'meow'.tr(),
                      style: w400TextStyle(height: 1.6),
                    ),
                    const Gap(20),
                    Row(
                      children: appSupportedLocales
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: WidgetRippleButton(
                                  onTap: () {
                                    context.setLocale(e);
                                  },
                                  color: appColorText,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 32),
                                    child: Text(
                                      e.languageCode,
                                      style: w400TextStyle(
                                          color: appColorBackground),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              FlutterSwitch(
                width: 125.0,
                height: 55.0,
                valueFontSize: 25.0,
                toggleSize: 45.0,
                value: AppThemeProvider.isDarkMode(context),
                borderRadius: 30.0,
                padding: 8.0,
                showOnOff: true,
                activeText: "Dark",
                inactiveText: "Light",
                onToggle: (val) {
                  findInstance<ThemeBloc>().add(ChangedThemeEvent(isDark: val));
                },
              ),
              const Gap(32),
            ],
          ),
          const Gap(32),
        ],
      ),
    );
  }
}

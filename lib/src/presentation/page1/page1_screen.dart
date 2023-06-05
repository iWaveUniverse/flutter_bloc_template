import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:temp_package_name/src/base/bloc.dart';
import 'package:temp_package_name/src/utils/utils.dart';

class Page1Screen extends StatefulWidget {
  const Page1Screen({super.key});

  @override
  State<Page1Screen> createState() => _Page1ScreenState();
}

class _Page1ScreenState extends State<Page1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Gap(32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Gap(32),
            const WidgetAppSVG(
              'flutter',
              width: 32,
            ),
            const Gap(20),
            Expanded(
              child: Text(
                'DEMO',
                style: w600TextStyle(fontSize: 22),
              ),
            ),
            const Gap(16),
            WidgetRippleButton(
              onTap: () {
                context.pop();
              },
              color: appColorText,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                child: Text(
                  'Prev page',
                  style: w400TextStyle(color: appColorBackground),
                ),
              ),
            ),
            const Gap(16),
            WidgetRippleButton(
              onTap: () {
                context.push('/page2');
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
          child: Center(
            child: Text(
              'Page1Screen',
              style: w400TextStyle(),
            ),
          ),
        ),
        Row(
          children: [
            const Spacer(),
            BlocBuilder<ThemeBloc, ThemeState>(
              bloc: findInstance<ThemeBloc>(),
              builder: (context, state) {
                return FlutterSwitch(
                  width: 125.0,
                  height: 55.0,
                  valueFontSize: 25.0,
                  toggleSize: 45.0,
                  value: findInstance<ThemeBloc>().state.isDark,
                  borderRadius: 30.0,
                  padding: 8.0,
                  showOnOff: true,
                  activeText: "Dark",
                  inactiveText: "Light",
                  onToggle: (val) {
                    findInstance<ThemeBloc>()
                        .add(ChangedThemeEvent(isDark: val));
                  },
                );
              },
            ),
            const Gap(32),
          ],
        ),
        const Gap(32),
      ],
    ));
  }
}

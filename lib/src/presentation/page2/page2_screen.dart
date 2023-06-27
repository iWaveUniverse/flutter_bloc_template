import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class Page2Screen extends StatefulWidget {
  const Page2Screen({super.key});

  @override
  State<Page2Screen> createState() => _Page2ScreenState();
}

class _Page2ScreenState extends State<Page2Screen> {
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
              const Gap(32),
            ],
          ),
          const Gap(20),
          Expanded(
              child: Center(
            child: Text(
              'Page2Screen',
              style: w400TextStyle(),
            ),
          )),
        ],
      ),
    );
  }
}

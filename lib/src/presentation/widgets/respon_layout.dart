import 'package:flutter/material.dart';

T responByWidth<T>(context, T size,
    {T? computer, T? tablet2, T? tablet1, T? phone}) {
  if (ResponLayout.isComputer(context)) return computer ?? size;
  if (ResponLayout.isTablet2(context)) {
    return tablet2 ?? tablet1 ?? size;
  }
  if (ResponLayout.isTablet1(context)) return tablet1 ?? phone ?? size;
  if (ResponLayout.isPhone(context)) return phone ?? size;
  return size;
}

bool isComputerByWidth(context) => ResponLayout.isComputer(context);
bool isPhoneByWidth(context) => ResponLayout.isPhone(context);

class ResponLayout extends StatelessWidget {
  final Widget phone;
  final Widget tablet1;
  final Widget tablet2;
  final Widget computer;

  const ResponLayout({
    super.key,
    required this.phone,
    required this.tablet1,
    required this.tablet2,
    required this.computer,
  });

  static const int phoneLimit = 480;
  static const int tabletLimit2 = 1280;
  static const int tabletLimit1 = 780;

  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < phoneLimit;

  static bool isTablet1(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit1 &&
      MediaQuery.of(context).size.width >= phoneLimit;

  static bool isTablet2(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit2 &&
      MediaQuery.of(context).size.width >= tabletLimit1;

  static bool isComputer(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletLimit2;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < phoneLimit) {
          return phone;
        } else if (constraints.maxWidth < tabletLimit1) {
          return tablet1;
        } else if (constraints.maxWidth < tabletLimit2) {
          return tablet2;
        } else {
          return computer;
        }
      },
    );
  }
}

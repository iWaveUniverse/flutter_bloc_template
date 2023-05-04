import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

abstract class WidgetResponsiveBuilder<T> {
  Widget buildDesktop(BuildContext context, T state) => SizedBox();

  Widget buildTablet(BuildContext context, T state) => SizedBox();

  Widget buildMobile(BuildContext context, T state);

  Widget buildUi(
      {required BuildContext context,
      required T state,
      Widget? defaultWidget}) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      if (sizeInfo.deviceScreenType == DeviceScreenType.desktop) {
        return buildDesktop(context, state);
      } else if (sizeInfo.deviceScreenType == DeviceScreenType.tablet) {
        return buildTablet(context, state);
      } else if (sizeInfo.deviceScreenType == DeviceScreenType.mobile) {
        return buildMobile(context, state);
      }
      return defaultWidget ?? SizedBox();
    });
  }
}

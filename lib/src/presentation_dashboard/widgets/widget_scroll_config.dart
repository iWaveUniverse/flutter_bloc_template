import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WidgetScrollConfigurationHorizontal extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  const WidgetScrollConfigurationHorizontal({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: _NoThumbScrollBehavior().copyWith(scrollbars: false),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

class _NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class WidgetScrollConfigurationVertical extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  const WidgetScrollConfigurationVertical({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: _NoThumbScrollBehaviorVertical().copyWith(scrollbars: false),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

class _NoThumbScrollBehaviorVertical extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {};
}

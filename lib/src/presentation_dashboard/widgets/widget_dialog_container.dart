import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:temp_package_name/src/utils/utils.dart';
import 'package:_private_core/extensions/context_extension.dart';
import 'package:temp_package_name/src/constants/constants.dart';

class WidgetDialogContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool isTapToDismiss;
  final Color? color;
  const WidgetDialogContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
    this.isTapToDismiss = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetInkWellTransparent(
      onTap: () {
        if (isTapToDismiss) appContext.pop();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          width: appContext.width,
          height: appContext.height,
          child: Center(
            child: WidgetInkWellTransparent(
              onTap: () {},
              child: Container(
                width: width,
                height: height,
                margin: margin ?? const EdgeInsets.all(16),
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 48),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    boxShadow: appShadowLight,
                    color: color ?? appColorBackground,
                    borderRadius: BorderRadius.circular(borderRadius ?? 26)),
                child: child,
              ),
            ),
          ),
          // child: WidgetGlassBackground(
          //   blur: 8,
          //   backgroundColor: byTheme(Colors.white24, dark: Colors.black26),
          //   child: Center(
          //     child: Container(
          //       width: width,
          //       height: height,
          //       margin: margin ?? const EdgeInsets.all(16),
          //       padding: padding ?? const EdgeInsets.symmetric(horizontal: 48),
          //       clipBehavior: Clip.antiAlias,
          //       decoration: BoxDecoration(
          //           boxShadow: appShadowLight,
          //           color: appColorBackground,
          //           borderRadius: BorderRadius.circular(borderRadius ?? 26)),
          //       child: child,
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

List<BoxShadow> get appShadowLight => [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(3, 0),
        blurRadius: 6,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0, 3),
        blurRadius: 6,
        spreadRadius: 0,
      ),
    ];

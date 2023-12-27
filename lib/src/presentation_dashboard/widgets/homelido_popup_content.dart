import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:temp_package_name/src/constants/constants.dart';

enum ArrowAlignment {
  left1,
  left2,
  left35,
  right20,
  right25,
  right30,
  right35,
  center
}

class WidgetTrianglePopup extends StatelessWidget {
  final bool isUpDirection;
  final double? height;
  final Color? color;

  const WidgetTrianglePopup({
    super.key,
    this.isUpDirection = true,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: isUpDirection ? 0 : 2,
      child: Image.asset(
        assetpng('bg_triangle'),
        height: height ?? 12,
        color: color ?? appColorBackground,
      ),
    );
  }
}

class HomelidoPopupContent extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final ArrowAlignment arrowAlignment;
  final bool isUpDirection;

  const HomelidoPopupContent({
    super.key,
    required this.height,
    required this.width,
    this.arrowAlignment = ArrowAlignment.center,
    this.isUpDirection = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height + 11,
      child: Stack(
        children: isUpDirection
            ? [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: WidgetInkWellTransparent(
                    onTap: () {},
                    child: Container(
                      width: width,
                      height: height,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: appColorBackground,
                        boxShadow: appPopupShadow(context),
                      ),
                      child: child,
                    ),
                  ),
                ),
                if (arrowAlignment == ArrowAlignment.center)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: WidgetTrianglePopup(),
                  ),
                if (arrowAlignment == ArrowAlignment.left1)
                  Positioned(
                    top: 0,
                    left: width * 0.1,
                    child: const WidgetTrianglePopup(),
                  ),
                if (arrowAlignment == ArrowAlignment.left2)
                  Positioned(
                    top: 0,
                    left: width * 0.2,
                    child: const WidgetTrianglePopup(),
                  ),
                if (arrowAlignment == ArrowAlignment.left35)
                  Positioned(
                    top: 0,
                    left: width * 0.35,
                    child: const WidgetTrianglePopup(),
                  ),
                if (arrowAlignment == ArrowAlignment.right20)
                  Positioned(
                    top: 0,
                    right: width * 0.2,
                    child: const WidgetTrianglePopup(),
                  ),
                if (arrowAlignment == ArrowAlignment.right25)
                  Positioned(
                    top: 0,
                    right: width * 0.25,
                    child: const WidgetTrianglePopup(),
                  ),
                if (arrowAlignment == ArrowAlignment.right30)
                  Positioned(
                    top: 0,
                    right: width * 0.3,
                    child: const WidgetTrianglePopup(),
                  ),
                if (arrowAlignment == ArrowAlignment.right35)
                  Positioned(
                    top: 0,
                    right: width * 0.35,
                    child: const WidgetTrianglePopup(),
                  ),
              ]
            : [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: WidgetInkWellTransparent(
                    onTap: () {},
                    child: Container(
                      width: width,
                      height: height,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: appColorBackground,
                        boxShadow: appPopupShadow(context),
                      ),
                      child: child,
                    ),
                  ),
                ),
                if (arrowAlignment == ArrowAlignment.center)
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: WidgetTrianglePopup(
                      isUpDirection: false,
                    ),
                  ),
                if (arrowAlignment == ArrowAlignment.left2)
                  Positioned(
                    bottom: 0,
                    left: width * 0.2,
                    child: const WidgetTrianglePopup(
                      isUpDirection: false,
                    ),
                  ),
                if (arrowAlignment == ArrowAlignment.left35)
                  Positioned(
                    bottom: 0,
                    left: width * 0.35,
                    child: const WidgetTrianglePopup(
                      isUpDirection: false,
                    ),
                  ),
                if (arrowAlignment == ArrowAlignment.right20)
                  Positioned(
                    bottom: 0,
                    right: width * 0.2,
                    child: const WidgetTrianglePopup(
                      isUpDirection: false,
                    ),
                  ),
                if (arrowAlignment == ArrowAlignment.right25)
                  Positioned(
                    bottom: 0,
                    right: width * 0.25,
                    child: const WidgetTrianglePopup(
                      isUpDirection: false,
                    ),
                  ),
                if (arrowAlignment == ArrowAlignment.right35)
                  Positioned(
                    bottom: 0,
                    right: width * 0.35,
                    child: const WidgetTrianglePopup(
                      isUpDirection: false,
                    ),
                  ),
              ],
      ),
    );
  }
}

List<BoxShadow> appPopupShadow(BuildContext context) {
  return [
    BoxShadow(
      color: appColorText.withOpacity(0.08),
      offset: const Offset(3, 11),
      blurRadius: 40,
      spreadRadius: 0,
    )
  ];
}

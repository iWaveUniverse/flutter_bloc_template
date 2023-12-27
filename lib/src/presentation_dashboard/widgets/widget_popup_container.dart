import 'dart:math';

import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/presentation/widgets/homelido_popup_content.dart';

class WidgetPopupContainer extends StatelessWidget {
  final Widget child;
  final Alignment? alignmentTail;
  final EdgeInsets? paddingTail;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Border? border;
  final bool isEnableTail;
  final bool isScrollableIcon;

  const WidgetPopupContainer({
    super.key,
    required this.child,
    this.alignmentTail,
    this.paddingTail,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
    this.backgroundColor,
    this.border,
    this.isEnableTail = true,
    this.isScrollableIcon = false,
  });

  Alignment get _alignmentTail => (alignmentTail ?? Alignment.topRight);
  Color? get _backgroundColor => backgroundColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: Stack(
        alignment: _alignmentTail,
        children: [
          WidgetInkWellTransparent(
            onTap: () {},
            child: Container(
              width: width,
              height: height != null
                  ? (height! + (!isScrollableIcon ? 0 : (6.sw * 2 + 18.sw)))
                  : null,
              padding: (padding ?? EdgeInsets.zero).add(EdgeInsets.only(
                  bottom: !isScrollableIcon ? 0 : (6.sw * 2 + 18.sw))),
              clipBehavior: Clip.antiAlias,
              margin: _alignmentTail.y == 0
                  ? _alignmentTail.x < 0
                      ? EdgeInsets.only(left: 6.sw)
                      : EdgeInsets.only(right: 6.sw)
                  : _alignmentTail.y < 0
                      ? EdgeInsets.only(top: 6.sw)
                      : EdgeInsets.only(bottom: 6.sw),
              decoration: BoxDecoration(
                  boxShadow: appPopupShadow(context),
                  color: _backgroundColor,
                  border: border,
                  borderRadius: borderRadius ?? BorderRadius.circular(16.sw)),
              child: child,
            ),
          ),
          if (isScrollableIcon)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.sw),
                margin: _alignmentTail.y == 0
                    ? _alignmentTail.x < 0
                        ? EdgeInsets.only(left: 6.sw)
                        : EdgeInsets.only(right: 6.sw)
                    : _alignmentTail.y < 0
                        ? EdgeInsets.only(top: 6.sw)
                        : EdgeInsets.only(bottom: 6.sw),
                decoration: BoxDecoration(
                    boxShadow: appPopupShadow(context),
                    color: _backgroundColor,
                    border: border,
                    borderRadius: BorderRadius.only(
                        bottomLeft:
                            (borderRadius ?? BorderRadius.circular(16.sw))
                                .bottomLeft,
                        bottomRight:
                            (borderRadius ?? BorderRadius.circular(16.sw))
                                .bottomRight)),
                alignment: Alignment.center,
                child: Icon(
                  Icons.keyboard_double_arrow_down,
                  color: appColorText.withOpacity(.2),
                  size: 18.sw,
                ),
              ),
            ),
          if (isEnableTail)
            Padding(
              padding: paddingTail ??
                  (_alignmentTail.x == 0
                      ? EdgeInsets.zero
                      : _alignmentTail.x < 0
                          ? EdgeInsets.only(left: 28.sw)
                          : EdgeInsets.only(right: 28.sw)),
              // child: ClipPath(
              //   clipper: _alignmentTail.y < 0 ? _CliperTop() : _CliperBottom(),
              child: Transform.rotate(
                angle: pi / 4,
                child: Container(
                  height: 12.sw,
                  width: 12.sw,
                  color: _backgroundColor,
                ),
              ),
            ),
          // )
        ],
      ),
    );
  }
}

class _CliperBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2);
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _CliperTop extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(0, 0);
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WidgetPopupContainerGlass extends StatelessWidget {
  final Widget child;
  final Alignment? alignmentTail;
  final EdgeInsets? paddingTail;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  const WidgetPopupContainerGlass({
    super.key,
    required this.child,
    this.alignmentTail,
    this.paddingTail,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
    this.backgroundColor,
  });

  Alignment get _alignmentTail => (alignmentTail ?? Alignment.topRight);
  Color? get _backgroundColor => backgroundColor ?? appColorBackgroundPopup;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: _alignmentTail,
      children: [
        Container(
          width: width,
          height: height,
          clipBehavior: Clip.antiAlias,
          margin: _alignmentTail.y < 0
              ? const EdgeInsets.only(top: 8)
              : const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            boxShadow: appPopupShadow(context),
          ),
          child: WidgetGlassBackground(
              backgroundColor: _backgroundColor,
              borderRadius: borderRadius ?? BorderRadius.circular(16.sw),
              padding: padding,
              child: child),
        ),
        Padding(
          padding: paddingTail ??
              (_alignmentTail.x < 0
                  ? EdgeInsets.only(left: 28.sw)
                  : const EdgeInsets.only(right: 28)),
          child: ClipPath(
            clipper: _alignmentTail.y < 0 ? _CliperTop() : _CliperBottom(),
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                height: 16.sw,
                width: 16.sw,
                color: _backgroundColor,
              ),
            ),
          ),
        )
      ],
    );
  }
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
      child: WidgetAssetImage.png(
        'bg_triangle',
        height: height ?? 12.sw,
        color: color ?? appColorBackgroundPopup,
      ),
    );
  }
}

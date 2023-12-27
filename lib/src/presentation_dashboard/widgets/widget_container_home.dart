import 'package:_private_core/widgets/widget_glass_background.dart';
import 'package:flutter/material.dart';
import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:temp_package_name/src/constants/constants.dart';

class WidgetTitleDialog extends StatelessWidget {
  final String text;
  const WidgetTitleDialog(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: WidgetBaseDialog.titleTextStyle,
    );
  }
}

class WidgetSubDialog extends StatelessWidget {
  final String text;
  final bool isRequired;
  const WidgetSubDialog(this.text, {super.key, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: WidgetBaseDialog.subTextStyle,
        ),
        if (isRequired)
          Text(
            '*',
            style: w500TextStyle(fontSize: 10, color: Colors.red),
          ),
      ],
    );
  }
}

class WidgetBaseDialog extends StatelessWidget {
  static double horizontalPadding = 28;
  static TextStyle titleTextStyle = w500TextStyle(fontSize: 28.sw);
  static TextStyle subTextStyle = w400TextStyle(fontSize: 14.sw);

  final Widget child;
  final double? width;
  final String? tag;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Color? color;
  const WidgetBaseDialog({
    super.key,
    required this.child,
    this.width,
    this.padding,
    this.margin,
    this.tag,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Widget builder = GestureDetector(
      onTap: () {},
      child: Container(
        margin: margin ?? EdgeInsets.zero,
        padding: padding ??
            EdgeInsets.fromLTRB(horizontalPadding, horizontalPadding * .85,
                horizontalPadding, horizontalPadding * .85),
        decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(22),
            color: color ?? Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(4, 4),
                  color: hexColor('#455A91').withOpacity(.16))
            ]),
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    );
    return PointerInterceptor(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Material(
          color: Colors.transparent,
          child: WidgetGlassBackground(
            blur: 12,
            backgroundColor: Colors.white24,
            child: Center(
              child: tag != null
                  ? Hero(
                      tag: tag!,
                      child: Material(
                        color: Colors.transparent,
                        child: builder,
                      ),
                    )
                  : builder,
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetBaseCardFlat extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Function()? onTap;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final double? elevation;
  const WidgetBaseCardFlat({
    super.key,
    required this.child,
    this.borderColor,
    this.elevation,
    this.onTap,
    this.color,
    this.padding,
    this.borderRadius,
    this.borderWidth,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.instance.appBackground,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(kborderRadius),
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
              borderRadius:
                  borderRadius ?? BorderRadius.circular(kborderRadius),
              border: Border.all(
                  color: borderColor ?? hexColor('#EBEDF3'),
                  width: borderWidth ?? 1)),
          child: child,
        ),
      ),
    );
  }
}

class WidgetBaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Function()? onTap;
  final Color? color;
  final double? elevation;
  const WidgetBaseCard({
    super.key,
    required this.child,
    this.elevation,
    this.onTap,
    this.color,
    this.padding,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: hexColor('#EBEDF3')),
        borderRadius: borderRadius ?? BorderRadius.circular(kborderRadius),
        boxShadow: [
          BoxShadow(
              blurRadius: 8,
              offset: const Offset(2, 4),
              color: hexColor('#A8B9E6').withOpacity(.15))
        ],
      ),
      child: Material(
        borderRadius: borderRadius ?? BorderRadius.circular(kborderRadius),
        color: color ?? AppColors.instance.appBackground,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(kborderRadius),
          child: Container(
            margin: margin,
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}

class WidgetResponseHomeDrawer extends StatelessWidget {
  final Widget child;
  const WidgetResponseHomeDrawer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
    // return ResponsiveLayout(
    //   tiny: Container(),
    //   phone: child,
    //   tablet: child,
    //   largeTablet: child,
    //   computer: Row(
    //     children: [
    //       const WidgetDrawer(),
    //       Expanded(child: child),
    //     ],
    //   ),
    // );
  }
}

class WidgetContainerHome extends StatelessWidget {
  static double get paddingTop => 32.sw;
  static double get paddingLeft => 32.sw;

  final Widget child;
  final bool withoutScroll;
  final Color? color;
  const WidgetContainerHome({
    super.key,
    required this.child,
    this.withoutScroll = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(45.sw))),
      padding:
          EdgeInsets.only(top: paddingTop, left: paddingTop, right: paddingTop),
      child: withoutScroll
          ? child
          : Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: child,
              ),
            ),
    );
  }
}

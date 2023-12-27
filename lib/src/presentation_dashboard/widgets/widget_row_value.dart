import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_hover_builder.dart';

import 'widget_copyable.dart';

class WidgetTableContainer extends StatelessWidget {
  final Widget header;
  final Widget data;
  const WidgetTableContainer(
      {super.key, required this.header, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(16.sw),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.sw),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: 42.sw),
                      child: data,
                    ),
                  ),
                  WidgetRowHeader(
                    child: header,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WidgetRowHeader extends StatelessWidget {
  final Widget child;
  const WidgetRowHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.sw,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.sw)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 20.sw,
              spreadRadius: 4.sw,
              offset: Offset(0, 4.sw))
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.sw),
      child: child,
    );
  }
}

class WidgetRowItem extends StatelessWidget {
  final int index;
  final Widget child;
  final Function()? onTap;
  final bool ignoringChild;
  const WidgetRowItem(
      {super.key,
      this.ignoringChild = true,
      required this.child,
      required this.index,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return WidgetInkWellTransparent(
      onTap: onTap,
      child: WidgetHoverBuilder(builder: (isHover) {
        return Container(
          decoration: BoxDecoration(
              color: !isHover && onTap != null
                  ? hexColor('#FAFAFA')
                  : Colors.white,
              border: Border.all(width: 0.4, color: hexColor('#F2F2F2'))),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: onTap != null
              ? IgnorePointer(
                  ignoring: ignoringChild,
                  child: child,
                )
              : child,
        );
      }),
    );
  }
}

class WidgetRowValue extends StatelessWidget {
  static TextStyle get textStyleLabel =>
      w400TextStyle(color: hexColor('#9499AD'), fontSize: 14.sw, height: 1);
  static TextStyle get textStyleValue =>
      w400TextStyle(color: hexColor('#9499AD'), fontSize: 14.sw, height: 1);

  final int flex;
  final Alignment alignment;
  final int maxLines;
  // String? // Widget
  final dynamic value;
  final bool isLabel;
  const WidgetRowValue({
    super.key,
    required this.value,
    this.alignment = Alignment.centerLeft,
    this.flex = 1,
    this.maxLines = 1,
  }) : isLabel = false;

  const WidgetRowValue.label({
    super.key,
    required this.value,
    this.alignment = Alignment.centerLeft,
    this.flex = 1,
    this.maxLines = 1,
  }) : isLabel = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: value is Widget
            ? value
            : isLabel
                ? Text(
                    value ?? "",
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleLabel,
                  )
                : WidgetTextCopyable(
                    value ?? "",
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: isLabel ? textStyleLabel : textStyleValue,
                  ),
      ),
    );
  }
}

class WidgetRowValueShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final int flex;
  final Alignment alignment;
  const WidgetRowValueShimmer({
    super.key,
    this.width,
    this.height,
    this.alignment = Alignment.centerLeft,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: WidgetAppShimmer(
          width: width ?? 60.sw,
          height: height ?? 16.sw,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

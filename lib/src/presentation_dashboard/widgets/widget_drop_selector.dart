import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:temp_package_name/src/constants/constants.dart';

import 'widget_app_inkwell.dart';
import 'widget_popup_container.dart';

class WidgetDropSelector<T> extends StatelessWidget {
  final Widget Function(dynamic, TextEditingController) itemsBuilder;
  final Widget Function(bool isDropdownOpened)? childBuilder;

  final String label;
  final String value;

  final double? width;
  final bool isEnableSearch;
  final bool isSetHeight;
  final bool isUpDirection;

  const WidgetDropSelector({
    super.key,
    required this.itemsBuilder,
    required this.label,
    required this.value,
    this.width,
    this.isEnableSearch = true,
    this.isSetHeight = true,
    this.isUpDirection = false,
    this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetOverlayActions(
      builder: (child, size, childPosition, pointerPosition, animationValue,
          hide, context) {
        final TextEditingController controller = TextEditingController();
        Widget childWidget = Transform.scale(
          alignment: isUpDirection
              ? const Alignment(0.8, 1.0)
              : const Alignment(0.8, -1.0),
          scale: animationValue,
          child: WidgetPopupContainer(
            width: width ?? size.width,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            height: isSetHeight ? 300.sw : null,
            alignmentTail:
                isUpDirection ? Alignment.bottomRight : Alignment.topRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isEnableSearch) ...[
                  Container(
                    height: 48.sw,
                    margin: EdgeInsets.symmetric(horizontal: 16.sw),
                    padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.sw),
                      color: hexColor('fafafa'),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        WidgetAppSVG(
                          'ic_search_auth',
                          width: 15,
                          color: appColorText.withOpacity(.4),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            controller: controller,
                            style: w300TextStyle(
                              fontSize: 16.sw,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 4.sw),
                              isCollapsed: true,
                              isDense: true,
                              hintStyle: w300TextStyle(
                                fontSize: 16.sw,
                                color: appColorText.withOpacity(.4),
                              ),
                              hintText: 'Search..',
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (context, value, child) {
                            if (controller.text.isEmpty) {
                              return const SizedBox(width: 11.36);
                            } else {
                              return child!;
                            }
                          },
                          child: WidgetAppInkWell(
                            onTap: () {
                              controller.text = '';
                            },
                            child: WidgetAppSVG(
                              'ic_clear',
                              width: 10,
                              color: appColorText.withOpacity(.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(4.sw)
                ],
                if (isEnableSearch)
                  ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (context, value, child) {
                        return itemsBuilder(hide, controller);
                      })
                else
                  itemsBuilder(hide, controller),
              ],
            ),
          ),
        );
        if (isUpDirection) {
          return Positioned(
            right: context.width - childPosition.dx - size.width,
            bottom: context.height - childPosition.dy + 4,
            child: childWidget,
          );
        } else {
          return Positioned(
            right: context.width - childPosition.dx - size.width,
            top: childPosition.dy + size.height + 4,
            child: childWidget,
          );
        }
      },
      childBuilder: childBuilder ??
          (isDropdownOpened) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: w400TextStyle(
                        fontSize: fs14(), color: hexColor('#9499AD')),
                  ),
                  Gap(8.sw),
                  Container(
                    height: 52.sw,
                    padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    decoration: BoxDecoration(
                      color: hexColor('#FAFAFA'),
                      borderRadius: BorderRadius.circular(16.sw),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            value,
                            style: w400TextStyle(
                              fontSize: 16.sw,
                              color: appColorText.withOpacity(.6),
                            ),
                          ),
                        ),
                        WidgetAppSVG(
                          'arrow_down',
                          width: 24.sw,
                        )
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

class WidgetDropSelectorItem extends StatelessWidget {
  final Function() onTap;
  final Widget? icon;
  final String label;
  final int? maxLines;
  final bool isSelected;

  final Widget Function(bool)? builder;

  const WidgetDropSelectorItem({
    super.key,
    required this.onTap,
    required this.label,
    required this.isSelected,
    this.icon,
    this.maxLines,
  }) : builder = null;

  const WidgetDropSelectorItem.builder({
    super.key,
    required this.onTap,
    required this.builder,
    required this.isSelected,
  })  : icon = null,
        label = '',
        maxLines = null;

  @override
  Widget build(BuildContext context) {
    return WidgetAppInkWell(
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 12.sw, horizontal: 16.sw),
        child: builder != null
            ? builder!(isSelected)
            : Row(
                children: [
                  if (icon != null) icon!,
                  Expanded(
                    child: Text(
                      label,
                      maxLines: maxLines ?? 1,
                      overflow: TextOverflow.ellipsis,
                      style: w400TextStyle(
                        fontSize: 16.sw,
                        color: appColorText,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ).opacity(isSelected ? .6 : 1);
  }
}

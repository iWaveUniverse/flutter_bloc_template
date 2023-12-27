import 'dart:async';

import 'package:_private_core/_private_core.dart';
import 'package:flutter/material.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'widget_popup_container.dart';

class WidgetAppTooltip extends StatefulWidget {
  final bool isEnable;
  final Widget child;
  final String message;
  final Widget Function(Alignment alignment, String message)? builder;
  final Alignment? alignment;
  const WidgetAppTooltip({
    super.key,
    this.isEnable = true,
    required this.child,
    required this.message,
    this.alignment,
    this.builder,
  });

  @override
  State<WidgetAppTooltip> createState() => _WidgetAppTooltipState();
}

class _WidgetAppTooltipState extends State<WidgetAppTooltip>
    with TickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));
  bool isHovered = false;
  Timer? _debounce;

  Alignment get alignment => widget.alignment ?? Alignment.topRight;
  double reverseNegative(double number) {
    return -number;
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnable) return widget.child;
    return MouseRegion(
      onEnter: (details) {
        if (_debounce?.isActive ?? false) {
          return;
        }
        _debounce = Timer(const Duration(milliseconds: 800), () {
          setState(() => isHovered = true);
          animationController.forward();
        });
      },
      onExit: (details) async {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        if (isHovered) {
          await animationController.reverse();
          setState(() => isHovered = false);
        }
      },
      child: PortalTarget(
        visible: isHovered,
        anchor: Aligned(
            follower: alignment,
            target: Alignment(
              alignment.x,
              reverseNegative(alignment.y),
            ),
            offset: Offset(0, alignment.y < 0 ? 8 : -8)),
        portalFollower: FadeTransition(
          opacity: CurvedAnimation(
            parent: animationController,
            curve: Curves.easeIn,
          ),
          child: widget.builder != null
              ? widget.builder!(alignment, widget.message)
              : WidgetPopupContainer(
                  alignmentTail: alignment,
                  padding: EdgeInsets.all(12.sw),
                  child: Text(
                    widget.message,
                    style: w400TextStyle(fontSize: fs16(context), height: 1.3),
                  ),
                ),
        ),
        child: widget.child,
      ),
    );
  }
}

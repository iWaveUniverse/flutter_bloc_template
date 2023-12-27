import 'dart:async';

import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/utils/app_toast.dart';

import 'widget_popup_container.dart';

_toast(Offset position, Size size) {
  appToastPosition('Copied!',
      position: Offset(
          position.dx + size.width / 2 - 45, position.dy - size.height - 16),
      duration: const Duration(milliseconds: 1000), builder: (String text) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: appColorText,
        borderRadius: BorderRadius.circular(99),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              size: 18,
              color: AppColors.instance.appBackground,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              text,
              style: w300TextStyle(
                  fontSize: 13, color: AppColors.instance.appBackground),
            )
          ],
        ),
      ),
    );
  });
}

class WidgetCopyable extends StatelessWidget {
  final String text;
  final Widget child;

  const WidgetCopyable({
    super.key,
    required this.text,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey copyButtonKey = GlobalKey();
    return InkWell(
      key: copyButtonKey,
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        RenderBox box =
            copyButtonKey.currentContext!.findRenderObject()! as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        _toast(position, box.size);
      },
      child: child,
    );
  }
}

class WidgetTextCopyable extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;

  const WidgetTextCopyable(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey copyButtonKey = GlobalKey();
    return InkWell(
      key: copyButtonKey,
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        RenderBox box =
            copyButtonKey.currentContext!.findRenderObject()! as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        _toast(position, box.size);
      },
      child: Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: style,
      ),
    );
  }
}

class WidgetToastable extends StatefulWidget {
  final String? text;
  final Widget Function()? builder;
  final Widget child;
  final double? widthPopup;
  final bool visible;

  final Alignment? follower;
  final Alignment? target;

  const WidgetToastable({
    super.key,
    this.text,
    this.builder,
    required this.child,
    this.widthPopup,
    this.follower,
    this.target,
    this.visible = false,
  });

  @override
  State<WidgetToastable> createState() => _WidgetToastableState();
}

class _WidgetToastableState extends State<WidgetToastable> {
  bool tooltip = false;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: tooltip || widget.visible,
      anchor: Aligned(
          follower: widget.follower ?? Alignment.bottomCenter,
          target: widget.target ?? Alignment.topCenter,
          offset: const Offset(0, -8)),
      portalFollower: widget.builder != null
          ? widget.builder!()
          : WidgetPopupContainer(
              width: widget.widthPopup,
              alignmentTail: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
              child: Text(
                widget.text ?? "",
                style: w400TextStyle(fontSize: fs14(context), height: 1.3),
              ),
            ),
      child: WidgetInkWellTransparent(
        onTap: () {
          setState(() {
            tooltip = true;
          });
          timer?.cancel();
          timer = Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                tooltip = false;
              });
            }
          });
        },
        child: widget.child,
      ),
    );
  }
}

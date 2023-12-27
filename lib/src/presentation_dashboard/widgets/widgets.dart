import 'package:_private_core/_private_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/utils/utils.dart';

class WidgetDivider extends StatelessWidget {
  const WidgetDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      width: appContext.width,
      height: .8,
      color: hexColor('#EDEEF3'),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class WidgetCloseIcon extends StatefulWidget {
  final double? size;
  final Color? color;
  const WidgetCloseIcon({super.key, this.size, this.color});

  @override
  State<WidgetCloseIcon> createState() => _WidgetCloseIconState();
}

class _WidgetCloseIconState extends State<WidgetCloseIcon> {
  bool amIHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (details) => setState(() => amIHovering = true),
      onExit: (details) => setState(() => amIHovering = false),
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 200),
        turns: !amIHovering ? -.5 : 0,
        child: Icon(
          Icons.close,
          size: widget.size ?? 24,
          color: widget.color ?? appColorText,
        ),
      ),
    );
  }
}

class WidgetCloseButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Color? color;
  const WidgetCloseButton({super.key, this.onTap, this.color});

  @override
  State<WidgetCloseButton> createState() => _WidgetCloseButtonState();
}

class _WidgetCloseButtonState extends State<WidgetCloseButton> {
  bool amIHovering = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ??
          () {
            appContext.pop();
          },
      onHover: (value) {
        setState(() {
          amIHovering = value;
        });
      },
      child: Row(
        children: [
          Text(
            'close'.tr(),
            style: w300TextStyle(fontSize: 16, color: widget.color),
          ),
          const SizedBox(
            width: 4,
          ),
          AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: !amIHovering ? -.5 : 0,
            child: Icon(
              Icons.close,
              size: 24,
              color: widget.color ?? appColorText,
            ),
          )
        ],
      ),
    );
  }
}

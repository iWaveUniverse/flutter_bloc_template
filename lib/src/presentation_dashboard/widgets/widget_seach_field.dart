import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:temp_package_name/src/constants/constants.dart';

import '../web_auth_pro/widgets/widget_inner_shadow.dart';

class WidgetSearchField extends StatefulWidget {
  final String? hint;
  final dynamic validator;
  final EdgeInsetsGeometry? margin;
  final Function(String _)? onSubmitted;
  final Function(String _)? onChanged;
  final Function(String _)? onFocus;
  final Function(String _)? onUnFocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? next;
  final BorderRadius? borderRadius;
  final bool enable;
  final bool obscureText;
  final bool autofocus;
  final Color? fillColor;
  final TextInputType? inputType;
  final bool isVerified;
  final String? errorMessage;
  final double? height;
  final EdgeInsets? contentPadding;
  final Widget? customSuffitIcon;
  final int? maxLength;

  const WidgetSearchField({
    super.key,
    this.maxLength,
    this.customSuffitIcon,
    this.fillColor,
    this.errorMessage,
    this.contentPadding,
    this.height,
    this.hint,
    this.inputType,
    this.autofocus = false,
    this.obscureText = false,
    this.enable = true,
    this.focusNode,
    this.next,
    this.borderRadius,
    this.margin,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onFocus,
    this.onUnFocus,
    this.validator,
    this.isVerified = false,
  });

  @override
  _WidgetSearchFieldState createState() => _WidgetSearchFieldState();
}

class _WidgetSearchFieldState extends State<WidgetSearchField> {
  late FocusNode focusNode;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        widget.onFocus?.call(controller.text);
      } else {
        widget.onUnFocus?.call(controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              WidgetInnerShadow(
                borderRadius:
                    widget.borderRadius ?? BorderRadius.circular(kborderRadius),
                // boder: widget.errorMessage != null
                //     ? NeumorphicBorder(color: redCircle)
                //     : const NeumorphicBorder.none(),
                padding: const EdgeInsets.all(3),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.search,
                          size: 18,
                          color: AppColors.instance.buttonTopBorderColor,
                        ),
                      ),
                      Container(
                        height: (widget.height ?? 30) * .5,
                        width: 2,
                        decoration: BoxDecoration(
                            color: appColorTextHint.withOpacity(.8),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: widget.height ?? 30,
                          child: Center(
                            child: TextFormField(
                              maxLength: widget.maxLength,
                              autofocus: widget.autofocus,
                              keyboardType: widget.inputType,
                              focusNode: focusNode,
                              obscureText: widget.obscureText,
                              enabled: widget.enable,
                              controller: controller,
                              validator: widget.validator,
                              onChanged: widget.onChanged,
                              onFieldSubmitted: (_) {
                                if (widget.next != null) {
                                  widget.next!.requestFocus();
                                } else if (widget.onSubmitted != null) {
                                  widget.onSubmitted?.call(_);
                                }
                              },
                              style: w700TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                  counter: const SizedBox(),
                                  isCollapsed: true,
                                  hintText: widget.hint,
                                  hintStyle: w500TextStyle(
                                      fontSize: 12,
                                      color:
                                          AppColors.instance.searchTopHintColor,
                                      fontStyle: FontStyle.italic),
                                  border: InputBorder.none,
                                  contentPadding: widget.contentPadding ??
                                      const EdgeInsets.fromLTRB(16, 8, 16, 0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.customSuffitIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: widget.customSuffitIcon,
                )
              else if (widget.isVerified && widget.errorMessage == null)
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: appColorPrimary1,
                    radius: 10,
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                )
            ],
          ),
          if (widget.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.errorMessage!,
                style: w300TextStyle(
                    color: redCircle,
                    fontSize:
                        ResponsiveLayout.byWidth2(context, 14, 15, 13, 12)),
              ),
            )
        ],
      ),
    );
  }
}

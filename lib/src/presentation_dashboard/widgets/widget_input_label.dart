import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:gap/gap.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/utils/utils.dart';

import '../my_payment/widget/widget_credit_card.dart';

class WidgetAppInputLabel extends StatefulWidget {
  final String label;
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
  final TextStyle? textStyle;
  final TextStyle? textlabelStyle;
  final TextStyle? textHintStyle;
  final TextInputType? inputType;
  final bool isVerified;
  final String? errorMessage;
  final double? height;
  final bool skipHeight;
  final EdgeInsets? contentPadding;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;
  final int? maxLine;
  final int? minLine;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Widget? labelIcon;
  final bool labelNotExpand;
  final bool isReadOnly;
  final bool isPassword;
  final List<TextInputFormatter>? inputFormatters;

  const WidgetAppInputLabel({
    super.key,
    required this.label,
    this.labelNotExpand = false,
    this.maxLine = 1,
    this.padding,
    this.minLine,
    this.textAlign,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.errorMessage,
    this.textStyle,
    this.textHintStyle,
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
    this.skipHeight = false,
    this.backgroundColor,
    this.labelIcon,
    this.textlabelStyle,
    this.isReadOnly = false,
    this.isPassword = false,
    this.inputFormatters,
  });

  @override
  _WidgetAppInputLabelState createState() => _WidgetAppInputLabelState();
}

class _WidgetAppInputLabelState extends State<WidgetAppInputLabel> {
  late FocusNode focusNode;
  late TextEditingController controller;
  late bool _isObscureText = widget.isPassword ? true : widget.obscureText;
  final ValueNotifier<int> length = ValueNotifier(0);

  @override
  void dispose() {
    super.dispose();
    length.dispose();
  }

  @override
  void didUpdateWidget(covariant WidgetAppInputLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller?.text != null &&
        widget.controller?.text != controller.text) {
      controller.text = widget.controller!.text;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    length.value = controller.text.length;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.labelNotExpand)
                Text(
                  widget.label.tr(),
                  style: widget.textlabelStyle ??
                      w300TextStyle(fontSize: 14.sw, color: appColorLabel),
                )
              else
                Expanded(
                  child: Text(
                    widget.label.tr(),
                    style: widget.textlabelStyle ??
                        w300TextStyle(fontSize: 14.sw, color: appColorLabel),
                  ),
                ),
              if (widget.labelIcon != null)
                widget.labelIcon!
              else if (widget.maxLength != null)
                ValueListenableBuilder<int>(
                  valueListenable: length,
                  builder: (context, value, child) => Text(
                    '$value/${widget.maxLength}',
                    style: w300TextStyle(
                        fontSize: fs14(), color: appColorText.withOpacity(.4)),
                  ),
                ),
            ],
          ),
          Gap(8.sw),
          WidgetInkWellTransparent(
            onTap: () {
              focusNode.requestFocus();
            },
            child: Container(
              alignment: widget.height != null
                  ? Alignment.topLeft
                  : Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: widget.backgroundColor ?? hexColor('#FAFAFA'),
                  borderRadius: BorderRadius.circular(16.sw)),
              height: widget.skipHeight ? null : (widget.height ?? 50.sw8),
              padding: EdgeInsets.symmetric(
                  horizontal: 16.sw,
                  vertical: widget.height != null ? 20.sw : 0),
              child: Row(
                children: [
                  if (widget.prefixIcon != null) widget.prefixIcon!,
                  Expanded(
                    child: TextField(
                      inputFormatters: widget.inputFormatters,
                      maxLength: widget.maxLength,
                      onChanged: (value) {
                        length.value = value.length;
                        widget.onChanged?.call(value);
                      },
                      readOnly: widget.isReadOnly,
                      minLines: widget.minLine,
                      maxLines: widget.maxLine,
                      autofocus: widget.autofocus,
                      keyboardType: widget.inputType,
                      focusNode: focusNode,
                      obscureText: _isObscureText,
                      enabled: widget.enable,
                      controller: controller,
                      onSubmitted: (_) {
                        if (widget.next != null) {
                          widget.next!.requestFocus();
                        } else if (widget.onSubmitted != null) {
                          widget.onSubmitted?.call(_);
                        }
                      },
                      textAlign: widget.textAlign ?? TextAlign.left,
                      style:
                          (widget.textStyle ?? w400TextStyle(fontSize: 16.sw))
                              .copyWith(
                                  color: !widget.enable ? appColorLabel : null),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        counterText: '',
                        counter: null,
                        hintText: widget.hint,
                        hintStyle: widget.textHintStyle ??
                            w300TextStyle(
                                color: hexColor('#D9DCE2'), fontSize: 16.sw),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (widget.isPassword && widget.suffixIcon == null) ...[
                    SizedBox(width: 8.sw),
                    _buildSufixPassword(),
                  ],
                  if (widget.suffixIcon != null) widget.suffixIcon!,
                ],
              ),
            ),
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

  Widget _buildSufixPassword() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _isObscureText = !_isObscureText;
          setState(() {});
        },
        child: Ink(
          width: 24,
          height: 24,
          child: Center(
            child: WidgetAppSVG(
              'assets/images/svg/ic_hide.svg',
              width: 24.spw,
              color: AppColors.instance.gray1,
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetInputLabel extends StatefulWidget {
  final String label;
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
  final TextStyle? textStyle;
  final TextStyle? textHintStyle;
  final TextInputType? inputType;
  final bool isVerified;
  final String? errorMessage;
  final double? height;
  final bool skipHeight;
  final EdgeInsets? contentPadding;
  final Widget? customSuffitIcon;
  final int? maxLength;
  final int? maxLine;
  final int? minLine;
  final TextAlign? textAlign;
  final EdgeInsets? padding;

  const WidgetInputLabel({
    super.key,
    required this.label,
    this.maxLine = 1,
    this.padding,
    this.minLine,
    this.textAlign,
    this.maxLength,
    this.customSuffitIcon,
    this.fillColor,
    this.errorMessage,
    this.textStyle,
    this.textHintStyle,
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
    this.skipHeight = false,
  });

  @override
  _WidgetInputLabelState createState() => _WidgetInputLabelState();
}

class _WidgetInputLabelState extends State<WidgetInputLabel> {
  late FocusNode focusNode;
  late TextEditingController controller;

  @override
  void didUpdateWidget(covariant WidgetInputLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller?.text != null) {
      controller.text = widget.controller!.text;
    }
  }

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
            clipBehavior: Clip.none,
            alignment: Alignment.centerRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius ??
                      BorderRadius.circular(kborderRadius),
                  border: Border.all(
                      color: widget.errorMessage != null
                          ? redCircle
                          : hexColor('#EBEDF3')),
                ),
                padding: widget.padding ?? const EdgeInsets.only(top: 6),
                child: SizedBox(
                  height: widget.skipHeight ? null : (widget.height ?? 30),
                  child: Center(
                    child: TextFormField(
                      minLines: widget.minLine,
                      maxLines: widget.maxLine,
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
                      textAlign: widget.textAlign ?? TextAlign.left,
                      style: widget.textStyle ?? w500TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                          counter: const SizedBox(),
                          isCollapsed: true,
                          hintText: widget.hint,
                          hintStyle: widget.textHintStyle ??
                              w300TextStyle(
                                  color: hexColor('#D9DCE2'), fontSize: 16),
                          border: InputBorder.none,
                          contentPadding: widget.contentPadding ??
                              const EdgeInsets.symmetric(horizontal: 16)),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -8,
                left: 12,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.instance.appBackground,
                      borderRadius: BorderRadius.circular(4)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Text(
                    widget.label,
                    style: w300TextStyle(
                        fontSize: 10,
                        color: widget.errorMessage != null
                            ? redCircle
                            : hexColor('#B4BCCE')),
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

int toHourIntTime(String x, isAM) {
  int value = int.parse(x);
  return (value + (isAM ? 0 : 12)) == 24 ? 0 : (value + (isAM ? 0 : 12));
}

InputBorder get bordertransparent =>
    const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

class WidgetInputTimeOfDayS extends StatefulWidget {
  final ValueNotifier<bool> isValidTimeValue;
  final ValueNotifier<bool> timeIsAMValue;
  final ValueNotifier<TimeOfDayS> timeValue;
  final bool border;
  final onChanged;
  const WidgetInputTimeOfDayS({
    super.key,
    required this.border,
    required this.onChanged,
    required this.isValidTimeValue,
    required this.timeIsAMValue,
    required this.timeValue,
  });

  @override
  State<WidgetInputTimeOfDayS> createState() => _WidgetInputTimeOfDaySState();
}

class _WidgetInputTimeOfDaySState extends State<WidgetInputTimeOfDayS> {
  late MaskedTextController c = MaskedTextController(
      mask: '00:00:00',
      text:
          '${requestZeroFirstText(widget.timeValue.value.hour - (!AppPrefs.instance.is24HFormat && widget.timeValue.value.hour > 12 ? 12 : 0))}:${requestZeroFirstText(widget.timeValue.value.minute)}:${requestZeroFirstText(widget.timeValue.value.seconds)}');
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: widget.isValidTimeValue,
        builder: (context, value, child) {
          Color color = !widget.border
              ? Colors.black12
              : value
                  ? appColorPrimary1
                  : hexColor('#FD0092');
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: AppColors.instance.lightBlue,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: color, width: 1)),
            child: Row(
              children: [
                SizedBox(
                  height: 34,
                  width: 90,
                  child: Center(
                    child: TextField(
                      onChanged: (_) {
                        if (_.length == 8) {
                          widget.timeValue.value = TimeOfDayS(
                              hour: toHourIntTime(
                                  _.split(':').first,
                                  AppPrefs.instance.is24HFormat
                                      ? true
                                      : widget.timeIsAMValue.value),
                              minute: int.parse(_.split(':')[1]),
                              seconds: int.parse(
                                _.split(':').last,
                              ));
                          widget.onChanged(_);
                        } else {
                          widget.isValidTimeValue.value = true;
                        }
                      },
                      controller: c,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      style: w700TextStyle(),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          border: bordertransparent,
                          enabledBorder: bordertransparent,
                          focusedBorder: bordertransparent),
                    ),
                  ),
                ),
                Container(
                  color: color,
                  width: 1,
                  height: 34,
                ),
                if (!AppPrefs.instance.is24HFormat)
                  ValueListenableBuilder<bool>(
                      valueListenable: widget.timeIsAMValue,
                      builder: (context, value, child) {
                        return Container(
                          width: 36,
                          height: 34,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(4))),
                          child: Column(
                            children: value
                                ? [
                                    Container(
                                      width: 36,
                                      height: 17,
                                      color: color,
                                      child: Center(
                                        child: Text(
                                          'AM',
                                          style: w500TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    WidgetInkWellTransparent(
                                      onTap: () {
                                        widget.timeIsAMValue.value = false;
                                        widget.timeValue.value = TimeOfDayS(
                                            hour: toHourIntTime(
                                                c.text.split(':').first,
                                                widget.timeIsAMValue.value),
                                            minute:
                                                int.parse(c.text.split(':')[1]),
                                            seconds: int.parse(
                                                c.text.split(':').last));
                                        widget.onChanged('');
                                      },
                                      child: Container(
                                        width: 36,
                                        height: 17,
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            'PM',
                                            style: w500TextStyle(
                                                color: color, fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    WidgetInkWellTransparent(
                                      onTap: () {
                                        widget.timeIsAMValue.value = true;
                                        widget.timeValue.value = TimeOfDayS(
                                            hour: toHourIntTime(
                                                c.text.split(':').first,
                                                widget.timeIsAMValue.value),
                                            minute:
                                                int.parse(c.text.split(':')[1]),
                                            seconds: int.parse(
                                                c.text.split(':').last));
                                        widget.onChanged('');
                                      },
                                      child: Container(
                                        width: 36,
                                        height: 17,
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            'AM',
                                            style: w500TextStyle(
                                                color: color, fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 36,
                                      height: 17,
                                      color: color,
                                      child: Center(
                                        child: Text(
                                          'PM',
                                          style: w500TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                          ),
                        );
                      })
                else
                  Container(
                    width: 36,
                    height: 34,
                    color: color,
                    child: Center(
                      child: Text(
                        '24h',
                        style: w500TextStyle()
                            .copyWith(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}

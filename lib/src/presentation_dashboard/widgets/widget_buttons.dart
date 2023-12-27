import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:temp_package_name/src/constants/constants.dart';

class WidgetIconText extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final String label;
  final double height;
  const WidgetIconText({
    super.key,
    required this.height,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetRippleButton(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: appColorText,
              size: 20,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              label,
              style: w500TextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetButtonMore extends StatelessWidget {
  final Function(GlobalKey key) onTap;
  final double size;
  final IconData? icon;
  WidgetButtonMore({
    super.key,
    required this.onTap,
    this.icon,
    this.size = 24,
  });

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _key,
      onTap: () {
        onTap(_key);
      },
      child: Icon(
        icon ?? Icons.menu_rounded,
        size: size,
        color: appColorTextHint,
      ),
    );
  }
}

class WidgetTopButtonOutline extends StatelessWidget {
  final Function()? onTap;
  final String label;
  final EdgeInsets? margin;
  const WidgetTopButtonOutline({
    super.key,
    required this.label,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: AppColors.instance.appBackground,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(kborderRadiusTopButton),
          child: Container(
            height: 48.sw8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kborderRadiusTopButton),
                border: Border.all(
                    color: kborderColorTopButton,
                    width: kborderWidthTopButton)),
            alignment: Alignment.center,
            child: Text(
              label,
              style: w500TextStyle(
                  fontSize: 16, color: AppColors.instance.buttonTopLabelColor),
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetTopButtonFilledBack extends StatelessWidget {
  final Function()? onTap;
  const WidgetTopButtonFilledBack({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return WidgetTopButtonFilled(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chevron_left,
            color: appColorText,
            size: 24,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'back'.tr(),
            style: w500TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class WidgetTopButtonFilled extends StatelessWidget {
  final Function()? onTap;
  final String? label;
  final EdgeInsets? margin;
  final Widget? child;
  final double? width;
  const WidgetTopButtonFilled({
    super.key,
    this.label,
    this.width,
    this.child,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: AppColors.instance.appBackground,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(kborderRadiusTopButton),
          child: Container(
            width: width,
            height: 48.sw8,
            decoration: BoxDecoration(
                color: kfillColorTopButton,
                borderRadius: BorderRadius.circular(kborderRadiusTopButton),
                border: Border.all(
                    color: kborderColorTopButtonFilled,
                    width: kborderWidthTopButton)),
            padding: const EdgeInsets.symmetric(horizontal: 32),
            alignment: Alignment.center,
            child: child ??
                Text(
                  label ?? "",
                  style: w500TextStyle(
                      fontSize: 16,
                      color: AppColors.instance.buttonTopLabelColor),
                ),
          ),
        ),
      ),
    );
  }
}

class WidgetButtonNO extends StatelessWidget {
  final Function()? onTap;
  final double? width;
  final String? label;
  const WidgetButtonNO({
    super.key,
    this.label,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetRippleButton(
      radius: 16.sw,
      color: Colors.white,
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
      child: Container(
        width: width,
        height: 48.sw8,
        padding: EdgeInsets.symmetric(horizontal: width != null ? 16 : 46),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.sw),
          border: Border.all(
            color: hexColor('#E2E1E3'),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label ?? 'No',
          style: w500TextStyle(fontSize: 16.sw),
        ),
      ),
    );
  }
}

class WidgetButtonOK extends StatelessWidget {
  final Function()? onTap;
  final bool enable;
  final bool loading;
  final String? label;
  final double? width;
  final Color? color;
  const WidgetButtonOK({
    super.key,
    this.color,
    this.onTap,
    this.enable = true,
    this.loading = false,
    this.label,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetRippleButton(
      onTap: enable ? onTap : null,
      radius: 16.sw,
      color: !enable ? hexColor("C6C5C8") : (color ?? appColorPrimary1),
      child: Container(
        height: 48.sw8,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: width != null ? 16 : 46),
        alignment: Alignment.center,
        child: Stack(alignment: Alignment.center, children: [
          if (loading) WidgetLoadingCupertino(size: 12.sw),
          Opacity(
            opacity: !loading ? 1 : 0,
            child: Text(
              label ?? 'Yes',
              style: w500TextStyle(color: Colors.white, fontSize: 16.sw),
            ),
          )
        ]),
      ),
    );
  }
}

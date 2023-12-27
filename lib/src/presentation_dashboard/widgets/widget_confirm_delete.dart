import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:_private_core/_private_core.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_buttons.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_container_home.dart';

class WidgetConfirmDelete extends StatelessWidget {
  final String? item;
  final String? title;
  final TextStyle? contentStyle;

  final Widget? childBuilder;

  const WidgetConfirmDelete({
    super.key,
    this.title,
    this.item,
    this.contentStyle,
    this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    double width = 360;
    return WidgetBaseDialog(
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (childBuilder != null)
              childBuilder!
            else ...[
              WidgetTitleDialog(
                title!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Text(
                  item!,
                  textAlign: TextAlign.center,
                  style: contentStyle ?? w500TextStyle(),
                ),
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WidgetButtonNO(
                  width: (width - WidgetBaseDialog.horizontalPadding) / 2,
                ),
                WidgetButtonOK(
                  onTap: () {
                    context.pop(true);
                  },
                  color: hexColor('#FF345B'),
                  width: (width - WidgetBaseDialog.horizontalPadding) / 2,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

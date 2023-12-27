import 'package:_private_core/utils/styles.dart';
import 'package:_private_core/utils/utils.dart';
import 'package:_private_core/widgets/widget_overlay_actions.dart';
import 'package:flutter/material.dart';
import 'package:_private_core/widgets/widget_app_svg.dart';
import 'package:temp_package_name/src/constants/constants.dart';

import 'widget_popup_container.dart';

class WidgetNoteInfos extends StatelessWidget {
  final Color? color;
  final double width;
  final double height;
  final String? msg;
  const WidgetNoteInfos(
      {super.key,
      this.color,
      required this.width,
      required this.height,
      this.msg});

  @override
  Widget build(BuildContext context) {
    return WidgetOverlayActions(
      duration: const Duration(milliseconds: 50),
      builder: (child, size, childPosition, rightClickPosition, animationValue,
          hide, context) {
        return Positioned(
          left: childPosition.dx - width + 20 + 22 / 2 + size.width / 2,
          top: childPosition.dy - size.height - 8 - height,
          child: SizedBox(
            height: (height + 10) * animationValue,
            child: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: width,
                    height: height,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: color ?? hexColor('#7A838C'),
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        msg ?? '',
                        style: w300TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: WidgetTrianglePopup(
                      isUpDirection: false,
                      color: color ?? hexColor('#7A838C'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: WidgetAppSVG(
        assetsvg('ic_info'),
        width: 24,
        color: AppColors.instance.gray1,
      ),
    );
  }
}

import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:temp_package_name/src/constants/constants.dart';

import 'widget_app_inkwell.dart';

class WidgetPaginateTable extends StatelessWidget {
  final int currentPage;
  final int currentRow;
  final Function() onPrePressed;
  final Function() onNextPressed;
  final Function(int) onChangedRow;
  final bool isEnableNext;

  const WidgetPaginateTable(
      {super.key,
      this.isEnableNext = false,
      required this.currentPage,
      required this.currentRow,
      required this.onPrePressed,
      required this.onNextPressed,
      required this.onChangedRow});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: hexColor('#EBEBEB')),
              borderRadius: BorderRadius.circular(16.sw)),
          child: SizedBox(
            height: 42.sw,
            child: Row(
              children: [
                WidgetInkWellTransparent(
                    onTap: currentPage == 1 ? null : onPrePressed,
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_left,
                        color:
                            currentPage == 1 ? appColorTextHint : appColorText,
                      ),
                    )),
                Text(
                  '${'Page'.tr()} $currentPage',
                  style: w300TextStyle(),
                ),
                WidgetInkWellTransparent(
                  onTap: isEnableNext ? onNextPressed : null,
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_right,
                      color: !isEnableNext ? appColorTextHint : appColorText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.sw),
        WidgetOverlayActions(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: hexColor('#EBEBEB')),
                borderRadius: BorderRadius.circular(16.sw)),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            height: 42,
            child: Row(
              children: [
                Text(
                  '$currentRow ${'rows'.tr()}',
                  style: w300TextStyle(),
                ),
                Icon(Icons.arrow_drop_down, color: appColorText),
              ],
            ),
          ),
          builder: (Widget child,
              Size size,
              Offset position,
              rightClickPosition,
              double animationValue,
              Function hide,
              context) {
            return Positioned(
              left: position.dx,
              top: position.dy - (30 * 5 + 22) - 8,
              child: Transform.scale(
                scale: animationValue,
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: size.width,
                  height: (30 * 5 + 22),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: appColorText.withOpacity(.1),
                        offset: const Offset(0, 0),
                        spreadRadius: 1,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [10, 20, 30, 40, 50]
                          .map(
                            (e) => WidgetAppInkWell(
                              onTap: () {
                                hide();
                                onChangedRow(e);
                              },
                              child: Container(
                                width: size.width,
                                height: 30,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '$e ${'rows'.tr()}',
                                  style: w300TextStyle(),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

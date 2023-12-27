import 'package:_private_core/widgets/widgets.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import 'package:_private_core/_private_core.dart';
import 'package:temp_package_name/src/constants/constants.dart';

import 'homelido_popup_content.dart';

class WidgetDatePickerPopup extends StatelessWidget {
  final ValueChanged<List<DateTime?>>? onValueChanged;
  final List<DateTime?>? initialValue;
  final Widget child;
  final dynamic inkwellBorderRadius;
  final DateTime? firstDate;
  final DateTime? lastDate;
  const WidgetDatePickerPopup({
    super.key,
    required this.child,
    this.onValueChanged,
    this.initialValue,
    this.inkwellBorderRadius,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetOverlayActions(
      inkwellBorderRadius: inkwellBorderRadius ?? 99,
      builder: (child, size, childPosition, pointerPosition, animationValue,
          hide, context) {
        return Positioned(
          left: childPosition.dx,
          top: childPosition.dy + size.height + 12,
          child: HomelidoPopupContent(
            arrowAlignment: ArrowAlignment.left2,
            width: 330,
            height: 330,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                firstDate: firstDate,
                lastDate: lastDate,
                selectedYearTextStyle:
                    w400TextStyle(fontSize: 14, color: Colors.white),
                yearTextStyle: w400TextStyle(
                  fontSize: 14,
                ),
                weekdayLabelTextStyle: w500TextStyle(fontSize: 14),
                selectedDayTextStyle:
                    w400TextStyle(fontSize: 14, color: Colors.white),
                selectedDayHighlightColor: appColorPrimary1,
                dayTextStyle: w400TextStyle(
                  fontSize: 14,
                ),
                todayTextStyle:
                    w400TextStyle(fontSize: 14, color: appColorPrimary1),
                calendarType: CalendarDatePicker2Type.single,
              ),
              value: initialValue ?? [],
              onValueChanged: (value) {
                hide();
                onValueChanged?.call(value);
              },
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class WidgetYearPickerPopup extends StatelessWidget {
  final ValueChanged<int>? onValueChanged;
  final int? initialValue;
  final int minValue;
  final int maxValue;
  final Widget child;
  const WidgetYearPickerPopup(
      {super.key,
      required this.child,
      this.onValueChanged,
      this.initialValue,
      required this.minValue,
      required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return WidgetOverlayActions(
      child: child,
      builder: (child, size, childPosition, pointerPosition, animationValue,
          hide, context) {
        return Positioned(
          left: childPosition.dx,
          top: childPosition.dy + size.height + 12,
          child: HomelidoPopupContent(
              arrowAlignment: ArrowAlignment.left2,
              width: 330,
              height: 330,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Material(
                  color: Colors.transparent,
                  child: GridView.builder(
                    itemCount: maxValue - minValue,
                    itemBuilder: (context, index) {
                      int value = maxValue - index;
                      bool selected = initialValue == value;
                      return Center(
                        child: InkWell(
                          onTap: () {
                            hide();
                            onValueChanged?.call(value);
                          },
                          borderRadius: BorderRadius.circular(99),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 24),
                            decoration: BoxDecoration(
                                color: selected
                                    ? appColorPrimary1
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(99)),
                            child: Text(
                              '$value',
                              style: w400TextStyle(
                                  fontSize: 14,
                                  color:
                                      !selected ? appColorText : Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 100 / 40),
                  ),
                ),
              )),
        );
      },
    );
  }
}

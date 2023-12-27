import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_popup_container.dart';

class WidgetSliderStepCustomizeVertical extends StatefulWidget {
  final int length;
  final String Function(int) labelByIndex;
  final int selected;
  final bool isEnableTooltip;
  final bool isEnableTooltipOnlyDrag;
  final bool isEnableDotStep;
  final ValueChanged<int> onChanged;
  final double height;
  const WidgetSliderStepCustomizeVertical({
    super.key,
    required this.length,
    required this.labelByIndex,
    required this.selected,
    this.isEnableTooltip = true,
    this.isEnableTooltipOnlyDrag = false,
    this.isEnableDotStep = true,
    required this.onChanged,
    required this.height,
  });

  @override
  State<WidgetSliderStepCustomizeVertical> createState() =>
      _WidgetSliderStepCustomizeVerticalState();
}

class _WidgetSliderStepCustomizeVerticalState
    extends State<WidgetSliderStepCustomizeVertical> {
  late int selected = widget.selected;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      selected = widget.selected;
    });
  }

  @override
  void didUpdateWidget(covariant WidgetSliderStepCustomizeVertical oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      selected = widget.selected;
    });
  }

  Widget buildPoint(index) {
    return PortalTarget(
      visible: (widget.isEnableTooltipOnlyDrag
              ? _draging
              : widget.isEnableTooltip) &&
          index == selected,
      anchor: const Aligned(
          follower: Alignment.bottomCenter,
          target: Alignment.topCenter,
          offset: Offset(0, -12)),
      portalFollower: WidgetPopupContainer(
        borderRadius: BorderRadius.circular(8.sw),
        alignmentTail: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(vertical: 10.sw, horizontal: 12.sw),
        child: Text(
          widget.labelByIndex(index),
          style: w500TextStyle(
            fontSize: 14.sw,
          ),
        ),
      ),
      child: Container(
        width: 12.sw,
        height: 12.sw,
        decoration: widget.isEnableDotStep || index == selected
            ? ShapeDecoration(
                gradient: index > selected
                    ? LinearGradient(
                        colors: [hexColor('#D1D1D1'), hexColor('#D1D1D1')])
                    : const LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFF007D89), Color(0xFF16BECE)],
                      ),
                shape: OvalBorder(
                  side: BorderSide(
                    width: 3.sw,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Colors.white,
                  ),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x19000000),
                    blurRadius: 4.sw,
                    offset: Offset(0, 2.sw),
                    spreadRadius: 2.sw,
                  )
                ],
              )
            : const BoxDecoration(),
      ),
    );
  }

  late double maxHeight;
  @override
  Widget build(BuildContext context) {
    maxHeight = widget.height;
    return SizedBox(
      height: maxHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 5.sw,
            height: maxHeight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: hexColor('#F0F2F5')),
          ),
          Container(
            height: maxHeight * (selected / (widget.length - 1)),
            width: 5.sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF007D89), Color(0xFF16BECE)],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.length,
                (index) => buildPoint(widget.length - 1 - index)),
          ),
          GestureDetector(
            onTapDown: (details) {
              appHaptic();
            },
            onVerticalDragStart: _onVerticalDragStart,
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragDown: (_) {
              appHaptic();
            },
            onVerticalDragCancel: () {
              setState(() {
                _draging = false;
              });
            },
            onVerticalDragEnd: (details) {
              setState(() {
                _draging = false;
              });
            },
            dragStartBehavior: DragStartBehavior.start, // default
            behavior: HitTestBehavior.translucent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  widget.length, (index) => _selectZone(widget.length - index)),
            ),
          )
        ],
      ),
    );
  }

  bool _draging = false;
  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _draging = true;
    });
    double dy = details.localPosition.dy;
    _checkPosition(dy);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _draging = true;
    });
    double dy = details.localPosition.dy;
    _checkPosition(dy);
  }

  _checkPosition(dy) {
    setState(() {
      double heightItem = maxHeight / (widget.length - 1);
      for (var i = widget.length - 1; i >= 0; i--) {
        if (i == widget.length - 1) {
          if (dy < heightItem / 2) {
            if (selected != widget.length - 1) {
              appHaptic();
              selected = widget.length - 1;
              widget.onChanged(selected);
            }
            break;
          }
        } else if (i != 0) {
          if (dy < heightItem / 2 + heightItem * (widget.length - i - 1)) {
            if (selected != i) {
              appHaptic();
              selected = i;
              widget.onChanged(selected);
            }
            break;
          }
        } else {
          if (selected != 0) {
            appHaptic();
            selected = 0;
            widget.onChanged(selected);
          }
          break;
        }
      }
    });
  }

  Widget _selectZone(index) {
    double heightItem = maxHeight / (widget.length - 1);
    return WidgetInkWellTransparent(
      onTap: () {
        appHaptic();
        setState(() {
          selected = index - 1;
          widget.onChanged(selected);
        });
      },
      child: SizedBox(
        height:
            index == 1 || index == widget.length ? heightItem / 2 : heightItem,
        width: 32.sw,
      ),
    );
  }
}

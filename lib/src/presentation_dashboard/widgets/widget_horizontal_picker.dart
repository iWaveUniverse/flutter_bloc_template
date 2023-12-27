import 'dart:async';

import 'package:_private_core/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:infinite_listview/infinite_listview.dart';

typedef TextMapper = String Function(String numberText);
typedef HorizontalPickerItemBuilder = Widget Function(
    BuildContext context, int index, bool isSelected);
typedef HorizontalPickerAroundBuilder<T> = Widget Function(
    BuildContext context, int index, T value);

@immutable
class WidgetHorizontalPicker<T> extends StatefulWidget {
  final HorizontalPickerItemBuilder itemBuilder;
  final List<T> data;
  final HorizontalPickerAroundBuilder? bottomBuilder;
  final HorizontalPickerAroundBuilder? topBuilder;
  final ValueChanged<int> onChanged;
  final int itemCountShown;
  final double itemHeight;
  final double itemWidth;
  final bool haptics;
  final bool infiniteLoop;
  final Duration selectedTimeDelay;

  int? value;

  WidgetHorizontalPicker(
      {super.key,
      required this.itemBuilder,
      required this.onChanged,
      required this.data,
      int? initIndex = 0,
      this.topBuilder,
      this.bottomBuilder,
      this.itemCountShown = 3,
      this.itemHeight = 150,
      this.itemWidth = 100,
      this.haptics = false,
      this.infiniteLoop = false,
      this.selectedTimeDelay = const Duration(milliseconds: 500)}) {
    value = initIndex;
  }

  @override
  WidgetHorizontalPickerState createState() => WidgetHorizontalPickerState();
}

class WidgetHorizontalPickerState extends State<WidgetHorizontalPicker>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  Timer? _timer;
  late int _oldSlectedValue;
  bool animatingTo = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _oldSlectedValue = widget.value!;
    final initialOffset = widget.value! * widget.itemWidth;
    if (widget.infiniteLoop) {
      _scrollController =
          InfiniteScrollController(initialScrollOffset: initialOffset);
    } else {
      _scrollController = ScrollController(initialScrollOffset: initialOffset);
    }
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (animatingTo) return;
    var indexOfMiddleElement = (_scrollController.offset / itemExtent).round();
    if (widget.infiniteLoop) {
      indexOfMiddleElement %= itemCount;
    } else {
      indexOfMiddleElement = indexOfMiddleElement.clamp(0, itemCount - 1);
    }
    final intValueInTheMiddle =
        _intValueFromIndex(indexOfMiddleElement + additionalItemsOnEachSide);
    if (widget.value != intValueInTheMiddle) {
      widget.value = intValueInTheMiddle;
      if (widget.haptics) HapticFeedback.selectionClick();
    }
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _maybeCenterValue(),
    );
  }

  @override
  void didUpdateWidget(WidgetHorizontalPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _maybeCenterValue();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  bool get isScrolling => _scrollController.position.isScrollingNotifier.value;

  double get itemExtent => widget.itemWidth;

  int get itemCount => widget.data.length;

  int get listItemsCount => itemCount + 2 * additionalItemsOnEachSide;

  int get additionalItemsOnEachSide => (widget.itemCountShown - 1) ~/ 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.topBuilder != null)
          widget.topBuilder!(
              context, widget.value!, widget.data[widget.value!]),
        SizedBox(
          width: widget.itemCountShown * widget.itemWidth,
          height: widget.itemHeight,
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (not) {
              if (not.dragDetails?.primaryVelocity == 0) {
                Future.microtask(() => _maybeCenterValue());
              }
              return true;
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.infiniteLoop)
                  InfiniteListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController as InfiniteScrollController,
                      itemExtent: itemExtent,
                      itemBuilder: _itemBuilder,
                      padding: EdgeInsets.zero)
                else
                  ListView.builder(
                    itemCount: listItemsCount,
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemExtent: itemExtent,
                    itemBuilder: _itemBuilder,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
        ),
        if (widget.bottomBuilder != null)
          widget.bottomBuilder!(
              context, widget.value!, widget.data[widget.value!]),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final value = _intValueFromIndex(index % itemCount);
    final isExtra = !widget.infiniteLoop &&
        (index < additionalItemsOnEachSide ||
            index >= listItemsCount - additionalItemsOnEachSide);
    final isSelected = value == widget.value;

    if (isExtra) return const SizedBox.shrink();
    return WidgetInkWellTransparent( 
      onTap: () {
        if (!isSelected) {
          setState(() {
            widget.value = value;
          });
        }
        _maybeCenterValue(select: true);
      },
      child: widget.itemBuilder(context, value, isSelected),
    );
  }

  int _intValueFromIndex(int index) {
    index -= additionalItemsOnEachSide;
    index %= itemCount;
    return index;
  }

  void _maybeCenterValue({bool select = false}) {
    if (_scrollController.hasClients && !isScrolling) {
      int index = widget
          .value!; //widget.startDate.addDate(widget.value!).dateDifference(widget.startDate);
      animatingTo = true;
      _scrollController
          .animateTo(
        index * itemExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      )
          .then((value) {
        animatingTo = false;
      });
      _timer?.cancel();
      if (select || widget.selectedTimeDelay.inSeconds == 0) {
        if (_oldSlectedValue != widget.value) {
          setState(() {
            widget.onChanged(widget.value!);
            _oldSlectedValue = widget.value!;
          });
        }
      }
      if (!select && widget.selectedTimeDelay.inSeconds > 0) {
        _timer = Timer(widget.selectedTimeDelay, () {
          _scrollController.animateTo(
            _oldSlectedValue * itemExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        });
      }
    }
  }
}

import 'package:flutter/material.dart';

class WidgetHoverBuilder extends StatefulWidget {
  final Widget Function(bool isHover) builder;
  const WidgetHoverBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<WidgetHoverBuilder> createState() => _WidgetHoverBuilderState();
}

class _WidgetHoverBuilderState extends State<WidgetHoverBuilder> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (details) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (details) => setState(() {
        setState(() {
          isHover = false;
        });
      }),
      child: widget.builder(isHover),
    );
  }
}

import 'package:_private_core/_private_core.dart';
import 'package:flutter/material.dart';

class WidgetAppInkWell extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const WidgetAppInkWell({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: hexColor('FAFAFA'),
        child: child,
      ),
    );
  }
}

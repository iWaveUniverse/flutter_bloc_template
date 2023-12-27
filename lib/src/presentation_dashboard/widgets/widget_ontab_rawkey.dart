import 'dart:async';
 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetOnTabRawKey extends StatelessWidget {
  final Widget child;
  final VoidCallback onKey;
  const WidgetOnTabRawKey({
    super.key,
    required this.child,
    required this.onKey,
  });

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
          Timer(const Duration(milliseconds: 100), onKey);
        }
      },
      child: child,
    );
  }
}

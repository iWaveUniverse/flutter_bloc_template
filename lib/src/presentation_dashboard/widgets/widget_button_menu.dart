import 'package:flutter/material.dart';
import 'package:_private_core/_private_core.dart';

import '../../constants/constants.dart';

class ButtonMenuData {
  int value;
  IconData iconData;
  String label;
  ButtonMenuData(
      {required this.iconData, required this.label, required this.value});
}

dynamic onShowMenu({
  required List<ButtonMenuData> buttons,
  required context,
  required offset,
}) async {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  return await showMenu<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      items: buttons
          .map<PopupMenuEntry<int>>((e) => PopupMenuItem(
              value: e.value,
              padding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
              child: Row(
                children: [
                  Icon(
                    e.iconData,
                    size: 14,
                    color: appColorTextHint,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    e.label,
                    style: w500TextStyle(fontSize: 10, color: appColorTextHint),
                  ),
                ],
              )))
          .toList(),
      position:
          RelativeRect.fromSize(offset & const Size(48.0, 48.0), overlay.size));
}

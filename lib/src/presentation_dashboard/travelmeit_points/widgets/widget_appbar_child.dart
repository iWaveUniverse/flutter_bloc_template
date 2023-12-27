import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_package_name/src/constants/app_colors.dart';
import 'package:temp_package_name/src/constants/app_styles.dart';

import '../bloc/point_interests_bloc.dart';

class WidgetTravelmeitPointAppBarChild extends StatelessWidget {
  const WidgetTravelmeitPointAppBarChild({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelmeitPointsBloc, TravelmeitPointsState>(
        bloc: travelmeitPointsBloc,
        builder: (context, state) {
          return Row(
            children: [
              SizedBox(
                width: 32.sw,
              ),
              WidgetInkWellTransparent(
                  onTap: () {
                    travelmeitPointsBloc
                        .add(const SelectTravelmeitPointsEvent());
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
                    child: Text(
                      "List".tr(),
                      style: state.isPointDetailView
                          ? w400TextStyle(
                              fontSize: 16.sw, color: hexColor('9499AD'))
                          : w700TextStyle(
                              fontSize: 16.sw, color: appColorPrimary1),
                    ),
                  )),
              WidgetInkWellTransparent(
                  onTap: () {
                    travelmeitPointsBloc
                        .add(SelectTravelmeitPointsEvent(state.itemSelected));
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
                    child: Text(
                      "Spot".tr(),
                      style: !state.isPointDetailView
                          ? w400TextStyle(
                              fontSize: 16.sw, color: hexColor('9499AD'))
                          : w700TextStyle(
                              fontSize: 16.sw, color: appColorPrimary1),
                    ),
                  ))
            ],
          );
        });
  }
}

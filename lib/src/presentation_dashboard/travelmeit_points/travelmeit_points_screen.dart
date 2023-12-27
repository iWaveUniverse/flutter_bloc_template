import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/presentation/travelmeit_points/bloc/point_interests_bloc.dart';
import 'package:temp_package_name/src/presentation/travelmeit_points/widgets/widget_point_detail.dart';
import '../travelmeit_tours/bloc/travelmeit_tours_bloc.dart';
import 'widgets/widget_body.dart';
import 'widgets/widget_left_menu.dart';

class TravelmeitPointsScreen extends StatefulWidget {
  const TravelmeitPointsScreen({super.key});

  @override
  State<TravelmeitPointsScreen> createState() => _TravelmeitPointsScreenState();
}

class _TravelmeitPointsScreenState extends State<TravelmeitPointsScreen> {
  @override
  void initState() {
    super.initState();
    travelmeitPointsBloc.add(InitTravelmeitPointsEvent());
    travelmeitToursBloc.add(InitTravelmeitToursEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelmeitPointsBloc, TravelmeitPointsState>(
      bloc: travelmeitPointsBloc,
      builder: (context, state) {
        if (state.isPointDetailView) {
          return WidgetDetailPoint(m: state.itemSelected!);
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.sw, horizontal: 24.sw),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const WidgetLeftMenu(), Gap(24.sw), const WidgetBody()],
          ),
        );
      },
    );
  }
}

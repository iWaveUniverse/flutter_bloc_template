import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_interest.dart';
import 'package:temp_package_name/src/network_resources/points/repo.dart';
import 'package:temp_package_name/src/presentation/travelmeit_points/bloc/point_interests_bloc.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_app_switcher.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_paginate_table.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_row_value.dart';
import 'package:temp_package_name/src/utils/utils.dart';

class WidgetBody extends StatelessWidget {
  const WidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TravelmeitPointsBloc, TravelmeitPointsState>(
        bloc: travelmeitPointsBloc,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: WidgetTableContainer(
                  header: Row(
                    children: [
                      WidgetRowValue.label(value: 'Picture'.tr(), flex: 1),
                      WidgetRowValue.label(value: 'Title'.tr(), flex: 2),
                      WidgetRowValue.label(value: 'Country'.tr(), flex: 1),
                      WidgetRowValue.label(value: 'City'.tr(), flex: 1),
                      WidgetRowValue.label(value: 'Custom cat'.tr(), flex: 1),
                      WidgetRowValue.label(value: 'Importance'.tr(), flex: 1),
                      WidgetRowValue.label(value: 'Display'.tr(), flex: 1),
                    ],
                  ),
                  data: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, index) {
                      if (state.isFetching || state.items == null) {
                        return _WidgetItemShimmer(index: index);
                      }
                      return _WidgetItem(
                        index: index,
                        m: state.items![index],
                      );
                    },
                    itemCount: state.isFetching || state.items == null
                        ? 8
                        : state.items!.length,
                  ),
                ),
              ),
              Gap(8.sw),
              Row(
                children: [
                  const Spacer(),
                  WidgetPaginateTable(
                    currentPage: state.page,
                    currentRow: state.pageSize,
                    isEnableNext: state.items?.length == state.pageSize,
                    onChangedRow: (rows) {
                      travelmeitPointsBloc.add(
                          FetchTravelmeitPointsEvent(page: 1, pageSize: rows));
                    },
                    onPrePressed: () {
                      travelmeitPointsBloc.add(
                          FetchTravelmeitPointsEvent(page: state.page - 1));
                    },
                    onNextPressed: () {
                      travelmeitPointsBloc.add(
                          FetchTravelmeitPointsEvent(page: state.page + 1));
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WidgetItemShimmer extends StatelessWidget {
  final int index;
  const _WidgetItemShimmer({required this.index});

  @override
  Widget build(BuildContext context) {
    return WidgetRowItem(
      index: index,
      child: Row(
        children: [
          WidgetRowValue(
            flex: 1,
            value: Row(
              children: [
                WidgetAppShimmer(
                  width: 28.sw,
                  height: 28.sw,
                  borderRadius: BorderRadius.circular(99),
                ),
                Gap(8.sw),
                WidgetAppShimmer(
                  width: 60.sw,
                  height: 16.sw,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
          const WidgetRowValueShimmer(flex: 2),
          const WidgetRowValueShimmer(flex: 1),
          const WidgetRowValueShimmer(flex: 1),
          const WidgetRowValueShimmer(flex: 1),
          const WidgetRowValueShimmer(flex: 1),
          const WidgetRowValueShimmer(flex: 1),
        ],
      ),
    );
  }
}

class _WidgetItem extends StatefulWidget {
  final int index;
  final dynamic m;
  const _WidgetItem({
    required this.index,
    this.m,
  });

  @override
  State<_WidgetItem> createState() => __WidgetItemState();
}

class __WidgetItemState extends State<_WidgetItem> {
  late PointInterest m = widget.m;

  _update(value) async {
    setState(() {
      m.display = value;
    });
    var r = await PointsRepo().updatePoiByAdmin({
      "id": m.id,
      "display": m.display,
    });
    if (r == true) {
      travelmeitPointsBloc.add(const FetchTravelmeitPointsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetRowItem(
      ignoringChild: false,
      onTap: () {
        travelmeitPointsBloc.add(SelectTravelmeitPointsEvent(m));
      },
      index: widget.index,
      child: Row(
        children: [
          WidgetRowValue(
            flex: 1,
            value: Align(
              alignment: Alignment.centerLeft,
              child: WidgetInkWellTransparent(
                onTap: () {
                  if (m.imageDisplaySmall != null || m.imageDisplay != null) {
                    pushWidget(
                        child: WidgetImagesViewer(
                            images: [m.imageDisplay ?? m.imageDisplaySmall]));
                  }
                },
                child: WidgetAppImage(
                  imageUrl: m.imageDisplaySmall,
                  placeholderWidget: const SizedBox(width: 100, height: 100),
                  width: 100,
                  radius: 4,
                ),
              ),
            ),
          ),
          WidgetRowValue(
            flex: 2,
            value: m.title ?? m.details?.title ?? "",
          ),
          WidgetRowValue(
              value: Row(
                children: [
                  WidgetAppFlag.countryCode(
                    countryCode: m.countryCode,
                    height: 20.sw,
                    radius: 4.sw,
                  ),
                  Gap(8.sw),
                  Expanded(
                    child: Text(
                      getCountryName(m.countryCode),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: w400TextStyle(
                          fontSize: fs12(),
                          height: 1.3,
                          color: hexColor('#9499AD')),
                    ),
                  )
                ],
              ),
              flex: 1),
          WidgetRowValue(
            flex: 1,
            value: m.cityName,
          ),
          WidgetRowValue(
              value: Row(
                children: [
                  m.customCategory != null
                      ? WidgetAppSVG(
                          'custom_cat_${m.customCategory!.id}',
                          width: 24.sw,
                          color: appColorText,
                        )
                      : Gap(8.sw),
                  Gap(8.sw),
                  Expanded(
                    child: Text(
                      m.customCategory?.label ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: w400TextStyle(
                          fontSize: fs12(),
                          height: 1.3,
                          color: hexColor('#9499AD')),
                    ),
                  )
                ],
              ),
              flex: 1),
          WidgetRowValue(value: getPopularFromRate(m.rate), flex: 1),
          WidgetRowValue(
              value: Row(
                children: [
                  WidgetAppSwitcher(
                    onToggle: (_) {
                      _update(_ ? 1 : 0);
                    },
                    value: m.display == 1,
                  ),
                  const Spacer()
                ],
              ),
              flex: 1),
        ],
      ),
    );
  }
}

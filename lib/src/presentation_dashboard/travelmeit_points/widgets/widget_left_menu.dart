import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:_private_core_network/network_resources/country/country_repo.dart';
import 'package:_private_core_network/network_resources/country/models/country_available.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_category.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_app_inkwell.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_drop_selector.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_popup_container.dart';
import 'package:temp_package_name/src/utils/app_utils.dart';

import '../bloc/point_interests_bloc.dart';
import 'widget_create_point.dart';
import 'widget_dialog_map.dart';

class WidgetLeftMenu extends StatelessWidget {
  const WidgetLeftMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.sw,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: WidgetInkWellTransparent(
                  onTap: () {
                    appDialog(const WidgetCreatePoint());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              blurRadius: 40.sw,
                              spreadRadius: 12.sw,
                              offset: Offset(0, 4.sw))
                        ]),
                    padding: EdgeInsets.fromLTRB(20.sw, 10.sw, 20.sw, 10.sw),
                    child: Row(
                      children: [
                        Container(
                          height: 52.sw,
                          width: 52.sw,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                appColorPrimary1,
                                appColorPrimary2,
                              ],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: WidgetAppSVG(
                            'solucalc_user_plus',
                            width: 28.sw,
                          ),
                        ),
                        Gap(12.sw),
                        Text(
                          ' + create',
                          style: w500TextStyle(
                              fontSize: fs18(), color: appColorPrimary1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(16.sw),
              BlocBuilder<TravelmeitPointsBloc, TravelmeitPointsState>(
                bloc: travelmeitPointsBloc,
                builder: (context, state) {
                  return WidgetInkWellTransparent(
                    onTap: state.isFetching == true
                        ? null
                        : () {
                            appDialog(const WidgetDialogMapPoints());
                          },
                    child: Container(
                      decoration: BoxDecoration(
                          color: appColorPrimary1
                              .withOpacity(state.isFetching == true ? .5 : 1),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 40.sw,
                                spreadRadius: 12.sw,
                                offset: Offset(0, 4.sw))
                          ]),
                      padding: EdgeInsets.all(10.sw),
                      child: Container(
                        height: 52.sw,
                        width: 52.sw,
                        alignment: Alignment.center,
                        child: WidgetAppSVG(
                          'location_map',
                          width: 38.sw,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Gap(24.sw),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.sw),
                  border: Border.all(width: 1.sw, color: Colors.white),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      hexColor('#EBEBEB'),
                      hexColor('#EBEBEB').withOpacity(.7),
                      hexColor('#E8E3E3').withOpacity(.0)
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.sw),
                    child: const Column(
                      children: [
                        _WidgetCountryFilter(),
                        _WidgetDisplayFilter(),
                        _WidgetCateFilter(),
                      ],
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class _WidgetCountryFilter extends StatefulWidget {
  const _WidgetCountryFilter();

  @override
  State<_WidgetCountryFilter> createState() => __WidgetCountryFilterState();
}

class __WidgetCountryFilterState extends State<_WidgetCountryFilter> {
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  late List<CountryAvailable> countriesAvaliable = [];
  _fetch() async {
    if (localgetcountriesAvailableByKeyword[""] != null &&
        (localgetcountriesAvailableByKeyword[""] as List).isNotEmpty) {
      countriesAvaliable = localgetcountriesAvailableByKeyword[""];
    } else {
      countriesAvaliable = await CountryRepo().getcountriesAvailableByKeyword();
      localgetcountriesAvailableByKeyword[""] = countriesAvaliable;
    }
    countriesAvaliable
        .removeWhere((element) => element.iso == "zz" || element.iso == "ZZ");
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (countriesAvaliable.isEmpty) return const SizedBox();
    return BlocBuilder<TravelmeitPointsBloc, TravelmeitPointsState>(
        bloc: travelmeitPointsBloc,
        builder: (context, state) {
          return WidgetOverlayActions(
            builder: (child, size, childPosition, pointerPosition,
                animationValue, hide, context) {
              return Positioned(
                right: context.width - childPosition.dx - size.width,
                top: childPosition.dy + size.height + 4,
                child: Transform.scale(
                  alignment: const Alignment(0.8, -1.0),
                  scale: animationValue,
                  child: WidgetPopupContainer(
                    width: size.width,
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    height: 300.sw,
                    child: Column(
                      children: [
                        Container(
                          height: 48.sw,
                          margin: EdgeInsets.symmetric(horizontal: 16.sw),
                          padding: EdgeInsets.symmetric(horizontal: 16.sw),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.sw),
                            color: hexColor('fafafa'),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              WidgetAppSVG(
                                'ic_search_auth',
                                width: 15,
                                color: appColorPrimary1,
                              ),
                              const SizedBox(width: 10.5),
                              Expanded(
                                child: TextField(
                                  textInputAction: TextInputAction.done,
                                  controller: controller,
                                  style: w300TextStyle(
                                    fontSize: 16.sw,
                                  ),
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    isDense: true,
                                    hintStyle: w300TextStyle(
                                      fontSize: 16.sw,
                                      color: appColorText.withOpacity(.4),
                                    ),
                                    hintText: 'Search..',
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (context, value, child) {
                                  if (controller.text.isEmpty) {
                                    return const SizedBox(width: 11.36);
                                  } else {
                                    return child!;
                                  }
                                },
                                child: WidgetAppInkWell(
                                  onTap: () {
                                    controller.text = '';
                                    setState(() {});
                                  },
                                  child: WidgetAppSVG(
                                    'ic_clear',
                                    width: 10,
                                    color: appColorText.withOpacity(.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(4.sw),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (context, value, child) {
                                  return Column(
                                    children: <Widget>[
                                          WidgetAppInkWell(
                                            onTap: () async {
                                              await hide();
                                              travelmeitPointsBloc.add(
                                                  const UpdateFilterTravelmeitPointsEvent(
                                                      clearCountryCode: true));
                                            },
                                            child: Ink(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.sw,
                                                  horizontal: 16.sw),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "All countries".tr(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .visible,
                                                        style: w400TextStyle(
                                                          fontSize: 16.sw,
                                                          color: appColorText,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ] +
                                        countriesAvaliable
                                            .where((e) =>
                                                value.text.trim().isEmpty ||
                                                e.iso!.isContainsASCII(
                                                    value.text.trim()) ||
                                                getCountryName(e.iso)
                                                    .isContainsASCII(
                                                        value.text.trim()))
                                            .map<Widget>((e) =>
                                                _buildLanguageItem(hide, e))
                                            .toList(),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childBuilder: (isDropdownOpened) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Country",
                  style: w400TextStyle(
                      fontSize: fs14(), color: hexColor('#9499AD')),
                ),
                Gap(8.sw),
                Container(
                  height: 52.sw,
                  padding: EdgeInsets.symmetric(horizontal: 16.sw),
                  decoration: BoxDecoration(
                    color: hexColor('#FAFAFA'),
                    borderRadius: BorderRadius.circular(16.sw),
                  ),
                  alignment: Alignment.centerLeft,
                  child: state.countryCode == null
                      ? Row(
                          children: [
                            Expanded(
                              child: Text(
                                "All countries".tr(),
                                style: w400TextStyle(
                                  fontSize: 16.sw,
                                  color: appColorText.withOpacity(.6),
                                ),
                              ),
                            ),
                            WidgetAppSVG(
                              'arrow_down',
                              width: 24.sw,
                            )
                          ],
                        )
                      : Row(
                          children: [
                            WidgetAppFlag.countryCode(
                              countryCode: state.countryCode,
                              height: 22.sw,
                            ),
                            Gap(12.sw),
                            Expanded(
                              child: Text(
                                getCountryName(state.countryCode),
                                style: w400TextStyle(
                                  fontSize: 16.sw,
                                  color: appColorText.withOpacity(.6),
                                ),
                              ),
                            ),
                            WidgetAppSVG(
                              'arrow_down',
                              width: 24.sw,
                            )
                          ],
                        ),
                ),
                Gap(16.sw),
              ],
            ),
          );
        });
  }

  Widget _buildLanguageItem(hide, CountryAvailable m) {
    final isSelected = m.iso == travelmeitPointsBloc.state.countryCode;
    return WidgetAppInkWell(
      onTap: () async {
        await hide();
        travelmeitPointsBloc
            .add(UpdateFilterTravelmeitPointsEvent(countryCode: m.iso));
      },
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 10.sw, horizontal: 16.sw),
        child: Row(
          children: [
            WidgetAppFlag.countryCode(
              countryCode: m.iso,
              height: 20.sw,
            ),
            Gap(12.sw),
            Expanded(
              child: Text(
                getCountryName(m),
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: w400TextStyle(
                  fontSize: 16.sw,
                  color: appColorText,
                ),
              ),
            ),
          ],
        ),
      ),
    ).opacity(isSelected ? .6 : 1);
  }
}

class _WidgetDisplayFilter extends StatelessWidget {
  const _WidgetDisplayFilter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelmeitPointsBloc, TravelmeitPointsState>(
        bloc: travelmeitPointsBloc,
        builder: (context, state) {
          return WidgetOverlayActions(
            builder: (child, size, childPosition, pointerPosition,
                animationValue, hide, context) {
              return Positioned(
                right: context.width - childPosition.dx - size.width,
                top: childPosition.dy + size.height + 4,
                child: Transform.scale(
                  alignment: const Alignment(0.8, -1.0),
                  scale: animationValue,
                  child: WidgetPopupContainer(
                    width: size.width,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Column(
                      children: [
                        WidgetDropSelectorItem(
                          onTap: () async {
                            await hide();
                            travelmeitPointsBloc.add(
                                const UpdateFilterTravelmeitPointsEvent(
                                    clearDisplay: true));
                          },
                          isSelected: state.display == null,
                          label: "All",
                        ),
                        WidgetDropSelectorItem(
                          onTap: () async {
                            await hide();
                            travelmeitPointsBloc.add(
                                const UpdateFilterTravelmeitPointsEvent(
                                    display: 1));
                          },
                          isSelected: state.display == 1,
                          label: "Yes",
                        ),
                        WidgetDropSelectorItem(
                          onTap: () async {
                            await hide();
                            travelmeitPointsBloc.add(
                                const UpdateFilterTravelmeitPointsEvent(
                                    display: 0));
                          },
                          isSelected: state.display == 0,
                          label: "No",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childBuilder: (isDropdownOpened) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Display",
                  style: w400TextStyle(
                      fontSize: fs14(), color: hexColor('#9499AD')),
                ),
                Gap(8.sw),
                Container(
                  height: 52.sw,
                  padding: EdgeInsets.symmetric(horizontal: 16.sw),
                  decoration: BoxDecoration(
                    color: hexColor('#FAFAFA'),
                    borderRadius: BorderRadius.circular(16.sw),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.display == null
                              ? "All"
                              : (state.display == 1 ? "Yes" : "No").tr(),
                          style: w400TextStyle(
                            fontSize: 16.sw,
                            color: appColorText.withOpacity(.6),
                          ),
                        ),
                      ),
                      WidgetAppSVG(
                        'arrow_down',
                        width: 24.sw,
                      )
                    ],
                  ),
                ),
                Gap(16.sw),
              ],
            ),
          );
        });
  }
}

class _WidgetCateFilter extends StatelessWidget {
  const _WidgetCateFilter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelmeitPointsBloc, TravelmeitPointsState>(
      bloc: travelmeitPointsBloc,
      builder: (context, state) {
        if (state.categories?.isNotEmpty != true) return const SizedBox();
        return WidgetDropSelector(
          label: "Category".tr(),
          value: state.categoriesSelected.isEmpty
              ? "All categories".tr()
              : state.categoriesSelected.first.label ?? "",
          itemsBuilder: (
            hide,
            controller,
          ) {
            return Expanded(
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      return Column(
                        children: <Widget>[
                              WidgetDropSelectorItem(
                                onTap: () async {
                                  await hide();
                                  travelmeitPointsBloc.add(
                                      const UpdateFilterTravelmeitPointsEvent(
                                          clearCategories: true));
                                },
                                isSelected: state.categoriesSelected.isEmpty,
                                label: "All categories".tr(),
                              ),
                            ] +
                            state.categories!
                                .where((e) =>
                                    value.text.trim().isEmpty ||
                                    e.label!.isContainsASCII(value.text.trim()))
                                .map<Widget>((e) => _buildLanguageItem(hide, e))
                                .toList(),
                      );
                    }),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageItem(hide, PointCategory m) {
    final isSelected =
        travelmeitPointsBloc.state.categoriesSelected.any((e) => e.id == m.id);
    return WidgetDropSelectorItem.builder(
      builder: (_) => Row(
        children: [
          WidgetAppSVG(
            'custom_cat_${m.id}',
            width: 24.sw,
            color: appColorText,
          ),
          Gap(8.sw),
          Expanded(
            child: Text(
              m.label ?? "",
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: w400TextStyle(
                fontSize: 16.sw,
                color: appColorText,
              ),
            ),
          ),
        ],
      ),
      isSelected: isSelected,
      onTap: () async {
        await hide();
        travelmeitPointsBloc
            .add(UpdateFilterTravelmeitPointsEvent(categories: [m]));
      },
    );
  }
}

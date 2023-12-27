import 'dart:async';

import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:_private_core_network/network_resources/google_place/models/models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_category.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_interest.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_similar_around.dart';
import 'package:temp_package_name/src/network_resources/points/repo.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_app_map.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_buttons.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_container_home.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_drop_selector.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_input_label.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_popup_container.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_row_value.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_search_place_builder.dart';
import 'package:temp_package_name/src/utils/app_input_formatters.dart';
import 'package:temp_package_name/src/utils/utils.dart';

import '../bloc/point_interests_bloc.dart';
import 'widget_dialog_gpt_generate.dart';
import 'widget_slider_step_customize_vertical.dart';

class WidgetCreatePoint extends StatefulWidget {
  const WidgetCreatePoint({super.key});

  @override
  State<WidgetCreatePoint> createState() => _WidgetCreatePointState();
}

class _WidgetCreatePointState extends State<WidgetCreatePoint> {
  late LatLng latLng =
      getCenterPointByCountryCode(travelmeitPointsBloc.state.countryCode);
  late GoogleMapController mapController;

  late TextEditingController controllerLat =
      TextEditingController(text: (latLng.latitude).toStringAsFixed(6));
  late TextEditingController controllerLng =
      TextEditingController(text: (latLng.longitude).toStringAsFixed(6));

  final TextEditingController addressController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController shortController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  String? languageCode = AppPrefs.instance.languageCode;

  bool get isEnable => cat != null && titleController.text.isNotEmpty;

  bool loading = false;
  bool visibleSearchPlace = false;

  String? errorMessage;
  _save() async {
    errorMessage = null;
    setState(() {
      loading = true;
    });
    PointInterest? m = await PointsRepo().createPoiFromAdmin({
      "languageCode": languageCode,
      "title": titleController.text.trim(),
      "shortDescription": shortController.text.trim(),
      "longDescription": longController.text.trim(),
      "customCatId": cat?.id,
      "lat": latLng.latitude,
      "lng": latLng.longitude,
      "filterEntertainment": filterEntertainment,
      "filterArt": filterArt,
      "filterLandscape": filterLandscape,
      "filterHistory": filterHistory,
      "rate": rate,
    });
    loading = false;
    if (mounted) {
      if (m != null) {
        travelmeitPointsBloc.add(UpdateFilterTravelmeitPointsEvent(
            categories: [cat!], countryCode: m.countryCode));
        travelmeitPointsBloc.add(SelectTravelmeitPointsEvent(m));
        context.pop();
      } else {
        errorMessage = 'Something wrong, please try again!';
        setState(() {});
      }
    }
  }

  Timer? _debounce;
  _updateMap(latLng, {VoidCallback? callback}) async {
    errorMessage = null;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      await mapController.animateCamera(CameraUpdate.newLatLng(latLng));
      callback?.call();
    });
    _fetchPointByLatLng();
  }

  bool isFetching = false;
  Timer? _debounce2;
  List<PointSimilarAround> items = [];
  _fetchPointByLatLng() async {
    setState(() {
      isFetching = true;
    });
    if (_debounce2?.isActive ?? false) _debounce2?.cancel();
    _debounce2 = Timer(const Duration(seconds: 1), () async {
      items = await PointsRepo().checkSimilarPoiAroundLatLng({
        "distance": 25,
        "lat": double.parse(controllerLat.text),
        "lng": double.parse(controllerLng.text),
      });
      isFetching = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  int step = 1;

  String rate = "1";
  PointCategory? cat;

  int filterHistory = 5;
  int filterArt = 5;
  int filterEntertainment = 5;
  int filterLandscape = 5;

  @override
  void dispose() {
    super.dispose();
    controllerLat.dispose();
    controllerLng.dispose();
    addressController.dispose();
    titleController.dispose();
    shortController.dispose();
    longController.dispose();
    mapController.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return step == 2
        ? WidgetDialogGPTGenerate(
            key: const ValueKey(2),
            isShortDesc: true,
            languageCode: languageCode,
            label: "Short Description",
            content: shortController.text,
            labelButtonCancel: "Back".tr(),
            labelButtonOk: "Next".tr(),
            callbackCancel: () {
              setState(() {
                step--;
              });
            },
            callbackOk: (_) {
              shortController.text = _;
              errorMessage = "";
              setState(() {
                step++;
              });
            },
          )
        : step == 3
            ? WidgetDialogGPTGenerate(
                key: const ValueKey(3),
                errorMessage: errorMessage,
                isShortDesc: false,
                languageCode: languageCode,
                label: "Long Description",
                content: longController.text,
                labelButtonCancel: "Back".tr(),
                labelButtonOk: "Save".tr(),
                callbackCancel: () {
                  errorMessage = "";
                  setState(() {
                    step--;
                  });
                },
                callbackOk: (_) {
                  longController.text = _;
                  _save();
                },
                loadingButtonOk: loading,
              )
            : WidgetBaseDialog(
                width: 1280.sw,
                padding: EdgeInsets.all(24.sw),
                color: hexColor('#FAFAFA'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 420.sw,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetAppMap(
                                  onCameraMove: (position) {
                                    addressController.clear();
                                    controllerLat.text = position
                                        .target.latitude
                                        .toStringAsFixed(6);
                                    controllerLng.text = position
                                        .target.longitude
                                        .toStringAsFixed(6);
                                    latLng = position.target;
                                    _fetchPointByLatLng();
                                  },
                                  controllerInitialized:
                                      (GoogleMapController c) {
                                    mapController = c;
                                  },
                                  borderRadius: BorderRadius.circular(26.sw),
                                  center: latLng,
                                  zoom: 14,
                                  enableControllerCurrentPosition: false,
                                  enableControllerHome: false,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3.sw, color: appColorPrimary1),
                                      shape: BoxShape.circle),
                                  width: 105.sw,
                                  height: 105.sw,
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 7.sw,
                                      backgroundColor: appColorPrimary1,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Gap(24.sw),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: WidgetAppInputLabel(
                                        label: "Lng",
                                        inputFormatters:
                                            appInputFormattersDouble,
                                        backgroundColor: Colors.white,
                                        controller: controllerLat,
                                        onUnFocus: (value) {
                                          addressController.clear();
                                          _updateMap(LatLng(
                                              double.tryParse(value) ?? 0,
                                              latLng.longitude));
                                        },
                                      ),
                                    ),
                                    Gap(24.sw),
                                    Expanded(
                                      child: WidgetAppInputLabel(
                                        inputFormatters:
                                            appInputFormattersDouble,
                                        label: "Lat",
                                        backgroundColor: Colors.white,
                                        controller: controllerLng,
                                        onUnFocus: (value) {
                                          addressController.clear();
                                          _updateMap(LatLng(
                                            latLng.latitude,
                                            double.tryParse(value) ?? 0,
                                          ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(16.sw),
                                WidgetSearchPlaceBuilder(
                                  isUpDirection: false,
                                  controller: addressController,
                                  visible: visibleSearchPlace,
                                  builder: (ValueChanged onChanged,
                                      TextEditingController controller,
                                      bool loading) {
                                    return WidgetAppInputLabel(
                                      labelNotExpand: true,
                                      labelIcon: loading
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(left: 12.sw),
                                              child: CupertinoActivityIndicator(
                                                radius: 8.sw,
                                                color: appColorPrimary1,
                                              ),
                                            )
                                          : null,
                                      label: "Address",
                                      onChanged: onChanged,
                                      backgroundColor: Colors.white,
                                      controller: controller,
                                      onFocus: (_) {
                                        visibleSearchPlace = true;
                                        setState(() {});
                                      },
                                      onUnFocus: (_) {
                                        visibleSearchPlace = false;
                                        setState(() {});
                                      },
                                    );
                                  },
                                  onSubmitted: (SeachPlaceResultDetailModel
                                      value) async {
                                    latLng = LatLng(
                                        value.geometry?.location?.lat ??
                                            latLng.latitude,
                                        value.geometry?.location?.lng ??
                                            latLng.longitude);
                                    _updateMap(latLng, callback: () {
                                      Timer(const Duration(seconds: 1), () {
                                        addressController.text =
                                            value.formattedAddress ?? "";
                                      });
                                    });
                                  },
                                ),
                                Gap(16.sw),
                                Row(
                                  children: [
                                    Text(
                                      "Already exist in this list ? ".tr(),
                                      style: w300TextStyle(
                                          fontSize: 14.sw,
                                          color: appColorLabel),
                                    ),
                                  ],
                                ),
                                Gap(8.sw),
                                Expanded(
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(24.sw)),
                                    child: WidgetTableContainer(
                                      header: Row(
                                        children: [
                                          WidgetRowValue.label(
                                              value: 'Picture'.tr(), flex: 1),
                                          WidgetRowValue.label(
                                              value: 'Title'.tr(), flex: 2),
                                          WidgetRowValue.label(
                                              value: 'Short description'.tr(),
                                              flex: 3),
                                        ],
                                      ),
                                      data: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (_, index) {
                                          if (isFetching) {
                                            return _WidgetItemShimmer(
                                                index: index);
                                          }
                                          return _WidgetItem(
                                            index: index,
                                            m: items[index],
                                          );
                                        },
                                        itemCount:
                                            isFetching ? 2 : items.length,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(24.sw),
                    Row(
                      children: [
                        Expanded(
                          child: WidgetAppInputLabel(
                            label: 'Title',
                            controller: titleController,
                            backgroundColor: Colors.white,
                            maxLength: 100,
                            onChanged: (_) {
                              setState(() {});
                            },
                          ),
                        ),
                        Gap(24.sw),
                        Expanded(
                            child: Row(
                          children: [
                            Expanded(
                              child: WidgetOverlayActions(
                                builder: (Widget child,
                                    Size size,
                                    Offset childPosition,
                                    Offset? pointerPosition,
                                    double animationValue,
                                    Function hide,
                                    BuildContext context) {
                                  return Positioned(
                                    right: context.width -
                                        childPosition.dx -
                                        size.width -
                                        12,
                                    top: childPosition.dy + size.height + 8.sw,
                                    child: Transform.scale(
                                      alignment: const Alignment(0.8, -1.0),
                                      scale: animationValue,
                                      child: WidgetPopupContainer(
                                        width: size.width * .8,
                                        padding: EdgeInsets.only(
                                            top: 12.sw, bottom: 12.sw),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (_, index) =>
                                              WidgetDropSelectorItem(
                                            isSelected: false,
                                            label: populars[index],
                                            onTap: () {
                                              hide();
                                              if (index == 3) {
                                                rate = "";
                                              } else {
                                                rate = "${index + 1}";
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          itemCount: populars.length,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: BlocBuilder<TravelmeitPointsBloc,
                                        TravelmeitPointsState>(
                                    bloc: travelmeitPointsBloc,
                                    builder: (context, state) {
                                      return WidgetAppInputLabel(
                                        label: "Importance",
                                        controller: TextEditingController(
                                            text: getPopularFromRate(rate)),
                                        backgroundColor: Colors.white,
                                        suffixIcon: WidgetAppSVG(
                                          'ic_arrow_down',
                                          width: 24.sw,
                                          color: hexColor('#363853'),
                                        ),
                                      ).ignore(true);
                                    }),
                              ),
                            ),
                            Gap(24.sw),
                            Expanded(
                              child: WidgetOverlayActions(
                                builder: (Widget child,
                                    Size size,
                                    Offset childPosition,
                                    Offset? pointerPosition,
                                    double animationValue,
                                    Function hide,
                                    BuildContext context) {
                                  return Positioned(
                                    right: context.width -
                                        childPosition.dx -
                                        size.width -
                                        12,
                                    top: childPosition.dy + size.height + 8.sw,
                                    child: Transform.scale(
                                      alignment: const Alignment(0.8, -1.0),
                                      scale: animationValue,
                                      child: WidgetPopupContainer(
                                        width: size.width * .8,
                                        padding: EdgeInsets.only(
                                            top: 12.sw, bottom: 12.sw),
                                        child: BlocBuilder<TravelmeitPointsBloc,
                                                TravelmeitPointsState>(
                                            bloc: travelmeitPointsBloc,
                                            builder: (context, state) {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (_, index) =>
                                                    WidgetDropSelectorItem(
                                                  isSelected: false,
                                                  icon: Row(
                                                    children: [
                                                      WidgetAppSVG(
                                                        'custom_cat_${state.categories![index].id}',
                                                        width: 24.sw,
                                                        color: appColorText,
                                                      ),
                                                      Gap(12.sw),
                                                    ],
                                                  ),
                                                  label: state
                                                          .categories![index]
                                                          .label ??
                                                      "",
                                                  onTap: () {
                                                    hide();
                                                    cat = state
                                                        .categories![index];
                                                    setState(() {});
                                                  },
                                                ),
                                                itemCount:
                                                    state.categories?.length ??
                                                        0,
                                              );
                                            }),
                                      ),
                                    ),
                                  );
                                },
                                child: BlocBuilder<TravelmeitPointsBloc,
                                        TravelmeitPointsState>(
                                    bloc: travelmeitPointsBloc,
                                    builder: (context, state) {
                                      if (state.categories?.isNotEmpty ==
                                          true) {
                                        cat ??= state.categories?.first;
                                      }
                                      return WidgetAppInputLabel(
                                        label: "Travelmeit custom category",
                                        key: ValueKey(cat),
                                        controller: TextEditingController(
                                            text: cat?.label),
                                        backgroundColor: Colors.white,
                                        suffixIcon: WidgetAppSVG(
                                          'ic_arrow_down',
                                          width: 24.sw,
                                          color: hexColor('#363853'),
                                        ),
                                      ).ignore(true);
                                    }),
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                    Gap(24.sw),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 36.sw, bottom: 16.sw),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.sw)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    WidgetSliderStepCustomizeVertical(
                                      height: 160.sw,
                                      isEnableDotStep: false,
                                      isEnableTooltipOnlyDrag: false,
                                      selected: filterArt,
                                      length: 11,
                                      labelByIndex: (p0) {
                                        return "${p0 * 10}%";
                                      },
                                      onChanged: (value) {
                                        filterArt = value;
                                        setState(() {});
                                      },
                                    ),
                                    Gap(24.sw),
                                    Text(
                                      "Art",
                                      style: w400TextStyle(
                                          fontSize: fs14(),
                                          color: appColorPrimary1),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    WidgetSliderStepCustomizeVertical(
                                      height: 160.sw,
                                      isEnableDotStep: false,
                                      isEnableTooltipOnlyDrag: false,
                                      selected: filterEntertainment,
                                      length: 11,
                                      labelByIndex: (p0) {
                                        return "${p0 * 10}%";
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          filterEntertainment = value;
                                        });
                                      },
                                    ),
                                    Gap(24.sw),
                                    Text(
                                      "Entert.",
                                      style: w400TextStyle(
                                          fontSize: fs14(),
                                          color: appColorPrimary1),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    WidgetSliderStepCustomizeVertical(
                                      height: 160.sw,
                                      isEnableDotStep: false,
                                      isEnableTooltipOnlyDrag: false,
                                      selected: filterLandscape,
                                      length: 11,
                                      labelByIndex: (p0) {
                                        return "${p0 * 10}%";
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          filterLandscape = value;
                                        });
                                      },
                                    ),
                                    Gap(24.sw),
                                    Text(
                                      "Landsc.",
                                      style: w400TextStyle(
                                          fontSize: fs14(),
                                          color: appColorPrimary1),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    WidgetSliderStepCustomizeVertical(
                                      height: 160.sw,
                                      isEnableDotStep: false,
                                      isEnableTooltipOnlyDrag: false,
                                      selected: filterHistory,
                                      length: 11,
                                      labelByIndex: (p0) {
                                        return "${p0 * 10}%";
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          filterHistory = value;
                                        });
                                      },
                                    ),
                                    Gap(24.sw),
                                    Text(
                                      "History",
                                      style: w400TextStyle(
                                          fontSize: fs14(),
                                          color: appColorPrimary1),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Gap(24.sw),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: WidgetButtonNO(
                                  label: 'Cancel'.tr(),
                                  onTap: () {
                                    context.pop();
                                  },
                                ),
                              ),
                              Gap(24.sw),
                              Expanded(
                                child: WidgetButtonOK(
                                  enable: isEnable,
                                  label: 'Next'.tr(),
                                  loading: loading,
                                  onTap: () {
                                    step++;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
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
          const WidgetRowValueShimmer(flex: 3),
        ],
      ),
    );
  }
}

class _WidgetItem extends StatelessWidget {
  final int index;
  final PointSimilarAround m;
  const _WidgetItem({
    required this.index,
    required this.m,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetRowItem(
      index: index,
      child: Row(
        children: [
          WidgetRowValue(
            flex: 1,
            value: Align(
              alignment: Alignment.centerLeft,
              child: WidgetInkWellTransparent(
                onTap: () {
                  if (m.previewPictureUrl != null) {
                    pushWidget(
                        child:
                            WidgetImagesViewer(images: [m.previewPictureUrl]));
                  }
                },
                child: WidgetAppImage(
                  imageUrl: m.previewPictureUrl,
                  placeholderWidget: SizedBox(
                    height: 40.sw,
                    width: 60.sw,
                  ),
                  height: 40.sw,
                  width: 60.sw,
                  radius: 4,
                ),
              ),
            ),
          ),
          WidgetRowValue(
            flex: 2,
            value: m.title ?? "",
          ),
          WidgetRowValue(
            flex: 3,
            value: m.shortDescription,
          ),
        ],
      ),
    );
  }
}

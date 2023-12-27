import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:_private_core_network/network_resources/country/country_repo.dart';
import 'package:_private_core_network/network_resources/country/models/country_available.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/network_resources/here_routing/model/route.dart';
import 'package:temp_package_name/src/network_resources/here_routing/repo.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_category.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_interest.dart';
import 'package:temp_package_name/src/network_resources/points/model/travel_tour.dart';
import 'package:temp_package_name/src/network_resources/points/repo.dart';
import 'package:temp_package_name/src/presentation/travelmeit_tours/bloc/travelmeit_tours_bloc.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_app_inkwell.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_app_map.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_app_switcher.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_drop_selector.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_popup_container.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_scroll_config.dart';
import 'package:temp_package_name/src/utils/app_map_helper.dart';
import 'package:temp_package_name/src/utils/utils.dart';

import '../bloc/point_interests_bloc.dart';

class WidgetDialogMapPoints extends StatefulWidget {
  const WidgetDialogMapPoints({super.key});

  @override
  State<WidgetDialogMapPoints> createState() => _WidgetDialogMapPointsState();
}

class _WidgetDialogMapPointsState extends State<WidgetDialogMapPoints> {
  late GoogleMapController mapController;
  double get _padding => 16.sw;
  bool isDisplayLabel = true;
  _rightHome(TravelmeitPointsState state) {
    if (state.items?.isNotEmpty == true) {
      int index =
          state.items!.indexWhere((e) => e.id == state.itemSelected!.id);
      if (index >= state.items!.length - 1) {
        _explainDetail(state.items![0]);
      } else {
        _explainDetail(state.items![index + 1]);
      }
    }
  }

  _leftHome(TravelmeitPointsState state) {
    if (state.items?.isNotEmpty == true) {
      int index =
          state.items!.indexWhere((e) => e.id == state.itemSelected!.id);
      if (index == 0) {
        _explainDetail(state.items![state.items!.length - 1]);
      } else {
        _explainDetail(state.items![index - 1]);
      }
    }
  }

  _explainDetail(PointInterest e) async {
    mapController.animateCamera(CameraUpdate.newLatLng(e.latLng));
    travelmeitPointsBloc.add(SelectTravelmeitPointsEvent(e));
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Material(
          color: Colors.transparent,
          child: WidgetGlassBackground(
            blur: 12,
            backgroundColor: Colors.white24,
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 32.sw),
                        height: context.height - 32.sw * 3.5,
                        child: BlocBuilder<TravelmeitPointsBloc,
                            TravelmeitPointsState>(
                          bloc: travelmeitPointsBloc,
                          builder: (context, state) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                WidgetAppMap(
                                  key: ValueKey(isDisplayLabel),
                                  controllerInitialized: (p0) =>
                                      mapController = p0,
                                  borderRadius: BorderRadius.circular(26.sw),
                                  center: travelmeitPointsBloc.latestLatLng ??
                                      getCenterPointByCountryCode(
                                          state.countryCode),
                                  zoom: travelmeitPointsBloc.zoomLevel ??
                                      (travelmeitPointsBloc.latestLatLng ==
                                                  null &&
                                              state.countryCode == null
                                          ? 4
                                          : 11),
                                  buildMarkers: state.items
                                      ?.map((e) => AppBuildMarker.builder(
                                            id: "${e.id}${isDisplayLabel ? "" : "_circle"}${e.display == 1 ? "_display" : ""}",
                                            onTap: () {
                                              travelmeitPointsBloc.add(
                                                  SelectTravelmeitPointsEvent(
                                                      e));
                                            },
                                            builder: () async {
                                              return await (!isDisplayLabel
                                                  ? pointCircleBitmapDescriptor(
                                                      e, e.display == 1)
                                                  : pointBitmapDescriptor(
                                                      e, e.display == 1));
                                            },
                                            latLng: e.latLng,
                                          ))
                                      .toList(),
                                  onCameraMove: (position) {
                                    travelmeitPointsBloc.zoomLevel =
                                        position.zoom;
                                    travelmeitPointsBloc.latestLatLng =
                                        position.target;
                                  },
                                  enableControllerCurrentPosition: false,
                                  enableControllerHome: false,
                                  controllerBuilder: (Widget child) {
                                    return Positioned(
                                      right: 12.sw,
                                      bottom: 56.sw,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // if (m.lat != null || m.googleStreetMapUrl != null)
                                          //   WidgetAppOpenStreetMap(
                                          //     lat: m.lat?.toDouble(),
                                          //     lng: m.lng?.toDouble(),
                                          //     googleStreetMapUrl: m.googleStreetMapUrl,
                                          //   ),
                                          child,
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                if (state.itemSelected != null)
                                  LayoutBuilder(builder: (context, p) {
                                    bool isNotEnough =
                                        460.sw + 12.sw * 2 + 40.sw * 2 >
                                            p.maxWidth;
                                    return PointerInterceptor(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (state.items!.length > 1)
                                            WidgetGlassBackground(
                                              blur: 5,
                                              padding: EdgeInsets.zero,
                                              borderRadius:
                                                  BorderRadius.circular(40.sw),
                                              backgroundColor:
                                                  appColorBackground
                                                      .withOpacity(.8),
                                              child: WidgetInkWellTransparent(
                                                onTap: () {
                                                  _leftHome(state);
                                                },
                                                child: Container(
                                                  width: 40.sw,
                                                  height: 40.sw,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle),
                                                  alignment: Alignment.center,
                                                  child: WidgetAppSVG(
                                                    'ic_arrow_left',
                                                    width: 8.sw,
                                                    color: appColorText,
                                                  ),
                                                ),
                                              ),
                                            )
                                          else
                                            Gap(40.sw),
                                          if (isNotEnough)
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(12.sw),
                                                child: WidgetMarkerDetailPoint(
                                                  key: ValueKey(
                                                      state.itemSelected!.id),
                                                  m: state.itemSelected!,
                                                ),
                                              ),
                                            )
                                          else
                                            Padding(
                                              padding: EdgeInsets.all(12.sw),
                                              child: WidgetMarkerDetailPoint(
                                                  key: ValueKey(
                                                      state.itemSelected!.id),
                                                  m: state.itemSelected!),
                                            ),
                                          if (state.items!.length > 1)
                                            WidgetGlassBackground(
                                              blur: 5,
                                              padding: EdgeInsets.zero,
                                              borderRadius:
                                                  BorderRadius.circular(40.sw),
                                              backgroundColor:
                                                  appColorBackground
                                                      .withOpacity(.8),
                                              child: WidgetInkWellTransparent(
                                                onTap: () {
                                                  _rightHome(state);
                                                },
                                                child: Container(
                                                  width: 40.sw,
                                                  height: 40.sw,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle),
                                                  alignment: Alignment.center,
                                                  child: WidgetAppSVG(
                                                    'ic_arrow_right',
                                                    width: 8.sw,
                                                    color: appColorText,
                                                  ),
                                                ),
                                              ),
                                            )
                                          else
                                            Gap(40.sw),
                                        ],
                                      ),
                                    );
                                  })
                              ],
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 32.sw,
                        right: 32.sw,
                        child: PointerInterceptor(
                          child: Container(
                            padding: EdgeInsets.all(_padding),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(65.sw),
                                color: Colors.white,
                                boxShadow: appShadowLight),
                            child: Row(
                              children: [
                                SizedBox(width: 10.sw),
                                Center(
                                    child: WidgetAssetImage.png(
                                  'travelmeit_logo',
                                  width: 80.sw,
                                  fit: BoxFit.scaleDown,
                                )),
                                SizedBox(width: 16.sw),
                                Expanded(
                                  child: BlocBuilder<TravelmeitPointsBloc,
                                          TravelmeitPointsState>(
                                      bloc: travelmeitPointsBloc,
                                      builder: (context, state) {
                                        // return WidgetScrollConfigurationHorizontal(
                                        //   child: SingleChildScrollView(
                                        //     scrollDirection: Axis.horizontal,
                                        //     child: Row(
                                        //       children: [
                                        //         Gap(_padding),
                                        //         _WidgetCountryFilter((_) {
                                        //           mapController.animateCamera(
                                        //               CameraUpdate.newLatLngZoom(
                                        //                   getCenterPointByCountryCode(
                                        //                       _),
                                        //                   10));
                                        //         }),
                                        //         Gap(_padding),
                                        //         const _WidgetDisplayFilter(),
                                        //         Gap(_padding),
                                        //         const _WidgetCateFilter(),
                                        //         Gap(_padding),
                                        //         Spacer(),
                                        //         Text(
                                        //           "Display",
                                        //           style: w400TextStyle(
                                        //               fontSize: 14.sw,
                                        //               color:
                                        //                   hexColor('#8F8C92')),
                                        //         ),
                                        //         Gap(12.sw),
                                        //         WidgetAppSwitcher(
                                        //           onToggle: (_) {
                                        //             _update(_ ? 1 : 0);
                                        //           },
                                        //           value: m.display == 1,
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // );
                                        return Row(
                                          children: [
                                            Gap(_padding),
                                            _WidgetCountryFilter((_) {
                                              mapController.animateCamera(
                                                  CameraUpdate.newLatLngZoom(
                                                      getCenterPointByCountryCode(
                                                          _),
                                                      10));
                                            }),
                                            Gap(_padding),
                                            const _WidgetDisplayFilter(),
                                            Gap(_padding),
                                            const _WidgetCateFilter(),
                                            const Spacer(),
                                            Text(
                                              "Display details".tr(),
                                              style: w400TextStyle(
                                                  fontSize: 14.sw,
                                                  color: hexColor('#8F8C92')),
                                            ),
                                            Gap(12.sw),
                                            WidgetAppSwitcher(
                                              onToggle: (_) {
                                                setState(() {
                                                  isDisplayLabel = _;
                                                });
                                              },
                                              value: isDisplayLabel,
                                            ),
                                            Gap(_padding),
                                          ],
                                        );
                                      }),
                                ),
                                Gap(8.sw),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      context.pop();
                                    },
                                    hoverColor: byTheme(appColorElement,
                                        dark: hexColor('#353638')),
                                    borderRadius: BorderRadius.circular(99),
                                    child: Ink(
                                      width: 48.sw,
                                      height: 48.sw,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hexColor('#F0F1F6'),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 24.sw,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetMarkerPoint extends StatelessWidget {
  final PointInterest m;
  const WidgetMarkerPoint({
    super.key,
    required this.m,
  });

  double get _radius => 43.sw / 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.2),
          color: m.display == 1 ? hexColor('23A7B4') : hexColor('#C0C0C0'),
          borderRadius: BorderRadius.circular(99)),
      padding: EdgeInsets.all(8.sw),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            key: m.globalKey,
            backgroundColor: Colors.white,
            radius: (_radius + 1.2),
            child: WidgetAppImage(
              imageUrl: m.imageDisplayTiny,
              radius: 999,
              height: (_radius * 2),
              width: (_radius * 2),
              errorWidget: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Image.asset(
                  assetpng('placeholder'),
                  fit: BoxFit.cover,
                  height: (_radius * 2),
                  width: (_radius * 2),
                ),
              ),
            ),
          ),
          Gap(8.sw),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150.sw),
            child: Text(
              m.details?.title ?? "Unknown".tr(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: w400TextStyle(fontSize: fs16(), color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetMarkerDetailPoint extends StatefulWidget {
  final PointInterest m;
  const WidgetMarkerDetailPoint({super.key, required this.m});

  @override
  State<WidgetMarkerDetailPoint> createState() =>
      _WidgetMarkerDetailPointState();
}

class _WidgetMarkerDetailPointState extends State<WidgetMarkerDetailPoint> {
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
      travelmeitPointsBloc.add(const SelectTravelmeitPointsEvent());
      travelmeitPointsBloc
          .add(const FetchTravelmeitPointsEvent(isAlsoRemoveOld: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 460.sw,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: Color(0x19111111),
          blurRadius: 40,
          offset: Offset(0, 8),
          spreadRadius: 0,
        )
      ], color: Colors.white, borderRadius: BorderRadius.circular(16.sw)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
            child: Row(
              children: [
                Text(
                  widget.m.customCategory?.label ?? "No category",
                  style: w400TextStyle(fontSize: 14.sw),
                ),
                Container(
                  height: 14.sw,
                  width: 1.sw,
                  margin: EdgeInsets.symmetric(horizontal: 8.sw),
                ),
                Text(
                  "Display",
                  style: w400TextStyle(
                      fontSize: 14.sw, color: hexColor('#8F8C92')),
                ),
                Gap(12.sw),
                WidgetAppSwitcher(
                  onToggle: (_) {
                    _update(_ ? 1 : 0);
                  },
                  value: m.display == 1,
                ),
                const Spacer(),
                _WidgetAddToTour(m),
              ],
            ),
          ),
          Container(
            height: 1,
            color: hexColor('#EBEBEB'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
            child: WidgetInkWellTransparent(
              onTap: () {
                context.pop();
                travelmeitPointsBloc.add(SelectTravelmeitPointsEvent(m));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetAppImage(
                        imageUrl: m.imageDisplayTiny,
                        radius: 16.sw,
                        height: 82.sw,
                        width: 86.sw,
                        errorWidget: ClipRRect(
                          borderRadius: BorderRadius.circular(16.sw),
                          child: Image.asset(
                            assetpng('placeholder'),
                            fit: BoxFit.cover,
                            height: 82.sw,
                            width: 86.sw,
                          ),
                        ),
                      ),
                      Gap(8.sw),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              m.details?.title ?? "Unknown".tr(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: w400TextStyle(fontSize: fs16()),
                            ),
                            Gap(4.sw),
                            Text(
                              m.cityName ?? "Unknown".tr(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: w300TextStyle(
                                  fontSize: fs14(), color: hexColor('#7A838C')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(12.sw),
                  Text(
                    widget.m.shortDescription ??
                        widget.m.details?.shortDescription ??
                        "Short description not available".tr(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: w400TextStyle(fontSize: 14.sw),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetCountryFilter extends StatefulWidget {
  final ValueChanged callback;
  const _WidgetCountryFilter(this.callback);

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
            childBuilder: (isDropdownOpened) => Container(
              height: 48.sw,
              width: 200.sw,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              decoration: BoxDecoration(
                border: Border.all(color: hexColor('#EDEEF3')),
                borderRadius: BorderRadius.circular(99),
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
                              color: appColorText,
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
                              color: appColorText,
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
        widget.callback(m.iso);
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
            childBuilder: (isDropdownOpened) => Container(
              height: 48.sw,
              width: 160.sw,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              decoration: BoxDecoration(
                border: Border.all(color: hexColor('#EDEEF3')),
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Display (${state.display == null ? "All" : (state.display == 1 ? "Yes" : "No").tr()})",
                      style: w400TextStyle(
                        fontSize: 16.sw,
                        color: appColorText,
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
          childBuilder: (isDropdownOpened) {
            return Container(
              height: 48.sw,
              width: 220.sw,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              decoration: BoxDecoration(
                border: Border.all(color: hexColor('#EDEEF3')),
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.categoriesSelected.isEmpty
                          ? "All categories".tr()
                          : state.categoriesSelected.first.label ?? "",
                      style: w400TextStyle(
                        fontSize: 16.sw,
                        color: appColorText,
                      ),
                    ),
                  ),
                  WidgetAppSVG(
                    'arrow_down',
                    width: 24.sw,
                  )
                ],
              ),
            );
          },
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

class _WidgetAddToTour extends StatefulWidget {
  final PointInterest m;
  const _WidgetAddToTour(this.m);

  @override
  State<_WidgetAddToTour> createState() => __WidgetAddToTourState();
}

class __WidgetAddToTourState extends State<_WidgetAddToTour> {
  PointInterest get m => widget.m;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TravelmeitToursBloc, TravelmeitToursState>(
      bloc: travelmeitToursBloc,
      builder: (context, state) {
        List<TravelTour> items = state.items!
            .where((e) => !e.jsonPoints.any((e0) => e0.id == m.id))
            .where((e) => e.countryCode == m.countryCode)
            .toList();
        if (state.items?.isNotEmpty != true) return const SizedBox();
        return WidgetDropSelector(
          isEnableSearch: items.length < 5 ? false : true,
          isUpDirection: true,
          isSetHeight: items.length < 5 ? false : true,
          width: 200.sw,
          label: "",
          value: "",
          childBuilder: (isDropdownOpened) {
            return Row(
              children: [
                Text(
                  "Add to tour +".tr(),
                  style:
                      w400TextStyle(fontSize: 14.sw, color: appColorPrimary1),
                ),
                if (loading)
                  CupertinoActivityIndicator(
                    color: appColorPrimary1,
                    radius: 8.sw,
                  )
              ],
            );
          },
          itemsBuilder: (hide, controller) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items
                    .where((e) =>
                        controller.text.trim().isEmpty ||
                        e.label!.isContainsASCII(controller.text.trim()))
                    .map<Widget>((e) => _buildLanguageItem(hide, e))
                    .toList(),
              ),
            );
          },
        ).ignore(loading);
      },
    );
  }

  Widget _buildLanguageItem(hide, TravelTour m) {
    return WidgetDropSelectorItem(
      onTap: () async {
        _save(m);
        await hide();
      },
      isSelected: false,
      maxLines: 3,
      label: m.label ?? "",
    );
  }

  HereRoute? routeInfoToSave;
  Routes? get routeAvailiableToSave =>
      routeInfoToSave?.routes?.isNotEmpty == true
          ? routeInfoToSave?.routes?.first
          : null;
  _fetchRouterToSave(items) async {
    routeInfoToSave = await HereRoutingRepo().routes({
      "transportMode": "pedestrian",
      "origin":
          "${items.first.latLng.latitude},${items.first.latLng.longitude}",
      "destination":
          "${items.last.latLng.latitude},${items.last.latLng.longitude}",
      "via": items
          .sublist(1, items.length - 1)
          .map((e) => "${e.latLng.latitude},${e.latLng.longitude}")
          .toList(),
      "return": "polyline,summary",
      "apikey": hereMapApiKey,
    });
  }

  int get totalLengthInMetToSave {
    int met = 0;
    routeAvailiableToSave?.sections?.forEach((e) {
      met += e.summary?.length ?? 0;
    });
    return met;
  }

  int get totalDurationInSecToSave {
    int second = 0;
    routeAvailiableToSave?.sections?.forEach((e) {
      second += e.summary?.duration ?? 0;
    });
    return second;
  }

  bool loading = false;
  _save(TravelTour tour) async {
    setState(() {
      loading = true;
    });
    List<PointInterest> items = tour.jsonPoints + [m];
    await _fetchRouterToSave(items);
    bool status = await PointsRepo().updateTravelTourByAdmin({
      "travelTourId": tour.id,
      "json": {
        "points": items.map((e) => e.toJson(isRemoveDesc: true)).toList(),
        "durationInSec": totalDurationInSecToSave,
        "totalLengthInMet": totalLengthInMetToSave,
        "countryCode": tour.json?["countryCode"],
        "countryName": tour.json?["countryName"],
        "cityName": tour.json?["cityName"],
        "sections":
            routeAvailiableToSave?.sections?.map((e) => e.toJson()).toList()
      },
      "numberOfPoints": items.length,
    });
    if (status) {
      travelmeitToursBloc.add(const SelectTravelmeitToursEvent());
    }
    loading = false;
    if (mounted) setState(() {});
  }
}

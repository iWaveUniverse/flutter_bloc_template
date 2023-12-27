// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:_private_core_network/network_resources/google_place/google_place_repo.dart';
import 'package:_private_core_network/network_resources/google_place/models/models.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'package:temp_package_name/src/presentation/widgets/widget_popup_container.dart';

class WidgetSearchPlaceBuilder extends StatefulWidget {
  final Widget Function(ValueChanged onChanged,
      TextEditingController controller, bool loading) builder;
  final TextEditingController? controller;
  final ValueChanged<SeachPlaceResultDetailModel> onSubmitted;
  final String? countryCode;
  final ValueChanged<LatLng>? onChangedFocusMap;
  final Future<List<AutocompletePrediction>> Function(String)?
      googlePlaceAutoComplete;

  final bool isUpDirection;
  final bool visible;

  const WidgetSearchPlaceBuilder({
    super.key,
    this.controller,
    this.countryCode,
    this.onChangedFocusMap,
    required this.builder,
    required this.onSubmitted,
    this.googlePlaceAutoComplete,
    this.isUpDirection = true,
    this.visible = true,
  });

  @override
  State<WidgetSearchPlaceBuilder> createState() =>
      _WidgetSearchPlaceBuilderState();
}

class _WidgetSearchPlaceBuilderState extends State<WidgetSearchPlaceBuilder> {
  final ValueNotifier<List<AutocompletePrediction>> _searchPlaces =
      ValueNotifier([]);
  AutocompletePrediction? _autocompletePrediction;
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;

  Timer? _debounce;
  bool loading = false;

  _onChanged(query) {
    setState(() {
      loading = true;
    });
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      _searchPlaces.value = [];
      setState(() {
        loading = true;
      });
      _searchPlaces.value =
          await (widget.googlePlaceAutoComplete?.call(query) ??
              GooglePlaceRepo().googlePlaceAutoComplete(query,
                  language: appPrefs.languageCode,
                  countryCode: widget.countryCode));
      setState(() {
        loading = false;
      });
    });
  }

  _detailPlaceGoogle(p) async {
    _autocompletePrediction = p;
    setState(() {});

    try {
      SeachPlaceResultDetailModel? placeDetail = await GooglePlaceRepo()
          .googlePlaceSearchById({
        "placeId": _autocompletePrediction!.placeId,
        "language": appPrefs.languageCode
      });
      if (placeDetail?.geometry?.location?.lng != null) {
        widget.onSubmitted.call(placeDetail!);
        _searchPlaces.value = [];
        widget.onChangedFocusMap?.call(LatLng(
            placeDetail.geometry!.location!.lat!,
            placeDetail.geometry!.location!.lng!));
      }
    } catch (e) {
      print('_detailPlaceGoogle error: $e');
    }
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _textEditingController = widget.controller ?? TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_textEditingController.text.isNotEmpty) {
        _onChanged(_textEditingController.text);
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textEditingController.dispose();
    }
    _focusNode.dispose();
    _searchPlaces.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _searchPlaces,
      builder: (_, value, child) {
        int count = min(_searchPlaces.value.length, 3);
        return PortalTarget(
          visible: _textEditingController.text.isNotEmpty &&
              _searchPlaces.value.isNotEmpty &&
              widget.visible,
          anchor: Aligned(
              follower: widget.isUpDirection
                  ? Alignment.bottomLeft
                  : Alignment.topLeft,
              target: widget.isUpDirection
                  ? Alignment.topLeft
                  : Alignment.bottomLeft,
              offset: Offset(0, widget.isUpDirection ? -12 : 12)),
          portalFollower: WidgetPopupContainer(
            isScrollableIcon: _searchPlaces.value.length > 3,
            width: 380,
            height: 74 * count + 1 * (count - 1),
            alignmentTail: !widget.isUpDirection
                ? Alignment.topLeft
                : Alignment.bottomLeft,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                AutocompletePrediction p = _searchPlaces.value[index];
                List<String> full = (p.description ?? '').split(',');
                String address = '';
                String country = full.length > 2
                    ? '${full[full.length - 2]}, ${full.last}'
                    : '';
                if (full.length > 2) {
                  for (int i = 0; i < full.length - 2; i++) {
                    address += '${full[i]} ';
                  }
                }
                return WidgetInkWellTransparent(
                  onTap: () {
                    _textEditingController.text = p.description ?? "";
                    _detailPlaceGoogle(p);
                  },
                  child: Ink(
                    height: 74.sw,
                    padding: const EdgeInsets.only(left: 16, right: 18),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(24.sw),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: w500TextStyle(
                                    fontSize: fs16(context),
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                Gap(8.sw),
                                Text(
                                  country,
                                  style: w300TextStyle(
                                    fontSize: fs12(context),
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: _searchPlaces.value.length,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.sw),
                  height: 1,
                  color: const Color(0xFFEDEEF3),
                );
              },
            ),
          ),
          child: widget.builder(_onChanged, _textEditingController, loading),
        );
      },
    );
  }
}

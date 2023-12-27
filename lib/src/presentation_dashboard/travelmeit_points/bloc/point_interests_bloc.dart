import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_category.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_interest.dart';
import 'package:temp_package_name/src/network_resources/points/repo.dart';
import 'package:temp_package_name/src/utils/utils.dart';

part 'point_interests_event.dart';
part 'point_interests_state.dart';

TravelmeitPointsBloc get travelmeitPointsBloc =>
    findInstance<TravelmeitPointsBloc>();

class TravelmeitPointsBloc
    extends Bloc<TravelmeitPointsEvent, TravelmeitPointsState> {
  TravelmeitPointsBloc()
      : super(TravelmeitPointsState(categoriesSelected: [])) {
    on<InitTravelmeitPointsEvent>(_init);
    on<FetchTravelmeitPointsEvent>(_fetch);
    on<SelectTravelmeitPointsEvent>(_seletcPoints);
    on<UpdateTravelmeitPointsEvent>(_update);
    on<UpdateFilterTravelmeitPointsEvent>(_filter);
  }

  LatLng? latestLatLng;
  double? zoomLevel;

  _filter(UpdateFilterTravelmeitPointsEvent event, emit) {
    state.itemSelected = null;
    state.isPointDetailView = false;
    if (event.clearCountryCode) state.countryCode = null;
    if (event.clearDisplay) state.display = null;
    if (event.clearCategories) state.categoriesSelected = [];
    emit(state.update(
      items: [],
      categoriesSelected: event.categories,
      countryCode: event.countryCode,
      display: event.display,
    ));
    add(FetchTravelmeitPointsEvent(page: 1, callback: event.callback));
  }

  _init(event, emit) async {
    if (state.categories?.isNotEmpty != true) {
      List<PointCategory> categories =
          AppPrefs.instance.getPoiCustomCategories.isNotEmpty
              ? AppPrefs.instance.getPoiCustomCategories
              : await PointsRepo().getPoiCustomCategories();
      emit(state.update(categories: categories));
      // if (state.categoriesSelected.isNotEmpty != true) {
      //   emit(state.update(categoriesSelected: categories));
      // }
    }
    add(const FetchTravelmeitPointsEvent());
  }

  _fetch(FetchTravelmeitPointsEvent event, emit) async {
    state.page = event.page ?? state.page;
    state.pageSize = event.pageSize ?? state.pageSize;
    emit(state.update(items: [], isFetching: event.isAlsoRemoveOld));
    Map<String, dynamic> params = {
      'page': state.page,
      'pageSize': state.pageSize,
      // "maxDistance": 50000 * (kDebugMode ? 1 : 1),
      // "maxDistance": state.maxDistanceInMet,
      // "lat": AppGeolocator.latLng.latitude,
      // "lng": AppGeolocator.latLng.longitude,
      "countryCode": state.countryCode,
      "display": state.display,
    };
    params.removeWhere((key, value) => value == null);
    // if (state.popularityIndex != 3) {
    //   params.addAll({
    //     "rate": "${state.popularityIndex + 1}${state.isHeritage ? "h" : ""}"
    //   });
    // }
    if (state.categoriesSelected.isNotEmpty) {
      String customCatIds = "";
      for (var e in state.categoriesSelected) {
        customCatIds += "${e.id},";
      }
      customCatIds = customCatIds.substring(0, customCatIds.length - 1);
      params.addAll({"customCatIds": customCatIds});
    }
    List<PointInterest>? points = await PointsRepo().getPoiFromAdmin(params);
    // AppPrefs.instance.points = pointsByCategory?.points;
    // AppPrefs.instance.latLng = AppGeolocator.latLng;
    emit(state.update(items: points, isFetching: false));
    event.callback?.call();
  }

  _seletcPoints(SelectTravelmeitPointsEvent event, emit) {
    if (event.point == null) {
      add(const FetchTravelmeitPointsEvent());
    }
    state.itemSelected = event.point;
    emit(state.update(isPointDetailView: event.point != null));
  }

  Timer? _debounce;
  _update(UpdateTravelmeitPointsEvent event, emit) {
    emit(state.update(
      categoriesSelected: event.categories,
      isHeritage: event.isHeritage,
      popularityIndex: event.popularityIndex,
      maxDistanceInMet: event.maxDistanceInMet,
    ));

    if ((event.isHeritage != null ||
            event.popularityIndex != null ||
            event.categories != null ||
            event.maxDistanceInMet != null) &&
        event.fetchPoints) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 2), () {
        add(const FetchTravelmeitPointsEvent(page: 1));
      });
    }
  }
}

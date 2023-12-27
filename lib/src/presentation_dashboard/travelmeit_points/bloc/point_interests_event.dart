part of 'point_interests_bloc.dart';

sealed class TravelmeitPointsEvent extends Equatable {
  const TravelmeitPointsEvent();

  @override
  List<Object> get props => [];
}

class InitTravelmeitPointsEvent extends TravelmeitPointsEvent {}

class UpdateFilterTravelmeitPointsEvent extends TravelmeitPointsEvent {
  final String? countryCode;
  final bool clearCountryCode;
  final int? display;
  final bool clearDisplay;
  final List<PointCategory>? categories;
  final bool clearCategories;
  final VoidCallback? callback;
  const UpdateFilterTravelmeitPointsEvent({
    this.callback,
    this.countryCode,
    this.clearCountryCode = false,
    this.display,
    this.clearDisplay = false,
    this.categories,
    this.clearCategories = false,
  });
}

class FetchTravelmeitPointsEvent extends TravelmeitPointsEvent {
  final int? page;
  final int? pageSize;
  final bool isAlsoRemoveOld;
  final VoidCallback? callback;
  const FetchTravelmeitPointsEvent({
    this.callback,
    this.page,
    this.pageSize,
    this.isAlsoRemoveOld = true,
  });
}

class SelectTravelmeitPointsEvent extends TravelmeitPointsEvent {
  final PointInterest? point;
  const SelectTravelmeitPointsEvent([this.point]);
}

class UpdateTravelmeitPointsEvent extends TravelmeitPointsEvent {
  final List<PointCategory>? categories;
  final int? popularityIndex;
  final bool? isHeritage;
  final int? maxDistanceInMet;
  final bool fetchPoints;
  const UpdateTravelmeitPointsEvent({
    this.categories,
    this.popularityIndex,
    this.isHeritage,
    this.maxDistanceInMet,
    this.fetchPoints = true,
  });
}

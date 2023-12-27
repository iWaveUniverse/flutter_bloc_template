part of 'point_interests_bloc.dart';

class TravelmeitPointsState {
  List<PointInterest>? items;
  int page;
  int pageSize;

  PointInterest? itemSelected;
  bool isPointDetailView;
  bool isFetching;

  final List<PointCategory>? categories;
  List<PointCategory> categoriesSelected;

  final int popularityIndex;
  final bool isHeritage;
  final int maxDistanceInMet;
  String? countryCode;
  int? display;

  TravelmeitPointsState({
    this.items,
    this.page = 1,
    this.pageSize = 50,
    this.itemSelected,
    this.isPointDetailView = false,
    this.isFetching = true,
    this.categories,
    required this.categoriesSelected,
    this.isHeritage = false,
    this.popularityIndex = 3,
    this.maxDistanceInMet = 50 * 1000,
    this.display = 1,
    this.countryCode,
  });

  TravelmeitPointsState update({
    List<PointInterest>? items,
    PointInterest? itemSelected,
    bool? isPointDetailView,
    bool? isFetching,
    List<PointCategory>? categories,
    List<PointCategory>? categoriesSelected,
    int? popularityIndex,
    bool? isHeritage,
    int? maxDistanceInMet,
    int? page,
    int? pageSize,
    int? display,
    String? countryCode,
  }) {
    return TravelmeitPointsState(
      items: items ?? this.items,
      isPointDetailView: isPointDetailView ?? this.isPointDetailView,
      itemSelected: itemSelected ?? this.itemSelected,
      isFetching: isFetching ?? this.isFetching,
      categories: categories ?? this.categories,
      categoriesSelected: categoriesSelected ?? this.categoriesSelected,
      popularityIndex: popularityIndex ?? this.popularityIndex,
      isHeritage: isHeritage ?? this.isHeritage,
      maxDistanceInMet: maxDistanceInMet ?? this.maxDistanceInMet,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      display: display ?? this.display,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}

String getPopularFromRate(String? rate) {
  if (rate == null || rate.isEmpty) return populars[0];
  if (int.parse(rate.substring(0, 1)) - 1 == -1) return "";
  return populars[int.parse(rate.substring(0, 1)) - 1];
}

bool isHeritage(String? rate) {
  if (rate == null) return false;
  return rate.endsWith('h');
}

List<String> get populars => [
      "Highly".tr(),
      "Medium".tr(),
      "Low".tr(),
    ];

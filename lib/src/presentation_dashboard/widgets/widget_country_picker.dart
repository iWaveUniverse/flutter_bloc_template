import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:_private_core_network/network_resources/country/models/country_available.dart';
import 'package:_private_core_network/network_resources/language/language_repo.dart';
import 'package:_private_core_network/network_resources/language/models/language_available.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_package_name/src/base/main/bloc/main_bloc.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/utils/utils.dart';

class WidgetCountryHorizPicker extends StatefulWidget {
  final String? initCurrentIso;
  final ValueChanged<CountryAvailable> onChanged;
  const WidgetCountryHorizPicker(
      {super.key, required this.onChanged, this.initCurrentIso});

  @override
  State<WidgetCountryHorizPicker> createState() =>
      _WidgetCountryHorizPickerState();
}

class _WidgetCountryHorizPickerState extends State<WidgetCountryHorizPicker> {
  late int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      bloc: mainBloc,
      builder: (context, state) {
        if (state.countriesAvaliable?.isNotEmpty != true) {
          return const SizedBox();
        }
        List<CountryAvailable> countries =
            List.from(state.countriesAvaliable!.where((e) => true));
        if (_selectedIndex == -1) {
          if (widget.initCurrentIso == null) {
            _selectedIndex = 0;
          } else {
            _selectedIndex =
                countries.indexWhere((e) => e.iso == widget.initCurrentIso!);
          }
        }

        return ClipRRect(
          child: SizedBox(
            height: 88.sw + 16.sw,
            child: ListView.separated(
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                CountryAvailable country = countries[index];
                return WidgetInkWellTransparent(
                  onTap: () {
                    _selectedIndex = index;
                    setState(() {});
                    widget.onChanged(country);
                  },
                  child: Container(
                    height: 88.sw,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: index == _selectedIndex
                            ? [
                                BoxShadow(
                                    color: hexColor('#ACACAC').withOpacity(.25),
                                    blurRadius: 12.sw)
                              ]
                            : [],
                        color: index == _selectedIndex
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16.sw)),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        WidgetAppFlag.countryCode(
                          countryCode: country.iso,
                          height: 24.sw,
                          radius: 6.sw,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 160.sw),
                          child: Text(
                            getCountryName(country.iso),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: w400TextStyle(
                                fontSize: 16.sw,
                                color: index == _selectedIndex
                                    ? appColorText
                                    : appColorText.withOpacity(.5)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => SizedBox(width: 16.sw),
              itemCount: countries.length,
            ),
          ),
        );
      },
    );
  }
}

class WidgetLanguageHorizPicker extends StatefulWidget {
  final String? initLanguageCode;
  final ValueChanged<LanguageAvailable> onChanged;
  const WidgetLanguageHorizPicker(
      {super.key, required this.onChanged, this.initLanguageCode});

  @override
  State<WidgetLanguageHorizPicker> createState() =>
      _WidgetLanguageHorizPickerState();
}

class _WidgetLanguageHorizPickerState extends State<WidgetLanguageHorizPicker> {
  late int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      bloc: mainBloc,
      builder: (context, state) {
        if (state.languagesAvailable?.isNotEmpty != true) {
          return const SizedBox();
        }
        List<LanguageAvailable> countries =
            List.from(state.languagesAvailable!.where((e) => true));
        if (_selectedIndex == -1) {
          if (widget.initLanguageCode == null) {
            _selectedIndex = 0;
          } else {
            _selectedIndex =
                countries.indexWhere((e) => e.code == widget.initLanguageCode!);
          }
        }

        return ClipRRect(
          child: SizedBox(
            height: 88.sw + 16.sw,
            child: ListView.separated(
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                LanguageAvailable country = countries[index];
                return WidgetInkWellTransparent(
                  onTap: () {
                    _selectedIndex = index;
                    setState(() {});
                    widget.onChanged(country);
                  },
                  child: Container(
                    height: 88.sw,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: index == _selectedIndex
                            ? [
                                BoxShadow(
                                    color: hexColor('#ACACAC').withOpacity(.25),
                                    blurRadius: 12.sw)
                              ]
                            : [],
                        color: index == _selectedIndex
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16.sw)),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        WidgetAppFlag.languageCode(
                          languageCode: country.code,
                          height: 24.sw,
                          radius: 6.sw,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 160.sw),
                          child: Text(
                            "${country.code}".tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: w400TextStyle(
                                fontSize: 16.sw,
                                color: index == _selectedIndex
                                    ? appColorText
                                    : appColorText.withOpacity(.5)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) => SizedBox(width: 16.sw),
              itemCount: countries.length,
            ),
          ),
        );
      },
    );
  }
}

class WidgetLanguagesHorizPickerByKey extends StatefulWidget {
  final String? initLanguageCode;
  final ValueChanged<String> onChanged;
  final String keyword;
  const WidgetLanguagesHorizPickerByKey({
    super.key,
    required this.onChanged,
    this.initLanguageCode,
    required this.keyword,
  });

  @override
  State<WidgetLanguagesHorizPickerByKey> createState() =>
      _WidgetLanguagesHorizPickerByKeyState();
}

class _WidgetLanguagesHorizPickerByKeyState
    extends State<WidgetLanguagesHorizPickerByKey> {
  late int _selectedIndex = -1;
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  List<LanguageAvailable>? languagesAvailable;
  _fetch() async {
    if (localgetLanguageAvailableByKeyword[widget.keyword] is List &&
        (localgetLanguageAvailableByKeyword[widget.keyword] as List)
            .isNotEmpty) {
      languagesAvailable = localgetLanguageAvailableByKeyword[widget.keyword];
    } else {
      languagesAvailable = await LanguageRepo().getLanguageAvailableByKeyword({
        "keyword": widget.keyword,
      });
      localgetLanguageAvailableByKeyword[widget.keyword] = languagesAvailable;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (languagesAvailable == null) return const SizedBox();
    List<LanguageAvailable> langs = List.from(languagesAvailable!);
    if (_selectedIndex == -1) {
      if (widget.initLanguageCode == null) {
        _selectedIndex = 0;
      } else {
        _selectedIndex =
            langs.indexWhere((e) => e.code == widget.initLanguageCode!);
      }
    }

    return ClipRRect(
      child: SizedBox(
        height: 88.sw + 16.sw,
        child: ListView.separated(
          clipBehavior: Clip.none,
          padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            LanguageAvailable m = langs[index];
            return WidgetInkWellTransparent(
              onTap: () {
                _selectedIndex = index;
                setState(() {});
                widget.onChanged(m.code!);
              },
              child: Container(
                height: 88.sw,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    boxShadow: index == _selectedIndex
                        ? [
                            BoxShadow(
                                color: hexColor('#ACACAC').withOpacity(.25),
                                blurRadius: 12.sw)
                          ]
                        : [],
                    color: index == _selectedIndex
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.sw)),
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    WidgetAppFlag.languageCode(
                      languageCode: m.code,
                      height: 24.sw,
                      radius: 6.sw,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 160.sw),
                      child: Text(
                        m.language ?? getLanguageName(m),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: w400TextStyle(
                            fontSize: 16.sw,
                            color: index == _selectedIndex
                                ? appColorText
                                : appColorText.withOpacity(.5)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, index) => SizedBox(width: 16.sw),
          itemCount: langs.length,
        ),
      ),
    );
  }
}

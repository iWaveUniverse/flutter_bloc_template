import 'dart:async';

import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:_private_core_network/network_resources/resources.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:temp_package_name/src/network_resources/points/model/point_interest.dart';
import 'package:temp_package_name/src/network_resources/points/repo.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_app_map.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_app_switcher.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_copyable.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_country_picker.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_drop_selector.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_input_label.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_popup_container.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_ximage.dart';
import 'package:temp_package_name/src/utils/utils.dart';

import '../bloc/point_interests_bloc.dart';
import 'widget_dialog_gpt_generate.dart';

class WidgetDetailPoint extends StatefulWidget {
  final PointInterest m;
  const WidgetDetailPoint({super.key, required this.m});

  @override
  State<WidgetDetailPoint> createState() => _WidgetDetailPointState();
}

class _WidgetDetailPointState extends State<WidgetDetailPoint> {
  late PointInterest m = widget.m;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController shortController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  String? languageCode = AppPrefs.instance.languageCode;

  onChanged(_) async {
    int index = details.indexWhere((e) => e.languageCode == languageCode);
    final r = await PointsRepo().updatePoiDetails({
      "poiId": m.id,
      "languageCode": languageCode,
      "title": titleController.text.trim(),
      "shortDescription": shortController.text.trim(),
      "longDescription": longController.text.trim(),
    });
    if (r) {
      details[index].title = titleController.text.trim();
      details[index].shortDescription = shortController.text.trim();
      details[index].longDescription = longController.text.trim();
      if (mounted) {
        setState(() {});
        await _initialize();
        if (mounted) _updateExistingTrans();
      }
    }
  }

  _update(value) async {
    setState(() {
      m.display = value;
    });
    var r = await PointsRepo().updatePoiByAdmin({
      "id": m.id,
      "display": m.display,
    });
    if (r == true) {
      // travelmeitPointsBloc.add(const FetchTravelmeitPointsEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  List<PoiDetail> details = [];
  bool loading = false;
  _initialize() async {
    setState(() {
      loading = true;
    });
    details = await PointsRepo().getPoiDetailsFromAdmin({"poiId": widget.m.id});
    loading = false;
    if (mounted) {
      setState(() {});
      _updateExistingTrans();
    }
  }

  _updateExistingTrans() {
    PoiDetail m = details.firstWhere((e) => e.languageCode == languageCode,
        orElse: () => PoiDetail());

    titleController.text = m.title ?? "";
    shortController.text = m.shortDescription ?? "";
    longController.text = m.longDescription ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24.sw, right: 24.sw),
          child: Row(
            children: [
              _buildPics(),
              Gap(16.sw),
              _buildContent(),
            ],
          ),
        ),
        _WidgetBaseInfos(m: m),
      ],
    );
  }

  Widget _buildPics() {
    return Expanded(
      flex: 480,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(24.sw + 62.sw),
            Text(
              "Main Picture".tr(),
              style: w400TextStyle(fontSize: 18.sw),
            ),
            Gap(16.sw),
            _WidgetItemImage(
              isMainPic: true,
              m: m.mainPictureUrl,
              poiId: m.id,
            ),
            Gap(20.sw),
            Text(
              "Gallery".tr(),
              style: w400TextStyle(fontSize: 18.sw),
            ),
            Gap(16.sw),
            LayoutBuilder(builder: (_, p) {
              return Wrap(
                runSpacing: 16.sw,
                spacing: 16.sw,
                children: List.generate(
                  8,
                  (index) => SizedBox(
                    width: (p.maxWidth - 16.sw) / 2,
                    height: ((p.maxWidth - 16.sw) / 2) / (400 / 350),
                    child: _WidgetItemImage(
                      isMainPic: false,
                      poiId: m.id,
                      index: index,
                      m: index < (m.galleryPictureUrl?.length ?? 0)
                          ? m.galleryPictureUrl![index]
                          : null,
                      onChanged: (value) {
                        if (value == null &&
                            m.galleryPictureUrl!.length > index) {
                          m.galleryPictureUrl!.removeAt(index);
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              );
            }),
            Gap(24.sw),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      flex: 950,
      child: Column(
        children: [
          Gap(24.sw + 66.sw),
          WidgetLanguagesHorizPickerByKey(
            keyword: "travelmeitGuidesAvailable",
            initLanguageCode: languageCode,
            onChanged: (code) {
              setState(() {
                languageCode = code;
              });
              _updateExistingTrans();
            },
          ),
          Gap(16.sw),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.sw),
                  border: Border.all(color: Colors.white),
                  color: hexColor('#EBEBEB')),
              child: Column(
                children: [
                  Container(
                    height: 58.sw,
                    padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          "  id:  ".tr(),
                          style: w400TextStyle(
                              fontSize: 16.sw, color: appColorLabel),
                        ),
                        Text(
                          "${m.id}    ".tr(),
                          style: w500TextStyle(fontSize: 16.sw),
                        ),
                        WidgetCopyable(
                          text: "${m.xid}",
                          child: Row(
                            children: [
                              Text(
                                "  xid:  ".tr(),
                                style: w400TextStyle(
                                    fontSize: 16.sw, color: appColorLabel),
                              ),
                              Text(
                                "${m.xid}    ".tr(),
                                style: w500TextStyle(fontSize: 16.sw),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Display".tr(),
                          style: w400TextStyle(
                              fontSize: 16.sw, color: appColorLabel),
                        ),
                        Gap(12.sw),
                        WidgetAppSwitcher(
                          onToggle: (_) {
                            _update(_ ? 1 : 0);
                          },
                          value: m.display == 1,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.sw,
                    color: hexColor('#E2E1E3'),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.sw),
                        child: Column(
                          children: [
                            WidgetAppInputLabel(
                              label: 'Title',
                              controller: titleController,
                              onUnFocus: onChanged,
                              maxLength: 100,
                            ),
                            Gap(24.sw),
                            WidgetAppInputLabel(
                              label: 'Short Description',
                              labelIcon: Row(
                                children: [
                                  WidgetCopyable(
                                    text: shortController.text,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: WidgetAppSVG(
                                        'ic_copy',
                                        width: 16.sw,
                                      ),
                                    ),
                                  ),
                                  Gap(12.sw),
                                  WidgetInkWellTransparent(
                                    onTap: () async {
                                      final r = await appDialog(
                                          WidgetDialogGPTGenerate(
                                              isShortDesc: true,
                                              languageCode: languageCode,
                                              label: "Short Description",
                                              content: shortController.text));
                                      if (r is String) {
                                        shortController.text = r;
                                        onChanged("");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: WidgetAppSVG(
                                        'ic_gpt_generate',
                                        width: 16.sw,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              height: 140.sw,
                              maxLine: 6,
                              controller: shortController,
                              onUnFocus: onChanged,
                            ),
                            Gap(24.sw),
                            WidgetAppInputLabel(
                              label: 'Long Description',
                              labelIcon: Row(
                                children: [
                                  WidgetCopyable(
                                    text: longController.text,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: WidgetAppSVG(
                                        'ic_copy',
                                        width: 16.sw,
                                      ),
                                    ),
                                  ),
                                  Gap(12.sw),
                                  WidgetInkWellTransparent(
                                    onTap: () async {
                                      final r = await appDialog(
                                          WidgetDialogGPTGenerate(
                                              languageCode: languageCode,
                                              label: "Long Description",
                                              content: longController.text));
                                      if (r is String) {
                                        longController.text = r;
                                        onChanged("");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: WidgetAppSVG(
                                        'ic_gpt_generate',
                                        width: 16.sw,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              height: 300.sw,
                              maxLine: 20,
                              controller: longController,
                              onUnFocus: onChanged,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(16.sw),
        ],
      ),
    );
  }
}

Future<FilePickerResult?> _pickImage({allowMultiple = false}) async {
  return await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png']);
}

class _WidgetItemImage extends StatefulWidget {
  final CommonMedia? m;
  final dynamic poiId;
  final bool isMainPic;
  final ValueChanged<CommonMedia?>? onChanged;
  final int index;
  const _WidgetItemImage({
    this.m,
    required this.poiId,
    required this.isMainPic,
    this.onChanged,
    this.index = 0,
  });

  @override
  State<_WidgetItemImage> createState() => __WidgetItemImageState();
}

class __WidgetItemImageState extends State<_WidgetItemImage> {
  CommonMedia? pic;
  bool isDraging = false;
  XFile? xfile;
  late ValueNotifier<double> progress =
      ValueNotifier(widget.m?.smallPic != null ? 1 : 0);

  _delete({bool deleteForReplace = false}) async {
    xfile = null;
    if (mounted) setState(() {});
    await PointsRepo().removeGalleryPicForPoi({
      "poiId": widget.poiId,
      "galleryIds": [widget.m?.id ?? pic?.id]
    });
    progress.value = 0;
    widget.onChanged?.call(null);
  }

  onPickToUpload() async {
    FilePickerResult? result = await _pickImage(allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      if (result.files.length == 1) {
        xfile = XFile('',
            bytes: result.files.first.bytes, name: result.files.first.name);
        setState(() {});
        _upload();
      } else {
        xfile = XFile('',
            bytes: result.files.first.bytes, name: result.files.first.name);
        setState(() {});
        _upload();
        // _bloc.uploadMultiFiles(
        //     List.generate(result.files.sublist(1).length, (i) => 0 + i),
        //     result.files
        //         .sublist(1)
        //         .map((e) => XFile('', bytes: e.bytes, name: e.name))
        //         .toList());
      }
    }
  }

  _upload() async {
    pic = await (widget.isMainPic
        ? PointsRepo().setMainPicForPoi(
            await compressTooBigImage(await xfile!.readAsBytes()),
            xfile!.name,
            widget.poiId,
            345 / 264, (int count, int total) {
            progress.value = count / total;
          })
        : PointsRepo().setGalleryPicForPoi(
            await compressTooBigImage(await xfile!.readAsBytes()),
            xfile!.name,
            widget.poiId,
            widget.m?.id,
            345 / 264, (int count, int total) {
            progress.value = count / total;
          }));
    if (pic != null) {
      widget.onChanged?.call(pic);
      progress.value = 1;
      setState(() {});
    } else {
      progress.value = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 400 / 350,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.sw),
        child: DropTarget(
          onDragDone: (detail) {
            var xfiles =
                detail.files.where((e) => isImageByMime(e.mimeType)).toList();
            if (xfiles.isNotEmpty) {
              if (xfiles.length == 1) {
                xfile =
                    detail.files.where((e) => isImageByMime(e.mimeType)).first;
                setState(() {});
                _upload();
              } else {
                xfile = xfiles.first;
                setState(() {});
                _upload();
              }
            }
          },
          onDragEntered: (detail) {
            setState(() {
              isDraging = true;
            });
          },
          onDragExited: (detail) {
            setState(() {
              isDraging = false;
            });
          },
          child: WidgetInkWellTransparent(
            onTap: onPickToUpload,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(16.sw),
              padding: const EdgeInsets.all(4),
              dashPattern: const [8, 8],
              color: hexColor('#C7C5C9'),
              strokeWidth: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: hexColor('#FAFAFA'),
                    borderRadius: BorderRadius.circular(16.sw)),
                child: (xfile == null && widget.m?.smallPic == null)
                    ? Center(
                        child: isDraging
                            ? Text(
                                'Drop here'.tr(),
                                textAlign: TextAlign.center,
                                style: w400TextStyle(
                                    fontSize: fs16(context),
                                    color: appColorPrimary1),
                              )
                            : Text(
                                'open Navigator\nDrag & drop'.tr(),
                                textAlign: TextAlign.center,
                                style: w400TextStyle(fontSize: fs14(context)),
                              ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16.sw),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            if (xfile != null)
                              Image(
                                image: XFileImage(xfile!),
                                fit: BoxFit.cover,
                                width: context.width,
                                height: context.height,
                              )
                            else
                              WidgetAppImage(
                                boxFit: BoxFit.cover,
                                width: context.width,
                                height: context.height,
                                imageUrl: widget.m?.smallPic,
                              ),
                            _buildLoading()
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

  Widget _buildLoading() {
    return WidgetGlassBackground(
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      backgroundColor: Colors.black12,
      blur: 4,
      child: Container(
        height: widget.isMainPic ? 50.sw8 : 44.sw8,
        padding:
            EdgeInsets.symmetric(horizontal: widget.isMainPic ? 24.sw : 16.sw),
        alignment: Alignment.center,
        child: ValueListenableBuilder(
            valueListenable: progress,
            builder: (context, value, child) {
              if (value == -1) {
                return InkWell(
                  onTap: _upload,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Seem have problem when upload your image, try again?'
                              .tr(),
                          style: w200TextStyle(
                            fontSize: fs10(context),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Gap(8.sw),
                      Icon(
                        Icons.refresh,
                        size: 20.sw,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              }
              if (value == 1 && (widget.m?.smallPic != null || pic != null)) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        !widget.isMainPic
                            ? '${"Image".tr()} ${widget.index + 1}'
                            : 'Main pic'.tr(),
                        style: w200TextStyle(
                          fontSize: fs12(context),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.sw, vertical: 4.sw),
                      child: WidgetAppSVG(
                        'replace',
                        width: 20.sw,
                        height: 20.sw,
                      ),
                    ),
                    Container(
                      height: 16.sw,
                      width: 1,
                      color: Colors.white.withOpacity(.1),
                    ),
                    InkWell(
                      onTap: _delete,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.sw, vertical: 4.sw),
                        child: WidgetAppSVG(
                          'deletepic',
                          width: 20.sw,
                          height: 20.sw,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Files uploading:'.tr(),
                    style: w200TextStyle(
                      fontSize: fs12(context),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 2.sw,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearPercentIndicator(
                          padding: EdgeInsets.zero,
                          lineHeight: 6,
                          barRadius: const Radius.circular(99),
                          percent: value,
                          backgroundColor: Colors.grey,
                          progressColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 12.sw,
                      ),
                      Text(
                        value == 1 ? "Done".tr() : '${(value * 100).toInt()}%',
                        style: w200TextStyle(
                          fontSize: fs12(context),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class _WidgetBaseInfos extends StatefulWidget {
  final PointInterest m;
  const _WidgetBaseInfos({required this.m});

  @override
  State<_WidgetBaseInfos> createState() => __WidgetBaseInfosState();
}

class __WidgetBaseInfosState extends State<_WidgetBaseInfos> {
  late PointInterest m = widget.m;

  get point => m.lat != null
      ? LatLng(m.lat!.toDouble(), m.lng!.toDouble())
      : WidgetAppMap.defaultLatLng;

  Timer? _debounce;
  onChanged(_) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      setState(() {
        PointsRepo().updatePoi({
          "id": m.id,
          "catId": m.customCategory?.id,
          "rate": m.rate,
        });
      });
    });
  }

  bool isExplanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
          color: hexColor('#FAFAFA'),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.sw)),
          boxShadow: isExplanded
              ? [const BoxShadow(color: Colors.black12, blurRadius: 999)]
              : []),
      padding: EdgeInsets.symmetric(horizontal: 24.sw, vertical: 16.sw),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isExplanded)
              WidgetInkWellTransparent(
                onTap: () {
                  setState(() {
                    isExplanded = !isExplanded;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Base Informations".tr(),
                        style: w500TextStyle(fontSize: 18.sw),
                      ),
                    ),
                    WidgetAppSVG(
                      'ic_arrow_down',
                      width: 24.sw,
                      color: hexColor('#363853'),
                    )
                  ],
                ),
              )
            else ...[
              WidgetInkWellTransparent(
                onTap: () {
                  setState(() {
                    isExplanded = !isExplanded;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Filter".tr(),
                        style: w500TextStyle(fontSize: 18.sw),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 90,
                      child: WidgetAppSVG(
                        'ic_arrow_down',
                        width: 24.sw,
                        color: hexColor('#363853'),
                      ),
                    )
                  ],
                ),
              ),
              Gap(14.sw),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            WidgetAppInputLabel(
                              label: "Lng",
                              backgroundColor: hexColor('#F2F2F2'),
                              controller: TextEditingController(
                                  text: "${widget.m.lng}"),
                              enable: false,
                            ),
                            Gap(16.sw),
                            WidgetOverlayActions(
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
                                                label: state.categories![index]
                                                        .label ??
                                                    "",
                                                onTap: () {
                                                  hide();
                                                  m.customCategory =
                                                      state.categories![index];
                                                  setState(() {});
                                                  onChanged(_);
                                                },
                                              ),
                                              itemCount:
                                                  state.categories?.length ?? 0,
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
                                    return WidgetAppInputLabel(
                                      key: ValueKey(m.id),
                                      label: "Travelmeit custom category",
                                      controller: TextEditingController(
                                          text: m.customCategory?.label ?? ""),
                                      backgroundColor: hexColor('#F2F2F2'),
                                      suffixIcon: WidgetAppSVG(
                                        'ic_arrow_down',
                                        width: 24.sw,
                                        color: hexColor('#363853'),
                                      ),
                                    ).ignore(true);
                                  }),
                            ),
                            Gap(16.sw),
                            WidgetAppInputLabel(
                              label: "City name",
                              backgroundColor: hexColor('#F2F2F2'),
                              controller: TextEditingController(
                                  text: widget.m.cityName ?? ""),
                              enable: false,
                            ),
                            Gap(16.sw),
                          ],
                        )),
                        Gap(16.sw),
                        Expanded(
                            child: Column(
                          children: [
                            WidgetAppInputLabel(
                              label: "Lat",
                              backgroundColor: hexColor('#F2F2F2'),
                              controller: TextEditingController(
                                  text: "${widget.m.lat}"),
                              enable: false,
                            ),
                            Gap(16.sw),
                            WidgetOverlayActions(
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
                                              m.rate = "";
                                            } else {
                                              m.rate = "${index + 1}";
                                            }
                                            setState(() {});
                                            onChanged(_);
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
                                      key: ValueKey(m.id),
                                      label: "Importance",
                                      controller: TextEditingController(
                                          text: getPopularFromRate(m.rate)),
                                      backgroundColor: hexColor('#F2F2F2'),
                                      suffixIcon: WidgetAppSVG(
                                        'ic_arrow_down',
                                        width: 24.sw,
                                        color: hexColor('#363853'),
                                      ),
                                    ).ignore(true);
                                  }),
                            ),
                            Gap(16.sw),
                            WidgetAppInputLabel(
                              label: "Country",
                              backgroundColor: hexColor('#F2F2F2'),
                              controller: TextEditingController(
                                  text: getCountryName(m.countryCode)),
                              enable: false,
                            ),
                            Gap(16.sw),
                          ],
                        )),
                      ],
                    )),
                    Gap(16.sw),
                    Expanded(
                      child: SizedBox(
                        height: 420.sw,
                        child: WidgetAppMap(
                          key: ValueKey(point),
                          borderRadius: BorderRadius.circular(26.sw),
                          center: point,
                          zoom: 16,
                          buildMarkers: [
                            AppBuildMarker(
                                id: "${m.id}",
                                onTap: () {},
                                widget: CircleAvatar(
                                  radius: 48.sw / 2,
                                  backgroundColor:
                                      appColorPrimary1.withOpacity(.3),
                                  child: CircleAvatar(
                                    radius: 32.sw / 2,
                                    backgroundImage:
                                        AssetImage(assetjpg('travelmeitPoi')),
                                  ),
                                ),
                                latLng: LatLng(
                                    m.lat!.toDouble(), m.lng!.toDouble()))
                          ],
                          enableControllerCurrentPosition: false,
                          enableControllerHome: false,
                          controllerBuilder: (Widget child) {
                            return Positioned(
                              top: 12.sw,
                              right: 12.sw,
                              bottom: 12.sw,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (m.lat != null)
                                    WidgetAppOpenStreetMap(
                                      lat: m.lat?.toDouble(),
                                      lng: m.lng?.toDouble(),
                                    ),
                                  child,
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

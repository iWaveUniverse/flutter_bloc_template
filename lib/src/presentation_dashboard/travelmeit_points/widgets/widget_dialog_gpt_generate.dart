import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:temp_package_name/src/constants/app_colors.dart';
import 'package:temp_package_name/src/constants/app_styles.dart';
import 'package:temp_package_name/src/network_resources/ai/ai_repo.dart';
import 'package:temp_package_name/src/network_resources/ai/models/ai_bot.dart';
import 'package:temp_package_name/src/network_resources/ai/models/gpt_result.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_app_inkwell.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_buttons.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_container_home.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_input_label.dart';
import 'package:temp_package_name/src/presentation/widgets/widget_popup_container.dart';

class WidgetDialogGPTGenerate extends StatefulWidget {
  final String content;
  final String label;
  final String? languageCode;
  final bool isShortDesc;

  final VoidCallback? callbackCancel;
  final ValueChanged? callbackOk;
  final String? labelButtonOk;
  final String? labelButtonCancel;
  final bool? loadingButtonOk;

  final String? errorMessage;

  const WidgetDialogGPTGenerate({
    super.key,
    required this.content,
    required this.label,
    required this.languageCode,
    this.isShortDesc = false,
    this.callbackCancel,
    this.callbackOk,
    this.labelButtonOk,
    this.labelButtonCancel,
    this.loadingButtonOk,
    this.errorMessage,
  });

  @override
  State<WidgetDialogGPTGenerate> createState() =>
      _WidgetDialogGPTGenerateState();
}

class _WidgetDialogGPTGenerateState extends State<WidgetDialogGPTGenerate> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  List<String> models = [
    "travelmeit-short-desc",
    "travelmeit-short-desc-funny",
    "travelmeit-long-desc",
    "travelmeit-long-desc-funny"
  ];

  @override
  void initState() {
    super.initState();
    controller1.text = widget.content;
    _fetch();
  }

  List<AiBot> bots = [];
  AiBot? bot;
  _fetch() async {
    setState(() {
      loading = true;
    });
    bots = await AIRepo().getBotListFromPlatform({"params": 210});
    if (bots.isEmpty) {
      bots = models.map((e) => AiBot(promptPurpose: e)).toList();
    }
    bot = bots.firstWhere((e) =>
        e.promptPurpose ==
        (widget.isShortDesc
            ? "travelmeit-short-desc"
            : "travelmeit-long-desc"));
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
  }

  bool loading = false;
  GptResult? result;
  _gererate() async {
    setState(() {
      loading = true;
    });
    result = await AIRepo().askGpt({
      "promptPurpose": bot?.promptPurpose,
      "prompt":
          "${controller1.text} > return the description in languageCode = ${widget.languageCode}"
    });
    controller2.text = result?.data ?? "";
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetBaseDialog(
      color: hexColor('FAFAFA'),
      borderRadius: BorderRadius.circular(24.sw),
      padding: EdgeInsets.all(24.sw),
      width: 1280.sw6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          WidgetAppInputLabel(
            textlabelStyle: w500TextStyle(fontSize: 18.sw),
            label: '${widget.label} (input)',
            backgroundColor: Colors.white,
            textStyle: w400TextStyle(
                fontSize: 14.sw, height: 1.6, color: hexColor('#57535D')),
            // labelIcon: WidgetInkWellTransparent(
            //   onTap: () {
            //     context.pop();
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.all(4.0),
            //     child: Icon(
            //       Icons.close,
            //       size: 20.sw,
            //       weight: .6,
            //     ),
            //   ),
            // ),
            onChanged: (_) {
              setState(() {});
            },
            height: 200.sw,
            maxLine: 8,
            controller: controller1,
          ),
          Gap(14.sw),
          Text(
            "Bot",
            style: w400TextStyle(fontSize: 14.sw, color: hexColor('#57535D')),
          ),
          Gap(8.sw),
          Row(
            children: [
              WidgetOverlayActions(
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
                          children: bots
                              .map((e) => WidgetAppInkWell(
                                    onTap: () async {
                                      await hide();
                                      bot = e;
                                    },
                                    child: Ink(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.sw, horizontal: 16.sw),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              e.promptPurpose ?? "",
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
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  );
                },
                childBuilder: (isDropdownOpened) => Container(
                  height: 48.sw8,
                  width: 300.sw,
                  padding: EdgeInsets.symmetric(horizontal: 16.sw),
                  decoration: BoxDecoration(
                    color: hexColor('#F2F2F2'),
                    borderRadius: BorderRadius.circular(16.sw),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          bot?.promptPurpose ?? "-",
                          style: w400TextStyle(
                            fontSize: 16.sw,
                            color: hexColor('#2C2830'),
                          ),
                        ),
                      ),
                      WidgetAppSVG(
                        'arrow_down',
                        width: 24.sw,
                        color: hexColor('#2C2830'),
                      )
                    ],
                  ),
                ),
              ),
              Gap(24.sw),
              Expanded(
                child: WidgetRippleButton(
                  onTap: controller1.text.isNotEmpty ? _gererate : null,
                  radius: 14.sw,
                  color: appColorPrimary1
                      .withOpacity(controller1.text.isNotEmpty ? 1 : .4),
                  height: 48.sw8,
                  child: SizedBox(
                    height: 48.sw,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (loading)
                            CupertinoActivityIndicator(
                              radius: 10.sw,
                              color: Colors.white,
                            )
                          else
                            WidgetAppSVG(
                              'ic_gpt_generate',
                              width: 20.sw,
                              color: Colors.white,
                            ),
                          Gap(8.sw),
                          Text(
                            "Generate",
                            style: w700TextStyle(
                                color: Colors.white, fontSize: 14.sw),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(24.sw),
          Stack(
            alignment: Alignment.center,
            children: [
              WidgetAppInputLabel(
                textlabelStyle: w500TextStyle(fontSize: 18.sw),
                label: '${widget.label}  (output)',
                backgroundColor: Colors.white,
                textStyle: w400TextStyle(
                    fontSize: 14.sw, height: 1.6, color: hexColor('#57535D')),
                height: 300.sw,
                maxLine: 12,
                controller: controller2,
                onChanged: (_) {
                  setState(() {});
                },
              ),
              if (loading)
                WidgetAppLottie(
                  'stars',
                  height: 300.sw,
                )
            ],
          ),
          if (widget.errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: 24.sw, bottom: 16.sw),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    widget.errorMessage!,
                    style: w400TextStyle(
                        color: AppColors.instance.mainRed, fontSize: 16.sw),
                  ),
                ],
              ),
            )
          else
            Gap(24.sw),
          Row(
            children: [
              Expanded(
                child: WidgetButtonNO(
                  onTap: widget.callbackCancel ??
                      () {
                        context.pop();
                      },
                  label: widget.labelButtonCancel ?? "Cancel",
                ),
              ),
              Gap(24.sw),
              Expanded(
                child: WidgetButtonOK(
                  onTap: controller2.text.isNotEmpty
                      ? () {
                          if (widget.callbackOk != null) {
                            widget.callbackOk!.call(controller2.text);
                          } else {
                            context.pop(controller2.text);
                          }
                        }
                      : null,
                  loading: widget.loadingButtonOk ?? loading,
                  enable: controller2.text.isNotEmpty,
                  label: widget.labelButtonOk ?? "Apply".tr(),
                ),
              ),
            ],
          )
        ],
      ).ignore(loading),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:temp_package_name/src/constants/constants.dart';
import 'package:_private_core/widgets/widget_app_lottie.dart';

class TaskUploading {
  final String name;
  final int percent;

  TaskUploading(this.name, this.percent);
}

class WidgetFileUploadingItem extends StatelessWidget {
  final String fileName;
  final dynamic value;
  const WidgetFileUploadingItem({
    super.key,
    required this.fileName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName,
                    maxLines: 1,
                    style: w500TextStyle()
                        .copyWith(fontSize: 14, color: Colors.white)),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        animation: false,
                        lineHeight: 12.0,
                        animationDuration: 1000,
                        percent: value / 100,
                        barRadius: const Radius.circular(99),
                        progressColor: hexColor('#0554AA'),
                        backgroundColor: hexColor('#041C43'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "$value.0%",
                        style: w500TextStyle()
                            .copyWith(color: Colors.white, fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          WidgetAppLottie(assetlottie('upload'), width: 36),
        ],
      ),
    );
  }
}

class WidgetFileUploading extends StatefulWidget {
  final List<Widget> Function() childrenBuilder;
  const WidgetFileUploading({
    super.key,
    required this.childrenBuilder,
  });

  @override
  State<WidgetFileUploading> createState() => _WidgetFileUploadingState();
}

class _WidgetFileUploadingState extends State<WidgetFileUploading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(color: AppColors.instance.mainColorDark),
      child: Column(
        children: widget.childrenBuilder(),
      ),
    );
  }
}

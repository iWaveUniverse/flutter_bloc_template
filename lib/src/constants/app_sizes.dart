import '../utils/utils.dart';

double get appPaddingHori => 20.sw;

extension ScaleExt on num {
  double get s => this * scaleW(appContext);
  double get sw2 => this * (scaleW(appContext) < .2 ? .2 : scaleW(appContext));
  double get sw3 => this * (scaleW(appContext) < .3 ? .3 : scaleW(appContext));
  double get sw4 => this * (scaleW(appContext) < .4 ? .4 : scaleW(appContext));
  double get sw5 => this * (scaleW(appContext) < .5 ? .5 : scaleW(appContext));
  double get sw6 => this * (scaleW(appContext) < .6 ? .6 : scaleW(appContext));
  double get sw7 => this * (scaleW(appContext) < .7 ? .7 : scaleW(appContext));
  double get sw8 => this * (scaleW(appContext) < .8 ? .8 : scaleW(appContext));
  double get sw9 => this * (scaleW(appContext) < .9 ? .9 : scaleW(appContext));

  double get sw => this * 1.0;
}

double scaleW(context, [double v = 1]) {
  if (context == null) return 1.0;
  // if (MediaQuery.sizeOf(context).width >= 1280) return 1;
  // return MediaQuery.sizeOf(context).width / 1280 * v;
  return 1.0;
}

double fs44([context]) => 44.0;

double fs36([context]) => 36.0;

double fs32([context]) => 32.0;

double fs28([context]) => 28.0;

double fs24([context]) => 24.0;

double fs20([context]) => 20.0;

double fs18([context]) => 18.0;

double fs16([context]) => 16.0;

double fs14([context]) => 14.0;

double fs12([context]) => 12.0;

double fs10([context]) => 10.0;

double fs8([context]) => 8.0;

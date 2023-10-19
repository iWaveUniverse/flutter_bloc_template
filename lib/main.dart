import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '_iwu_pack.dart';
import 'src/base/bloc.dart';
import 'src/base/theme_bloc/widgets/widget_theme_wraper.dart';
import 'src/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initEasyLocalization();
  if (kIsWeb) {
    // await Firebase.initializeApp(
    //   options: firebaseOptionsPREPROD,
    // );
    setPathUrlStrategy();
  } else if (!Platform.isWindows) {
    // await Firebase.initializeApp();
  }
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  await AppPrefs.instance.initialize();
  imagineeringwithusPackSetup();
  bloc.Bloc.observer = AppBlocObserver();
  getItSetup();
  runApp(wrapEasyLocalization(child: const _App()));
}

class _App extends StatefulWidget {
  const _App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {
  @override
  void initState() {
    super.initState();
    authBloc.add(const LoadAuthEvent());
  }

  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp.router(
        routerConfig: goRouter,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: AppPrefs.instance.isDarkTheme
            ? ThemeData.dark()
            : ThemeData.light(),
        themeMode:
            AppPrefs.instance.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}

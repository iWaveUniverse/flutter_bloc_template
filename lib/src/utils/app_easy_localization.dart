import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

initEasyLocalization() async {
  await EasyLocalization.ensureInitialized();
}

Widget wrapEasyLocalization({required child}) => EasyLocalization(
      child: child,
      startLocale: appSupportedLocales.first,
      fallbackLocale: appSupportedLocales.first,
      supportedLocales: appSupportedLocales,
      path: 'assets/l10n',
      assetLoader: const RootBundleAssetLoader(), // default
    );

const List<Locale> appSupportedLocales = [
  Locale('vi'),
  Locale('en'),
  Locale('fr')
];

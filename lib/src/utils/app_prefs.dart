import 'dart:io';
import 'dart:convert';

import 'package:_imagineeringwithus_pack/setup/app_base.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class AppPrefs extends AppPrefsBase {
  AppPrefs._();

  static final AppPrefs _instance = AppPrefs._();

  static AppPrefs get instance => _instance;

  late Box _box;
  final _encryptionKey = base64Url.decode(
    const String.fromEnvironment(
      'SECRET_KEY',
      defaultValue: 'jgGYXtQC6hIAROYyI_bbBZu4jFVHiqUICSf8yN2zp_8=',
    ),
  );
  bool _initialized = false;

  initialize() async {
    if (_initialized) return;
    if (!kIsWeb) {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      Hive.init(appDocDirectory.path);
    }
    _box = await Hive.openBox(
      'AppPref',
      encryptionCipher: HiveAesCipher(_encryptionKey),
    );
    _initialized = true;
  }

  Stream watch(key) => _box.watch(key: key);

  void clear() {
    _box.delete('accessToken');
    _box.delete('themeModel');
  }

  set themeModel(String? value) => _box.put('themeModel', value);

  String? get themeModel => _box.get('themeModel');

  @override
  set languageCode(String? value) => _box.put('languageCode', value);

  @override
  String get languageCode => _box.get('languageCode') ?? 'en';

  @override
  set dateFormat(String value) => _box.put('dateFormat', value);

  @override
  String get dateFormat => _box.get('dateFormat') ?? 'en';

  @override
  set timeFormat(String value) => _box.put('timeFormat', value);

  @override
  String get timeFormat => _box.get('timeFormat') ?? 'en';
}

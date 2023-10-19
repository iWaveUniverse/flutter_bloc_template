import 'dart:io';
import 'dart:convert';

import 'package:_iwu_pack/setup/app_base.dart'; 
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decode/jwt_decode.dart'; 
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

  Future initialize() async {
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
    _box.deleteAll([
      AppPrefsBase.accessTokenKey,
      AppPrefsBase.refreshTokenKey,
      AppPrefsBase.themeModeKey,
      AppPrefsBase.languageCodeKey,
      "user_info",
    ]);
  }

  bool get isDarkTheme =>
      AppPrefs.instance.themeModel == AppPrefsBase.themeModeDarkKey;

  set themeModel(String? value) => _box.put(AppPrefsBase.themeModeKey, value);

  String? get themeModel => _box.get(AppPrefsBase.themeModeKey);

  @override
  set languageCode(String? value) =>
      _box.put(AppPrefsBase.languageCodeKey, value);

  @override
  String get languageCode => _box.get(AppPrefsBase.languageCodeKey) ?? 'en';

  @override
  set dateFormat(String value) => _box.put('dateFormat', value);

  @override
  String get dateFormat => _box.get('dateFormat') ?? 'en';

  @override
  set timeFormat(String value) => _box.put('timeFormat', value);

  @override
  String get timeFormat => _box.get('timeFormat') ?? 'en';

  // Future saveAccountToken(AccountToken token) async {
  //   await Future.wait([
  //     _box.put(AppPrefsBase.accessTokenKey, token.accessToken),
  //     _box.put(AppPrefsBase.refreshTokenKey, token.refreshToken)
  //   ]);
  // }

  // dynamic getNormalToken() async {
  //   var result = await _box.get(AppPrefsBase.accessTokenKey);
  //   if (result != null) {
  //     DateTime? expiryDate = Jwt.getExpiryDate(result.toString());
  //     if (expiryDate != null &&
  //         expiryDate.millisecondsSinceEpoch <
  //             DateTime.now().millisecondsSinceEpoch) {
  //       String? refresh = await _box.get(AppPrefsBase.refreshTokenKey);
  //       if (refresh != null) {
  //         NetworkResponse response =
  //             await AccountUsersRepo().refresh_access_token(refresh);
  //         if (response.data?.accessToken != null) {
  //           result = response.data?.accessToken;
  //           saveAccountToken(response.data!);
  //         }
  //       }
  //     }
  //   }
  //   return result;
  // }

  // AccountUser? get user {
  //   final objectString = _box.get('user_info');
  //   if (objectString != null) {
  //     final jsonMap = jsonDecode(objectString);
  //     return AccountUser.fromJson(jsonMap);
  //   }
  //   return null;
  // }

  // set user(userInfo) {
  //   if (userInfo != null) {
  //     final string = json.encode(userInfo.toJson());
  //     _box.put('user_info', string);
  //   } else {
  //     _box.delete('user_info');
  //   }
  // }
}

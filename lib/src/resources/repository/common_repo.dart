import '../resources.dart';

class CommonRepo {
  CommonRepo._();

  static CommonRepo? _instance;

  factory CommonRepo([AppApi? api]) {
    _instance ??= CommonRepo._();
    _instance!._api = api ?? AppApiImp();
    return _instance!;
  }

  late final AppApi _api;

// Future<List<Country>> getPhoneAvailable() async {
//   NetworkResponse response = await _api.getPhoneAvailable();
//   return response.data ?? [];
// }
}

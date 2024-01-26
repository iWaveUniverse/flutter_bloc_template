import 'package:_iwu_pack_network/network_resources/resources.dart'; 

import 'app_api.dart'; 

class CommonRepo {
  CommonRepo._();

  static CommonRepo? _instance;

  factory CommonRepo([MyAppApi? api]) {
    _instance ??= CommonRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api; 

  Future<bool> demo([params]) async {
    NetworkResponse response = await _api.demo(params);
    return response.data ?? false;
  }
}

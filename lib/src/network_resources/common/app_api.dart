import 'package:_iwu_pack_network/_iwu_pack_network.dart';
import 'package:_iwu_pack_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'model/feedback_type.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String demo() => "/v2/demo";
}

abstract class MyAppApi {
  Future<NetworkResponse> demo(params);
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> demo(params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient()
            .get(_MyAppEndpoint.demo(), queryParameters: params);
        return NetworkResponse.fromResponse(response,
            converter: (json) =>
                (json as List).map((e) => FeedbackType.fromJson(e)).toList());
      },
    );
  }
}

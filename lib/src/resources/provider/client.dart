 

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../utils/utils.dart';
import 'app_endpoint.dart';

const String getMethod = "GET";
const String postMethod = "POST";
const String putMethod = "PUT";
const String deleteMethod = "DELETE";

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class AppClients extends DioForNative {
  static AppClients? _instance;

  final Logger _logger = Logger();

  factory AppClients(
      {String baseUrl = AppEndpoint.BASE_URL, BaseOptions? options}) {
    _instance ??= AppClients._(baseUrl: baseUrl, options: options);
    if (options != null) _instance!.options = options;
    _instance!.options.baseUrl = baseUrl;
    return _instance!;
  }

  AppClients._({String baseUrl = AppEndpoint.BASE_URL, BaseOptions? options})
      : super(options) {
    interceptors.add(InterceptorsWrapper(
      onRequest: _requestInterceptor,
      onResponse: _responseInterceptor,
      onError: _errorInterceptor,
    ));
    this.options.baseUrl = baseUrl;
  }

  _requestInterceptor(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addEntries(
        [MapEntry('Authorization', AppPrefs.instance.getNormalToken())]);
    _logger.i("[RequestInterceptor] [${options.method}] ${options.uri}:");
    _logger.i("Header: ${options.headers}");
    switch (options.method) {
      case getMethod:
        _logger.i("Params: ${options.queryParameters}");
        break;
      default:
        if (options.data is Map) {
          _logger.i("Params: ${options.data}");
        } else if (options.data is FormData) {
          _logger.i("Params: ${options.data.fields}");
        }
        break;
    }
    options.connectTimeout =
        const Duration(seconds: AppEndpoint.connectionTimeout);
    options.receiveTimeout =
        const Duration(seconds: AppEndpoint.receiveTimeout);
    handler.next(options);
  }

  _responseInterceptor(Response response, ResponseInterceptorHandler handler) {
    _logger.d("[ResponseInterceptor] ${response.requestOptions.uri}: ${response.statusCode}\nData: ${response.data}");
    handler.next(response);
  }

  _errorInterceptor(DioError dioError, ErrorInterceptorHandler handler) {
    _logger.wtf("[ErrorInterceptor] ${dioError.response?.requestOptions.uri} ${dioError.type}\n${dioError.message}");
    handler.next(dioError);
  }
}

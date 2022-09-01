

import 'package:dio/dio.dart';

class DefaultApi {

  static Dio _dio = new Dio();

  static void configureDio(){

    // base del url
    final String baseURL = '';

    // configuracion de la base url
    _dio.options.baseUrl = baseURL;

    // configuracion de los headers
    _dio.options.headers = {};

  }

  static Future httpGet(String path, {Map<String, dynamic>? params}) async {
    try {
      final resp = await _dio.get(path, queryParameters: params);
      return resp.data;
    } on DioError catch (e) {
      print(e.response);
      throw ('Error en el GET');
    }
  }

  static Future post(String path, Map<String, dynamic>? data) async {
    try {
      final resp = await _dio.post(path, data: data);
      return resp;
    } on DioError catch (e) {
      print(e.response);
      throw ('Error en el POST');
    }
  }

}
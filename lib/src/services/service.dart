import 'dart:convert';
import 'package:dio/dio.dart';
import 'dio_exception.dart';

class APIServices {
  final dio = Dio();

  Future<Map<String, dynamic>?> initializeCheckout(
      var data, String token) async {
    Map<String, dynamic>? responseD;

    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = token;
    try {
      await dio.post<String>(APIs.initiate, data: data).then((value) {
        var responseData = json.decode(value.data!);
        responseD = responseData;
        print(responseData);
        return responseData;
      });
    } on DioError catch (e) {
      print(DioExceptions.fromDioError(e).message);
    }
    return responseD;
  }

  Future<Map<String, dynamic>> paymentStatus(
      String token, String reference) async {
    Map<String, dynamic> responseD = {
      "success": false,
      "message": "An error occurred"
    };

    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = token;

    try {
      await dio.get<String>("${APIs.paymentStatus}/$reference").then((value) {
        var responseData = json.decode(value.data!);
        responseD = responseData;
        return responseData;
      });
    } on DioError catch (e) {
      print(DioExceptions.fromDioError(e).message);
    }

    return responseD;
  }
}

class APIs {
  static String baseUrl = 'https://sagecloud.ng/api/v3';
  static String initiate = "$baseUrl/payment/initiate";
  static String paymentStatus = "$baseUrl/payment/status";
}

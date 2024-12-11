import 'package:dio/dio.dart';
import 'package:flutter_application_1/Core/constant/api_const.dart';

class DataListBookProvider {
  Future<dynamic> data(String lastUpdate) async {
    var response = await Dio().post(ApiConstant.bookList + lastUpdate);
    return response.data;
  }
}

import 'dart:convert';
import 'package:blog_management/services/base_services.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class CommonServices extends BaseService{
  late final Dio _dio;
  final formatDate = DateFormat('dd MMM, yyyy');
  CommonServices(){
    _dio = Dio();
  }
  Future<Map> fetchData(Map dataObj) async {
    String url = dataObj['url'];
    Map data = dataObj['data'];
    Map? resp ;
    try {
      if(dataObj['method'] == 'get') {
        var response = await _dio.get(url).timeout(
          const Duration(seconds: 20),
        );
        resp = response.data;
      } else if (dataObj['method'] == 'post') {
        var response = await _dio
            .post(url,
            data: json.encode(data))
            .timeout(
          const Duration(seconds: 20),
        );
        resp = response.data;
      } else if(dataObj['method'] == 'patch') {
        var response = await _dio
            .patch(url,
            data: json.encode(data))
            .timeout(
          const Duration(seconds: 20),
        );
        resp = response.data;
      }else if(dataObj['method'] == 'delete'){
        var response = await _dio.delete(url).timeout(
          const Duration(seconds: 20),
        );
        resp = response.data;
      }
    } catch (err) {
      // print(err);
    }
    return resp!;
  }

  void showMessage(context,String msg, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        showCloseIcon: true,
        content: Text(msg),
      ),
    );
  }

}
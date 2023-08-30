import 'dart:io';

import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ApiService {
  final _commonService = CommonServices();

  Future<Map> getCall(String api) async {
    final String url = '$baseUrl/$api.json';
    Map dataObj = {
      'method': 'get',
      'url': url,
      'data': {},
    };
    try {
      var resp = await _commonService.fetchData(dataObj);
      return resp;
    } catch (err) {
      return {err: err.toString()};
    }
  }

  Future<Map> postCall(Map data, String api) async {
    final String url = '$baseUrl/$api.json';
    Map dataObj = {
      'method': 'post',
      'url': url,
      'data': data,
    };
    try {
      var resp = await  _commonService.fetchData(dataObj);
      return resp;
    } catch (err) {
      return {err: err.toString()};
    }
  }

  Future<Map> patchCall(Map data, String api) async {
    final String url = '$baseUrl/$api.json';
    Map dataObj = {
      'method': 'patch',
      'url': url,
      'data': data,
    };
    try {
      var resp = await _commonService.fetchData(dataObj);
      return resp;
    } catch (err) {
      print(err);
      return {err: err.toString()};
    }
  }

  Future<Map> deleteCall(String api) async {
    final String url = '$baseUrl/$api.json';
    Map dataObj = {
      'method': 'delete',
      'url': url,
      'data': {},
    };
    try {
      var resp = await _commonService.fetchData(dataObj);
      return resp;
    } catch (err) {
      return {err: err.toString()};
    }
  }

  Future<String> uploadImages(File? image, String title, String author) async {
    String? imageUrl;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('blogImages')
          .child('${title}_$author.jpg');
      await storageRef.putFile(image!);
      imageUrl = await storageRef.getDownloadURL();
    } catch (err) {
      return err.toString();
    }
    return imageUrl!;
  }

  Future<void> deleteImages(String title, String author) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('blogImages')
          .child('${title}_$author.jpg');
      await storageRef.delete();
    } catch (err) {

    }
  }
}

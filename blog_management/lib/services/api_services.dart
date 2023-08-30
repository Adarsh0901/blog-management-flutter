import 'package:blog_management/services/common_services.dart';
import 'package:blog_management/services/constants.dart';

class ApiService {
  final _commonService = CommonServices();

  Future<Map> getCall(String api) async {
    final String url = '$baseUrl/$api.json';
    Map dataObj = {
      'method': 'get',
      'url': url,
      'data': {},
    };
    try{
      var resp = await _commonService.fetchData(dataObj);
      return resp;
    }catch(err){
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
    try{
      var resp = _commonService.fetchData(dataObj);
      return resp;
    }catch(err){
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
    try{
      var resp = _commonService.fetchData(dataObj);
      return resp;
    }catch(err){
      return {err: err.toString()};
    }
  }

}
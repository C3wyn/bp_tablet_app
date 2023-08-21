import 'dart:convert';

import 'package:bp_tablet_app/models/bpmodel.model.dart';

class APIResponse<T> {
  late int Code;
  late String Name;
  late String Message;
  late T? Result;

  bool get isSuccess => Code==200;

  APIResponse(
    int code,
    String name,
    String message,
    T? result
  ){
    Code = code;
    Name = name;
    Message = message;
    Result = result;
  }

  factory APIResponse.fromJson(
    String json,
    {
      String? onSuccessMessage, 
      T? result
    }
  ){
    Map<String, dynamic> data = jsonDecode(json);
    if(data['data']!=null){
      return APIResponse(
        200,
        "Successfull", 
        onSuccessMessage?? "",
        result
      );
    }
    return APIResponse(data['error']['status'], data['error']['name'], data['error']['message'], null);
  }
}
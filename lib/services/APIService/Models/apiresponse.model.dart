import 'package:bp_tablet_app/models/bpmodel.model.dart';

class APIResponse {
  late int Code;
  late String Name;
  late String Message;
  late BackPointModel? Result;

  APIResponse(
    int code,
    String name,
    String message,
    BackPointModel? result
  ){
    Code = code;
    Name = name;
    Message = message;
    Result = result;
  }
}
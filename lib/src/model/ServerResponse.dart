import 'package:json_annotation/json_annotation.dart';

// part 'ServerResponse.g.dart';
//
// @JsonSerializable()
class ServerResponse {
  @JsonKey(name: 'success')
  final bool success;
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'message')
  final String apiMessage;
  @JsonKey(name: 'data')
  final dynamic data;

  ServerResponse({this.success, this.token, this.apiMessage, this.data});

  factory ServerResponse.fromJson(Map<dynamic, dynamic> json) {
    return ServerResponse(
      success: json["success"] as bool,
      token: json["token"] as String,
      apiMessage: json["message"] as String,
      data: json["data"],
    );
  }

  Map<String, dynamic> toJson() => _serverResponseToJson(this);

  Map<String, dynamic> _serverResponseToJson(ServerResponse instance) =>
      <String, dynamic>{
        'success': instance.success,
        'token': instance.token,
        'message': instance.apiMessage,
        'data': instance.data,
      };
}

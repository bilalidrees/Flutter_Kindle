import 'package:json_annotation/json_annotation.dart';

// part 'User.g.dart';
//
// @JsonSerializable()
class User {
  @JsonKey(name: 'fullname')
  String fullname;
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'password')
  String password;
  @JsonKey(name: 'picture')
  String picture;
  @JsonKey(name: 'contact')
  String contact;
  @JsonKey(name: 'gender')
  String gender;
  @JsonKey(name: 'dob')
  String dob;

  User({
    this.fullname,
    this.id,
    this.email,
    this.password,
    this.picture,
    this.contact,
    this.gender,
    this.dob,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      id: json["_id"] as String,
      fullname: json["fullname"] as String,
      email: json["email"] as String,
      password: json["password"] as String,
      picture: json["picture"] as String,
      contact: json["contact"] as String,
      gender: json["gender"] as String,
      dob: json["dob"] as String,
    );
  }

  Map<String, dynamic> toJson() => _userToJson(this);

  Map<String, dynamic> _userToJson(User instance) => <String, dynamic>{
        '_id': instance.id,
        'fullname': instance.fullname,
        'email': instance.email,
        'password': instance.password,
        'picture': instance.picture,
        'contact': instance.contact,
        'gender': instance.gender,
        'dob': instance.dob,
      };
}

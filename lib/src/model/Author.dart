import 'package:json_annotation/json_annotation.dart';

// part 'Author.g.dart';
//
// @JsonSerializable()
class Author {
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'firstname')
  String firstname;
  @JsonKey(name: 'lastname')
  String lastname;
  @JsonKey(name: 'pename')
  String pename;
  @JsonKey(name: 'published_at')
  String publishedAt;

  Author(
      {this.id, this.firstname, this.lastname, this.pename, this.publishedAt});

  factory Author.fromJson(Map<dynamic, dynamic> json) {
    return Author(
      id: json["id"] as String,
      firstname: json["firstname"] as String,
      lastname: json["lastname"] as String,
      pename: json["pename"] as String,
      publishedAt: json["published_at"] as String,
    );
  }

  Map<String, dynamic> toJson() => _authorToJson(this);

  Map<String, dynamic> _authorToJson(Author instance) => <String, dynamic>{
        'id': instance.id,
        'firstname': instance.firstname,
        'lastname': instance.lastname,
        'pename': instance.pename,
        'published_at': instance.publishedAt,
      };
}

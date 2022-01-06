import 'package:json_annotation/json_annotation.dart';

// part 'Image.g.dart';
//
// @JsonSerializable()
class Image {
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'alternativeText')
  String alternativeText;
  @JsonKey(name: 'caption')
  String caption;
  @JsonKey(name: 'url')
  String url;

  Image({this.id, this.name, this.alternativeText, this.caption, this.url});

  factory Image.fromJson(Map<dynamic, dynamic> json) {
    return Image(
      id: json["id"] as String,
      name: json["name"] as String,
      alternativeText: json["alternativeText"] as String,
      caption: json["caption"] as String,
      url: json["url"] as String,
    );
  }

  Map<String, dynamic> toJson() => _imageToJson(this);

  Map<String, dynamic> _imageToJson(Image instance) => <String, dynamic>{
        'id': instance.id,
        'name': instance.name,
        'alternativeText': instance.alternativeText,
        'caption': instance.caption,
        'url': instance.url,
      };
}

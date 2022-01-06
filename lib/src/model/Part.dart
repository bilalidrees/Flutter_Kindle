import 'package:json_annotation/json_annotation.dart';
import 'package:hiltonSample/src/model/Audio.dart';

// part 'Part.g.dart';
//
// @JsonSerializable()
class Part {
  @JsonKey(name: 'lang')
  String lang;
  @JsonKey(name: 'subtype')
  String subtype;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'published_at')
  String published_at;
  @JsonKey(name: 'audio')
  Audio audio;
  @JsonKey(name: 'sno')
  int sno;
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'bookId')
  String bookId;

  Part(
      {this.lang,
      this.subtype,
      this.title,
      this.description,
      this.published_at,
      this.audio,
      this.sno,
      this.id,
      this.bookId});

  factory Part.fromJson(Map<dynamic, dynamic> json) {
    return Part(
      audio: json['audio'] == null
          ? null
          : Audio.fromJson(json['audio'] as Map<dynamic, dynamic>),
      lang: json['lang'] as String,
      subtype: json['subtype'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      published_at: json['published_at'] as String,
      sno: json['sno'] as int,
      id: json['id'] as String,
      bookId: json['bookId'] == null ? null : json['bookId'] as String,
    );
  }

  Map<String, dynamic> toJson() => _partToJson(this);

  Map<String, dynamic> _partToJson(Part instance) => <String, dynamic>{
        'audio': instance.audio,
        'lang': instance.lang,
        'subtype': instance.subtype,
        'title': instance.title,
        'description': instance.description,
        'published_at': instance.published_at,
        'sno': instance.sno,
        'id': instance.id,
        'bookId': instance.bookId
      };
}

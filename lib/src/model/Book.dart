import 'package:json_annotation/json_annotation.dart';
import 'package:hiltonSample/src/model/Image.dart';
import 'package:hiltonSample/src/model/Part.dart';
import 'package:hiltonSample/src/model/Author.dart';

// part 'Book.g.dart';
//
// @JsonSerializable()
class Book {
  @JsonKey(name: 'lang')
  String lang;
  @JsonKey(name: 'subtype')
  String subtype;
  @JsonKey(name: 'parts')
  List<Part> parts;
  @JsonKey(name: 'authors')
  List<Author> authors;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'published_at')
  String publishedAt;
  @JsonKey(name: 'image')
  Image image;
  @JsonKey(name: 'sno')
  int sno;
  @JsonKey(name: 'id')
  String id;

  Book(
      {this.lang,
      this.subtype,
      this.parts,
      this.authors,
      this.title,
      this.description,
      this.publishedAt,
      this.image,
      this.sno,
      this.id});

  factory Book.fromJson(Map<dynamic, dynamic> json) {
    return Book(
        image: json['image'] == null
            ? null
            : Image.fromJson(json['image'] as Map<dynamic, dynamic>),
        lang: json['lang'] as String,
        subtype: json['subtype'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        publishedAt: json['published_at'] as String,
        sno: json['sno'] as int,
        id: json['id'] as String,
        parts: (json['parts'] as List)
            ?.map((e) =>
                e == null ? null : Part.fromJson(e as Map<dynamic, dynamic>))
            ?.toList(),
        authors: (json['authors'] as List)
            ?.map((e) =>
                e == null ? null : Author.fromJson(e as Map<dynamic, dynamic>))
            ?.toList());
  }

//
  Map<String, dynamic> toJson() => _bookToJson(this);

  Map<String, dynamic> _bookToJson(Book instance) => <String, dynamic>{
        'image': instance.image,
        'lang': instance.lang,
        'subtype': instance.subtype,
        'title': instance.title,
        'description': instance.description,
        'published_at': instance.publishedAt,
        'sno': instance.sno,
        'id': instance.id,
        'parts': instance.parts,
        'authors': instance.authors,
      };
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String?,
  author: json['author'] as String?,
  publisher: json['publisher'] as String?,
  year: (json['year'] as num?)?.toInt(),
  progress: json['progress'] as String?,
  type: $enumDecodeNullable(_$BookTypeEnumMap, json['type']),
);

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'author': instance.author,
  'publisher': instance.publisher,
  'year': instance.year,
  'progress': instance.progress,
  'type': _$BookTypeEnumMap[instance.type],
};

const _$BookTypeEnumMap = {BookType.epub: 'epub'};

import 'package:drift/drift.dart' as drift;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'types.g.dart';
part 'types.freezed.dart';

@freezed
abstract class Book with _$Book {
  const factory Book({
    required int id,
    required String? title,
    required String? author,
    required String? publisher,
    required int? year,
    required String? coverUrl,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

class StoredBooks extends drift.Table {
  drift.IntColumn get id => integer()();
  drift.TextColumn get title => text().nullable()();
  drift.TextColumn get author => text().nullable()();
  drift.TextColumn get publisher => text().nullable()();
  drift.IntColumn get year => integer().nullable()();
  drift.TextColumn get coverUrl => text().nullable()();

  @override
  Set<drift.Column<Object>> get primaryKey => {id};
}

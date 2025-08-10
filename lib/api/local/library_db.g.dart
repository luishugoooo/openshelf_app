// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_db.dart';

// ignore_for_file: type=lint
class $StoredBooksTable extends StoredBooks
    with TableInfo<$StoredBooksTable, StoredBook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredBooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<String> progress = GeneratedColumn<String>(
    'progress',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BookType?, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<BookType?>($StoredBooksTable.$convertertypen);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    publisher,
    year,
    progress,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_books';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredBook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredBook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredBook(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progress'],
      ),
      type: $StoredBooksTable.$convertertypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        ),
      ),
    );
  }

  @override
  $StoredBooksTable createAlias(String alias) {
    return $StoredBooksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BookType, int, int> $convertertype =
      const EnumIndexConverter<BookType>(BookType.values);
  static JsonTypeConverter2<BookType?, int?, int?> $convertertypen =
      JsonTypeConverter2.asNullable($convertertype);
}

class StoredBook extends DataClass implements Insertable<StoredBook> {
  final int id;
  final String? title;
  final String? author;
  final String? publisher;
  final int? year;
  final String? progress;
  final BookType? type;
  const StoredBook({
    required this.id,
    this.title,
    this.author,
    this.publisher,
    this.year,
    this.progress,
    this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<String>(progress);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<int>(
        $StoredBooksTable.$convertertypen.toSql(type),
      );
    }
    return map;
  }

  StoredBooksCompanion toCompanion(bool nullToAbsent) {
    return StoredBooksCompanion(
      id: Value(id),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
    );
  }

  factory StoredBook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredBook(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      year: serializer.fromJson<int?>(json['year']),
      progress: serializer.fromJson<String?>(json['progress']),
      type: $StoredBooksTable.$convertertypen.fromJson(
        serializer.fromJson<int?>(json['type']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'author': serializer.toJson<String?>(author),
      'publisher': serializer.toJson<String?>(publisher),
      'year': serializer.toJson<int?>(year),
      'progress': serializer.toJson<String?>(progress),
      'type': serializer.toJson<int?>(
        $StoredBooksTable.$convertertypen.toJson(type),
      ),
    };
  }

  StoredBook copyWith({
    int? id,
    Value<String?> title = const Value.absent(),
    Value<String?> author = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<String?> progress = const Value.absent(),
    Value<BookType?> type = const Value.absent(),
  }) => StoredBook(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    author: author.present ? author.value : this.author,
    publisher: publisher.present ? publisher.value : this.publisher,
    year: year.present ? year.value : this.year,
    progress: progress.present ? progress.value : this.progress,
    type: type.present ? type.value : this.type,
  );
  StoredBook copyWithCompanion(StoredBooksCompanion data) {
    return StoredBook(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      year: data.year.present ? data.year.value : this.year,
      progress: data.progress.present ? data.progress.value : this.progress,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredBook(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('publisher: $publisher, ')
          ..write('year: $year, ')
          ..write('progress: $progress, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, author, publisher, year, progress, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredBook &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.publisher == this.publisher &&
          other.year == this.year &&
          other.progress == this.progress &&
          other.type == this.type);
}

class StoredBooksCompanion extends UpdateCompanion<StoredBook> {
  final Value<int> id;
  final Value<String?> title;
  final Value<String?> author;
  final Value<String?> publisher;
  final Value<int?> year;
  final Value<String?> progress;
  final Value<BookType?> type;
  const StoredBooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.publisher = const Value.absent(),
    this.year = const Value.absent(),
    this.progress = const Value.absent(),
    this.type = const Value.absent(),
  });
  StoredBooksCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.publisher = const Value.absent(),
    this.year = const Value.absent(),
    this.progress = const Value.absent(),
    this.type = const Value.absent(),
  });
  static Insertable<StoredBook> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? publisher,
    Expression<int>? year,
    Expression<String>? progress,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (publisher != null) 'publisher': publisher,
      if (year != null) 'year': year,
      if (progress != null) 'progress': progress,
      if (type != null) 'type': type,
    });
  }

  StoredBooksCompanion copyWith({
    Value<int>? id,
    Value<String?>? title,
    Value<String?>? author,
    Value<String?>? publisher,
    Value<int?>? year,
    Value<String?>? progress,
    Value<BookType?>? type,
  }) {
    return StoredBooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      year: year ?? this.year,
      progress: progress ?? this.progress,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (progress.present) {
      map['progress'] = Variable<String>(progress.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $StoredBooksTable.$convertertypen.toSql(type.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredBooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('publisher: $publisher, ')
          ..write('year: $year, ')
          ..write('progress: $progress, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

abstract class _$LibraryDatabase extends GeneratedDatabase {
  _$LibraryDatabase(QueryExecutor e) : super(e);
  $LibraryDatabaseManager get managers => $LibraryDatabaseManager(this);
  late final $StoredBooksTable storedBooks = $StoredBooksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [storedBooks];
}

typedef $$StoredBooksTableCreateCompanionBuilder =
    StoredBooksCompanion Function({
      Value<int> id,
      Value<String?> title,
      Value<String?> author,
      Value<String?> publisher,
      Value<int?> year,
      Value<String?> progress,
      Value<BookType?> type,
    });
typedef $$StoredBooksTableUpdateCompanionBuilder =
    StoredBooksCompanion Function({
      Value<int> id,
      Value<String?> title,
      Value<String?> author,
      Value<String?> publisher,
      Value<int?> year,
      Value<String?> progress,
      Value<BookType?> type,
    });

class $$StoredBooksTableFilterComposer
    extends Composer<_$LibraryDatabase, $StoredBooksTable> {
  $$StoredBooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BookType?, BookType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$StoredBooksTableOrderingComposer
    extends Composer<_$LibraryDatabase, $StoredBooksTable> {
  $$StoredBooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredBooksTableAnnotationComposer
    extends Composer<_$LibraryDatabase, $StoredBooksTable> {
  $$StoredBooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BookType?, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$StoredBooksTableTableManager
    extends
        RootTableManager<
          _$LibraryDatabase,
          $StoredBooksTable,
          StoredBook,
          $$StoredBooksTableFilterComposer,
          $$StoredBooksTableOrderingComposer,
          $$StoredBooksTableAnnotationComposer,
          $$StoredBooksTableCreateCompanionBuilder,
          $$StoredBooksTableUpdateCompanionBuilder,
          (
            StoredBook,
            BaseReferences<_$LibraryDatabase, $StoredBooksTable, StoredBook>,
          ),
          StoredBook,
          PrefetchHooks Function()
        > {
  $$StoredBooksTableTableManager(_$LibraryDatabase db, $StoredBooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredBooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredBooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredBooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> progress = const Value.absent(),
                Value<BookType?> type = const Value.absent(),
              }) => StoredBooksCompanion(
                id: id,
                title: title,
                author: author,
                publisher: publisher,
                year: year,
                progress: progress,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> progress = const Value.absent(),
                Value<BookType?> type = const Value.absent(),
              }) => StoredBooksCompanion.insert(
                id: id,
                title: title,
                author: author,
                publisher: publisher,
                year: year,
                progress: progress,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoredBooksTableProcessedTableManager =
    ProcessedTableManager<
      _$LibraryDatabase,
      $StoredBooksTable,
      StoredBook,
      $$StoredBooksTableFilterComposer,
      $$StoredBooksTableOrderingComposer,
      $$StoredBooksTableAnnotationComposer,
      $$StoredBooksTableCreateCompanionBuilder,
      $$StoredBooksTableUpdateCompanionBuilder,
      (
        StoredBook,
        BaseReferences<_$LibraryDatabase, $StoredBooksTable, StoredBook>,
      ),
      StoredBook,
      PrefetchHooks Function()
    >;

class $LibraryDatabaseManager {
  final _$LibraryDatabase _db;
  $LibraryDatabaseManager(this._db);
  $$StoredBooksTableTableManager get storedBooks =>
      $$StoredBooksTableTableManager(_db, _db.storedBooks);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryDatabaseHash() => r'0a369a8359f77d23c8161166d48ef8e3223ad17e';

/// See also [libraryDatabase].
@ProviderFor(libraryDatabase)
final libraryDatabaseProvider = Provider<LibraryDatabase>.internal(
  libraryDatabase,
  name: r'libraryDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LibraryDatabaseRef = ProviderRef<LibraryDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

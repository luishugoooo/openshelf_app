// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localFileHash() => r'1d5f8a3a9230ec2fb67e4693f5bd2c430ef2a443';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [localFile].
@ProviderFor(localFile)
const localFileProvider = LocalFileFamily();

/// See also [localFile].
class LocalFileFamily extends Family<AsyncValue<File>> {
  /// See also [localFile].
  const LocalFileFamily();

  /// See also [localFile].
  LocalFileProvider call(int bookId) {
    return LocalFileProvider(bookId);
  }

  @override
  LocalFileProvider getProviderOverride(covariant LocalFileProvider provider) {
    return call(provider.bookId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'localFileProvider';
}

/// See also [localFile].
class LocalFileProvider extends AutoDisposeFutureProvider<File> {
  /// See also [localFile].
  LocalFileProvider(int bookId)
    : this._internal(
        (ref) => localFile(ref as LocalFileRef, bookId),
        from: localFileProvider,
        name: r'localFileProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$localFileHash,
        dependencies: LocalFileFamily._dependencies,
        allTransitiveDependencies: LocalFileFamily._allTransitiveDependencies,
        bookId: bookId,
      );

  LocalFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
  }) : super.internal();

  final int bookId;

  @override
  Override overrideWith(FutureOr<File> Function(LocalFileRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: LocalFileProvider._internal(
        (ref) => create(ref as LocalFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<File> createElement() {
    return _LocalFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalFileProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LocalFileRef on AutoDisposeFutureProviderRef<File> {
  /// The parameter `bookId` of this provider.
  int get bookId;
}

class _LocalFileProviderElement extends AutoDisposeFutureProviderElement<File>
    with LocalFileRef {
  _LocalFileProviderElement(super.provider);

  @override
  int get bookId => (origin as LocalFileProvider).bookId;
}

String _$booksNotifierHash() => r'afe4ebaea5d0ea81af9f74baf5f562517ab32b14';

/// See also [BooksNotifier].
@ProviderFor(BooksNotifier)
final booksNotifierProvider =
    StreamNotifierProvider<BooksNotifier, List<Book>>.internal(
      BooksNotifier.new,
      name: r'booksNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$booksNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BooksNotifier = StreamNotifier<List<Book>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

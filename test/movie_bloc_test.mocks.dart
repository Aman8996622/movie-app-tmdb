// Mocks generated by Mockito 5.4.4 from annotations
// in movieapp/test/movie_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:movieapp/core/network/dio_client.dart' as _i2;
import 'package:movieapp/data/models/movie_model.dart' as _i5;
import 'package:movieapp/data/repositories/movie_repository.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDioClient_0 extends _i1.SmartFake implements _i2.DioClient {
  _FakeDioClient_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MovieRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMovieRepository extends _i1.Mock implements _i3.MovieRepository {
  MockMovieRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DioClient get dioClient => (super.noSuchMethod(
        Invocation.getter(#dioClient),
        returnValue: _FakeDioClient_0(
          this,
          Invocation.getter(#dioClient),
        ),
      ) as _i2.DioClient);

  @override
  int get currentPage => (super.noSuchMethod(
        Invocation.getter(#currentPage),
        returnValue: 0,
      ) as int);

  @override
  set currentPage(int? _currentPage) => super.noSuchMethod(
        Invocation.setter(
          #currentPage,
          _currentPage,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<List<_i5.Movie>> fetchMovies({
    required String? category,
    int? currentPage = 1,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchMovies,
          [],
          {
            #category: category,
            #currentPage: currentPage,
          },
        ),
        returnValue: _i4.Future<List<_i5.Movie>>.value(<_i5.Movie>[]),
      ) as _i4.Future<List<_i5.Movie>>);

  @override
  _i4.Future<List<_i5.Movie>> movieSearch(String? query) => (super.noSuchMethod(
        Invocation.method(
          #movieSearch,
          [query],
        ),
        returnValue: _i4.Future<List<_i5.Movie>>.value(<_i5.Movie>[]),
      ) as _i4.Future<List<_i5.Movie>>);
}

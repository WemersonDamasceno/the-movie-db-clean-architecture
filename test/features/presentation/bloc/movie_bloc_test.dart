import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_movies_db_clean_architecture/core/errors/failures.dart';
import 'package:the_movies_db_clean_architecture/domain/entities/movie_entity.dart';
import 'package:the_movies_db_clean_architecture/domain/usecases/get_list_popular_movies_usecase.dart';
import 'package:the_movies_db_clean_architecture/domain/usecases/get_list_trending_movies_usecase.dart';
import 'package:the_movies_db_clean_architecture/features/presentation/bloc/movie_bloc.dart';

class MockGetListPopularMoviesUseCase extends Mock
    implements GetPopularMoviesUseCase {}

class MockGetListTrendingMoviesUseCase extends Mock
    implements GetTrendingMoviesUsecase {}

void main() {
  late MovieBloc blocMovie;
  late MockGetListPopularMoviesUseCase getListPopularMoviesUseCase;
  late MockGetListTrendingMoviesUseCase getListTrendingMoviesUseCase;

  setUp(() {
    getListPopularMoviesUseCase = MockGetListPopularMoviesUseCase();
    getListTrendingMoviesUseCase = MockGetListTrendingMoviesUseCase();

    blocMovie = MovieBloc(
      getMoviesPopularUseCase: getListPopularMoviesUseCase,
      getMoviesTrendingUsecase: getListTrendingMoviesUseCase,
    );
  });
  group('MovieBloc Popular|', () {
    blocTest<MovieBloc, MovieState>(
      'should emits [LoadingState, LoadedState] when LoadEvent is added.',
      setUp: () {
        when(() => getListPopularMoviesUseCase(0))
            .thenAnswer((_) async => const Right(<MovieEntity>[]));
      },
      build: () => blocMovie,
      act: (bloc) => bloc.add(
        const PopularMoviesLoadEvent(),
      ),
      expect: () => <MovieState>[
        const PopularMovieLoadingState(),
        const PopularMoviesLoadedState(listPopularMovies: <MovieEntity>[]),
      ],
    );

    blocTest('should emits [LoadingState, ErrorState] when LoadEvent is added.',
        setUp: () => when(() => getListPopularMoviesUseCase(0))
            .thenAnswer((_) async => Left(ServerFailure())),
        build: () => blocMovie,
        act: (MovieBloc bloc) => bloc.add(
              const PopularMoviesLoadEvent(),
            ),
        expect: () => <MovieState>[
              const PopularMovieLoadingState(),
              const MoviesErrorState(message: "Ops! Something went wrong"),
            ]);

    blocTest('should emit [LoadingState, ErrorState] when LoadEvent is added.',
        setUp: () => when(() => getListPopularMoviesUseCase(0))
            .thenAnswer((_) async => Left(NotFoundFailure())),
        build: () => blocMovie,
        act: (MovieBloc bloc) => bloc.add(
              const PopularMoviesLoadEvent(),
            ),
        expect: () => <MovieState>[
              const PopularMovieLoadingState(),
              const MoviesErrorState(message: "Ops! Something went wrong"),
            ]);
  });

  group("MovieBloc Trending |", () {
    blocTest<MovieBloc, MovieState>(
      'should emits [LoadingState, LoadedState] when LoadEvent is added.',
      setUp: () {
        when(() => getListTrendingMoviesUseCase(0))
            .thenAnswer((_) async => const Right(<MovieEntity>[]));
      },
      build: () => blocMovie,
      act: (bloc) => bloc.add(const TrendingMoviesLoadEvent()),
      expect: () => <MovieState>[
        const TrendingMovieLoadingState(),
        const TrendingMoviesLoadedState(listTrendingMovies: <MovieEntity>[]),
      ],
    );

    blocTest('should emits [LoadingState, ErrorState] when LoadEvent is added.',
        setUp: () => when(() => getListTrendingMoviesUseCase(0))
            .thenAnswer((_) async => Left(ServerFailure())),
        build: () => blocMovie,
        act: (MovieBloc bloc) => bloc.add(const TrendingMoviesLoadEvent()),
        expect: () => <MovieState>[
              const TrendingMovieLoadingState(),
              const MoviesErrorState(message: "Ops! Something went wrong"),
            ]);

    blocTest('should emit [LoadingState, ErrorState] when LoadEvent is added.',
        setUp: () => when(() => getListTrendingMoviesUseCase(0))
            .thenAnswer((_) async => Left(NotFoundFailure())),
        build: () => blocMovie,
        act: (MovieBloc bloc) => bloc.add(const TrendingMoviesLoadEvent()),
        expect: () => <MovieState>[
              const TrendingMovieLoadingState(),
              const MoviesErrorState(message: "Ops! Something went wrong"),
            ]);
  });
}

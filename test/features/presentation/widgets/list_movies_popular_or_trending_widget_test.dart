import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_movies_db_clean_architecture/core/utils/enums/enums.dart';
import 'package:the_movies_db_clean_architecture/domain/entities/movie_entity.dart';
import 'package:the_movies_db_clean_architecture/features/presentation/bloc/movie_bloc.dart';
import 'package:the_movies_db_clean_architecture/features/presentation/widgets/list_movies_popular_or_trending_widget.dart';
import 'package:the_movies_db_clean_architecture/features/presentation/widgets/list_movies_widget.dart';
import 'package:the_movies_db_clean_architecture/features/presentation/widgets/skeleton_movie_widget.dart';

import '../helpers/makeTestableWidget.dart';

class MockMovieBloc extends MockBloc<MovieEvent, MovieState>
    implements MovieBloc {}

void main() {
  late MovieBloc movieBloc;

  setUp(() {
    movieBloc = MockMovieBloc();
  });

  group("Widget listMoviesPopularOrTrending |", () {
    testWidgets('should return the widgets states loading and loaded',
        (tester) async {
      when(() => movieBloc.state).thenReturn(const PopularMovieLoadingState());

      whenListen(
        movieBloc,
        Stream.fromIterable([
          const PopularMovieLoadingState(),
          const PopularMoviesLoadedState(listPopularMovies: <MovieEntity>[]),
        ]),
      );
      await tester.pumpWidget(
        makeTestableWidget(
          child: const ListMoviePopularOrTrendingWidget(
              movieTypeEnum: MoviesTypeEnum.popularMovies),
          movieBloc: movieBloc,
        ),
      );

      await expectLater(find.byType(SkeletonMovieWidget), findsOneWidget);
      await tester.pump();
      expect(find.byType(SkeletonMovieWidget), findsNothing);
      expect(find.byType(ListMovieWidget), findsOneWidget);
    });

    testWidgets("should return the widgets when call errorState.",
        (WidgetTester tester) async {
      when(() => movieBloc.state).thenReturn(
          const MoviesErrorState(message: "Ops! Something went wrong."));

      await tester.pumpWidget(
        makeTestableWidget(
          child: const ListMoviePopularOrTrendingWidget(
            movieTypeEnum: MoviesTypeEnum.popularMovies,
          ),
          movieBloc: movieBloc,
        ),
      );

      await tester.pump();
      expect(find.byKey(const ValueKey("error")), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets("should return a widget BlocBuilder", (tester) async {
      when(() => movieBloc.state).thenReturn(const PopularMovieLoadingState());

      await tester.pumpWidget(
        makeTestableWidget(
          child: const ListMoviePopularOrTrendingWidget(
              movieTypeEnum: MoviesTypeEnum.popularMovies),
          movieBloc: movieBloc,
        ),
      );

      await expectLater(
          find.byType(BlocBuilder<MovieBloc, MovieState>), findsOneWidget);
      await tester.pump();
      expect(find.byType(BlocBuilder<MovieBloc, MovieState>), findsOneWidget);
    });
  });
}

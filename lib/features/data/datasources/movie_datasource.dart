import 'package:the_movies_db_clean_architecture/features/data/models/movie_model.dart';

abstract class MovieDatasource {
  Future<List<MovieModel>> getListPopularMovies();
  Future<List<MovieModel>> getListTrendingMovies();
}
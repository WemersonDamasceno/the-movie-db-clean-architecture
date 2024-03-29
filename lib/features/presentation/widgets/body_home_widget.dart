import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_movies_db_clean_architecture/core/utils/constants/custom_styles.dart';
import 'package:the_movies_db_clean_architecture/core/utils/enums/enums.dart';
import 'package:the_movies_db_clean_architecture/features/presentation/bloc/movie_bloc.dart';
import 'package:the_movies_db_clean_architecture/features/presentation/widgets/list_movies_popular_or_trending_widget.dart';

class BodyHomeWidget extends StatefulWidget {
  const BodyHomeWidget({Key? key}) : super(key: key);

  @override
  State<BodyHomeWidget> createState() => _BodyHomeWidgetState();
}

class _BodyHomeWidgetState extends State<BodyHomeWidget> {
  late MovieBloc blocContext;
  @override
  void initState() {
    initBloc(context);
    super.initState();
  }

  initBloc(BuildContext context) {
    blocContext = BlocProvider.of<MovieBloc>(context);
    blocContext.add(const PopularMoviesLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 5),
                child: Text(
                  'Os Mais Populares',
                  style: CustomStyles.styleTextTopic,
                ),
              ),
              SizedBox(
                height: 300,
                child: ListMoviePopularOrTrendingWidget(
                  movieTypeEnum: MoviesTypeEnum.popularMovies,
                ),
              ),
              Text(
                'Em Tendencia',
                style: CustomStyles.styleTextTopic,
              ),
              SizedBox(
                height: 300,
                child: ListMoviePopularOrTrendingWidget(
                  movieTypeEnum: MoviesTypeEnum.trendingMovies,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

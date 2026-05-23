import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'data/datasources/local/movie_local_datasource.dart';
import 'data/datasources/remote/movie_remote_datasource.dart';
import 'data/models/movie_model.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/usecases/get_favorites.dart';
import 'domain/usecases/get_trending.dart';
import 'domain/usecases/search_movies.dart';
import 'domain/usecases/toggle_favorite.dart';
import 'presentation/blocs/favorite/favorite_bloc.dart';
import 'presentation/blocs/movie/movie_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  await Hive.openBox<MovieModel>('favorites');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDatasource = MovieRemoteDatasourceImpl();
    final localDatasource = MovieLocalDatasourceImpl();
    final repository = MovieRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MovieBloc(
            getTrending: GetTrending(repository),
          ),
        ),
        BlocProvider(
          create: (_) => SearchBloc(
            searchMovies: SearchMovies(repository),
          ),
        ),
        BlocProvider(
          create: (_) => FavoriteBloc(
            getFavorites: GetFavorites(repository),
            toggleFavorite: ToggleFavorite(repository),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'CineApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
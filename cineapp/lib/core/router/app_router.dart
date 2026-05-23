import 'package:go_router/go_router.dart';
import '../../domain/entities/movie.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/search_screen.dart';
import '../../presentation/screens/detail_screen.dart';
import '../../presentation/screens/favorites_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final movie = state.extra as Movie;
        return DetailScreen(movie: movie);
      },
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],
);
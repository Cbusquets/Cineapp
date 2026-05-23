import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/movie/movie_bloc.dart';
import '../blocs/movie/movie_event.dart';
import '../blocs/movie/movie_state.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(GetTrendingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineApp'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MovieError) {
            return Center(child: Text(state.message));
          }
          if (state is MovieLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Tendencias',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () => context.push('/detail/${movie.id}', extra: movie),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
        onTap: (index) {
          if (index == 1) context.push('/search');
          if (index == 2) context.push('/favorites');
        },
      ),
    );
  }
}
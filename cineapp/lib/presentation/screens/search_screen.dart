import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar películas...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchMoviesEvent(query));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              context.read<SearchBloc>().add(ClearSearchEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Buscá una película', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_filter, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No se encontraron resultados', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          if (state is SearchError) {
            return Center(child: Text(state.message));
          }
          if (state is SearchLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
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
            );
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 2) context.push('/favorites');
        },
      ),
    );
  }
}
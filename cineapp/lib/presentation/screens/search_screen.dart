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
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(LoadGenresEvent());
  }

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
            final state = context.read<SearchBloc>().state;
            int? genreId;
            if (state is SearchLoaded) genreId = state.selectedGenreId;
            if (state is SearchEmpty) genreId = state.selectedGenreId;
            context.read<SearchBloc>().add(SearchMoviesEvent(query, genreId: genreId));
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
          final genres = state.genres;
          int? selectedGenreId;
          if (state is SearchLoaded) selectedGenreId = state.selectedGenreId;
          if (state is SearchEmpty) selectedGenreId = state.selectedGenreId;

          return Column(
            children: [
              if (genres.isNotEmpty)
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('Todos'),
                          selected: selectedGenreId == null,
                          onSelected: (_) {
                            context.read<SearchBloc>().add(
                                  SearchMoviesEvent(_controller.text),
                                );
                          },
                        ),
                      ),
                      ...genres.entries.map((e) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(e.value),
                              selected: selectedGenreId == e.key,
                              onSelected: (_) {
                                context.read<SearchBloc>().add(
                                      SearchMoviesEvent(
                                        _controller.text,
                                        genreId: e.key,
                                      ),
                                    );
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              Expanded(child: _buildBody(state)),
            ],
          );
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

  Widget _buildBody(SearchState state) {
    if (state is SearchInitial) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Buscá una película o elegí un género',
              style: TextStyle(color: Colors.grey),
            ),
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
            Text('No se encontraron resultados',
                style: TextStyle(color: Colors.grey)),
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
          crossAxisCount: 3,
          childAspectRatio: 0.65,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
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
  }
}
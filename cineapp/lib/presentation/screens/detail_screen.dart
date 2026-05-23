import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/api_constants.dart';
import '../../domain/entities/movie.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_event.dart';
import '../blocs/favorite/favorite_state.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(GetFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.movie.title,
                style: const TextStyle(fontSize: 14),
              ),
              background: CachedNetworkImage(
                imageUrl: '${ApiConstants.imageUrl}${widget.movie.backdropPath}',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie, size: 64),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        widget.movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(widget.movie.releaseDate),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sinopsis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.overview.isNotEmpty
                        ? widget.movie.overview
                        : 'Sin sinopsis disponible.',
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, state) {
                      bool isFav = false;
                      if (state is FavoriteLoaded) {
                        isFav = state.movies.any((m) => m.id == widget.movie.id);
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<FavoriteBloc>().add(
                                  ToggleFavoriteEvent(widget.movie, isFav),
                                );
                          },
                          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                          label: Text(isFav ? 'Quitar de favoritos' : 'Agregar a favoritos'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFav ? Colors.red : Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
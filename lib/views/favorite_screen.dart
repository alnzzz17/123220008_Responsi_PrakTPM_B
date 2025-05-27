import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi/models/movie_model.dart';
import 'package:responsi/presenters/favorite_presenter.dart';
import 'package:responsi/views/movie_detail_screen.dart';
import 'package:responsi/views/movie_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Movie>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoritePresenter = Provider.of<FavoritePresenter>(context, listen: false);
    setState(() {
      _favoritesFuture = favoritePresenter.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _favoritesFuture,
        builder: (context, mv) {
          if (mv.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (mv.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load favorites',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadFavorites,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (!mv.hasData || mv.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No favorite movies yet',
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadFavorites,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mv.data!.length,
              itemBuilder: (context, index) {
                final movie = mv.data![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: MovieCard(
                    movie: movie,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movieId: movie.id.toString(),
                          ),
                        ),
                      );
                      _loadFavorites();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi/models/movie_model.dart';
import 'package:responsi/presenters/movie_presenter.dart';
import 'package:responsi/views/favorite_screen.dart';
import 'package:responsi/views/movie_detail_screen.dart';
import 'package:responsi/views/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final moviePresenter = Provider.of<MoviePresenter>(context, listen: false);
    setState(() {
      _moviesFuture = moviePresenter.getMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
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
                    'Failed to load movies',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mv.error.toString(),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMovies,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (!mv.hasData || mv.data!.isEmpty) {
            return const Center(
              child: Text('No movies available'),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadMovies,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mv.data!.length,
              itemBuilder: (context, index) {
                final movie = mv.data![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: MovieCard(
                    movie: movie,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movieId: movie.id.toString(),
                          ),
                        ),
                      );
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

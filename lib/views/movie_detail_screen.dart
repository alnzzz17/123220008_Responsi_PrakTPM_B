import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi/models/movie_model.dart';
import 'package:responsi/presenters/favorite_presenter.dart';
import 'package:responsi/presenters/movie_presenter.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> _movieFuture;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadMovie();
    _checkFavoriteStatus();
  }

  Future<void> _loadMovie() async {
    final moviePresenter = Provider.of<MoviePresenter>(context, listen: false);
    setState(() {
      _movieFuture = moviePresenter
          .getMovieDetail(widget.movieId)
          .then((list) => list.first);
    });
  }

  Future<void> _checkFavoriteStatus() async {
    final favoritePresenter =
        Provider.of<FavoritePresenter>(context, listen: false);
    final isFav = await favoritePresenter.isFavorite(widget.movieId);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final favoritePresenter =
        Provider.of<FavoritePresenter>(context, listen: false);
    final movie = await _movieFuture;

    if (_isFavorite) {
      await favoritePresenter.removeFavorite(widget.movieId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites')),
      );
    } else {
      await favoritePresenter.addFavorite(movie);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favorites')),
      );
    }

    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: FutureBuilder<Movie>(
        future: _movieFuture,
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
                    'Failed to load movie details',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMovie,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (!mv.hasData) {
            return const Center(child: Text('No movie data available'));
          }

          final movie = mv.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        movie.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          movie.rating.toStringAsFixed(1),
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Released: ${movie.releaseDate}',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Genre Chips
                Wrap(
                  spacing: 8,
                  children: movie.genre
                      .map((genre) => Chip(
                            label: Text(genre),
                            backgroundColor:
                                theme.primaryColor.withOpacity(0.1),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Director
                Text(
                  'Director',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.director,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                // Cast
                Text(
                  'Cast',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: movie.cast
                          .map((actor) => Chip(label: Text(actor)))
                          .toList(),
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.description ?? 'No description available',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                // Duration
                Text(
                  'Duration: ${movie.duration}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

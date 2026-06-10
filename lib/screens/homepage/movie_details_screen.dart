import 'package:flutter/material.dart';
import 'package:my_watch_list/providers/user_provider.dart';
import 'package:my_watch_list/services/api_service.dart';

// IMPORT PROVIDERS
import 'package:provider/provider.dart';
import '../../providers/watchlist_provider.dart';

// IMPORT WIDGETS
import '../../widgets/widgets.dart';

// IMPORT MODELS
import '../../models/movie.dart';
import '../../models/watchlist.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  Future<void> _addToWatchlist(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final watchlistProvider = Provider.of<WatchlistProvider>(
      context,
      listen: false,
    );

    final user = userProvider.getUser;
    if (user == null) {
      Widgets.showSnackBar(
        context,
        'Devi essere loggato per aggiungere alla watchlist',
      );
      return;
    }

    bool isOnline = await ApiService.checkConnection();

    if (!isOnline) {
      if (context.mounted) {
        Widgets.showSnackBar(
          context,
          'Modalità Offline: non puoi aggiungere nuovi film ora.',
        );
      }
      return;
    }

    final newWatchlistItem = Watchlist(
      id: null,
      userId: user.id!,
      tmdbId: movie.id,
      title: movie.title,
      releaseDate: movie.releaseDate,
      tmdbRating: movie.voteAverage,
      status: 'watched',
      userRating: null,
      notes: null,
    );

    try {
      await watchlistProvider.addToWatchlistItem(newWatchlistItem, isOnline);
    } catch (e) {
      if (context.mounted) {
        Widgets.showSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildOverview(),
                  const SizedBox(height: 24),
                  _buildDetails(movie),
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: movie.backdropPath != null
            ? Image.network(
                movie.fullBackdropPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[900],
                  child: Icon(Icons.movie, size: 80),
                ),
              )
            : Container(
                color: Colors.grey[900],
                child: Icon(Icons.movie, size: 80),
              ),
      ),
    );
  }

  // POSTER  TITOLO + VOTO
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: movie.posterPath != null
              ? Image.network(
                  movie.fullPosterPath,
                  fit: BoxFit.cover,
                  width: 120,
                  height: 180,
                )
              : Container(
                  width: 120,
                  height: 180,
                  color: Colors.grey[800],
                  child: Icon(Icons.movie),
                ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITOLO
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),

              // VOTO
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Text(
                    ' / 10',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // GENERI
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: movie.genreIds.map((id) {
                  final genreName = GenreMapper.getGenreName(id);
                  final color = Movie.genreColor(id);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      genreName,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // OVERVIEW
  Widget _buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trama',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          movie.overview.isNotEmpty
              ? movie.overview
              : 'Nessuna trama disponibile.',
          style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.grey),
        ),
      ],
    );
  }

  // DETAILS
  Widget _buildDetails(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dettagli',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDetailRow('Titolo Originale', movie.originalTitle),
              const Divider(height: 24),
              _buildDetailRow(
                'Data di uscita',
                movie.releaseDate.toString().replaceAll(' 00:00:00.000', ''),
              ),
              const Divider(height: 24),
              _buildDetailRow(
                'Lingua Originale',
                movie.originalLanguage.toUpperCase(),
              ),
              const Divider(height: 24),
              _buildDetailRow('Popolarità', movie.popularity.toString()),
              const Divider(height: 24),
              _buildDetailRow('Voti ricevuti', movie.voteCount.toString()),
            ],
          ),
        ),
      ],
    );
  }

  // DETAILS ROW
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final bool isInWatchlist = watchlistProvider.isInWatchlist(movie.id);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isInWatchlist ? null : () => _addToWatchlist(context),
        icon: Icon(isInWatchlist ? Icons.check : Icons.add),
        label: Text(
          isInWatchlist ? 'GIÀ NELLA WATCHLIST' : 'AGGIUNGI ALLA WATCHLIST',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isInWatchlist
              ? Colors.grey
              : Theme.of(context).colorScheme.primary,
          foregroundColor: isInWatchlist
              ? Colors.white
              : Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

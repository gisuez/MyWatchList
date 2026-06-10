import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../../services/api_service.dart';
import '../../models/watchlist.dart';
import '../../models/series_detail.dart';

class SeriesDetailsScreen extends StatelessWidget {
  final SeriesDetail series; // Usiamo il modello dettagliato che hai postato

  const SeriesDetailsScreen({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con immagine di sfondo e pulsante back
          _buildSliverAppBar(context),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainInfo(context),
                _buildStatsBar(context),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Trama"),
                      const SizedBox(height: 8),
                      Text(
                        series.overview.isNotEmpty
                            ? series.overview
                            : "Nessuna trama disponibile.",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[400],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle("Stagioni"),
                      _buildSeasonsList(),
                      const SizedBox(height: 24),
                      _buildDetailsGrid(context),
                      const SizedBox(height: 32),
                      _buildActionButtons(context),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(series.fullBackdropPath, fit: BoxFit.cover),
            // Gradiente per rendere leggibili i testi e le icone
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Poster piccolo in sovrapposizione parziale
          Hero(
            tag: series.id,
            child: Container(
              width: 120,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(series.fullPosterPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  series.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: series.genres
                      .map((g) => _buildGenreChip(g))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChip(Genre genre) {
    final color = SeriesDetail.genreColor(genre.id);
    return Chip(
      label: Text(
        genre.name,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildStatsBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: Colors.grey.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            Icons.star,
            series.voteAverage.toStringAsFixed(1),
            "Rating",
          ),
          _buildStatItem(
            Icons.calendar_month,
            series.firstAirDate.split('-')[0],
            "Inizio",
          ),
          _buildStatItem(
            Icons.layers,
            series.numberOfSeasons.toString(),
            "Stagioni",
          ),
          _buildStatItem(
            Icons.timer,
            "${series.episodeRunTime.isNotEmpty ? series.episodeRunTime[0] : 'N/A'}m",
            "Durata",
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildSeasonsList() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: series.seasons.length,
        itemBuilder: (context, index) {
          final season = series.seasons[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12, top: 10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    season.posterPath != null
                        ? 'https://image.tmdb.org/t/p/w200${season.posterPath}'
                        : series.fullPosterPath,
                    height: 120,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  season.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildDetailRow("Status", series.status),
          _buildDetailRow(
            "Network",
            series.networks.map((n) => n.name).join(", "),
          ),
          _buildDetailRow(
            "Lingua Originale",
            series.originalLanguage.toUpperCase(),
          ),
          _buildDetailRow("Episodi Totali", series.numberOfEpisodes.toString()),
          _buildDetailRow(
            "Creato da",
            series.createdBy.map((c) => c.name).join(", "),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  // --- LOGICA AGGIUNTA ALLA WATCHLIST ---

  Widget _buildActionButtons(BuildContext context) {
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final bool isInWatchlist = watchlistProvider.isInWatchlist(series.id);

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: isInWatchlist ? null : () => _addToWatchlist(context),
        icon: Icon(isInWatchlist ? Icons.done_all : Icons.add),
        label: Text(
          isInWatchlist ? 'NELLA TUA LIBRERIA' : 'AGGIUNGI ALLA WATCHLIST',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isInWatchlist
              ? Colors.green.withOpacity(0.2)
              : Theme.of(context).colorScheme.primary,
          foregroundColor: isInWatchlist ? Colors.green : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Future<void> _addToWatchlist(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final watchlistProvider = Provider.of<WatchlistProvider>(
      context,
      listen: false,
    );
    final user = userProvider.getUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Accedi per salvare la serie')),
      );
      return;
    }

    bool isOnline = await ApiService.checkConnection();

    final newWatchlistItem = Watchlist(
      id: null,
      userId: user.id!,
      tmdbId: series.id,
      title: series.name, // mappato correttamente
      releaseDate: series.firstAirDate,
      tmdbRating: series.voteAverage,
      status: 'to_watch',
      userRating: null,
      notes: null,
    );

    try {
      await watchlistProvider.addToWatchlistItem(newWatchlistItem, isOnline);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}

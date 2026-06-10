import 'package:flutter/material.dart';
import 'package:my_watch_list/services/api_service.dart';

// IMPORT PROVIDERS
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/watchlist_provider.dart';

// IMPORT SCREEN
import 'watchlist_details_screen.dart';

// IMPORT WIDGETS
import '../../widgets/widgets.dart';

// IMPORT MODELS
import '../../models/watchlist.dart';

class WatchlistListScreen extends StatefulWidget {
  const WatchlistListScreen({super.key});

  @override
  State<WatchlistListScreen> createState() => _WatchlistListScreenState();
}

class _WatchlistListScreenState extends State<WatchlistListScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    setState(() {
      _isLoading = true;
    });

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

    try {
      bool isOnline = await ApiService.checkConnection();

      await watchlistProvider.fetchWatchlist(user.id!, isOnline);
    } catch (e) {
      if (mounted) {
        Widgets.showSnackBar(
          context,
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;
    final watchlist = Provider.of<WatchlistProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('MyWatchList - ${user?.username ?? "Utente"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadWatchlist,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : watchlist.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadWatchlist,
              child: ListView.builder(
                itemCount: watchlist.length,
                itemBuilder: (context, index) {
                  final item = watchlist[index];
                  return _buildWatchlistItem(item);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_filter, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('La tua watchlist è vuota!'),
        ],
      ),
    );
  }

  Widget _buildWatchlistItem(Watchlist item) {
    final Color ratingColor = _getRatingColor(item.tmdbRating);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ratingColor.withValues(alpha: 0.7),
          child: Text(
            item.tmdbRating.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(item.title),
        subtitle: Text(item.releaseDate),
        trailing: _buildStatusBadge(item.status),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WatchlistDetailsScreen(item: item),
            ),
          );
        },
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 9.7) return const Color(0xFF1c93dc);
    if (rating >= 9.0) return const Color(0xFF186237);
    if (rating >= 8.0) return const Color(0xFF26a45b);
    if (rating >= 7.0) return const Color(0xFFdebe3b);
    if (rating >= 6.0) return const Color(0xFFdd8f12);
    if (rating >= 5.0) return const Color(0xFFd24738);

    return const Color(0xFF633974);
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status == 'watched'
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

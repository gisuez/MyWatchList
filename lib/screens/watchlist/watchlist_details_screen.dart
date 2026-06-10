import 'package:flutter/material.dart';

// IMPORT PROVIDERS
import 'package:provider/provider.dart';
import '../../providers/watchlist_provider.dart';

// IMPORT SERVICES
import '../../services/api_service.dart';

// IMPORT WIDGETS
import '../../widgets/widgets.dart';

// IMPORT MODELS
import '../../models/watchlist.dart';

class WatchlistDetailsScreen extends StatefulWidget {
  final Watchlist item;

  const WatchlistDetailsScreen({super.key, required this.item});

  @override
  State<WatchlistDetailsScreen> createState() => _WatchlistDetailsScreenState();
}

class _WatchlistDetailsScreenState extends State<WatchlistDetailsScreen> {
  late TextEditingController _notesController;
  late String _status;
  int? _currentUserRating;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _status = widget.item.status;
    _currentUserRating = widget.item.userRating;
    _notesController = TextEditingController(text: widget.item.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateItem() async {
    setState(() {
      _isLoading = true;
    });

    final watchlistProvider = Provider.of<WatchlistProvider>(
      context,
      listen: false,
    );

    bool isOnline = await ApiService.checkConnection();

    final updateItem = Watchlist(
      id: widget.item.id,
      userId: widget.item.userId,
      tmdbId: widget.item.tmdbId,
      title: widget.item.title,
      releaseDate: widget.item.releaseDate,
      tmdbRating: widget.item.tmdbRating,
      status: _status,
      userRating: _currentUserRating,
      notes: _notesController.text,
    );

    try {
      await watchlistProvider.updateWatchlistItem(updateItem, isOnline);
      if (mounted) {
        Navigator.pop(context);
      }
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

  Future<void> _deleteItem() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina film'),
        content: const Text('Sei sicuro di voler eliminare questo film?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Elimina', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      final watchlistProvider = Provider.of<WatchlistProvider>(
        context,
        listen: false,
      );

      bool isOnline = await ApiService.checkConnection();

      try {
        await watchlistProvider.deleteWatchlistItem(widget.item.id!, isOnline);
        if (mounted) {
          Navigator.pop(context);
        }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _deleteItem,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Watched',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Switch(
                  value: _status == "watched",
                  onChanged: (value) {
                    setState(() {
                      if (_status == "watched") {
                        _status = "to_watch";
                      } else if (_status == "to_watch") {
                        _status = "watched";
                      }
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeThumbColor: Colors.green,
                ),
              ],
            ),

            const Divider(height: 40),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Il tuo voto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          _currentUserRating = index + 1;
                        });
                      },
                      icon: Icon(
                        index < (_currentUserRating ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      ),
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 40),

            const Text(
              'Note',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 20,
              minLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Scrivi qualcosa...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),

            const SizedBox(height: 30),

            // Bottone Salva
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateItem,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SALVA MODIFICHE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

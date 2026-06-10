import 'package:flutter/material.dart';

// IMPORT SERVICES
import '../services/api_service.dart';

// IMPORT DATABASE
import '../database/database_helper.dart';

// IMPORT MODELS
import '../models/watchlist.dart';

class WatchlistProvider extends ChangeNotifier {
  List<Watchlist> _watchlist = [];

  List<Watchlist> get items => _watchlist;

  Future<void> fetchWatchlist(int userId, bool isOnline) async {
    try {
      if (isOnline) {
        _watchlist = await ApiService.getWatchlistsByUser(userId);

        for (var item in _watchlist) {
          await DatabaseHelper.instance.insertWatchlist(item);
        }
      } else {
        _watchlist = await DatabaseHelper.instance.getWatchlistByUser(userId);
      }
    } catch (e) {
      _watchlist = await DatabaseHelper.instance.getWatchlistByUser(userId);
    } finally {
      notifyListeners();
    }
  }

  Future<void> addToWatchlistItem(Watchlist item, bool isOnline) async {
    if (!isOnline) {
      throw Exception('Modalità Offline: non puoi aggiungere nuovi film ora.');
    }

    try {
      final newItem = await ApiService.createWatchlist(item);

      _watchlist.add(newItem);

      await DatabaseHelper.instance.insertWatchlist(newItem);
    } catch (e) {
      String errorMsg = 'Errore nell\'aggiunta alla watchlist: $e';
      if (e.toString().contains('SocketException') ||
          e.toString().contains('ClientException')) {
        errorMsg = 'Il server non è attivo.';
      }
      throw errorMsg;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateWatchlistItem(Watchlist item, bool isOnline) async {
    if (!isOnline) {
      throw Exception(
        'Modalità Offline: non puoi modificare la watchlist ora.',
      );
    }

    try {
      await ApiService.updateWatchlist(item.id!, item);

      int index = _watchlist.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        _watchlist[index] = item;
      }

      await DatabaseHelper.instance.updateWatchlist(item);
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento della watchlist: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteWatchlistItem(int id, bool isOnline) async {
    if (!isOnline) {
      throw Exception(
        'Modalità Offline: non puoi modificare la watchlist ora.',
      );
    }

    try {
      await ApiService.deleteWatchlist(id);

      _watchlist.removeWhere((item) => item.id == id);

      await DatabaseHelper.instance.deleteWatchlist(id);
    } catch (e) {
      throw Exception('Errore nell\'eliminazione della watchlist: $e');
    } finally {
      notifyListeners();
    }
  }

  bool isInWatchlist(int tmdbId) {
    for (var item in _watchlist) {
      if (item.tmdbId == tmdbId) {
        return true;
      }
    }
    return false;
  }
}

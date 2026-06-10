// IMPORT SERVICES
import 'package:my_watch_list/services/api_service.dart';

// IMPORT MODELS
import 'package:my_watch_list/models/user.dart';
import 'package:my_watch_list/models/watchlist.dart';

void main() async {
  print('--- TEST CRUD USERS ---');

  // 1. GET ALL
  print('1. GET All Users...');
  try {
    var users = await ApiService.getUsers();
    print('Trovati ${users.length} users.');
  } catch (e) {
    print('Errore GET All: $e');
  }

  // 2. CREATE
  print('\n2. POST (Creato nuovo user)...');
  int newUserId = 0;
  try {
    var newUser = User(id: 999, username: 'test_user', password: 'password123');
    var creato = await ApiService.createUser(newUser);
    newUserId = creato.id!;
    print('Creato user con ID: $newUserId');
  } catch (e) {
    print('Errore POST: $e');
  }

  // 3. GET SINGLE
  print('\n3. GET User singolo (ID: $newUserId)...');
  try {
    var user = await ApiService.getUser(newUserId);
    print('User recuperato: ${user.username}');
  } catch (e) {
    print('Errore GET Single: $e');
  }

  // 4. PUT
  print('\n4. PUT (Aggiorna intero user ID: $newUserId)...');
  try {
    var userUpdated = User(
      id: newUserId,
      username: 'test_user_updated',
      password: 'new_password',
    );
    var resultPut = await ApiService.updateUser(newUserId, userUpdated);
    print('User aggiornato: ${resultPut.username}');
  } catch (e) {
    print('Errore PUT: $e');
  }

  // 5. PATCH
  print('\n5. PATCH (Aggiorna solo password ID: $newUserId)...');
  try {
    await ApiService.patchUser(newUserId, {'password': 'patched_password'});
    print('User patchato con nuova password.');
  } catch (e) {
    print('Errore PATCH: $e');
  }

  // 6. DELETE
  print('\n6. DELETE (Elimina user ID: $newUserId)...');
  try {
    await ApiService.deleteUser(newUserId);
    print('User eliminato correttamente.');
  } catch (e) {
    print('Errore DELETE: $e');
  }

  print('\n--- TEST CRUD WATCHLIST ---');

  // 1. GET ALL
  print('1. GET All Watchlist...');
  try {
    var watchlists = await ApiService.getWatchlists();
    print('Trovati ${watchlists.length} elementi nella watchlist.');
  } catch (e) {
    print('Errore GET All: $e');
  }

  // 2. CREATE
  print('\n2. POST (Crea nuovo elemento watchlist)...');
  int newWatchlistId = 0;
  try {
    var nuovoElemento = Watchlist(
      id: 999,
      userId: 1,
      tmdbId: 11111,
      title: 'Nuovo Film Test',
      releaseDate: '2024-01-01',
      status: 'to_watch',
      tmdbRating: 9.0,
    );
    var creato = await ApiService.createWatchlist(nuovoElemento);
    newWatchlistId = creato.id!;
    print('Creato elemento watchlist con ID: $newWatchlistId');
  } catch (e) {
    print('Errore POST: $e');
  }

  // 3. GET SINGLE
  print('\n3. GET Watchlist singola (ID: $newWatchlistId)...');
  try {
    var elemento = await ApiService.getWatchlist(newWatchlistId);
    print('Elemento recuperato: ${elemento.title}');
  } catch (e) {
    print('Errore GET Single: $e');
  }

  // 4. PUT
  print('\n4. PUT (Aggiorna elemento watchlist ID: $newWatchlistId)...');
  try {
    var elementoAggiornato = Watchlist(
      id: newWatchlistId,
      userId: 1,
      tmdbId: 11111,
      title: 'Titolo Film Test Aggiornato',
      releaseDate: '2024-01-01',
      status: 'watched',
      userRating: 8,
      tmdbRating: 0.0,
    );
    var resultPut = await ApiService.updateWatchlist(
      newWatchlistId,
      elementoAggiornato,
    );
    print(
      'Elemento aggiornato: ${resultPut.title}, Status: ${resultPut.status}',
    );
  } catch (e) {
    print('Errore PUT: $e');
  }

  // 5. PATCH
  print('\n5. PATCH (Aggiorna solo status ID: $newWatchlistId)...');
  try {
    var resultPatch = await ApiService.patchWatchlist(newWatchlistId, {
      'status': 'dropped',
    });
    print('Elemento patchato. Nuovo status: ${resultPatch.status}');
  } catch (e) {
    print('Errore PATCH: $e');
  }

  // 6. DELETE
  print('\n6. DELETE (Elimina elemento ID: $newWatchlistId)...');
  try {
    await ApiService.deleteWatchlist(newWatchlistId);
    print('Elemento watchlist eliminato correttamente.');
  } catch (e) {
    print('Errore DELETE: $e');
  }

  print('\nTest completati!');
}

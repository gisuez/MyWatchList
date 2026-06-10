import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';

// IMPORT MODELS
import '../models/watchlist.dart';
import '../models/user.dart';

class ApiService {
  static String serverUrl = 'http://localhost:3000';

  // STATUS SERVER
  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$serverUrl/users'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // =====================
  // ======= USERS =======
  // =====================
  static Future<User?> register(String username, String password) async {
    final response = await http.get(
      Uri.parse('$serverUrl/users?username=$username'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        throw Exception('Username già in uso');
      }
    }

    final String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    final newUser = User(username: username, password: hashedPassword);

    return await createUser(newUser);
  }

  static Future<User> login(String username, String password) async {
    final response = await http.get(
      Uri.parse('$serverUrl/users?username=$username'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      if (data.isEmpty) {
        throw Exception('Utente non trovato');
      }

      var user = User.fromJson(data.first);

      final bool checkPassword = BCrypt.checkpw(password, user.password);

      if (!checkPassword) {
        throw Exception('Password errata');
      }

      return user;
    } else {
      throw Exception('Errore di connessione');
    }
  }

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$serverUrl/users'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<User> getUser(int id) async {
    final response = await http.get(Uri.parse('$serverUrl/users/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user $id');
    }
  }

  static Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$serverUrl/users'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  static Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$serverUrl/users/$id'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user $id');
    }
  }

  static Future<User> patchUser(int id, Map<String, dynamic> updates) async {
    final response = await http.patch(
      Uri.parse('$serverUrl/users/$id'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to patch user $id');
    }
  }

  static Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$serverUrl/users/$id'),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user $id');
    }
  }

  // =====================
  // ===== WATCHLIST =====
  // =====================
  static Future<List<Watchlist>> getWatchlists() async {
    final response = await http.get(Uri.parse('$serverUrl/watchlist'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((data) => Watchlist.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load watchlist');
    }
  }

  static Future<List<Watchlist>> getWatchlistsByUser(int userId) async {
    final response = await http.get(
      Uri.parse('$serverUrl/watchlist?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((data) => Watchlist.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load watchlist for user $userId');
    }
  }

  static Future<Watchlist> getWatchlist(int id) async {
    final response = await http.get(Uri.parse('$serverUrl/watchlist/$id'));

    if (response.statusCode == 200) {
      return Watchlist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load watchlist $id');
    }
  }

  static Future<Watchlist> createWatchlist(Watchlist watchlist) async {
    final response = await http.post(
      Uri.parse('$serverUrl/watchlist'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(watchlist.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Watchlist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create watchlist item');
    }
  }

  static Future<Watchlist> updateWatchlist(int id, Watchlist watchlist) async {
    final response = await http.put(
      Uri.parse('$serverUrl/watchlist/$id'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(watchlist.toJson()),
    );

    if (response.statusCode == 200) {
      return Watchlist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update watchlist item $id');
    }
  }

  static Future<Watchlist> patchWatchlist(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await http.patch(
      Uri.parse('$serverUrl/watchlist/$id'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return Watchlist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to patch watchlist item $id');
    }
  }

  static Future<void> deleteWatchlist(int id) async {
    final response = await http.delete(
      Uri.parse('$serverUrl/watchlist/$id'),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete watchlist item $id');
    }
  }
}

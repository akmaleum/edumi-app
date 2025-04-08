// lib/database_helper.dart
import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  late final Database db;
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init() {
    final dbPath = p.join(Directory.current.path, 'db.sqlite3');
    db = sqlite3.open(dbPath);
    _createTableIfNotExists();
  }

  void _createTableIfNotExists() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        telephone TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  void insertUser(Map<String, dynamic> user) {
    final stmt = db.prepare('''
      INSERT INTO users (
        firstName, lastName, username, telephone, email, password, createdAt
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
    ''');

    stmt.execute([
      user['firstName'],
      user['lastName'],
      user['username'],
      user['telephone'],
      user['email'],
      user['password'],
      user['createdAt'],
    ]);
    stmt.dispose();
  }

  bool checkUsernameExists(String username) {
    final result = db.select(
      'SELECT 1 FROM users WHERE username = ? LIMIT 1',
      [username],
    );
    return result.isNotEmpty;
  }

  bool checkEmailExists(String email) {
    final result = db.select(
      'SELECT 1 FROM users WHERE email = ? LIMIT 1',
      [email],
    );
    return result.isNotEmpty;
  }

  Map<String, dynamic>? getUserByUsername(String username) {
    final result = db.select(
      'SELECT * FROM users WHERE username = ? LIMIT 1',
      [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

  void updateUser(int id, Map<String, dynamic> updatedUser) {
    final stmt = db.prepare('''
      UPDATE users SET
        firstName = ?, lastName = ?, username = ?, telephone = ?,
        email = ?, password = ?, createdAt = ?
      WHERE id = ?
    ''');

    stmt.execute([
      updatedUser['firstName'],
      updatedUser['lastName'],
      updatedUser['username'],
      updatedUser['telephone'],
      updatedUser['email'],
      updatedUser['password'],
      updatedUser['createdAt'],
      id,
    ]);
    stmt.dispose();
  }

  void close() {
    db.dispose();
  }
}
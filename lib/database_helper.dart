// lib/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _userDatabase; // For edumi.db (users)
  static Database? _consultationDatabase; // For edumi_another.db (consultations)

  DatabaseHelper._init();

  // Getter for the user database (edumi.db)
  Future<Database> get userDatabase async {
    if (_userDatabase != null) return _userDatabase!;
    _userDatabase = await _initDB('edumi.db', _createUserDatabase);
    return _userDatabase!;
  }

  // Getter for the consultation database (edumi_another.db)
  Future<Database> get consultationDatabase async {
    if (_consultationDatabase != null) return _consultationDatabase!;
    _consultationDatabase = await _initDB('edumi_another.db', _createConsultationDatabase);
    return _consultationDatabase!;
  }

  // Generic method to initialize a database
  Future<Database> _initDB(String fileName, Function(Database, int) onCreate) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    print('Opening database at: $path'); // For debugging

    return await openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;'); // Enable foreign key support
      },
    );
  }

  // Create the users table in edumi.db
  Future<void> _createUserDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
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

  // Create the consultations table in edumi_another.db
  Future<void> _createConsultationDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE consultations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        consultantName TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');
  }

  // Methods for the user database (edumi.db)

  // Insert a new user (used during sign-up)
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.userDatabase;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  // Check if a username or email already exists
  Future<bool> checkUsernameExists(String username) async {
    final db = await instance.userDatabase;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<bool> checkEmailExists(String email) async {
    final db = await instance.userDatabase;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Fetch a user by username (used during sign-in)
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await instance.userDatabase;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Fetch all users (for debugging)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await instance.userDatabase;
    return await db.query('users');
  }

  // Methods for the consultation database (edumi_another.db)

  // Insert a new consultation
  Future<int> insertConsultation(Map<String, dynamic> consultation) async {
    final db = await instance.consultationDatabase;
    return await db.insert('consultations', consultation, conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  // Fetch all consultations for a user
  Future<List<Map<String, dynamic>>> getConsultationsByUserId(int userId) async {
    final db = await instance.consultationDatabase;
    return await db.query(
      'consultations',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // Fetch all consultations (for debugging)
  Future<List<Map<String, dynamic>>> getAllConsultations() async {
    final db = await instance.consultationDatabase;
    return await db.query('consultations');
  }

  // Close both databases
  Future<void> close() async {
    if (_userDatabase != null) {
      await _userDatabase!.close();
      _userDatabase = null;
    }
    if (_consultationDatabase != null) {
      await _consultationDatabase!.close();
      _consultationDatabase = null;
    }
  }
}
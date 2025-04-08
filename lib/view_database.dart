// view_database.dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'database_helper.dart';

void main() {
  try {
    final dbHelper = DatabaseHelper.instance;
    print('Opening database at: ${p.join(Directory.current.path, 'db.sqlite3')}');

    final result = dbHelper.db.select('SELECT * FROM users');

    if (result.isEmpty) {
      print('No users found in the database.');
    } else {
      print('Users in the database:');
      print('ID | First Name | Last Name | Username | Telephone | Email | Created At');
      print('-' * 80);
      for (var row in result) {
        print('${row['id']} | ${row['firstName']} | ${row['lastName']} | ${row['username']} | ${row['telephone']} | ${row['email']} | ${row['createdAt']}');
      }
    }

    dbHelper.close();
    print('Database closed.');
  } catch (e) {
    print('Error: $e');
  }
}
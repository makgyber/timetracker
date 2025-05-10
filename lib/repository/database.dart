import 'package:timetracker/features/authentication/models/authenticated_user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'timetracker.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {breeds} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE authenticated_users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, token TEXT)',
    );
  }

  // Define a function that inserts breeds into the database
  Future<void> insertAuthenticatedUser(AuthenticatedUser authenticatedUser) async {
    final db = await _databaseService.database;
    await db.insert(
      'authenticated_users',
      authenticatedUser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the breeds from the breeds table.
  Future<List<AuthenticatedUser>> authenticatedUser() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query('authenticated_users');

    // Convert the List<Map<String, dynamic> into a List<Breed>.
    return List.generate(maps.length, (index) => AuthenticatedUser.fromMap(maps[index]));
  }

  // A method that deletes a breed data from the breeds table.
  Future<void> deleteAuthenticatedUserById(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the Breed from the database.
    await db.delete(
      'authenticated_users',
      // Use a `where` clause to delete a specific breed.
      where: 'id = ?',
      // Pass the Breed's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> deleteAllAuthenticatedUsers() async {
    // Get a reference to the database.
    final db = await _databaseService.database;
    // Remove the Breed from the database.
    await db.delete('authenticated_users');
  }

}
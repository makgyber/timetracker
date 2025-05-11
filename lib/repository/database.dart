import 'package:timetracker/features/authentication/models/authenticated_user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timetracker/features/job_orders/models/address.dart';
import 'package:timetracker/features/job_orders/models/customer.dart';
import 'package:timetracker/features/job_orders/models/job_order.dart';

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
      version: 2,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE authenticated_users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, token TEXT)',
    );
    await db.execute(
      'CREATE TABLE addresses('
          'id INTEGER PRIMARY KEY, '
          'region TEXT, '
          'province TEXT, '
          'city TEXT, '
          'barangay TEXT,'
          'street TEXT,'
          'longitude TEXT,'
          'latitude TEXT'
          ')',
    );
    await db.execute(
      'CREATE TABLE customers('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'classification TEXT'
      ')',
    );
    await db.execute(
      'CREATE TABLE job_orders('
          'id INTEGER PRIMARY KEY, '
          'code TEXT, '
          'summary TEXT, '
          'target_date TEXT, '
          'job_order_type TEXT,'
          'status TEXT,'
          'client_id INTEGER,'
          'address_id INTEGER,'
          'FOREIGN KEY(client_id) REFERENCES customers(id),'
          'FOREIGN KEY(address_id) REFERENCES addresses(id)'
          ')'
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


  Future<List<JobOrder>> jobOrders() async {
    final db = await _databaseService.database;

    // Query the table for all the Breeds.
    final List<Map<String, dynamic>> maps = await db.query('job_orders');

    return List.generate(maps.length, (index) => JobOrder.fromJson(maps[index]));
  }

  Future<int> insertJobOrder(JobOrder jobOrder) async {
    final db = await _databaseService.database;
    var jsonVal = jobOrder.toJson();
    jsonVal.remove('client');
    jsonVal.remove('address');
    return await db.insert(
      'job_orders',
      jsonVal,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<int> insertCustomer(Customer customer) async {
    final db = await _databaseService.database;
    return await db.insert(
      'customers',
      customer.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertAddress(Address address) async {
    final db = await _databaseService.database;
    return await db.insert(
      'addresses',
      address.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}
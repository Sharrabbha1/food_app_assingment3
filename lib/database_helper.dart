import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  // Private constructor
  DatabaseHelper._privateConstructor();

  // Factory constructor to return the singleton instance
  factory DatabaseHelper() {
    return _instance;
  }

  // Database object
  static Database? _database;

  static var instance;

  // Getter to access the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'food_ordering.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cost REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE order_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        total_cost REAL NOT NULL
      )
    ''');
  }

  // CRUD Operations

  // Insert a food item
  Future<int> insertFoodItem(Map<String, dynamic> foodItem) async {
    final db = await database;
    return await db.insert('food_items', foodItem);
  }

  

  // Fetch all food items
  Future<List<Map<String, dynamic>>> fetchAllFoodItems() async {
    final db = await database;
    return await db.query('food_items');
  }

  // Update a food item
  Future<int> updateFoodItem(int id, Map<String, dynamic> updatedFoodItem) async {
    final db = await database;
    return await db.update(
      'food_items',
      updatedFoodItem,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a food item
  Future<int> deleteFoodItem(int id) async {
    final db = await database;
    return await db.delete(
      'food_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert an order plan
  Future<int> insertOrderPlan(Map<String, dynamic> orderPlan) async {
    final db = await database;
    return await db.insert('order_plans', orderPlan);
  }

  // Query an order plan by date
  Future<Map<String, dynamic>?> fetchOrderPlanByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'order_plans',
      where: 'date = ?',
      whereArgs: [date],
    );
    return result.isNotEmpty ? result.first : null;
  }
}

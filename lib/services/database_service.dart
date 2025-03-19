import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  final String dbName = 'evox_db.db';
  static final DatabaseService _instance = DatabaseService._();
  DatabaseService._();
  static DatabaseService get instance => _instance;
  static Database? _db;
  Future<Database> get db async => _db ??= await _initDB();

  Future<Database> _initDB() async {
    ensureOpen(dbName);
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, dbName);
    // deleteDatabase(dbPath);
    return await openDatabase(dbPath);
  }

  Future<void> deleteDatabase(String path) {
    return databaseFactory.deleteDatabase(path);
  }

  ensureOpen(dbName) async {
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final version = 1;
      final db = await openDatabase(
        dbPath,
        onCreate: (db, version) {
          //create tables
          var batch = db.batch();
          batch.execute(createMeasurement);
          batch.execute(createIngredientTable);
          batch.execute(createInventoryTable);
          batch.execute(createRecepieIngredientTable);
          batch.execute(createRecepiesTable);
          batch.execute(insertIngredient);
          batch.execute(insertInventory);
          batch.execute(insertMeasurement);
          batch.commit();
        },
        // onConfigure: (db) {},
        // onUpgrade: (db, oldVersion, newVersion) {},
        // onDowngrade: (db, oldVersion, newVersion) {},
        // onOpen: (db) {}, //TODO: tutututu du
        version: version,
      );
      _db = db;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}

const createIngredientTable =
    'CREATE TABLE IF NOT EXISTS "Ingredient" ("id"	INTEGER NOT NULL UNIQUE, "name"	TEXT NOT NULL, "measure_id"	INTEGER NOT NULL, PRIMARY KEY("id" AUTOINCREMENT));';

const createInventoryTable =
    'CREATE TABLE IF NOT EXISTS "Inventory" ("id"	INTEGER NOT NULL UNIQUE, "ingredient_id"	INTEGER NOT NULL, "quantity"	INTEGER NOT NULL, PRIMARY KEY("id" AUTOINCREMENT));';

const createRecepiesTable =
    'CREATE TABLE IF NOT EXISTS "Recipe" ("id" INTEGER NOT NULL UNIQUE, "name"	TEXT, "duration" INTEGER,"meal_of_day_id" INTEGER, "instructions"	TEXT, PRIMARY KEY("id" AUTOINCREMENT));';

const createRecepieIngredientTable =
    'CREATE TABLE IF NOT EXISTS "RecipeIngredient" ("id"	INTEGER NOT NULL UNIQUE,"ingredient_id"	INTEGER NOT NULL,"recipe_id"	INTEGER NOT NULL,"quantity"	INTEGER NOT NULL, PRIMARY KEY("id" AUTOINCREMENT));';

const createMeasurement =
    'CREATE TABLE IF NOT EXISTS "Measurement" ("id"	INTEGER NOT NULL UNIQUE,"name" TEXT NOT NULL, PRIMARY KEY("id" AUTOINCREMENT));';
const insertMeasurement =
    'INSERT INTO "Measurement" ("id", "name") VALUES (1, \'Measure\')';
const insertIngredient =
    'INSERT INTO "Ingredient" ("id","name", "measure_id") VALUES (1,\'Ingredient\',1);';
const insertInventory =
    'INSERT INTO "Inventory" ("id","ingredient_id","quantity") VALUES (1,1,1);';

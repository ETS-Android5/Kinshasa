/* * This file is the database helper file for retrieving the data from the 
 * Favorites database. 
 */

import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'DrinkModel.dart';

class DBHelper {
  static Database _db;
  static const String NAME = "DrinkName";
  static const String LINK = "ImageLink";
  static const String INGREDIENTS = "Ingredients";
  static const String PROCEDURE = "Procedure";
  static const String NUTRIENTS = "Nutrients";
  static const String TABLE = "Favorites";
  static const String DB_NAME = "favorites.db";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($NAME TEXT PRIMARY KEY UNIQUE, $LINK TEXT UNIQUE,"
        "$INGREDIENTS TEXT UNIQUE, $PROCEDURE TEXT UNIQUE,"
        " $NUTRIENTS TEXT UNIQUE)");
  }

// Insert data into the favorites table/database
  Future<Drink> insert(Drink drink) async {
    var dbclient = await db;
    await dbclient.insert(TABLE, drink.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return drink;
  }

// Get all items in the favorites database
  Future<List<Drink>> getFavorites() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE);
    List<Drink> favorites = [];
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        favorites.add(Drink.fromFavoriteMap(maps[i]));
      }
    }
    return favorites;
  }

// Delete a favorite item from the database
  Future<int> delete(String name) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$NAME = ?', whereArgs: [name]);
  }

// Delete all favorite items from database
  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.delete(
      TABLE,
    );
  }
}

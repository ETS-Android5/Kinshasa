/* * This file is the database helper file for retrieving the data from the 
 * DRINKS database. 
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'DRINKS.db';
  static final _databaseVersion = 1;
  static final juiceTable = 'tableJuice';
  static final smoothieTable = 'tableSmoothie';
  static final shakeTable = 'tableShake';

  //constructor
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);

    // check if database already exists
    await deleteDatabase(path);
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // copy
    ByteData data = await rootBundle.load(join("assets", _databaseName));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // write
    await File(path).writeAsBytes(bytes, flush: true);

    return await openDatabase(path, version: _databaseVersion);
  }

  // CRUD
  //=====================================================================

  // Get juice data
  Future<List> getJuiceData() async {
    Database db = await instance.database;
    var result = await db.query(juiceTable);
    return result.toList();
  }

  // Get smoothie data
  Future<List> getSmoothieData() async {
    Database db = await instance.database;
    var result = await db.query(smoothieTable);
    return result.toList();
  }

  // Get shake data
  Future<List> getShakeData() async {
    Database db = await instance.database;
    var result = await db.query(shakeTable);
    return result.toList();
  }

  // ==========================================================================
  // Get the number of items in each table for display in the app bar in the
  // all screen

  // Raw query to get the number of objects in the juice table
  Future<int> getJuiceCount() async {
    var dbClient = await instance.database;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $juiceTable'));
  }

  // Raw query to get the number of objects in the smoothie table
  Future<int> getSmoothieCount() async {
    var dbClient = await instance.database;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $smoothieTable'));
  }

  // Raw query to get the number of objects in the shake table
  Future<int> getShakeCount() async {
    var dbClient = await instance.database;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $shakeTable'));
  }
}

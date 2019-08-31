
import 'dart:async';
import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import 'package:vscout/transfer.dart';
/// The database handler object that contains database intialization functions.
abstract class DatabaseHandler {
  Database database;
  StoreRef store;
  //TODO: Make file paths and file objects private, and use getters and setters to publicly access instead.
  File databaseFile;
  String relativeDatabasePath;
  String absoluteDatabasePath;
  Uuid _uuid = Uuid();

  String get randomId {
    return _uuid.v4();
  }

  int get now {
    return DateTime.now().millisecondsSinceEpoch;
  }

  Future initializeDatabase(String relativeDatabasePath) async {
    //Set the path to the database
    this.relativeDatabasePath = relativeDatabasePath;
    this.absoluteDatabasePath =
        ("${dirname(Platform.script.toFilePath()).toString()}${relativeDatabasePath}");
    // If no database.

    if (!await this.openDb()) {
      return false;
    }
    await this.setStore();
    return true;
  }

  Future createDatabaseFile() async {
    this.databaseFile = new File(this.absoluteDatabasePath);
    bool databaseExists = await this.databaseFile.exists();
    databaseExists = databaseExists ? true : await this.createDatabaseFile();
    return (await this.databaseFile.create() is File) ? true : false;
  }

  Future openDb() async {
    // Only open an existing database, else, catch error and return false.
    try {
      this.database = await databaseFactoryIo
          .openDatabase(this.absoluteDatabasePath, mode: DatabaseMode.existing);
    } on DatabaseException catch (e) {
      return false;
    }
    return true;
  }

  Future setStore({storeName}) async {
    this.store = stringMapStoreFactory.store(storeName);
    return this.store;
  }

  Future<Response> respond<T>(data, origin,
      {bool failed = false, bool join = false, String dataType = 'key'}) async {
    Response<T> response = Response();
    Map record = Map();
    List<Map> records = List();

    if (data is String) {
      record = {"key": data, "value": null};
      records.add(record);
    } else if (data is Map) {
      records.add(data);
    } else if (data is List<String>) {
      for (String key in data) {
        record = {"key": key, "value": null};
        records.add(record);
      }
    } else if (data is List<Map>) {
      records += data;
    }
    await response.addRecords(records, origin, failed: failed);
    return response;
  }
}

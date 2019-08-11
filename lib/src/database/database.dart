library vscout_cli.database;

import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../response/response.dart';

class DatabaseHandler {
  Database database;
  StoreRef store;

  File databaseFile;
  String relativeDatabasePath;
  String absoluteDatabasePath;

  Map _resultFields;

  static final DatabaseHandler _singleton = new DatabaseHandler._internal();

  factory DatabaseHandler() {
    return _singleton;
    // Constructors can't call async functions, actual initialization is done in [InitializeDb()].
  }

  DatabaseHandler._internal() {}

  initializeDatabase() async {
    this._resultFields = new Map();
    this._resultFields['status'] = HttpStatus.processing;
    //Set the path to the database
    this.relativeDatabasePath = '/../database/vscout.db';
    this.absoluteDatabasePath =
        ("${dirname(Platform.script.toFilePath()).toString()}${this.relativeDatabasePath}");

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

  Future<Response> findEntries(properties) async {
    Map results = new Map.from(this._resultFields);
    List<Filter> filters = List();
    properties.forEach((k, v) => filters.add(Filter.matches(k, v)));
    List records;

    await this.database.transaction((txn) async {
      records = await this
          .store
          .findKeys(txn, finder: Finder(filter: Filter.and(filters)));
    });
    return await this.respond(records, 'FIND', join: true);
  }

  Future<Response> respond(data, origin,
      {bool failed = false, bool join = false}) async {
    Response response = Response();
    await response.addData(data, origin, failed: failed, join: join);
    return response;
  }

  Future<Response> addEntry(entry) async {
    /// Adds Map entry into database.
    Response response = Response();
    var uuid = new Uuid();
    // Get current time to add to entry
    var now = new DateTime.now().millisecondsSinceEpoch.toString();
    entry['time'] = now;
    // Randomly generate a UUID for the key to avoid collisions in distrubuted Db.
    String key = uuid.v4();
    await this.database.transaction((txn) async {
      await this.store.record(key).put(txn, entry);
      key = this.store.record(key).key;
    });
    return await this.respond(key, 'ADD');
  }

  Future<Response> updateEntry(String entryRecord, Map updateData) async {
    /// Updates a single record in database.
    Response response = Response();
    var key;
    await this.database.transaction((txn) async {
      await this.store.record(entryRecord).update(txn, updateData);
      key = this.store.record(entryRecord).key;
    });
    return await this.respond(key, 'UPDATE');
  }
}

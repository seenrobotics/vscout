library vscout_cli.database;

import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

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

  DatabaseHandler._internal() {
    //
  }

  InitializeDb() async {
    this._resultFields = new Map();
    this._resultFields['status'] = HttpStatus.processing;
    //Set the path to the database
    this.relativeDatabasePath = '/../database/vscout.db';
    this.absoluteDatabasePath =
        ("${dirname(Platform.script.toFilePath()).toString()}${this.relativeDatabasePath}");
    this.database = await this.openDb();
    await this.setStore();

    return true;
  }

  Future createDatabaseFile() async {
    return (await this.databaseFile.create() is File) ? true : false;
  }

  Future openDb() async {
    //Check if database file exists and create it if not.
    this.databaseFile = new File(this.absoluteDatabasePath);
    bool databaseExists = await this.databaseFile.exists();
    databaseExists = databaseExists ? true : await this.createDatabaseFile();
    //Wait for database file to be created, proceed to open it.
    this.database = databaseExists
        ? await databaseFactoryIo.openDatabase(this.absoluteDatabasePath)
        : false;
    return this.database;
  }

  Future setStore({storeName}) async {
    this.store = stringMapStoreFactory.store(storeName);
    return this.store;
  }

  Future findEntries(properties) async {
    Map results = new Map.from(this._resultFields);
    List<Filter> filters = List();
    properties.forEach((k, v) => filters.add(Filter.matches(k, v)));
    var records;

    await this.database.transaction((txn) async {
      records = await this
          .store
          .findKeys(txn, finder: Finder(filter: Filter.and(filters)));
    });

    results['data'] = records;
    results['status'] = HttpStatus.ok;
    return results;
  }

  Future addEntry(entry) async {
    /// Adds Map entry into database.
    Map results = new Map.from(this._resultFields);
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
    results['data'] = key;
    results['status'] = HttpStatus.ok;
    return results;
  }

  Future updateEntry(String entryRecord, Map updateData) async {
    /// Updates a single record in database.
    Map results = new Map.from(this._resultFields);
    var key;
    await this.database.transaction((txn) async {
      await this.store.record(entryRecord).update(txn, updateData);
      key = this.store.record(entryRecord).key;
    });
    results['data'] = key;
    print(key);
    results['status'] = HttpStatus.ok;
    return results;
  }
}

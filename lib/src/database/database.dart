library vscout_cli.database;

import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DatabaseHandler {
  Database db;
  Store store;
  File databaseFile;
  String relativeDatabasePath;
  String realDatabasePath;
  Map resultFields;

  static final DatabaseHandler _singleton = new DatabaseHandler._internal();

  factory DatabaseHandler() {
    return _singleton;
    // Constructors can't call async functions, actual initialization is done in [InitializeDb()].
  }

  DatabaseHandler._internal() {
    //
  }

  InitializeDb() async {
    this.resultFields = new Map();
    this.resultFields['status'] = null;
    this.resultFields['data'] = null;
    //Set the path to the database
    this.relativeDatabasePath = '/../database/vscout.db';
    this.realDatabasePath = (dirname(Platform.script.toFilePath()).toString() +
        this.relativeDatabasePath);
    this.db = await this.openDb();
    this.SetStore('main');
    return true;
  }

  Future createDatabaseFile() async {
    return (await this.databaseFile.create() is File) ? true : false;
  }

  Future openDb() async {
    //Check if database file exists and create it if not.
    this.databaseFile = new File(this.realDatabasePath);
    bool databaseExists = await this.databaseFile.exists();
    databaseExists = databaseExists ? true : await this.createDatabaseFile();
    //Wait for database file to be created, proceed to open it.
    this.db = databaseExists
        ? await databaseFactoryIo.openDatabase(this.realDatabasePath)
        : false;
    return this.db;
  }

  SetStore(storeName) {
    this.store = this.db.getStore(storeName);
  }

  Future getMatches(properties) async {
    Map results = new Map.from(this.resultFields);
    List<Filter> filters = List();
    properties.forEach((k, v) => filters.add(Filter.matches(k, v)));
    var records =
        (await this.store.findRecords(Finder(filter: Filter.and(filters))));
    results['data'] = records;
    results['status'] = 200;
    return results;
  }

  Future addEntry(entry) async {
    /// Adds Map entry into database.
    Map results = new Map.from(this.resultFields);
    var uuid = new Uuid();
    // Get current time to add to entry
    var now = new DateTime.now().millisecondsSinceEpoch.toString();
    entry['time'] = now;
    // Randomly generate a UUID for the key to avoid collisions in distrubuted Db.
    String key = uuid.v4();
    Record record = Record(store, entry, key);
    record = await this.db.putRecord(record);
    results['data'] = record;
    results['status'] = 200;
    return results;
  }
}

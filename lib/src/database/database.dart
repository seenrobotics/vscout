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
  String absoluteDatabasePath;
  DatabaseHandler() {
    // Constructors can't call async functions, actual initialization is done in [InitializeDb()].
  }

  InitializeDb() async {
    //Set the path to the database.
    this.relativeDatabasePath = '/../database/vscout.db';
    this.absoluteDatabasePath = (dirname(Platform.script.toFilePath()).toString() +
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
    this.databaseFile = new File(this.absoluteDatabasePath);
    bool databaseExists = await this.databaseFile.exists();
    databaseExists = databaseExists ? true : await this.createDatabaseFile();
    //Wait for database file to be created, proceed to open it.
    this.db = databaseExists
        ? await databaseFactoryIo.openDatabase(this.absoluteDatabasePath)
        : false;
    return this.db;
  }

  SetStore(storeName) {
    this.store = this.db.getStore(storeName);
  }

  Future getMatches(properties) async {
    List<Filter> filters = List();
    properties.forEach((k, v) => filters.add(Filter.matches(k, v)));
    print(filters);
    var records =
        (await this.store.findRecords(Finder(filter: Filter.and(filters))));
    return records;
  }

  Future addEntry(entry) async {
    /// Adds Map entry into database.
    var uuid = new Uuid();
    // Get current time to add to entry
    var now = new DateTime.now().millisecondsSinceEpoch.toString();
    entry['time'] = now;
    // Randomly generate a UUID for the key to avoid collisions in distrubuted Db.
    String key = uuid.v4();
    Record record = Record(store, entry, key);
    record = await this.db.putRecord(record);
    return '${record.toString()}';
  }
}

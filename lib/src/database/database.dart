import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

String dbPath = '/../database/vscout.db';
var pathToDb = (dirname(Platform.script.toFilePath()).toString() + dbPath);

class DatabaseHandler {
  Database db;
  Store store;

  DatabaseHandler() {
    // Constructors can't call async functions, proper initialization is done in [InitializeDb()].
  }

  InitializeDb() async {
    this.db = await this.newDb();
    this.SetStore('main');
    return true;
  }

  Future newDb() async {
    this.db = await databaseFactoryIo.openDatabase(pathToDb);
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

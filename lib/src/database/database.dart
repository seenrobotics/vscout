import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'dart:io';

String dbPath = '/../database/vscout.db';
var pathToDb = (dirname(Platform.script.toFilePath()).toString() + dbPath);

class DatabaseHandler {
  Database db;
  Store store;

  DatabaseHandler() {
    //InitializeDb();
    // Constructors can't call async functions, proper initialization is done in InitializeDb
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

  Future addEntry(properties) async {
    // Check of datatype
    print(properties);
    if(!(properties.containsKey('dataType')&&properties['dataType'].isNotEmpty&&properties['dataType'] is String)) {
      return 'Error - Datatype not set or invalid';
    }

      String result = "";
      Record record = Record(store, properties);
      try {
        record = await this.db.putRecord(record);
      } on FormatException {
        return 'format error';
        //TODO: throw and catch database errors, probably in a new method
      } catch (e) {
        return (e);
        // ^^^
      }
      result += ('Added new team entry \n \n');
      result += (record.toString());
    
    return result;
  }
}

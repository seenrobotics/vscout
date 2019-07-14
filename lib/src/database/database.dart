import 'package:test/test.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
String dbPath = '/../database/vscout.db';
var pathToDb = (dirname(Platform.script.toFilePath()).toString()+dbPath);



class DatabaseHandler {
  Database db;
  Store store;

  DatabaseHandler()  {
    //InitializeDb();
    // Constructors can't call async functions, proper initialization is done in InitializeDb
  }
  
  InitializeDb() async{
    this.db = await this.newDb();
    this.SetStore('main');
    return true;
  }

  Future newDb() async {
    this.db = await databaseFactoryIo
      .openDatabase(pathToDb);
    return this.db;
  }
  SetStore(storeName) {
    this.store = this.db.getStore(storeName);
  }

  Future getMatches(properties) async {
    List<Filter> filters = new List();
    properties.forEach((k,v) => 
      filters.add(Filter.matches(k,v))
    );
    print(filters);
    var records =
      (await this.store.findRecords(Finder(filter: Filter.and(filters))));
    return records;
  }

  Future addTeamEntry(String teamId) async {
    String result = "";
    // Check if entry already exists
    var records = await getMatches({'teamId' : teamId});

    if(records.isNotEmpty)
    {
      result += "Team Already Exists \n";
      result += records.toString();
    } else{
      Record record = Record(store, {"teamId": teamId});
      try {
        record = await this.db.putRecord(record);
      } on FormatException
      {
        return 'format error';
        //TODO: throw and catch database errors, probably in a new method
      } catch(e)
      {
        return(e);
        // ^^^
      }
      result += ('Added new team entry \n \n');
      result += (record.toString());
    }
    return result;
  }
}
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

  Future getTeamEntry(String teamID) async {
    
  }

  Future addTeamEntry(String teamID) async {
    String result = "";
    // Check for if entry already exists
    var records =
      (await this.store.findRecords(Finder(filter: Filter.matches("teamID", teamID))));

    if(records.isNotEmpty)
    {
      result += "Team Already Exists \n";
      result += records.toString();
    } else{
      Record record = Record(store, {"teamID": teamID});
      try {
        record = await this.db.putRecord(record);
      } on FormatException
      {
        return 'format error';
        //idk what to do here
      } catch(e)
      {
        return(e);
        //idk what to do here either
      }
      //It worked
      result += ('It worked! \n \n');
      result += (record.toString());
    }
    return result;
  }
}
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
    this.newDB();
    //this code block isnt setting the database for some reason 
    // I think its because futures don't work in the constructor
    // Ill figure this out later
  }

  Future newDB() async {
    this.db = await databaseFactoryIo
      .openDatabase(pathToDb);
    return this.db;
  }

  Future addTeamEntry(String teamID) async {
    String result = "";
    this.db = await this.newDB();
    //If I just skip to this, it says database is null, even though DatabaseHandler ran already
    this.store = this.db.getStore('teams');
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
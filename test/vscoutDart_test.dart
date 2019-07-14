import 'package:test/test.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'dart:io';
String dbPath = 'test.db';

Future main() async {
  Database db = await databaseFactoryIo
      .openDatabase(join(".dart_tool", "sembast", "example", dbPath));
  Store store = db.getStore("main");
  Record record = Record(store, {"name": "ugly"});
  record = await db.putRecord(record);
  record = await store.getRecord(record.key);
  record =
      (await store.findRecords(Finder(filter: Filter.byKey(record.key)))).first;
  print(record);
  record = await store.getRecord(record.key);
  
  var records =
      (await store.findRecords(Finder(filter: Filter.matches("name", "^ugl"))));
  print(records);
}
// void main() {

//   test('calculate', () {
//     expect(calculate(), 42);
//   });
//   String dbPath = 'test.db';
//   DatabaseFactory dbFactory = databaseFactoryIo;
//   Database db = await dbFactory.openDatabase(dbPath);

//   await db.put('Simple application', 'title');
//   await db.put(10, 'version');
//   await db.put({'offline': true}, 'settings');
// }

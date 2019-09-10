import 'package:sembast/sembast.dart';

import 'package:vscout/database.dart' show DatabaseHandler;

/// Database handler object that records changes to the database to allow for syncing and reverting changes.
class ModifyHandler extends DatabaseHandler {
  List<Filter> filterList = List();

  static final ModifyHandler _singleton = ModifyHandler._internal();

  factory ModifyHandler() {
    return _singleton;
  }
  @override
  ModifyHandler._internal();

  addModify(List<String> keyset, String method, {Map data}) async {
    Map<String, dynamic> entry = Map();
    var key = DateTime.now().millisecondsSinceEpoch.toString();
    entry['time'] = key;
    entry['method'] = method;
    entry['keyset'] = keyset;
    entry['properties'] = data;
    await this.database.transaction((txn) async {
      await this.store.record(key).put(txn, entry);
      key = this.store.record(key).key;
    });
  }
}

import './mainDatabaseHandler.dart';

import 'dart:async';
import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../utils/parse/parse.dart';
import 'package:tuple/tuple.dart';

import 'package:vscout/transfer.dart';
import './databaseHandler.dart';

class ModifyHandler extends DatabaseHandler {
  List<Filter> filterList = List();

  RegExp queryRegExp = RegExp(r"^QUERY~-?[1234567890]+$", multiLine: false);
  RegExp filterRegExp = RegExp(r"^FIND@-?[1234567890]+$", multiLine: false);
  RegExp filterDBRegExp = RegExp(r"^FIND~-?[1234567890]+$", multiLine: false);

  Map _resultFields = {
    "status": HttpStatus.processing,
  };

  @override
  static final ModifyHandler _singleton = new ModifyHandler._internal();

  factory ModifyHandler() {
    return _singleton;
  }
  @override
  ModifyHandler._internal() {}

  Future initialize2() {}

  addModify(List<String> keyset, String method, {Map data}) async {
    Map<String, dynamic> entry = Map();
    var key = new DateTime.now().millisecondsSinceEpoch.toString();
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

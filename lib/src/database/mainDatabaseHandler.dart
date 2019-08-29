library vscout.main_database_handler;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:tuple/tuple.dart';
import 'package:vscout/src/utils/utils.dart';

import 'package:vscout/transfer.dart';
import './databaseHandler.dart';
import './modifyHandler.dart';

class MainDatabaseHandler extends DatabaseHandler {
  RegExp keysetRegExp = RegExp(r"^KEYS@-?[1234567890]+$", multiLine: false);

  List<List<String>> keysetList = List();
  Uuid uuid = Uuid();
  Map _resultFields = {
    "status": HttpStatus.processing,
  };

  static final MainDatabaseHandler _singleton =
      new MainDatabaseHandler._internal();

  factory MainDatabaseHandler() {
    return _singleton;
    // Constructors can't call async functions, actual initialization is done in [InitializeDb()].
  }

  MainDatabaseHandler._internal() {}

  Future initialize2() async {
    await ModifyHandler().initializeDatabase(this.relativeDatabasePath);
    await ModifyHandler().setStore(storeName: 'modify');
  }

  Future<Response> respond<T>(data, origin,
      {bool failed = false, bool join = false, String dataType = 'key'}) async {
    Response<T> response = Response();
    Map record = Map();
    List<Map> records = List();

    if (data is String) {
      record = {"key": data, "value": null};
      records.add(record);
    } else if (data is Map) {
      records.add(data);
    } else if (data is List<String>) {
      for (String key in data) {
        record = {"key": key, "value": null};
        records.add(record);
      }
    } else if (data is List<Map>) {
      records += data;
    }
    await response.addRecords(records, origin, failed: failed);
    return response;
  }

  Future<Response> updateEntry(String entryRecord, Map updateData) async {
    /// Updates a single record in database.
    Response response = Response();
    var key;
    await this.database.transaction((txn) async {
      await this.store.record(entryRecord).update(txn, updateData);
      key = this.store.record(entryRecord).key;
    });
    return await this.respond(key, 'UPDATE');
  }

  int keysetRefIndex(String ref) {
    int keysetIndex;
    if (keysetRegExp.hasMatch(ref)) {
      keysetIndex =
          int.parse(keysetRegExp.stringMatch(ref).toString().substring(5));
    }
    return keysetIndex;
  }

  List<String> findEntriesRef(String ref) {
    int refIndex = keysetRefIndex(ref);
    return keysetList[refIndex];
  }

  Future<Response> findEntriesFilter(Filter filter) async {
    List<String> records;
    await this.database.transaction((txn) async {
      records = await this.store.findKeys(txn, finder: Finder(filter: filter));
    });
    addKeyset(records);
    return await this.respond<String>(records, 'FIND');
  }

  Future<Response> findEntries(properties) async {
    Map results = new Map.from(this._resultFields);
    List<Filter> filters = List();
    properties.forEach((k, v) => filters.add(Filter.matches(k, v)));
    List<String> records;

    await this.database.transaction((txn) async {
      records = await this
          .store
          .findKeys(txn, finder: Finder(filter: Filter.and(filters)));
    });
    return await this.respond<String>(records, 'FIND');
  }

  addKeyset(List<String> keyset) {
    if (keysetList.isEmpty || keysetList[0] != keyset) {
      keysetList.insert(0, keyset);
    }
  }

  Future<Map<String, dynamic>> convertData(List<List> dataList) async {
    Map<String, dynamic> entry = Map();
    for (List dataSet in dataList) {
      if (dataSet.length == 2) {
        entry[dataSet[0]] = dataSet[1];
      } else if (dataSet.length == 1 && dataSet[0] is Map<String, dynamic>) {
        entry.addAll(dataSet[0]);
      }
    }
    return entry;
  }

  Response joinResponse(List<Response> responseList) {
    Response resultResponse = Response();
    for (Response response in responseList) {
      resultResponse.joinResponse(response);
    }
    return resultResponse;
  }

  Future<Response> addEntry(List<Tuple2> entryRecords) async {
    List<List> dataList = List();
    List<String> keys = List();
    for (Tuple2 entryTuple in entryRecords) {
      if (entryTuple.item1 == "data") {
        dataList.add(entryTuple.item2);
      } else if (entryTuple.item1 == "json" && entryTuple.item2 is String) {
        dataList.add(JsonDecoder().convert(entryTuple.item2));
      }
    }
    Map<String, dynamic> entry = await convertData(dataList);
    entry['time'] = now;
    keys.add(randomId);
    await this.database.transaction((txn) async {
      await this.store.record(keys[0]).put(txn, entry);
      keys[0] = this.store.record(keys[0]).key;
    });
    addKeyset(keys);
    ModifyHandler().addModify(keys, 'ADD', data: entry);
    return await this.respond(keys, 'ADD');
  }

  Future<Response> updateEntries(List<Tuple2> entryRecords) async {
    List<List> dataList = List();
    List<String> keys = List();
    for (Tuple2 entryTuple in entryRecords) {
      if (entryTuple.item1 == "key") {
        keys.add(entryTuple.item2[0]);
      } else if (entryTuple.item1 == "ref") {
        keys += findEntriesRef(entryTuple.item2[0]);
      } else if (entryTuple.item1 == "data") {
        dataList.add(entryTuple.item2);
      } else if (entryTuple.item1 == "json" && entryTuple.item2 is String) {
        dataList.add(JsonDecoder().convert(entryTuple.item2));
      }
    }
    Map<String, dynamic> updateData = await convertData(dataList);
    List<Response> result = List();
    await this.database.transaction((txn) async {
      for (String record in keys) {
        await this.store.record(record).update(txn, updateData);
        result.add(await this.respond(record, "UPDATE"));
      }
    });
    addKeyset(keys);
    ModifyHandler().addModify(keys, 'UPDATE', data: updateData);
    return joinResponse(result);
  }

  Future<Response> removeEntry(String entryRecord) async {
    await this.database.transaction((txn) async {
      await this.store.record(entryRecord).delete(txn);
    });
    return await this.respond(entryRecord, "REMOVE");
  }

  Future<List<Response>> removeEntries(List entryRecords) async {
    List<Response> result = List();
    await this.database.transaction((txn) async {
      for (String record in entryRecords) {
        await this.store.record(record).delete(txn);
        result.add(await this.respond(record, "UPDATE"));
      }
    });
    ModifyHandler().addModify(entryRecords, 'REMOVE');
    return await result;
  }

  Future<Response> rmEntries(List<Tuple2> entryRecords) async {
    List<String> keys = List();
    for (Tuple2 entryTuple in entryRecords) {
      if (entryTuple.item1 == "key") {
        keys.add(entryTuple.item2[0]);
      } else if (entryTuple.item1 == "ref") {
        keys += findEntriesRef(entryTuple.item2[0]);
      }
    }
    addKeyset(keys);
    List<Response> result = List();
    List<RecordSnapshot> resultRecords;
    Iterable<String> asdf = keys.skip(0);
    await this.database.transaction((txn) async {
      await this.store.records(asdf).delete(txn);
    });
    for (var record in keys) {
      result.add(await this.respond(record, 'RM'));
    }
    ModifyHandler().addModify(keys, "REMOVE");
    return joinResponse(result);
  }

  Future<List<Response>> lsEntries(List<Tuple2> entryRecords) async {
    List<String> keys = List();
    for (Tuple2 entryTuple in entryRecords) {
      if (entryTuple.item1 == "key") {
        keys.add(entryTuple.item2[0]);
      } else if (entryTuple.item1 == "ref") {
        keys += findEntriesRef(entryTuple.item2[0]);
      }
    }
    addKeyset(keys);
    //TODO: Take parameters of number of returns + specific properties to list is specified
    List<Response> result = List();
    List<RecordSnapshot> resultRecords;
    Iterable<String> asdf = keys.skip(0);
    await this.database.transaction((txn) async {
      resultRecords = await this.store.records(asdf).getSnapshots(txn);
    });
    for (var record in resultRecords) {
      var recordMap = {'key': record.key, 'value': record.value};
      result.add(await this.respond(recordMap, 'LS'));
    }

    return result;
  }
}

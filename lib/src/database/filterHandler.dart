import 'dart:async';

import 'package:sembast/sembast.dart';
import 'package:tuple/tuple.dart';

import 'package:vscout/transfer.dart';
import 'package:vscout/database.dart' show DatabaseHandler;

/// The filter handler object that CRUDs dynamic filters to be used to search a database.
class FilterHandler extends DatabaseHandler {
  List<Filter> filterList = List();

  RegExp filterRegExp = RegExp(r"^FIND@-?[1234567890]+$", multiLine: false);
  RegExp filterDBRegExp = RegExp(r"^FIND~-?[1234567890]+$", multiLine: false);

  static final FilterHandler _singleton = FilterHandler._internal();

  factory FilterHandler() {
    return _singleton;
  }
  @override
  FilterHandler._internal();

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

  int filterRefIndex(String filterRef) {
    int filterIndex;
    if (filterRegExp.hasMatch(filterRef)) {
      filterIndex = int.parse(
          filterRegExp.stringMatch(filterRef).toString().substring(5));
    }
    return filterIndex;
  }

  int filterSavedIndex(String filterRef) {
    int filterIndex;
    if (filterDBRegExp.hasMatch(filterRef)) {
      filterIndex = int.parse(
          filterDBRegExp.stringMatch(filterRef).toString().substring(5));
    }
    return filterIndex;
  }

  Future<Filter> filterFromDatabase(int refIndex) async {
    var records;
    await this.database.transaction((txn) async {
      var count = await this.store.count(txn);
      Finder finder = Finder(offset: count - refIndex - 1);
      records = (await this.store.findFirst(txn, finder: finder)).value;
    });
    return records;
  }

  Future<Filter> filterFromRef(String filterRef) async {
    Filter filter;
    int refIndex = filterRefIndex(filterRef);
    if (refIndex != null && (refIndex < filterList.length)) {
      filter = filterList[refIndex];
    } else {
      refIndex = filterSavedIndex(filterRef);
      if (refIndex != null) {
        //TODO: check for less than length in filter store
        filter = await filterFromDatabase(refIndex);
      }
    }
    return filter;
  }

  Future<Tuple2<String, Filter>> getFilter(var filterRef) async {
    Filter filter;
    String from;
    if (filterRef is Filter) {
      from = 'filter';
      filter = filterRef;
    } else if (filterRef is List) {
      if (filterRef.length == 1) {
        from = filterRef[0];
        filter = await filterFromRef(filterRef[0]);
      } else if (filterRef.length == 3) {
        from = 'new';
        var key = filterRef[0];
        String check = filterRef[1];
        var value = filterRef[2];
        switch (check) {
          case "==":
            {
              filter = Filter.equals(key, value);
            }
            break;
          case "!=":
            {
              filter = Filter.notEquals(key, value);
            }
            break;
          case "IN":
            {
              filter = Filter.matches(key, value);
            }
            break;
        }
      }
    }
    return Tuple2(from, filter);
  }

  Future<Response> saveFilter(Filter filter) async {
    Map<String, dynamic> entry = Map();
    entry['filter'] = filter;

    /// Adds Map entry into database.
    // Get current time to add to entry
    var now = DateTime.now().millisecondsSinceEpoch.toString();
    entry['time'] = now;
    // Randomly generate a UUID for the key to avoid collisions in distrubuted Db.
    var key;
    await this.database.transaction((txn) async {
      key = await this.store.add(txn, entry);
    });

    Response response = Response();
    Map map = {"filter": filter, "key": key};
    response.addRecords([map], 'SAVE/FILTER');
    return response;
  }

  Future<Filter> setFilter(Tuple2<String, Filter> filterTuple) async {
    int refIndex = filterRefIndex(filterTuple.item1);
    Filter resultFilter;
    if ((refIndex != null)) {
      if (refIndex == -1) {
        filterList.insert(0, filterTuple.item2);
        resultFilter = filterList[0];
      } else {
        filterList[refIndex] = filterTuple.item2;
        resultFilter = filterList[refIndex];
      }
    } else {
      Response saveFilterResponse = await saveFilter(filterTuple.item2);
      resultFilter = saveFilterResponse.data[0]['filter'];
    }
    return resultFilter;
  }

  Future<Response> setFinder(var baseRef, List args,
      {bool create = false}) async {
    Tuple2 baseFilterTuple = await getFilter(baseRef);
    Filter baseFilter = baseFilterTuple.item2;
    Tuple2 setFilterTuple;
    Response response = Response();
    for (int i = 0; i < args.length; i += 2) {
      String method = args[i];
      Filter joinFilter = (await getFilter(args[i + 1])).item2;
      switch (method) {
        case "AND":
          {
            baseFilter = Filter.and([baseFilter, joinFilter]);
          }
          break;
        case "OR":
          {
            baseFilter = Filter.or([baseFilter, joinFilter]);
          }
          break;
        case "AS":
          {
            baseFilter = joinFilter;
          }
          break;
      }
    }
    if (baseFilterTuple.item1 == 'new' ||
        baseFilterTuple.item1 == 'filter' ||
        create) {
      setFilterTuple = Tuple2<String, Filter>('FIND@-1', baseFilter);
    } else {
      setFilterTuple = baseFilterTuple.withItem2(baseFilter);
    }

    Filter resultFilter = await setFilter(setFilterTuple);

    Map map = {"filter": resultFilter};
    response.addRecords([map], 'SET/FILTER');
    return response;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../../utils/utils.dart';
import '../model.dart';

class UpdateDataModel extends Model {
  updateStringData(String queryParameters, String queryData) async {
    ///Parse string JSON to Map and pass to [updateMapData] method.
    Map searchParameters = parseArgsJson(queryParameters);
    Map updateData = parseArgsJson(queryData);
    this.result = await this.updateMapData(searchParameters, updateData);
    this.result['query'] = [queryParameters, queryData];
    this.result['queryType'] = 'UPDATE/DATA/STRING';
    return this.result;
  }

  Stream resultStream(List searchResultData, Map updateData) async* {
    for (var record in searchResultData) {
      var updateResult =
          await this.databaseHandler.updateEntry((record), updateData);
      //Check if each update query was succesful individaully to identify exactly which query failed.
      if (updateResult['status'] != HttpStatus.ok) {
        //On fail, returns the failed query along with metadata.
        updateResult['query'] = [record, updateData];
        updateResult['queryType'] = 'UPDATE/DATA/MAP - UPDATE';
        throw updateResult;
      } else {
        yield await this.databaseHandler.updateEntry((record), updateData);
      }
    }
  }

  Future updateMapData(Map searchParameters, Map updateData) async {
    //Call Database Handler search method.
    //TODO: Make it not error when no results are found.
    Map searchResult =
        (await this.databaseHandler.findEntries(searchParameters));

    //Find entries to be updated.
    if (searchResult['status'] != HttpStatus.ok) {
      this.result = searchResult;
      this.result['query'] = searchParameters.toString();
      this.result['queryType'] = 'UPDATE/DATA/MAP - SEARCH';
      return this.result;
    }
    List updateResultData = List();
    List searchResultData = searchResult['data'];
    await for (var updateResult
        in this.resultStream(searchResultData, updateData)) {
      updateResultData.add(updateResult['data']);
    }
    this.result['data'] = updateResultData;
    this.result['status'] = HttpStatus.ok;
    this.result['query'] = [searchParameters, updateData];
    this.result['queryType'] = 'UPDATE/DATA/MAP - UPDATE';
    return this.result;
  }
}

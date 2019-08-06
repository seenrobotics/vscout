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

  Future updateMapData(Map searchParameters, Map updateData) async {
    //Call Database Handler search method.
    Map searchResult =
        (await this.databaseHandler.findEntries(searchParameters));
    //Find entries to be updated.
    if (searchResult['status'] != HttpStatus.ok) {
      this.result = searchResult;
      this.result['query'] = searchParameters.toString();
      this.result['queryType'] = 'UPDATE/DATA/MAP - SEARCH';
      return this.result;
    }

    List searchResultData = searchResult['data'];
    List updateResultData = [];
    var updateResult;
    for (var record in searchResultData) {
      //Update each record individually but asynchronously.
      //TODO: Rewrite function to update all entries in one transaction to improve effeciency.
      updateResult = await this.databaseHandler.updateEntry(record, updateData);
      updateResultData.add(updateResult['data']);
      //Check if each update query was succesful individaully to identify exactly which query failed.
      if (updateResult['status'] != HttpStatus.ok) {
        //On fail, returns the failed query along with metadata.
        this.result = updateResult;
        this.result['query'] = [record, updateData];
        this.result['queryType'] = 'UPDATE/DATA/MAP - UPDATE';
        return this.result;
      } else if (searchResultData.length == updateResultData.length) {
        //Query successful.
        this.result['data'] = updateResultData;
        this.result['status'] = HttpStatus.ok;
        this.result['query'] = [searchParameters, updateData];
        this.result['queryType'] = 'UPDATE/DATA/MAP - UPDATE';
        return this.result;
      }
    }
    ;
  }
}

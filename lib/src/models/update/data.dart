import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../../utils/utils.dart';
import '../model.dart';
import '../../response/response.dart';

class UpdateDataModel extends Model {
  updateStringData(String queryParameters, String queryData) async {
    ///Parse string JSON to Map and pass to [updateMapData] method.
    Map searchParameters = parseArgsJson(queryParameters);
    Map updateData = parseArgsJson(queryData);
    this.result = await this.updateMapData(searchParameters, updateData);
    this.result.statusCheck([
      [queryParameters, queryData],
      'STRING'
    ]);
    return this.result;
  }

  Stream<Response> resultStream(List searchResultData, Map updateData) async* {
    for (var record in searchResultData) {
      // print(record);
      var updateResult =
          await this.databaseHandler.updateEntry((record), updateData);
      //Check if each update query was succesful individaully to identify exactly which query failed.
      updateResult
          .statusCheck([record, updateData], 'UPDATE/DATA/MAP - UPDATE');
      yield await this.databaseHandler.updateEntry((record), updateData);
    }
  }

  Future updateMapData(Map searchParameters, Map updateData) async {
    //Call Database Handler search method.
    //TODO: Make it not error when no results are found.
    Response searchResult =
        (await this.databaseHandler.findEntries(searchParameters));

    //Find entries to be updated.
    searchResult
        .statusCheck([searchParameters.toString(), 'UPDATE/DATA/MAP - SEARCH']);
    // TODO: Result stack trace
    // print(searchResult.data);

    Response updateResponse = Response();
    List searchResultData = searchResult.data;
    await for (var updateResult
        in this.resultStream(searchResultData, updateData)) {
      updateResponse.joinResponse(updateResult);
    }
    this.result = updateResponse;
    return this.result;
  }
}

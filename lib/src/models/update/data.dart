import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../../utils/utils.dart';
import '../model.dart';
import '../../response/response.dart';
import 'dart:async';
import 'dart:mirrors';

class UpdateDataModel extends Model {
  UpdateDataModel() {}
  @override
  void handleInputData(input) async {
    // TODO: Instead of using a Map as the data, create a QUERY object similar to RESPONSE that is holds parameters and data
    if (input.method == 'data') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(
          this.updateStringData(input.queryParameters, input.queryData));
    }
  }

  Future<Response> updateStringData(
      String queryData, String queryParameters) async {
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
      yield updateResult;
    }
  }

  Future<Response> updateMapData(Map searchParameters, Map updateData) async {
    //Call Database Handler search method.
    //TODO: Make it not error when no results are found.
    Response searchResult =
        (await this.databaseHandler.findEntries(searchParameters));

    //Find entries to be updated.
    searchResult
        .statusCheck([searchParameters.toString(), 'UPDATE/DATA/MAP - SEARCH']);
    // TODO: Result stack trace
    Response updateResponse = Response();

    List searchResultData = searchResult.data;
    List updateResponseList =
        await this.databaseHandler.updateEntries(searchResultData, updateData);
    for (Response response in updateResponseList) {
      updateResponse.joinResponse(response);
    }
    // await for (var updateResult
    //     in this.resultStream(searchResultData, updateData)) {
    //   updateResponse.joinResponse(updateResult);
    // }
    this.result = updateResponse;
    return this.result;
  }
}

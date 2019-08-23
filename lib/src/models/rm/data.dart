import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../../utils/utils.dart';
import '../model.dart';
import '../../response/response.dart';

class RemoveDataModel extends Model {
  @override
  void handleInputData(data) async{
      this.outputController.add(await removeStringData(data["queryParameters"]));
  }
  Future<Response> removeStringData(String queryParameters) async {
    ///Parse string JSON to Map and pass to [removeMapData] method.
    Map searchParameters = parseArgsJson(queryParameters);
    this.result = await this.removeMapData(searchParameters);
    this.result.statusCheck([
      queryParameters,
      'STRING'
    ]);
    return this.result;
  }

  Stream<Response> resultStream(List searchResultData) async* {
    for (var record in searchResultData) {
      // print(record);
      var removeResult =
          await this.databaseHandler.removeEntry((record));
      //Check if each remove query was succesful individaully to identify exactly which query failed.
      removeResult
          .statusCheck([record], 'REMOVE/DATA/MAP - REMOVE');
      yield removeResult;
    }
  }

  Future removeMapData(Map searchParameters) async {
    //Call Database Handler search method.
    //TODO: Make it not error when no results are found.
    Response searchResult =
        (await this.databaseHandler.findEntries(searchParameters));

    //Find entries to be removed.
    searchResult
        .statusCheck([searchParameters.toString(), 'REMOVE/DATA/MAP - SEARCH']);
    // TODO: Result stack trace
    // print(searchResult.data);

    Response removeResponse = Response();
    List searchResultData = searchResult.data;
    await for (var removeResult
        in this.resultStream(searchResultData)) {
      removeResponse.joinResponse(removeResult);
    }
    this.result = removeResponse;
    return this.result;
  }
}

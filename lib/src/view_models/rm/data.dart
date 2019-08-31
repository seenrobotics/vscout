part of vscout.view_models;

class RmDataVM extends ViewModel {
  @override
  void handleInputData(input) async {
    // TODO: Instead of using a Map as the data, create a QUERY object similar to RESPONSE that is holds parameters and data
    if (input.method == 'data') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(this.removeData(input));
    }
  }

  Future<Response> removeData(Request data) async {
    Response resultResponse =
        await this.databaseHandler.rmEntries(data.optionArgs);
    this.result = resultResponse;
    return this.result;
  }

  Future<Response> removeStringData(String queryParameters) async {
    ///Parse string JSON to Map and pass to [removeMapData] method.
    Map searchParameters = parseArgsJson(queryParameters);
    this.result = await this.removeMapData(searchParameters);
    this.result.statusCheck([queryParameters, 'STRING']);
    return this.result;
  }

  Stream<Response> resultStream(List searchResultData) async* {
    for (var record in searchResultData) {
      // print(record);
      var removeResult = await this.databaseHandler.removeEntry((record));
      //Check if each remove query was succesful individaully to identify exactly which query failed.
      removeResult.statusCheck([record], 'REMOVE/DATA/MAP - REMOVE');
      yield removeResult;
    }
  }

  Future<Response> removeMapData(Map searchParameters) async {
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
    await for (var removeResult in this.resultStream(searchResultData)) {
      removeResponse.joinResponse(removeResult);
    }
    this.result = removeResponse;
    return this.result;
  }
}

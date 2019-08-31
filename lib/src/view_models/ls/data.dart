part of vscout.view_models;

class LsDataVM extends ViewModel {
  @override
  void handleInputData(input) async {
    // TODO: Instead of using a Map as the data, create a QUERY object similar to RESPONSE that is holds parameters and data
    if (input.method == 'data') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(this.lsStringData(input.queryParameters));
    }
  }

  Future<Response> lsStringData(String queryParameters) async {
    Map properties = parseArgsJson(queryParameters);
    await this.lsMapData(properties);
    this.result.statusCheck(queryParameters, 'LS/DATA/STRING');
    return this.result;
  }

  Future<Response> lsMapData(Map searchParameters) async {
    Response<String> searchResult =
        (await this.databaseHandler.findEntries(searchParameters));

    //Find entries to be updated.
    searchResult
        .statusCheck([searchParameters.toString(), 'LS/DATA/MAP - SEARCH']);
    // TODO: Result stack trace
    Response lsResponse = Response();
    List<String> searchResultKeys = searchResult.keys;
    List<Response> lsResponseList =
        await this.databaseHandler.lsEntries(searchResultKeys);
    for (Response response in lsResponseList) {
      lsResponse.joinResponse(response);
    }
    this.result = lsResponse;
    return this.result;
  }

  Future<Response> lsFileData(String relativeFilePath) async {
    String fileFolder = '/../files/';
    //  Tries to find file in [files] folder.
    var absFilePath =
        ("${dirname(Platform.script.toFilePath()).toString()}$fileFolder$relativeFilePath");
    final inputFile = new File(absFilePath);
    String fileContents;
    fileContents = await inputFile.readAsString();
    //  Decode file contents as JSON.
    Map baseMap = json.decode(fileContents);
    // Remove trailing white space, convert inputs to string to allow for staticly typed Dart methods.
    Map properties = Map<String, String>();
    baseMap.forEach((k, v) =>
        properties[k is String ? k.trim() : k.toString().trim()] =
            v is String ? v.trim() : v.toString().trim());
    await this.lsMapData(properties);
    this.result.statusCheck(relativeFilePath, 'LS/DATA/MAP');
    return this.result;
  }
}

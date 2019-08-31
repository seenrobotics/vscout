part of vscout.view_models;

class FindDataVM extends ViewModel {
  FilterHandler queryDBHandler = FilterHandler();

  @override
  void handleInputData(input) async {
    // TODO: Instead of using a Map as the data, create a QUERY object similar to RESPONSE that is holds parameters and data
    if (input.method == 'data') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(this.findFilter(input));
    }
  }

  Future<Response> findFilter(Request data) async {
    Tuple2 filterTuple = await queryDBHandler.getFilter(data.args[0]);
    this.result =
        await this.databaseHandler.findEntriesFilter(filterTuple.item2);
    this.result.statusCheck(data, 'FIND/DATA/Filter');
    return this.result;
  }

  Future<Response> findData(var data) async {
    // this.result = await this.databaseHandler.findEntries(dataEntry);
    // this.result.statusCheck(dataEntry, 'FIND/DATA/MAP');
    // return this.result;
  }

  Future<Response> findFileData(String relativeFilePath) async {
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
    await this.findData(properties);
    this.result.statusCheck(relativeFilePath, 'FIND/DATA/MAP');
    return this.result;
  }
}

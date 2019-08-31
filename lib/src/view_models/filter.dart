part of '../../view_models.dart';

class FilterVM extends ViewModel {
  FilterHandler queryDBHandler = FilterHandler();

  @override
  void handleInputData(input) async {
    // TODO: Instead of using a Map as the data, create a QUERY object similar to RESPONSE that is holds parameters and data
    if (input.method == 'filter') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(this.filterData(input));
    }
  }

  Future<Response> filterData(Request request) async {
    Response response;
    List args = request.args;
    response = await FilterHandler()
        .setFinder(args[0], args.sublist(1), create: request.flags['new']);
    if ((request.flags["new"])) {
      response.responseText = "Created new filter FIND@0";
    }
    return response;
  }

  Future<Response> findMapData(Map dataEntry) async {
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
    await this.findMapData(properties);
    this.result.statusCheck(relativeFilePath, 'FIND/DATA/MAP');
    return this.result;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../../utils/utils.dart';
import '../model.dart';
import '../../response/response.dart';

class FindDataModel extends Model {
  @override
  void handleInputData(input) async {
    // TODO: Instead of using a Map as the data, create a QUERY object similar to RESPONSE that is holds parameters and data
    if (input.method == 'data') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(this.findStringData(input.queryParameters));
    }
  }

  Future<Response> findStringData(String queryParameters) async {
    Map properties = parseArgsJson(queryParameters);
    await this.findMapData(properties);
    this.result.statusCheck(queryParameters, 'FIND/DATA/STRING');
    return this.result;
  }

  Future<Response> findMapData(Map dataEntry) async {
    this.result = await await this.databaseHandler.findEntries(dataEntry);
    this.result.statusCheck(dataEntry, 'FIND/DATA/MAP');
    return this.result;
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

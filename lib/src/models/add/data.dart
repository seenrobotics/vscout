import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import '../../utils/utils.dart';
import '../model.dart';
import '../../response/response.dart';

class AddDataModel extends Model {
  @override
  void handleInputData(input) async {
    // TODO: Instead of using a Map as the data, create a QUERY object similar to RESPONSE that is holds parameters and data
    if (input.method == 'data') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(this.addStringData(input.queryData));
    } else if (input.method == 'file') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(this.addFileData(input.queryData));
    }
  }

  Future<Response> addStringData(String dataEntry) async {
    Map properties = parseArgsJson(dataEntry);
    await this.addMapData(properties);
    this.result.statusCheck(dataEntry, 'ADD/DATA/STRING');
    return this.result;
  }

  Future addMapData(Map dataEntry) async {
    this.result = await this.databaseHandler.addEntry(dataEntry);
    this.result.statusCheck(dataEntry.toString(), 'ADD/DATA/MAP');
    return this.result;
  }

  Future addFileData(String relativeFilePath) async {
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
    await this.addMapData(properties);
    this.result.statusCheck(relativeFilePath, 'ADD/DATA/FILE');
    return this.result;
  }
}

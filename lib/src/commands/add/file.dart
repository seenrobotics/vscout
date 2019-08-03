import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

import '../../utils/utils.dart';

class FileCommand extends Command {
  @override
  String get name => 'file';
  @override
  String get description => 'Add entry to the database through JSON File';
  var databaseHandler;

  FileCommand(databaseHandler) {
    argParser..addFlag('verbose', defaultsTo: false);
    this.databaseHandler = databaseHandler;
  }

  @override
  run() async {
    String fileFolder = '/../files/';
    //  Tries to find file in [files] folder.
    var absFilePath = (dirname(Platform.script.toFilePath()).toString() +
        fileFolder +
        argResults.rest[0]);
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
    var result = await this.databaseHandler.addEntry(properties);
    print('Added new entry \n \n');
    if (argResults['verbose'] == true) {
      print(properties);
      print(result);
    }
    return;
  }
}

import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show AddDataVM;

//TODO: This is broken right now because the input stream will default to parse input as string.
//TODO: Need to fix this by creating QUERY class, which will specify FILE or STRING for example.

class FileCommand extends Command {
  @override
  String get name => 'file';
  @override
  String get description => 'Add entry to the database through JSON File';
  Map results;

  FileCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    final AddDataVM addDataModel = AddDataVM();
    this.results = await addDataModel.addFileData(argResults.rest[0]);
    print('Added new entry \n \n');
    if (argResults['verbose'] == true) {
      print('${this.results.toString()} \n \n');
    } else {
      print("${this.results['data'].toString()} \n \n");
    }
    return;
  }
}

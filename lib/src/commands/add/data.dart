import 'package:args/command_runner.dart';

import '../../models/add/data.dart';

class DataCommand extends Command {
  @override
  String get name => 'data';
  @override
  String get description => 'Add data to the database';
  var databaseHandler;
  Map results;

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    final AddDataModel addDataModel = new AddDataModel();
    this.results = await addDataModel.addStringData(argResults.rest[0]);
    print('Added new entry \n \n');
    if (argResults['verbose'] == true) {
      print('${this.results.toString()} \n \n');
    } else {
      print("${this.results['data'].toString()} \n \n");
    }
    return;
  }
}

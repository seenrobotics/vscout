import 'package:args/command_runner.dart';
import 'package:vscout_cli/includes.dart';
import 'package:vscout_cli/src/database/database.dart';
class DataCommand extends Command {
  @override
  String get name => 'data';
  var database;
  @override
  String get description => 'Update data to the database';
  var databaseHandler;

  DataCommand(databaseHandler) {
    argParser..addFlag('verbose', defaultsTo: false);
    this.databaseHandler = databaseHandler;
  }

  @override
  run() async {
    Map properties = parseArgsJson(argResults.rest[0]);
    print(properties);
    var result = await this.databaseHandler.addEntry(properties);
    if (argResults['verbose'] == true) {
      print(result);
    }
  }
}

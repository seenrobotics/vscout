import 'package:args/command_runner.dart';
import 'package:vscout_cli/includes.dart';
import 'package:vscout_cli/src/database/database.dart';
class DataCommand extends Command {
  @override
  String get name => 'data';
  var database;
  @override
  String get description => 'Add data to the database';
  var databaseHandler;

  DataCommand(database) {
    argParser..addFlag('verbose', defaultsTo: false);
    this.database = database;
  }

  @override
  run() async {
    // TODO: Replace with actual command.
    Map properties = parseArgsJson(argResults.rest[0]);
    print(properties);
    var result = await this.databaseHandler.addEntry(properties);
    if (argResults['verbose'] == true) {
      print(result);
    }
  }
}

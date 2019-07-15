import 'package:args/command_runner.dart';
import 'dart:convert';
import 'package:vscout_cli/includes.dart';

class GetTeamCommand extends Command {
  @override
  String get name => 'team-entry';

  @override
  String get description => 'Add team entry to database';

  var databaseHandler;

  // @override
  // String get usageFooter => 'This is usage';

  @override
  String get usage => ("$description\n\n" +
      """Usage: vscout get team-entry [{Parameters : Values}]
-h, --help            Print this usage information.
    --[no-]verbose

EG: vscout get team-entry {'teamId' : '2381'}

Run "vscout help" to see global options.""");

  GetTeamCommand(database) {
    argParser..addFlag('verbose', defaultsTo: false);
    this.databaseHandler = database;
  }




  @override
  run() async {
    // TODO: Replace with actual command.
    print(argResults.rest[0]);
    Map filters = parseArgsJson(argResults.rest[0]);
    // Map filters = json.decode(argResults.rest[0]);
    var results = await this.databaseHandler.getMatches(filters);

    print(filters);
    print(results);
    // var result = await databaseHandler.addTeamEntry(team);
    if (argResults['verbose'] == true) {
      // print(result);
    }
  }
}

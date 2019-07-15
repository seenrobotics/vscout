import 'package:args/command_runner.dart';
import 'dart:convert';

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

EG: vscout get team-entry {teamId : 2381}

Run "vscout help" to see global options.""");

  GetTeamCommand(database) {
    argParser..addFlag('verbose', defaultsTo: false);
    this.databaseHandler = database;
  }

  /// Makes cmd arguments JSON parsable
  //  Turns [{asdf:asdf}] -> [{"asdf":"asdf"}]
  parseArgsJson(str) {
    String parse0 = str;
    String parse1 = parse0.replaceAll(":", ('\":\"'));
    String parse2 = parse1.replaceAll("{", ('{\"'));
    String parse3 = parse2.replaceAll("}", ('\"}'));

    Map parse4 = json.decode(parse3);

    Map parse5 = Map<String, String>();
    parse4.forEach((k, v) => parse5[k.trim()] = v.trim());
    return parse5;
  }

  @override
  run() async {
    // TODO: Replace with actual command.

    Map filters = this.parseArgsJson(argResults.rest[0]);

    var results = await this.databaseHandler.getMatches(filters);

    print(filters);
    print(results);
    // var result = await databaseHandler.addTeamEntry(team);
    if (argResults['verbose'] == true) {
      // print(result);
    }
  }
}

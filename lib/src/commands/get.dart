import 'package:args/command_runner.dart';

import 'get/get_team.dart';


class GetCommand extends Command {

  @override
  String get name => 'get';

  @override
  String get description => 'Add data or data types to the database';
  
  GetCommand(database) {
    addSubcommand(GetTeamCommand(database));
  }
  @override
  run() async {
    // var dataType = argResults.wasParsed('data-type');
    // print(dataType);
  }
}

import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

class AttributeCommand extends Command {
  @override
  String get name => 'attribute';

  @override
  String get description => 'Add attribute to the database';

  TypeCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    // TODO: Replace with actual command.
    if (argResults['verbose'] == true) {
      print('Added attribute ${argResults.rest[0]}');
    }
  }
}

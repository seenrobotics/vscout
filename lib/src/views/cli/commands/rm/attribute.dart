import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show RemoveAttributeVM;

class AttributeCommand extends Command {
  @override
  String get name => 'data-type';

  @override
  String get description => 'Remove attribute from the database';

  TypeCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    // TODO: Replace with actual command.
    if (argResults['verbose'] == true) {
      print('Removed attribute ${argResults.rest[0]}');
    }
  }
}

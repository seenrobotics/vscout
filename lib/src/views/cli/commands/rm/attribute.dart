import 'package:args/command_runner.dart';
import 'package:vscout/view_models.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show RmAttributeVM;

class AttributeCommand extends Command with VscoutCommand {
  @override
  String get name => 'data-type';

  @override
  String get description => 'Remove attribute from the database';

  TypeCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
    this.viewModel = RmAttributeVM();
  }

  @override
  handleResponse(data) {}

  @override
  run() async {
    // TODO: Replace with actual command.
    if (argResults['verbose'] == true) {
      print('Removed attribute ${argResults.rest[0]}');
    }
  }
}

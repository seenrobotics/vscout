import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show AddAttributeVM;

class AttributeCommand extends Command with VscoutCommand {
  @override
  String get name => 'attribute';

  @override
  String get description => 'Add attribute to the database';

  TypeCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
    this.viewModel = AddAttributeVM();
  }

  @override
  handleResponse(data) {}
  @override
  run() async {
    // TODO: Replace with actual command.
    if (argResults['verbose'] == true) {
      print('Added attribute ${argResults.rest[0]}');
    }
  }
}

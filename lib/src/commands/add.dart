import 'package:args/command_runner.dart';

import 'add/data.dart';
import 'add/attribute.dart';

class AddCommand extends Command {
  @override
  String get name => 'add';

  @override
  String get description => 'Add data or attribute to the database';

  AddCommand(databaseHandler) {
    addSubcommand(DataCommand(databaseHandler));
    addSubcommand(AttributeCommand());
  }
  @override
  run() async {}
}

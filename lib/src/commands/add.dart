import 'package:args/command_runner.dart';

import 'add/attribute.dart';
import 'add/data.dart';
import 'add/file.dart';

class AddCommand extends Command {
  @override
  String get name => 'add';

  @override
  String get description => 'Add data or attribute to the database';

  AddCommand(databaseHandler) {
    addSubcommand(AttributeCommand());
    addSubcommand(DataCommand(databaseHandler));
    addSubcommand(FileCommand(databaseHandler));
  }
  @override
  run() async {}
}

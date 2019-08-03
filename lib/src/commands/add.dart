import 'package:args/command_runner.dart';

import 'add/data.dart';
import 'add/file.dart';
import 'add/type.dart';


class AddCommand extends Command {
  @override
  String get name => 'add';

  @override
  String get description => 'Add data or data types to the database';

  AddCommand(databaseHandler) {
    addSubcommand(DataCommand(databaseHandler));
    addSubcommand(FileCommand(databaseHandler));
    addSubcommand(TypeCommand());
  }
  @override
  run() async {}
}

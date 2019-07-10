import 'package:args/command_runner.dart';

import 'add/data_type.dart';

class AddCommand extends Command {
  @override
  String get name => 'add';

  @override
  String get description => 'Add data or data types to the database';

  AddCommand() {
    addSubcommand(DataTypeCommand());
  }
  @override
  run() async {
    var dataType = argResults.wasParsed('data-type');
    print(dataType);
  }
}

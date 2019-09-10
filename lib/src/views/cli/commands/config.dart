import 'package:args/command_runner.dart';

class ConfigCommand extends Command {
  @override
  String get name => 'config';

  @override
  String get description => 'Configure defaults';

  ConfigCommand();
  @override
  run() async {}
}

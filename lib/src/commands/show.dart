import 'package:args/command_runner.dart';

class ShowCommand extends Command {
  @override
  String get name => 'show';

  @override
  String get description => 'Show or display data visually';

  ShowCommand();
  @override
  run() async {}
}

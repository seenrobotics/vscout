import 'dart:io';
import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';

class CliView {
  StreamController _commandController = StreamController.broadcast();
  StreamController get streamController => _commandController;
  Stream stream;
  int generalError = 1;
  CommandRunner runner;
  StreamSubscription inputSubscription;
  static final CliView _singleton = CliView._internal();
  factory CliView() {
    return _singleton;
    // Constructors can't call async functions, actual initialization is done in [InitializeDb()].
  }

  CliView._internal() {
    // this.inputSubscription = this.streamController.stream.listen((data) {
    //   this.runCommand(data);
    // });
  }
  Future listenTo(Stream stream) async {
    this.inputSubscription = stream.listen((data) {
      this.runCommand(data);
    });
  }

  Future close() async {
    await this.inputSubscription.cancel();
    return await this.streamController.close();
  }

  Future runCommand(List<String> args) async {
    return await runner.run(args).catchError((exception, stackTrace) {
      if (exception is String) {
        // STDOUT is buffered and writes are in batches.
        stdout.writeln(exception);
      } else {
        // STDERR is unbuffered and every character is written as soon as it is available.
        stderr.writeln('Error Message: $exception');
        if (args.contains('--verbose')) {
          stderr.writeln(stackTrace);
        }
      }
      exitCode = generalError;
    }).whenComplete(() {
      // ANSI escape code to reset (all attributes off).
      stdout.write(resetAll.wrap(''));
    });
  }
}

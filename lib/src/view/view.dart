import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:vscout_cli/src/utils/utils.dart';
import 'dart:convert';

class InterruptException implements Exception {
  String cause;
  InterruptException(this.cause);
}

class CliView {
  StreamController _commandController = StreamController.broadcast();
  StreamController get streamController => _commandController;
  Stream stream;
  bool inputInterrupt = false;
  int generalError = 1;
  CommandRunner runner;
  StreamSubscription inputSubscription;

  StreamController<List<String>> interruptController =
      StreamController.broadcast();
  String interruptListener;
  static final CliView _singleton = CliView._internal();
  factory CliView() {
    return _singleton;
    // Constructors can't call async functions, actual initialization is done in [InitializeDb()].
  }

  CliView._internal() {}

  Future<StreamSubscription> requestInterrupt(String requester) async {
    if (this.inputInterrupt || this.interruptController.hasListener) {
      throw InterruptException("$requester ${this.interruptListener}");
    }

    this.inputInterrupt = true;
    this.interruptListener = requester;
    return this.interruptController.stream.listen(null);
  }

  Future concludeInterrupt(String requester) async {
    if (this.inputInterrupt &&
        this.interruptController.hasListener &&
        this.interruptListener == requester) {
      this.inputInterrupt = false;
      this.interruptListener = null;
    }
  }

  Future listenTo(Stream stream) async {
    this.inputSubscription =
        Utf8Decoder().bind(stream).transform(InputArgsParser()).listen((data) {
      if (this.inputInterrupt) {
        this.interruptController.add(data);
      } else {
        this.runCommand(data);
      }
    });
  }

  Future close(int ExitCode) async {
    print("vscout cli exited with code $ExitCode");
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

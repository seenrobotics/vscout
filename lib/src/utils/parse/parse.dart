import 'dart:async';
import 'dart:convert';

/// Formats CLI arguments to make them JSON parsable.
//  Turns [{'asdf':'asdf'}] -> [{"asdf":"asdf"}].
parseArgsJson(String str) {
//  Replace all single quotes ' with double quotes " so [json.decode] is able to read it.
  String quoteReplace = str.replaceAll("\'", ('\"'));
//  Json decode string to map.
  Map baseMap = json.decode(quoteReplace);
// Remove trailing white space, convert inputs to string to allow for staticly typed Dart methods.
  Map result = Map<String, String>();
  baseMap.forEach((k, v) =>
      result[k is String ? k.trim() : k.toString().trim()] =
          v is String ? v.trim() : v.toString().trim());
  return result;
}

List<String> parseArgsList(var string) {
  List<String> resultList = List<String>();
  int a = 0;
  int nextSpace;
  while (a < string.length) {
    if (string[a] != ' ') {
      if (string[a] == '"') {
        RegExp quoteSearch = RegExp('(?<!\\\\)"');
        if (quoteSearch.allMatches(string, a + 1).isNotEmpty) {
          nextSpace = quoteSearch.allMatches(string, a + 1).first.start;
        } else {
          nextSpace = string.length;
        }
        a++;
      } else {
        nextSpace = string.indexOf(' ', a) >= 0
            ? string.indexOf(' ', a)
            : (string.length);
        // print('$a $nextSpace ${string.substring(a,nextSpace)}');
      }
      resultList.add(string.substring(a, nextSpace).trim());
      a = nextSpace + 1;
    } else {
      a++;
    }
  }
  return resultList;
}

class DuplicateTransformer<S, T> implements StreamTransformer<S, T> {
  StreamController _controller;

  StreamSubscription _subscription;

  bool cancelOnError;

  // Original Stream
  Stream<S> _stream;

  DuplicateTransformer({bool sync: false, this.cancelOnError}) {
    _controller = new StreamController<T>(
        onListen: _onListen,
        onCancel: _onCancel,
        onPause: () {
          _subscription.pause();
        },
        onResume: () {
          _subscription.resume();
        },
        sync: sync);
  }
  DuplicateTransformer.broadcast({bool sync: false, bool this.cancelOnError}) {
    _controller = new StreamController<T>.broadcast(
        onListen: _onListen, onCancel: _onCancel, sync: sync);
  }

  void _onListen() {
    _subscription = _stream.listen(onData,
        onError: _controller.addError,
        onDone: _controller.close,
        cancelOnError: cancelOnError);
  }

  void _onCancel() {
    _subscription.cancel();
    _subscription = null;
  }

  /**
   * Transformation
   */

  void onData(S data) {
    _controller.add(data);
    _controller.add(
        data); /* DUPLICATE EXAMPLE!! REMOVE FOR YOUR OWN IMPLEMENTATION!! */
  }

  /**
   * Bind
   */

  Stream<T> bind(Stream<S> stream) {
    this._stream = stream;
    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    // TODO: implement cast
    return null;
  }
}

class InputArgsParser<String, T> extends DuplicateTransformer<String, T> {
  @override
  void onData(String data) {
    String data2 = data;

    _controller.add(parseArgsList(data2));
  }
}

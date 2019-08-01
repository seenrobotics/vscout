import 'package:test/test.dart';

void main() {
  // TODO: replace placeholder with actual tests
  test("String.trim() removes surrounding whitespace", () {
    var string = "  foo ";
    expect(string.trim(), equals("foo"));
  });
}

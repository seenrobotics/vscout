import 'dart:convert';

  /// Makes cmd arguments JSON parsable
  //  Turns [{asdf:asdf}] -> [{"asdf":"asdf"}]
parseArgsJson(str) {
    String parse0 = str;
    String parse1 = parse0.replaceAll("\'", ('\"'));
    // String parse2 = parse1.replaceAll("{", ('{\"'));
    // String parse3 = parse2.replaceAll("}", ('\"}'));
    Map parse4 = json.decode(parse1);
    Map parse5 = Map<String, String>();
    parse4.forEach((k, v) => parse5[k is String? k.trim() : k.toString()] = v is String ? v.trim() : v.toString());
    
    // print(parse5);
    return parse5;
    
  }
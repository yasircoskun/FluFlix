import 'dart:async';

class PassByValueVarX {
  var x = null;
}

class PassByValueimdbDataModel {
  PassByValueimdbDataModel({required this.x});
  imdbDataModel x;
}

class imdbDataModel {
  var poster = "";
  var year = "";
  var country = "";
  var length = "";
  var language = "";
  var title = "";
  var description = "";
}

class StreamBank {
  StreamBank();
  static Map<String, StreamController<dynamic>> bank = {};

  static void addStream(String name, StreamController stream) {
    bank[name] = stream;
  }

  static StreamController<dynamic>? getStream(String name) {
    return bank[name];
  }
}


import 'package:flutter/foundation.dart';


class Logger {

  factory Logger(String message, Object content) {
    print("\n");
    print("=======" + message + "=============> " + "$content");
    print("\n");
  }

  static log(String message, Object content) {
    print("\n");
    print("=======" + message + "=============> " + "$content");
    print("\n");
  }

}


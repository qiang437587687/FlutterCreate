
import 'package:flutter/foundation.dart';


class Logger {

  factory Logger(String message, Object content) {
    print("\n");
    print("=======" + message + "  start ============>");
    print(content);
    print("<=======" + message + "  end ============");
    print("\n");
  }

  static log(String message, Object content) {
    print("\n");
    print("=======" + message + "  start ============>");
    print(content);
    print("<=======" + message + "  end ============");
    print("\n");
  }

}


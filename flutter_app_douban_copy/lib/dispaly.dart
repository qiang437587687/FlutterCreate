import 'package:flutter/material.dart';
import 'package:flutter_app_douban_copy/utils/Logger.dart';

double _screenWidth;
double _screenHeight;

void initScreen(BuildContext context) {
  var screenSize = MediaQuery.of(context).size;
  _screenWidth = screenSize.width;
  _screenHeight = screenSize.height;
  Logger("这样获取屏幕的宽度高度？注意MediaQuery", "_screenWidth = $_screenWidth _screenHeight = $_screenHeight");
}

double get screenWidth => _screenWidth;

double get screenHeight => _screenHeight;

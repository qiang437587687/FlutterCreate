import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_douban_copy/utils/Logger.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:flutter_app_douban_copy/http/HttpManager.dart'as HttpManager;
import 'package:flutter_app_douban_copy/user.dart';
import 'package:quiver/time.dart';

import 'dart:async';
import 'package:flutter/material.dart';//导入系统基础包
import 'package:flutter/services.dart';//导入网络请求相关的包

typedef void BoolCallback(bool f);

TextStyle styleBlack = TextStyle(
  color: Colors.black,
  decoration: TextDecoration.none,
  fontSize: 24.0,
);
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
import 'package:flutter_app_douban_copy/Const.dart';
import 'package:flutter_app_douban_copy/toolsTimer.dart';

import "package:flutter_app_douban_copy/dispaly.dart";

class CutAndGaussianBlur extends StatefulWidget {
  @override
  _CutAndGaussianBlurState createState() => _CutAndGaussianBlurState();
}

class _CutAndGaussianBlurState extends State<CutAndGaussianBlur> with SingleTickerProviderStateMixin {
  GlobalKey globalKey = new GlobalKey();


  @override
  Widget build(BuildContext context) {

    initScreen(context); //获取全局的宽度高度。
    return Container(
      child: Text("CutAndGaussianBlur"),
    );
  }
}


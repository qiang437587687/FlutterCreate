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



class CutAndGaussianBlur extends StatefulWidget {
  @override
  _CutAndGaussianBlurState createState() => _CutAndGaussianBlurState();
}

class _CutAndGaussianBlurState extends State<CutAndGaussianBlur> {
  GlobalKey globalKey = new GlobalKey();

  // 截图boundary，并且返回图片的二进制数据。
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    // 注意：png是压缩后格式，如果需要图片的原始像素数据，请使用rawRgba
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


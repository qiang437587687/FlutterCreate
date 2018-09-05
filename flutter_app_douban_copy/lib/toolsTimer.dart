
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


// 封装一个定时器。
class ToolsTimer extends StatefulWidget { //这里注意写上final 要不然会提示分析错误。

//  ToolsTimer(this.callback,{this.textStyle = styleBlack});

  ToolsTimer({Key key, @required this.callback,this.textStyle = styleBlack}) : super(key: key);

  final StringCallback callback;

  final TextStyle textStyle;

  final _ToolsTimerState state = _ToolsTimerState();

  stopOrStart() {
    state.stopOrStart();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    Logger("callback", callback);
    return state;
  }

}


class _ToolsTimerState extends State<ToolsTimer> {

   Timer timer;
   Stopwatch stopwatch;
   String time = "00:00.00";
   int milliseconds;

  _timerCallBack(Timer timer) {
    Logger("_timerCallBack", "zhang");
    widget.callback("zhang1111"); //可以使用widget的方式传值回去。OK

    if (stopwatch.isRunning) {
      Logger("查看是否running", stopwatch.isRunning);
    } else {
      Logger("查看是否running", stopwatch.isRunning);
    }

    // 利用一个记录的值来进行判断是不是进行回调，这个有点不太好
    // 如果调用reset那么这里的elapsedxxx 会变成0.重新记录。

    if (milliseconds != stopwatch.elapsedMilliseconds) {
      milliseconds = stopwatch.elapsedMilliseconds;
      final int seconds = (milliseconds / 1000).truncate();
      final int millSeconds = (milliseconds % 1000).truncate();
      Logger("--", "_callBack in if");
      Logger("count time", "$milliseconds");
      widget.callback("$milliseconds");
      setState(() {
        time = "耗时：$seconds 秒 $millSeconds 微秒 ";
      });
    }

  }

   stopOrStart() {
    Logger("测试进入stop", "stop");
    stopwatch.isRunning ? stopwatch.stop() : stopwatch.start();
  }

  _start() {
    stopwatch.start();
  }

  @override
  void initState() {
    // TODO: implement initState

    //初始化放到init里面也是可以的，这里注意后面的_timerCallBack不能直接写在外面。
    timer = Timer.periodic(Duration(milliseconds: 100), _timerCallBack);
    stopwatch = Stopwatch();
    stopwatch.stop();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(time,style: styleBlack,textAlign: TextAlign.center);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    timer = null;
    Logger("timer 进入 dispose timer = ", timer);
    super.dispose();
  }

}
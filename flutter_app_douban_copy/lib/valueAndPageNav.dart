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


class ValueAndPageNav extends StatelessWidget {

  final StringCallback sendBackClosure;

//  ValueAndPageNav(this.sendBackClosure);
  ValueAndPageNav({Key key, @required this.sendBackClosure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

//    ListTile(title: Text("1"),onTap: (){},);

    return Container(color: Colors.yellow,child: RaisedButton(onPressed: () { this.sendBackClosure("back");  },child: Text("send"),),);

  }

}
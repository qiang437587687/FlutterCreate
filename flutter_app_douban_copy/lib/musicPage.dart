import 'package:flutter/material.dart';
import 'package:flutter_app_douban_copy/http/HttpManager.dart'as HttpManager;
import 'package:flutter_app_douban_copy/utils/Logger.dart';
import 'package:flutter_app_douban_copy/utils/Tools.dart';
import 'package:html/parser.dart';

import 'package:flutter_app_douban_copy/musicPageModel.dart';

enum LoadState {
  neverLoad,
  successLoad,
  errorLoad
}

class MusicPage extends StatefulWidget {

  double offset;
  ScrollController controller;
  LoadState isLoad = LoadState.neverLoad;
  MusicPageModel data;

  @override
  _MusicPageState createState() => _MusicPageState();
  
}

class _MusicPageState extends State<MusicPage> {

  _loadData() {
    HttpManager.get(url: "https://music.douban.com",

        onSend: () {
          Logger("开始请求网络", "");
          _parseLoad(LoadState.neverLoad);
        },

        onSuccess: (String body) {
          Logger("请求后的body", body);
          //这里需要解析body的信息.
//          _parseLoad(LoadState.successLoad);
          _parseLoad(LoadState.successLoad,data: _parseLoad(LoadState.successLoad),str: "A");
        },

        onError: (Object e) {
          Logger("net error", e);
          _parseLoad(LoadState.errorLoad);

        }

    );
  }

  MusicPageModel _parseBodyMessage(String body) {
    //处理和记录，将body转换为model
    return MusicPageModel.formHtml(body);
  }

  //可选参数和默认值
  _parseLoad(LoadState state,{MusicPageModel data,String str = "B"}) {
    setState(() {
      widget.isLoad = state;
      widget.data = data;
    });
  }

  // 先走init方法有点类似于 iOS init
  @override
  void initState() {
    super.initState();
    Logger("initState", "");
  }

  //这个有点像reloaddata 这里reload的是wiget，setstate是会重新调用这里的。
  @override
  Widget build(BuildContext context) {
//    return widget.data == null ? _getLoading() : _body();
    Logger("build", "");
    return  _getLoading();
  }

  //获取加载中跟加载失败的widget
  _getLoading() {

    switch (widget.isLoad) {

      case LoadState.neverLoad:
        _loadData();
        return LoadingProgress();

      case LoadState.successLoad:
        return Text("加载成功了");

      case LoadState.errorLoad:
        return LoadingError(
          voidCallback: _loadData,
        );
    }
  }


}
import 'package:flutter/material.dart';
import 'package:flutter_app_douban_copy/http/HttpManager.dart'as HttpManager;
import 'package:flutter_app_douban_copy/utils/Logger.dart';
import 'package:flutter_app_douban_copy/utils/Tools.dart';
import 'package:html/parser.dart';

import 'package:flutter_app_douban_copy/musicPageModel.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'dart:async';

export 'package:url_launcher/url_launcher.dart';

enum LoadState {
  neverLoad,
  successLoad,
  errorLoad
}

class MusicPage extends StatefulWidget {

  double offset = 0.0;
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
          widget.data = _parseBodyMessage(body);
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
        return _body();

      case LoadState.errorLoad:
        return LoadingError(
          voidCallback: _loadData,
        );
    }
  }

  _initController() {
    widget.controller = ScrollController(initialScrollOffset: widget.offset);
    widget.controller.addListener(() {
      widget.offset = widget.controller.offset;
    });
  }



  //成功了之后，这里就返回body
  Widget _body() {

    _initController();
    return NestedScrollView(controller: widget.controller, headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {

      return <Widget> [
          SliverOverlapAbsorber(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),child: _getTopWidgets(),),
      ];

    }, body: Builder(
      builder: (BuildContext context) {
        return _getCenterWidgets(context);
      },
    ));

  }

  //顶部banner
  _getTopWidgets() {
    List<Widget> widgets = new List<Widget>.generate(widget.data.bannerList.length, (index) {
      return new GestureDetector(
        onTap: () => _click(widget.data.bannerList[index].address),
        child: new Image.network(
          widget.data.bannerList[index].imageAddress,
          fit: BoxFit.cover,
        ),
      );
    });
    
    return SliverPersistentHeader(delegate: SliverBanner(childs: widgets));
  }


  _click(String address) async {
    if (await canLaunch(address)) {
      await launch(address, forceWebView: true);
    }
  }

  //轮播图下面滑动部分
  _getCenterWidgets(BuildContext context) {
    return new CustomScrollView(
      slivers: _getCustomBody(context),
    );
  }

//  _getCustomBody(BuildContext context) {
//    List<Widget> widgets = <Widget>[
//      new SliverOverlapInjector(
//        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//      ),
//      SliverTitle(widget.data.m250List.title),
//      SliverList(
//        delegate: SliverChildListDelegate([
//          _get250Widget(),
//        ]),
//      ),
//      SliverTitle(widget.data.editList.title),
//      SliverList(
//        delegate: SliverChildListDelegate([
//          _getEditWidget(),
//        ]),
//      ),
//    ];
//    widgets.addAll(_getFashionWidget());
//
//    return widgets;
//  }

  _getCustomBody(BuildContext context) {
    List<Widget> widgets = <Widget>[
      new SliverOverlapInjector(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
      Text(widget.data.m250List.title),
    ];
//    widgets.addAll(_getFashionWidget());

    return widgets;
  }


}


class SliverBanner extends SliverPersistentHeaderDelegate {
  SliverBanner({@required this.childs});
  final List<Widget> childs;
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Opacity(
        opacity: (maxExtent - shrinkOffset)/maxExtent,
        child: Text("123"),
    );
  }
  
  @override
  // TODO: implement maxExtent
  double get maxExtent => 200.0;
  
  @override
  // TODO: implement minExtent
  double get minExtent => 0.0;
  
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }

}
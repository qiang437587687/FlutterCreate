import 'package:flutter/material.dart';
import 'package:flutter_app_douban_copy/http/HttpManager.dart' as HttpManager;
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

import 'package:flutter_app_douban_copy/musicInfoPage.dart';

export 'package:url_launcher/url_launcher.dart';

enum LoadState { neverLoad, successLoad, errorLoad }

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
    HttpManager.get(
        url: "https://music.douban.com",
        onSend: () {
          Logger("开始请求网络", "");
          _parseLoad(LoadState.neverLoad);
        },
        onSuccess: (String body) {
          Logger("请求后的body", body);
          //这里需要解析body的信息.
//          _parseLoad(LoadState.successLoad);
          _parseLoad(LoadState.successLoad,
              data: _parseBodyMessage(body), str: "A");
        },
        onError: (Object e) {
          Logger("net error", e);
          _parseLoad(LoadState.errorLoad);
        });
  }

  MusicPageModel _parseBodyMessage(String body) {
    //处理和记录，将body转换为model
    return MusicPageModel.formHtml(body);
  }

  //可选参数和默认值
  _parseLoad(LoadState state, {MusicPageModel data, String str = "B"}) {
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
    return _getLoading();
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
    return NestedScrollView(
        controller: widget.controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: _getTopWidgets(),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return _getCenterWidgets(context);
          },
        ));
  }

  //顶部banner
  _getTopWidgets() {
    List<Widget> widgets =
        new List<Widget>.generate(widget.data.bannerList.length, (index) {
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

  _getCustomBody(BuildContext context) {
    List<Widget> widgets = <Widget>[
      new SliverOverlapInjector(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
      SliverTitle(widget.data.m250List.title),
      SliverList(
          delegate: SliverChildListDelegate([
        _get250Widget(),
      ])),
      SliverTitle(widget.data.editList.title),
      SliverList(
        delegate: SliverChildListDelegate([
          _getEditWidget(),
        ]),
      ),
//      Text(widget.data.m250List.title),
    ];
    widgets.addAll(_getFashionWidget());

    return widgets;
  }

  _getEditWidget() {
    List<Widget> editList =
        new List.generate(widget.data.editList.itemList.length, (index) {
      MusicEditItem musicedititem = widget.data.editList.itemList[index];
      return new GestureDetector(
        onTap: () => _getInfo(widget.data.editList.itemList[index].address),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(musicedititem.imageAddress),
                Container(
                  child: Text(
                    musicedititem.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(
                    musicedititem.des,
                    style: Theme.of(context).textTheme.body2,
                  ),
                  alignment: Alignment.center,
                ),
                Container(
                  width: 150.0,
                  padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
                  child: Text(
                    musicedititem.summery,
                    style: Theme.of(context).textTheme.body2,
                  ),
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
      );
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: editList,
      ),
    );
  }

  _get250Widget() {
    List<Widget> m250List =
        new List.generate(widget.data.m250List.itemList.length, (index) {
      Music250Item music250item = widget.data.m250List.itemList[index];
      return new GestureDetector(
        onTap: () => _getInfo(music250item.address),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: new Image.network(
                  music250item.imageAddress,
                  width: 70.0,
                  height: 70.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: debugColor(Colors.yellow),
                child: Text(music250item.title,maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                width: 70.0,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
              )
            ],
          ),
        ),
      );
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: m250List,
      ),
    );
  }

  _getFashionWidget() {
    List<Widget> widgets = [];
    Logger("widget.data.fashionList length", widget.data.fashionList.length);
    widget.data.fashionList.forEach((e) {
      widgets.add(SliverTitle(e.title));
      widgets.add(SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, index) {
            return new GestureDetector(
              onTap: () => _getInfo(e.itemList[index].address),
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        e.itemList[index].imageAddress,
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: 200.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(e.itemList[index].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(color: Colors.white)),
                            Text(
                              e.itemList[index].type,
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: Colors.white),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.black54,
                            Colors.black12,
                            Colors.transparent,
                          ],
                        )),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: e.itemList.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 1.0,
        ),
      ));
    });

    return widgets;
  }

  _getInfo(String address) {
    Logger("get info address", address);
    address.contains("play") ? _loadPlay(address) : _navigationToInfo(address);
  }

  _navigationToInfo(String address) {
    Logger("_navigationToInfo", "");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MusicInfo(
              address: address,
            )));
  }

  _loadPlay(String address) async {
    Logger("_loadPlay", "");
    if (await canLaunch(address)) {
      launch(address, forceWebView: false);
    }
  }
}

class SliverTitle extends StatelessWidget {
  SliverTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverPersistentHeader(
      delegate: SliverTitleDelegate(title: title),
    );
  }
}

class SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  SliverTitleDelegate({@required this.title, this.height});

  final String title;
  final double height;
  BuildContext context;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    this.context = context;
    return Container(
      color: debugColor(Colors.red),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.centerLeft,
      child: new Opacity(
        opacity: shrinkOffset > minExtent
            ? (maxExtent - shrinkOffset) / maxExtent
            : 1.0,
        child: Text(
          title ?? "标题",
          style: Theme.of(context).textTheme.title.copyWith(
              color: Theme.of(context).primaryColor, fontFamily: 'Merri'),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => height ?? 60.0;
  @override
  // TODO: implement minExtent
  double get minExtent => height ?? Theme.of(context).textTheme.title.fontSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}

class SliverBanner extends SliverPersistentHeaderDelegate {
  SliverBanner({@required this.childs});
  final List<Widget> childs;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Opacity(
      opacity: (maxExtent - shrinkOffset) / maxExtent,
      child: ViewPager(
        children: childs,
        isShowIndicator: shrinkOffset == 0,
      ),
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

class ViewPager extends StatefulWidget {
  ViewPager(
      {Key key,
      @required this.children,
      this.isShowIndicator,
      this.delayMilliseconds: 5000,
      this.moveMilliseconds: 500})
      : super(key: key);
  final List<Widget> children;
  final bool isShowIndicator;
  final int delayMilliseconds;
  final int moveMilliseconds;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ViewPageState();
  }
}

class _ViewPageState extends State<ViewPager> {
  int position = 0;
  final PageController controller = new PageController();
  bool isDisPose = false;

  _setPosition(int index) {
    setState(() {
      position = index;
    });
  }

  _startViewPager() async {
    new Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (!isDisPose) {
        setState(() {
          position = position + 1;
          if (position == widget.children.length) {
            position = 0;
          }
          controller.animateToPage(position,
              duration: Duration(milliseconds: widget.moveMilliseconds),
              curve: Curves.easeIn);
        });
      }
      _startViewPager();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startViewPager();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Stack(
      children: <Widget>[
        //builder 可以这么用啊~~~
        PageView.builder(
          itemBuilder: (build, index) {
            return widget.children[index];
          },
          scrollDirection: Axis.vertical,
          itemCount: widget.children.length,
          controller: controller,
          onPageChanged: _setPosition,
          // ------
        ) //build结束
      ],
    );
  }

  @override
  void dispose() {
    isDisPose = true;
    super.dispose();
  }
}

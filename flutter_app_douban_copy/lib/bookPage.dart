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
import 'package:flutter_app_douban_copy/book.dart';

export 'package:url_launcher/url_launcher.dart';


class BookPage extends StatefulWidget {

  BookPage(this.offset);
  List<BookTitleList> bookTitleList;
  bool isLoad = false;
  ScrollController controller;
  double offset;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
      return BookPageState();
  }

}


class BookPageState extends State<BookPage> {
  bool isSuccess = true;

  //这里可以直接setstate？
  _initController() {
    widget.controller = ScrollController(initialScrollOffset: widget.offset);
    widget.controller.addListener(() {
        widget.offset = widget.controller.offset;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isLoad) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(child: widget.bookTitleList == null ? _getLoading() : _getBody(),),
    );
  }

  _loadData()  {
    HttpManager.get(url: "https://book.douban.com/",onSend: () {
      setState(() {
        isSuccess = true;
      });
    },

    onSuccess: (String body) {
      List<BookTitleList> temp = BookTitleList.getFromHtml(body);
      setState(() {
        widget.isLoad = true;
        widget.bookTitleList = temp;
      });
    },

    onError: (Object e) {
      setState(() {
        widget.isLoad = false;
        widget.bookTitleList = null;
      });
    }

    );
  }

  _getLoading() {
      if (isSuccess) {
        return LoadingProgress();
      } else {
        return LoadingError(voidCallback: _loadData);
      }
  }

  _getBody() {
    _initController();
    List<Widget> bookList = [];
    print("widget.bookTitleList.count ${widget.bookTitleList.length}");
    widget.bookTitleList.forEach((list) {
      print("widget.bookTitleList.title ${list.title}");
      bookList.add(SliverPersistentHeader(delegate: BookTitle(title: list.title)));
      bookList.add(SliverGrid(
            delegate:
              SliverChildBuilderDelegate((BuildContext context, index) {

                return BookItem(book: list.bookList[index],);

              },childCount: list.bookList.length,),

            gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 0.7,
              )

      ));
    });

    return CustomScrollView(controller: widget.controller,slivers: bookList,);
  }


}


class BookTitle extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;
  BuildContext context;

  BookTitle({@required this.title, this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    this.context = context;
    return Container(
        child: Center(
            child: Text(
              title ?? '标题',
              style: Theme.of(context).textTheme.title,
            )));
  }

  // TODO: implement maxExtent
  @override
  double get maxExtent => height ?? 60.0;

  // TODO: implement minExtent
  @override
  double get minExtent => height ?? Theme.of(context).textTheme.title.fontSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }


}



//item项
class BookItem extends StatelessWidget {
  final Book book;

  BookItem({this.book}) : super(key: ObjectKey(book));

  _getRatings() {
    int starCount = (book.ratingsValue ~/ 2).toInt();
    var starWidget = new List<Widget>.generate(starCount, (index) {
      return new Icon(
        Icons.star,
        color: Colors.yellow,
        size: 15.0,
      );
    });
    var noStarWidget = new List<Widget>.generate(5 - starCount, (index) {
      return new Icon(
        Icons.star,
        color: Colors.grey,
        size: 15.0,
      );
    });
    starWidget.addAll(noStarWidget);
    starWidget.add(new Text(
      '${book.ratingsValue}',
      style: new TextStyle(color: Colors.white),
    ));
    return starWidget;
  }

  _onclick(BuildContext context) {
    Logger("这里需要弹出去", context);
//    Navigator.push(
//        context,
//        new PageRouteBuilder(
//            pageBuilder: (BuildContext context, _, __) {
//              return BookInfo(
//                book: book,
//              );
//            },
//            opaque: false,
//            transitionDuration: new Duration(milliseconds: 200),
//            transitionsBuilder:
//                (___, Animation<double> animation, ____, Widget child) {
//              return new FadeTransition(
//                opacity: animation,
//                child: new ScaleTransition(
//                  scale: new Tween<double>(begin: 0.5, end: 1.0)
//                      .animate(animation),
////                  position: new Tween<Offset>(begin: const Offset(-1.0, 0.0),end: Offset.zero)
////                      .animate(animation),
//                  child: child,
//                ),
//              );
//            }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // 写一下卡片
    return GestureDetector(
      onTap: _onclick(context), //试一下这样点击会不会有问题
      child: Card(
        child: Stack(
          children: <Widget>[
            Image.network(
              book.imageAddress,
            ),
            
            DecoratedBox(
                decoration: BoxDecoration(
                                gradient: RadialGradient(
                                    colors: [
                                      const Color(0x00000000),
                                      const Color(0x70000000),
//                                            Colors.red,
//                                            Colors.yellow,
//                                            Colors.blue
                                            ],
                                  center: const Alignment(0.0, -0.5),
                                  stops: <double>[0.0, 0.5],

                                ),

                            ),
                child: Opacity(opacity: 0.6,child:
                  Column(

                  mainAxisAlignment: MainAxisAlignment.end, //主列 column上下为主。
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: <Widget>[
                    Center(
                      child: Text(book.name, style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),),

                    Center(child: Text(book.author ,style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white, fontSize: 10.0), ),),

                    Row(mainAxisAlignment: MainAxisAlignment.center, children: _getRatings(),),

                  ],),
                ),
            ),
            
          ],
        ),
      ),
    );
  }
}


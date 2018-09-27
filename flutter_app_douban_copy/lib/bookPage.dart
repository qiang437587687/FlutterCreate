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
    widget.bookTitleList.forEach((list) {
      bookList.add(SliverPersistentHeader(delegate: bookList))
    });
  }


}


class BookTitle extends SliverPersistentHeaderDelegate {
  final String title;
  BookTitleList({@required this.title, this.height});
  final double height;
  BuildContext context;

  

}





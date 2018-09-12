import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_douban_copy/http/HttpManager.dart'as HttpManager;
import 'package:flutter_app_douban_copy/utils/Logger.dart';
import 'package:flutter_app_douban_copy/utils/Tools.dart';
import 'package:html/parser.dart';

export 'package:url_launcher/url_launcher.dart';



class MusicInfo extends StatefulWidget {
  MusicInfo({this.address});

  final String address;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MusicInfoState();
  }

}


class _MusicInfoState extends State<MusicInfo> {
  bool isSuccess = true;
  MusicInfo1 result;
  final double _appBarHeight = 256.0;

  _loadData() async {

    HttpManager.get(url: widget.address,
      onSend: () {
        Logger("开始请求music info address ", widget.address);
      },

      onSuccess: (result) {
        setState(() {
          this.result = new MusicInfo1.json(result);
        });
      },

    );

  }

  _getLoading() {
    if (isSuccess) {
      return LoadingProgress();
    } else {
      return LoadingError(
        voidCallback: _loadData,
      );
    }
  }

  _getBody() {

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //还能用ignore 来取消Image的错误警告。厉害了
        // ignore: conflicting_dart_import
        Image.network(
          result.image,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
        ),

        /*
          this.color,
          this.image,
          this.border,
          this.borderRadius,
          this.boxShadow,
          this.gradient,
          this.backgroundBlendMode,
          this.shape = BoxShape.rectangle,
        *
        * */

        BackdropFilter(filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                       child: DecoratedBox(decoration: BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.all(const Radius.circular(8.0)))),
        ),

        Center(
          child: Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(const Radius.circular(80.0)),
              color: Colors.grey.shade600.withOpacity(0.3),
            ),

            child: CustomScrollView(
              slivers: <Widget>[
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: _appBarHeight,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(result.name ?? "名字暂缺"),
                        background: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.network(result.image,fit: BoxFit.cover,height: _appBarHeight,)
                          ],
                        ),
                      ),

                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.info), onPressed: () {
                          _showInfoBottomSheet();
                        }),

                      ],
                      floating: false,
                      snap: false,

                    ),
                  
                  SliverPadding(
                      padding: const EdgeInsets.all(4.0),
                      sliver: SliverList(delegate: SliverChildListDelegate(_getCommentList())),
                  )
                
              ],
            ),


          ),
        )

      ],
    );
  }

  List<Widget> _getCommentList() {
    List<Widget> list = [
      ListTile(
        title: Text('介绍',
            style: Theme.of(context).textTheme.title.copyWith(
              color: Colors.white,
            )),
      ),
      Text(
        result.indent.isEmpty ? '    暂无介绍' : result.indent,
        style: Theme.of(context).textTheme.body1.copyWith(
          color: Colors.white,
        ),
      ),
      ListTile(
        title: Text('曲目',
            style: Theme.of(context).textTheme.title.copyWith(
              color: Colors.white,
            )),
      ),
      Text(
        result.introContent.isEmpty ? '   暂无曲目' : result.introContent,
        style: Theme.of(context).textTheme.body1.copyWith(
          color: Colors.white,
        ),
      ),
    ];
    return list;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(body: result == null ? _getLoading() : _getBody(),);
  }


  List<Widget> _getTextList() {
    List<Widget> widgetList = [];
    if (result.otherName != null && result.otherName.isNotEmpty) {
      widgetList.add(_getText(result.otherName));
    }
    if (result.author != null && result.author.isNotEmpty) {
      widgetList.add(_getText(result.author));
    }
    if (result.schools != null && result.schools.isNotEmpty) {
      widgetList.add(_getText(result.schools));
    }
    if (result.Album != null && result.Album.isNotEmpty) {
      widgetList.add(_getText(result.Album));
    }
    if (result.medium != null && result.medium.isNotEmpty) {
      widgetList.add(_getText(result.medium));
    }
    if (result.releaseTime != null && result.releaseTime.isNotEmpty) {
      widgetList.add(_getText(result.releaseTime));
    }
    if (result.publisher != null && result.publisher.isNotEmpty) {
      widgetList.add(_getText(result.publisher));
    }
    if (result.recordsNumber != null && result.recordsNumber.isNotEmpty) {
      widgetList.add(_getText(result.recordsNumber));
    }
    if (result.barCode != null && result.barCode.isNotEmpty) {
      widgetList.add(_getText(result.barCode));
    }
    if (result.isrc != null && result.isrc.isNotEmpty) {
      if (result.isrc.contains('\n')) {
        List<String> isrcs = result.isrc.split('\n');
        widgetList.addAll(isrcs.map((s) => _getText(s)));
      } else {
        widgetList.add(_getText(result.isrc));
      }
    }
    return widgetList;
  }

  _getText(String text) {
    return ListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.body1,
      ),
      leading: Icon(Icons.info_outline),
    );
  }


  _showInfoBottomSheet() {
    List<Widget> items = _getTextList();
    Logger("_showInfoBottomSheet items", items);
    showModalBottomSheet(context: context, builder: (BuildContext context) {

      return Drawer(
        child: ListView.builder(itemBuilder: (context, index) {
          return items[index];
        },
          itemCount: items.length,
        ),

      );

    }

    );
  }




}




class MusicInfo1{
  final String name;//名字
  final String image;//图片
  final String otherName;//又名
  final String author;//表演者
  final String schools;//流派
  final String Album;//专辑
  final String medium;//介质
  final String releaseTime;//发行时间
  final String publisher;//出版者
  final String recordsNumber;//唱片数
  final String barCode;//条形码
  final String isrc;//isrc
  final String indent;//曲目
  final String introContent;//介绍

  MusicInfo1(this.name,this.image, this.otherName, this.author, this.schools, this.Album, this.medium, this.releaseTime, this.publisher, this.recordsNumber, this.barCode, this.isrc, this.indent, this.introContent);

  factory MusicInfo1.json(String htmldoc){
    var doc=parse(htmldoc);
    var body=doc.body;

    var a = body.getElementsByClassName('nbg').first;
    var b = a.attributes['href'];//图片
    var c=a.getElementsByTagName('img').first.attributes['alt'];//名字

    var d=body.getElementsByClassName('ckd-collect').last;
    var e=d.text.replaceAll('  ', '').split('\n\n\n\n');

    String otherName;
    String author;
    String schools;
    String Album;
    String medium;
    String releaseTime;
    String publisher;
    String recordsNumber;
    String barCode;
    String isrc;

    for(String text in e){
      if(text.isNotEmpty){
        String item;
        if(text.contains('\n\n\n')){
          var split = text.split('\n\n\n');
          item='';
          split.forEach((a){
            if(item.isEmpty){
              item =a.replaceAll('\n', '');
            }else{
              item +='\n${a.replaceAll('\n', '')}';
            }
          });
        }else{
          item=text.replaceAll("\n", '');
        }
        if(text.contains("又名:")){
          otherName=item;
        }else if(text.contains("表演者:")){
          author=item;
        }else if(text.contains("流派:")){
          schools=item;
        }else if(text.contains("专辑类型:")){
          Album=item;
        }else if(text.contains("介质:")){
          medium=item;
        }else if(text.contains("发行时间:")){
          releaseTime=item;
        }else if(text.contains("出版者:")){
          publisher=item;
        }else if(text.contains("唱片数:")){
          recordsNumber=item;
        }else if(text.contains("条形码:")){
          barCode=item;
        }else if(text.contains("其他版本:")||text.contains('ISRC')){
          if(isrc!=null){
            if(text.contains(':')){
              isrc +='\n$item';
            }else{
              isrc +=item;
            }
          }else{
            isrc=item;
          }
        }
      }
    }

    var f=body.getElementsByClassName('related_info');
    //简介
    var g = f.first.getElementsByClassName('all');
    String h='';//介绍
    if(g.length>0){
      h=g.first.text.replaceAll('\n', '').replaceFirst('　　', '');
      h=h.replaceAll('　　', '　　\n    ');
      h='   $h';
    }
    var i=body.getElementsByClassName('track-list');
    String j='';//曲目
    if(i.length>0){
      j=i.first.text.replaceAll('\n', '').replaceAll(' ', '');
      j=j.replaceAll(RegExp("[0-9]\d*"), "\n");
      j=j.replaceAll('.', '');
      j=j.replaceFirst('\n', '');
    }

    return new MusicInfo1(c,b,otherName,author,schools,Album,medium,releaseTime,publisher,recordsNumber,barCode,isrc,h,j);

  }
}
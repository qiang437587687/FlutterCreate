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
//这个常识一下各种iOS控件

/*
* return  CupertinoPageScaffold(

        navigationBar: CupertinoNavigationBar(
          leading: RaisedButton(onPressed: _leadingButtonClick),
          middle: Text("$index"),
          trailing: RaisedButton(onPressed: _trailingButtonClick),
        ),
//
        child: new GestureDetector(onTapUp: (tap) {
          print("tap up up up");
        },
          child: new Center(child: Text("$index")),
        ) ,

      );*/



class PageIOSScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _getJsonStr();

    BuildContext globalContext = context;

    CupertinoTabBar tabbar = CupertinoTabBar(items: [BottomNavigationBarItem(icon: Icon(Icons.person),title: Text("123")),
    BottomNavigationBarItem(icon: Icon(Icons.http),title: Text("456")),
    BottomNavigationBarItem(icon: Icon(Icons.movie),title: Text("789")),]);

    CupertinoTabScaffold tabScaffold = CupertinoTabScaffold(tabBar: tabbar, tabBuilder: (BuildContext context, int index) {
      assert(index >= 0 && index <= 2);
      switch (index) {
        case 0:
          return new CupertinoTabView(
            builder: (BuildContext context) {
              return CupertinoDemoTab1("$index", Colors.orange, () { print("$index  leading click"); Navigator.pop(globalContext); }, () { print("$index trailing click"); });
            },
          );

        case 1:
          return new CupertinoTabView(
            builder: (BuildContext context) {
              return CupertinoDemoTab1("$index", Colors.yellow, () { print("$index  leading click"); }, () { print("$index trailing click"); });
            },
          );

        case 2:
          return new CupertinoTabView(
            builder: (BuildContext context) {
              return MyForm();
            },
          );
      }

    });


    DefaultTabController dtC = DefaultTabController(
      length: 3,
      child: tabScaffold
    );

    return dtC;
  }


  _leadingButtonClick() {
    Logger.log("_leadingButtonClick", "_leadingButtonClick");
  }

  _trailingButtonClick() {
    Logger.log("_trailingButtonClick", "_trailingButtonClick");

  }

  _getJsonStr() {
    // 解析一下json
    //
    HttpManager.get(url: "http://localhost/zhang/GGJson.php", onSend: (){
      print("开始请求网络了");
    },
      onSuccess: (String body) {
        print("数据是\n ======> ");
        print(body);
        Map userMap = json.decode(body);
        var user = new User.fromJson(userMap);
        print(user);
      },
      onError: (Object e) {

        //这里需要一个tip提示。~ 一会搞，~
        Logger.log("error message ==== > ", e);
      },
    );

  }

}


class CupertinoDemoTab1 extends StatelessWidget {

  CupertinoDemoTab1(this.name,this.color,this.leadingCallback,this.trailingCallback);
  final String name;
  final Color color;
  final VoidCallback leadingCallback;
  final VoidCallback trailingCallback;
  String time;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    CupertinoButton lButton = CupertinoButton(child: Text("CupertinoButton"), onPressed: null);
    //这个控件直接放在leading上面会有一些位置移动，这里就需要用一个控件进行包裹，设定好位置之后再放到上面。
    GestureDetector ges = GestureDetector(onTap: leadingCallback ,child: Text("back"),);
    //用控件包裹了，这里面的Factor貌似是拉伸度，
    Align ali = Align(widthFactor: 1.0,alignment: Alignment.center,child: ges,);

    final myController = TextEditingController();
//    TextField tellField = TextField(
//      controller: myController,
//    );

    _onTextFieldChanged(String str) {
        Logger("changed str", str);

        if (str == "zhang") {
        } else {
          Logger("_onTextFieldChanged", "stop");
        }

    }


    // material  such as a Card,  Dialog, Drawer, or Scaffold.

    /*
        Key key,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    TextInputType keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    * */
    Drawer dw = Drawer(child: TextField(controller: myController,autocorrect: false,onChanged: _onTextFieldChanged,));
    Card card = Card(child: TextField(controller: myController,autocorrect: false,onChanged: _onTextFieldChanged,),color: Colors.purple,);
    MyForm from = MyForm();
    Container contain =  Container(child: card,width: 100.0,height: 50.0,);

    //这一块是封装的定时器的
    /**/
    ToolsTimer timerr = ToolsTimer((str) {
      Logger(" timer str ", str);
    });
    _pressCurrent() {
      timerr.stopOrStart();
    }
    RaisedButton button = RaisedButton(onPressed: _pressCurrent,child: Text("点击停止或者开始"),);


    List<Widget> weights = <Widget>[Text(name,textAlign: TextAlign.center,style: styleBlack,),contain,timerr,button];

    return CupertinoPageScaffold(

      navigationBar: CupertinoNavigationBar(
        //这种方法不太好啊~
        leading: Container(child: Text("123",textAlign: TextAlign.center,),alignment: Alignment.center,width: 44.0,height: 44.0,),
        middle: Text(name),
        trailing: ali,
      ),
//
      child: Container(alignment: Alignment.center,color: color,child: Center(child: ListView(children: weights,)),)


//      new GestureDetector(onTapUp: (tap) {
//        print("tap up up up");
//        //首先停止一下
//        if (timer.timerISActive) {
//          timer.stop();
//        } else {
//          timer.start();
//        }
//      },
//        child: ,
//
//      ),


    );



  }
}


class MyForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyFormState();
  }

}

//这个是输入框，
class _MyFormState extends State<MyForm> {
  // Create a text controller and use it to retrieve the current value.
  // of the TextField!
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when disposing of the Widget.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog with the
        // text the user has typed into our text field.
        onPressed: () {
           showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the user has typed in using our
                // TextEditingController
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}


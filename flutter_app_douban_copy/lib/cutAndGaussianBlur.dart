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

import "package:flutter_app_douban_copy/dispaly.dart";
import 'dart:ui' as ui;

class CutAndGaussianBlur extends StatefulWidget {
  @override
  _CutAndGaussianBlurState createState() => _CutAndGaussianBlurState();
}

class _CutAndGaussianBlurState extends State<CutAndGaussianBlur> with SingleTickerProviderStateMixin {
  GlobalKey globalKey = new GlobalKey();
  bool _second = false;
  AnimationController controller; // 注意一下这个怎么控制动画的

  int surplusDay = 0;
  String currencyName = "电风扇";
  double surplusAmountToday = 100.0;

  final double MAXSIGMA = 5.0;
  final double MINSIGMA = 0.0;

  double sigma;
  double secondOpacity = 0.0;

  @override
  void initState() {
    super.initState();

//    controller = new AnimationController(vsync: this, duration: const Duration(microseconds: 1000)); // 初始化动画控制器
    controller = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    final Animation curve = new CurvedAnimation(parent: controller, curve: Curves.easeOut);
    final Tween doubleTween = new Tween<double>(begin: MINSIGMA,end: MAXSIGMA); //返回一个值用来描述动画过程在此之间的一个数.
    final Tween opacityTween = new Tween<double>(begin: 0.0, end: 1.0);

    curve.addListener(() {
      setState(() {
        var s = opacityTween.evaluate(curve); //猜想是正确的，动画的变化程度对应一个数字区间。
        Logger(" 注意这里的数值变化ssssssssss ----> opacityTween.evaluate(curve);", s);
        secondOpacity = s;
        var m = doubleTween.evaluate(curve);
//        Logger("注意这里的数值变化mmmmmmmmmmm ————————————> doubleTween.evaluate(curve);", m);
        sigma = m;
      });
    });

  }


  Widget _firstPage() {
//    return Stack(
//      children: <Widget>[
//        GestureDetector(
//          onPanStart: (DragStartDetails details) {
//            setState(() {
//              RenderBox referenceBox = context.findRenderObject();
//              Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
//            });
//          },
//        ),
//
//      ],
//    );

    return Container(
      width: 100.0,
      height: 100.0,
      color: Colors.orange,
    );
  }

  Widget _secondPage() {

//    return Opacity(opacity: _second ? secondOpacity : 0.0, // 简单测试版
//      child: Container(
//        width: 50.0,
//        height: 50.0,
//        color: Colors.purple,
//      ),
//    );

    return Opacity(opacity: _second ? 1.0 : 0.0,
        child: new BackdropFilter(
          filter: new ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Opacity(opacity: secondOpacity,
            child: Container(
              color: Colors.black.withOpacity(0.01),
              child: new Center(
                child: new RichText(text: new TextSpan(

                  children: <TextSpan> [

                    new TextSpan(
                      text: "\n${surplusAmountToday.toStringAsFixed(2)}", //取小数点后2位
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 48.0,
                      )
                    ),

                    new TextSpan(
                        text: "\n今日剩余",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                    new TextSpan(
                        text: "\n今日剩余",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                    new TextSpan(
                        text: "\n今日剩余",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                    new TextSpan(
                        text: "\n今日剩余",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                    new TextSpan(
                        text: "\n今日剩余",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),

                  ],
                  text: currencyName,
                  style: new TextStyle(
                      fontSize: 18.0,
                      decoration: TextDecoration.none,
                      color: Colors.red)
                ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
    );


  }

  /*
   onTapDown: onTapDownEachDay,
              onPanEnd: onTapDrasecondPagegEndEachDay,
              onTapUp: onTapUpEachDay,
              child: RadiusButton(
  * */

  setSecondPage() {
    controller.reset();
    controller.forward();
    setState(() {
      _second = true;
    });
  }

  setFirstPage() {
    controller.stop();
    setState(() {
      _second = false;
    });
  }

  onTapDragEndEachDay(DragEndDetails details) {
    Logger("onTapDragEndEachDay", "onTapDragEndEachDay");

    setFirstPage();
  }


  onTapDownEachDay(TapDownDetails details) {
    Logger("onTapDownEachDay", "onTapDownEachDay");

    setSecondPage();
  }

  onTapUpEachDay(TapUpDetails details) {
    Logger("onTapUpEachDay", "onTapUpEachDay");

    setFirstPage();
  }

  // setstate会重新刷新这里。
  @override
  Widget build(BuildContext context) {
    Logger("inbuild", "");
    initScreen(context); //获取全局的宽度高度。
//    return Stack(
//      fit: StackFit.expand,
//      children: <Widget>[
//        _firstPage(),
//        new IgnorePointer(
//          child: _secondPage(),
////          child: Text("123"),
//        )
//      ],
//    );
    return Container(
      color: Colors.white,
      width: screenWidth,
      height: screenHeight,
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Center(child:
              ListView(children: <Widget>[

                Text("niubi",textAlign: TextAlign.start,style: Theme.of(context).textTheme.title,),
                Text("hone",textAlign: TextAlign.center,style: Theme.of(context).textTheme.title,),
                Text("json",textAlign: TextAlign.right,style: Theme.of(context).textTheme.title,),
                Text("gay",textAlign: TextAlign.start,style: Theme.of(context).textTheme.title,),
                Text("sara",textAlign: TextAlign.center,style: Theme.of(context).textTheme.title,),
                Text("niubi",textAlign: TextAlign.right,style: Theme.of(context).textTheme.title,),

                ],

              ),
            ),
            padding: const EdgeInsets.all(10.0),
            color: Colors.orange,
            width: 100.0,
            height: 200.0,
          ),
          Container(
            width: 100.0,
            height: 200.0,
            color: Colors.red,
            child: Stack(
//              fit: StackFit.expand, -->这个属性的扩张会导致控件的位置去左上角
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                _firstPage(),
              ],
            ),
          ),
          new IgnorePointer(
            child: Text("123",style: Theme.of(context).textTheme.title,),
          ),


          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: GestureDetector(
              onTapDown: onTapDownEachDay,
              onPanEnd: onTapDragEndEachDay,
              onTapUp: onTapUpEachDay,
              child: Text("按键",style: styleBlack,),
            ),
          ),

          Container(width: 100.0, height: 200.0,color: Colors.cyan,
          child:  Stack(fit: StackFit.loose,alignment: Alignment.center,
            children: <Widget>[

              _firstPage(),
              new IgnorePointer(
                child: _secondPage(),
              ),

            ],),)

        ],
      )
    );




  }
}


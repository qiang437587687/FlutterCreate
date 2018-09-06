
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//显示加载转圈
class LoadingProgress extends StatelessWidget {
  getProgressDialog() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getProgressDialog();
  }
}

//加载error
class LoadingError extends StatelessWidget {
  LoadingError({@required this.voidCallback});

  final VoidCallback voidCallback;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: RaisedButton(
          textColor: Colors.green,
          child: Text("加载error"),
          onPressed: voidCallback),
    );
  }
}
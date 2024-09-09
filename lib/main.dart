import 'package:flutter/material.dart';  // 確認
import 'package:app_links/app_links.dart';  // app_links 用
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _sub;
  AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    initAppLinks();
  }

  void initAppLinks() async {
    _appLinks = AppLinks();

    try {
      final initialLink = await _appLinks.getInitialAppLink();
      if (initialLink != null) {
        print("Initial Link: $initialLink");
      }
    } on Exception catch (e) {
      print("エラー: $e");
    }

    _sub = _appLinks.uriLinkStream.listen((Uri link) {
      if (link != null) {
        print("Received Link: $link");
      }
    }, onError: (err) {
      print("ストリームエラー: $err");
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('App Links Example'),
        ),
        body: Center(
          child: Text('Welcome to the App Links Demo'),
        ),
      ),
    );
  }
}

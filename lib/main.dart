import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri?>? _sub;
  AppLinks? _appLinks;

  @override
  void initState() {
    super.initState();
    initAppLinks();
  }

  void initAppLinks() async {
    _appLinks = AppLinks(
      onAppLink: (Uri? uri, String linkString) {  // Nullable Uriに対応
        if (uri != null) {
          print("Received Link: $uri, Link String: $linkString");
          _handleIncomingLink(uri, linkString);
        }
      },
    );

    try {
      final Uri? initialLink = await _appLinks!.getInitialAppLink();  // Nullable型のUri?を使用
      if (initialLink != null) {
        print("Initial Link: $initialLink");
        _handleIncomingLink(initialLink, initialLink.toString());
      }
    } on Exception catch (e) {
      print("エラー: $e");
    }

    _sub = _appLinks!.uriLinkStream.listen((Uri? uri) {  // Nullable Uriに対応
      if (uri != null) {
        print("Streamed Link: $uri");
        _handleIncomingLink(uri, uri.toString());
      }
    }, onError: (err) {
      print("ストリームエラー: $err");
    });
  }

  void _handleIncomingLink(Uri uri, String linkString) {
    // ここでリンクに基づく処理や画面遷移を実装
    if (uri.path == '/special') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SpecialPage()),
      );
    }
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

class SpecialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Special Page'),
      ),
      body: Center(
        child: Text('This is a special page triggered by a deep link!'),
      ),
    );
  }
}

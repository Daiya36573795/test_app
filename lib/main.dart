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
  StreamSubscription<Uri> _sub;
  AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    initAppLinks();
  }

  void initAppLinks() async {
    _appLinks = AppLinks(
      onAppLink: (Uri uri) {  // 必須パラメータとしてのonAppLinkを追加
        print("Received Link: $uri");  // リンクを受け取ったときの処理
        _handleIncomingLink(uri);  // リンクに基づく処理（画面遷移など）
      },
    );

    try {
      final Uri initialLink = await _appLinks.getInitialAppLink();  // アプリ起動時にリンクがあれば取得
      if (initialLink != null) {
        print("Initial Link: $initialLink");
        _handleIncomingLink(initialLink);  // 初期リンクを処理
      }
    } on Exception catch (e) {
      print("エラー: $e");
    }

    _sub = _appLinks.uriLinkStream.listen((Uri uri) {  // リアルタイムでリンクを監視
      if (uri != null) {
        print("Streamed Link: $uri");
        _handleIncomingLink(uri);  // ストリームでリンクが受信されたときの処理
      }
    }, onError: (err) {
      print("ストリームエラー: $err");
    });
  }

  void _handleIncomingLink(Uri uri) {
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

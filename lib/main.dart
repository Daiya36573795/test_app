import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
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
  String _currentLink;

  @override
  void initState() {
    super.initState();
    initUniLinks(); // ユニバーサルリンクの初期化
  }

  void initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleIncomingLink(initialLink); // アプリ起動時のリンク処理
      }
    } on Exception catch (e) {
      print("エラー: $e"); // エラーハンドリング
    }

    _sub = linkStream.listen((String link) {
      if (link != null) {
        _handleIncomingLink(link); // リンクが取得された時の処理
      }
    }, onError: (err) {
      print("ストリームエラー: $err"); // ストリームエラーの処理
    });
  }

  void _handleIncomingLink(String link) {
    setState(() {
      _currentLink = link;
    });

    // ここでリンクに基づく画面遷移やデータ処理を行います
    if (link.contains("special-path")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SpecialPage()),
      );
    }
    print("処理中のリンク: $link");
  }

  @override
  void dispose() {
    _sub?.cancel(); // ストリームのキャンセル
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Uni Links Example'),
        ),
        body: Center(
          child: Text(_currentLink != null
              ? 'Received Link: $_currentLink'
              : 'Welcome to the Uni Links Demo'),
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

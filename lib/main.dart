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

  @override
  void initState() {
    super.initState();
    initUniLinks(); // ユニバーサルリンクの初期化
  }

  void initUniLinks() async {
    try {
      final initialLink = await getInitialLink(); 
      print("Initial Link: $initialLink"); // アプリ起動時にリンクがあれば表示
    } on Exception {
      // エラーハンドリング
    }

    _sub = linkStream.listen((String link) {
      if (link != null) {
        print("Received Link: $link"); // リンクが取得された時の処理
        // ここで画面遷移やデータ処理などを行います
      }
    }, onError: (err) {
      // エラーハンドリング
    });
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
          child: Text('Welcome to the Uni Links Demo'),
        ),
      ),
    );
  }
}

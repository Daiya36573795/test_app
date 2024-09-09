import 'package:app_links/app_links.dart'; // 変更箇所
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
  AppLinks _appLinks; // app_links用に変更

  @override
  void initState() {
    super.initState();
    initAppLinks(); // app_links用に変更
  }

  void initAppLinks() async { // app_links用に変更
    _appLinks = AppLinks();

    try {
      final initialLink = await _appLinks.getInitialAppLink(); // app_links用に変更
      if (initialLink != null) {
        print("Initial Link: $initialLink");
      }
    } on Exception catch (e) {
      print("エラー: $e");
    }

    _sub = _appLinks.uriLinkStream.listen((Uri link) { // app_links用に変更
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

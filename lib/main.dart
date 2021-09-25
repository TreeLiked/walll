import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:common_utils/common_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wall/provider/msg_provider.dart';
import 'package:wall/provider/tweet_provider.dart';

import 'application.dart';
import 'config/routes/routes.dart';
import 'page/splash_page.dart';
import 'provider/account_local_provider.dart';
import 'provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const WallApp());
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setSystemUIOverlayStyle(
  //     SystemUiOverlayStyle.);
  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class WallApp extends StatefulWidget {
  static const bool inProduction = bool.fromEnvironment("dart.vm.product");

  const WallApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WallAppState();
  }
}

class _WallAppState extends State<WallApp> {
  static const String _tag = "_WallAppState";

  final JPush _jPush = JPush();

  _WallAppState() {
    final router = fluro.FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();
    initUMengAnalytics();

    LogUtil.init(tag: _tag, maxLen: 1024, isDebug: !WallApp.inProduction);
    LogUtil.e("生产环境: ${WallApp.inProduction}", tag: "AlmondDonuts");

    _jPush.getRegistrationID().then((rid) {
      if (rid.isNotEmpty) {
        Application.setDeviceId(rid);
        // _getAndUpdateDeviceInfo(rid);
      } else {
        LogUtil.e("获取不到RegistrationId", tag: "AlmondDonuts");
      }
    });

    // var fireDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + 3000);
    // var localNotification = LocalNotification(
    //     id: 234,
    //     title: 'fadsfa',
    //     buildId: 1,
    //     content: 'fdas',
    //     fireTime: fireDate,
    //     subtitle: 'fasf',
    //     badge: 5,
    //     extra: {"fa": "0"});
    // _jPush.sendLocalNotification(localNotification).then((res) {
    //   print(res);
    // });
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Color(0xff000000), statusBarIconBrightness: Brightness.dark));
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  addEventListeners() {
    _jPush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        LogUtil.e("flutter onReceiveNotification: $message", tag: _tag);
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        LogUtil.e("flutter onOpenNotification: $message", tag: _tag);

        _jPush.clearAllNotifications();

        Map<String, dynamic> extraMap;
        if (Platform.isAndroid) {
          extraMap = json.decode(message['extras']['cn.jpush.android.EXTRA']);
        } else if (Platform.isIOS) {
          extraMap = message;
        } else {
          return;
        }
        LogUtil.d(extraMap, tag: _tag);
        if (extraMap.containsKey("JUMP")) {
          _handleJump(extraMap);
        }
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        LogUtil.d("flutter onReceiveMessage: $message", tag: _tag);
      },
    );
  }

  _handleJump(Map<String, dynamic> extraMap) {
    if (Application.context == null) {
      return;
    }
    String jumpKey = extraMap['JUMP'].toString();
    int refId = int.parse(extraMap['REF_ID']);
    if (jumpKey == 'TWEET_DETAIL') {
      _forwardTweetDetail(refId);
    }
  }

  _forwardTweetDetail(tweetId) async {
    print('跳转到 -> tweet detail $tweetId');
    // NavigatorUtils.push(Application.context, Routes.tweetDetail + "?tweetId=$tweetId");

//    Navigator.push(
//      Application.context,
//      MaterialPageRoute(builder: (context) => TweetDetail(null, tweetId: tweetId)),
//    );
  }

  Future<void> initPlatformState() async {
    addEventListeners();
    _jPush.setup(
      appKey: "2541d486ffc85cf504572f6e",
      channel: "developer-default",
//      channel: "flutter_channel",
      production: WallApp.inProduction,
      debug: !WallApp.inProduction,
    );
//    _jPush.applyPushAuthority(new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    if (!mounted) return;
  }

  Future<void> initUMengAnalytics() async {
    // await UMengUtil.initUMengAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => AccountLocalProvider()),
        // ChangeNotifierProvider(create: (BuildContext context) => TweetTypesFilterProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => ThemeProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => TweetProvider()),
        // ChangeNotifierProvider(create: (BuildContext context) => CircleTweetProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => MsgProvider()),
      ],
      // child:  MaterialApp(
      //     title: 'Wall',
      //     //showPerformanceOverlay: true, //显示性能标签
      //     debugShowCheckedModeBanner: false,
      //     home: SplashPage(),
      //     onGenerateRoute: Application.router.generator,
      //     localizationsDelegates: const [
      //       GlobalMaterialLocalizations.delegate,
      //       GlobalWidgetsLocalizations.delegate,
      //       GlobalCupertinoLocalizations.delegate,
      //       DefaultCupertinoLocalizations.delegate
      //     ],
      //     supportedLocales: const [const Locale('zh', 'CH')],
      //   )
      // );
      child: Consumer<ThemeProvider>(builder: (_, provider, __) {
        return MaterialApp(
          title: 'Wall',
          //showPerformanceOverlay: true, //显示性能标签
          debugShowCheckedModeBanner: false,
          theme: provider.getTheme(),
          darkTheme: provider.getTheme(isDarkMode: true),
          home: const SplashPage(),
//            home: SplashPage(),
          onGenerateRoute: Application.router!.generator,
          // localizationsDelegates: const [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          supportedLocales: const [Locale('zh', 'CH')],
        );
      }),
    );

    // return ChangeNotifierProvider<ThemeProvider>(
    //   builder: (_) => ThemeProvider(),
    //   child: Consumer<ThemeProvider>(
    //     builder: (_, provider, __) {
    //       return MaterialApp(
    //           title: 'Flutter Deer',
    //           //showPerformanceOverlay: true, //显示性能标签
    //           debugShowCheckedModeBanner: false,
    //           theme: provider.getTheme(),
    //           darkTheme: provider.getTheme(isDarkMode: true),
    //           home: SplashPage(),
    //           onGenerateRoute: Application.router.generator,
    //           // localizationsDelegates: const [
    //           //   GlobalMaterialLocalizations.delegate,
    //           //   GlobalWidgetsLocalizations.delegate,
    //           //   GlobalCupertinoLocalizations.delegate,
    //           // ],
    //           supportedLocales: const [Locale('zh', 'CH'), Locale('en', 'US')]);
    //     },
    //   ),
    // );
  }
}

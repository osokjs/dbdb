import 'dart:developer';

import 'package:dbdb/model/group_code.dart';
import 'package:dbdb/model/route_code.dart';
import 'package:dbdb/model/route_data.dart';
import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'model/favorite_data.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'db db'),
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

  @override
  void initState() {
    super.initState();
    log('initState starting...');
    // WidgetsBinding.instance?.addPostFrameCallback((FrameCallback callback) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // executes after build
      log('--- executes after build.');
    });

    Future.delayed(Duration.zero, () {
      log('future delayed zero.');
    });
  }


  void _incrementCounter()  async {
    setState(() {
      _counter++;
    });

    int result = await DatabaseHelper.instance.insertFavorite(
      FavoriteData(
        id: 0,
        groupId: 1,
        name: '내 장소 $_counter',
        latitude: 37.55 + _counter,
        longitude: 126.66 + _counter,
        accuracy: 10.1 + _counter,
        updated: DateTime.now().toString()
      )
    );

    List<FavoriteData> list = await DatabaseHelper.instance.queryAllFavorite();
    log('@@ $result rows are inserted. length: ${list.length}');

    for(var fd in list) {
      log(fd.toString());
    }
  }

  void _createGroupCode() async {
    int result = 0;
    result = await DatabaseHelper.instance.insertGroupCode(
      '그룹 $_counter',
    );
    log('@@ $result rows are inserted.');
    List<GroupCode> list = await DatabaseHelper.instance.queryAllGroupCode();

    for(var rd in list) {
      log(rd.toString());
    }
  }


  void _createRouteCode() async {
    int result = 0;
    // 먼저 해당 routeId에 해당하는 자료를 삭제한 후 루트 데이터를 insert 한다.
    // result = await DatabaseHelper.instance.deleteById(DatabaseHelper._routeCodeTable, _counter);
    // log('삭제 후: $result');
      result = await DatabaseHelper.instance.insertRouteCode(
      '루트 그룹 $_counter',
        DateTime.now().toString(),
      );
    log('@@ $result rows are inserted.');
    List<RouteCode> list = await DatabaseHelper.instance.queryAllRouteCode();

    for(var rd in list) {
      log(rd.toString());
    }
  }

  void _manageRoute() async {
    int result = 0;
    // 먼저 해당 routeId에 해당하는 자료를 삭제한 후 루트 데이터를 insert 한다.
    result = await DatabaseHelper.instance.deleteRouteId(_counter);
    log('삭제 후: routeId: $_counter, 결과: $result');
    for(int i=0; i<_counter+1; i++) {
      result = await DatabaseHelper.instance.insertRoute(
          RouteData(
              routeId: _counter,
              idx: i+1,
              name: '포인트 ${i+1}',
              latitude: 37.55 + i+1,
              longitude: 126.66 + i+1,
              accuracy: 10.1 + i+1,
          )
      );
    }
    log('@@ $result rows are inserted.');
    List<RouteData> list = await DatabaseHelper.instance.queryAllRoute(_counter);

    for(var rd in list) {
      log(rd.toString());
    }

    list = await DatabaseHelper.instance.queryAllRoute(_counter-1);

    for(var rd in list) {
      log(rd.toString());
    }


  }

  @override
  Widget build(BuildContext context) {
    log('build starting...');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              child: const Text('숫자 증가'),
              onPressed:         _incrementCounter,
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('그룹 생성'),
              onPressed: _createGroupCode,
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('루트 그룹 생성'),
              onPressed: _createRouteCode,
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('루트 내용 추가'),
              onPressed: _manageRoute,
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('데이타베이스 제거'),
              onPressed: () => DatabaseHelper.instance.myDeleteDatabase(),
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('데이타베이스 제거'),
              onPressed: () => DatabaseHelper.instance.myDeleteDatabase(),
            ), // ElevatedButton
          ],
        ), // Column
      ), // Center
    ); // Scaffold
  }
}

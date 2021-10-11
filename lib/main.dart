import 'dart:developer';

import 'package:dbdb/model/group_code.dart';
import 'package:dbdb/model/route_code.dart';
import 'package:dbdb/model/route_data.dart';
import 'package:dbdb/view/full_screen_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return GetMaterialApp(
      title: 'db db',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'db db'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String _resultText = '초기값';

  final TextEditingController _controller = TextEditingController();

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    int result = await DatabaseHelper.instance.insertFavorite(FavoriteData(
        id: 0,
        groupId: 1,
        name: '내 장소 $_counter',
        latitude: 37.55 + _counter,
        longitude: 126.66 + _counter,
        accuracy: 10.1 + _counter,
        updated: DateTime.now().toString()));

    List<FavoriteData> list = await DatabaseHelper.instance.queryAllFavorite();
    log('@@ $result rows are inserted. length: ${list.length}');
    Get.snackbar(
        '숫자 증가', '@@ $result rows are inserted. length: ${list.length}');

    for (var fd in list) {
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

    for (var rd in list) {
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

    for (var rd in list) {
      log(rd.toString());
    }
  }

  void _manageRoute() async {
    int result = 0;
    // 먼저 해당 routeId에 해당하는 자료를 삭제한 후 루트 데이터를 insert 한다.
    result = await DatabaseHelper.instance.deleteRouteId(_counter);
    log('삭제 후: routeId: $_counter, 결과: $result');
    for (int i = 0; i < _counter + 1; i++) {
      result = await DatabaseHelper.instance.insertRoute(RouteData(
        routeId: _counter,
        idx: i + 1,
        name: '포인트 ${i + 1}',
        latitude: 37.55 + i + 1,
        longitude: 126.66 + i + 1,
        accuracy: 10.1 + i + 1,
      ));
    }
    log('@@ $result rows are inserted.');
    List<RouteData> list =
        await DatabaseHelper.instance.queryAllRoute(_counter);

    for (var rd in list) {
      log(rd.toString());
    }

    list = await DatabaseHelper.instance.queryAllRoute(_counter - 1);

    for (var rd in list) {
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
            ElevatedButton(
              child: const Text('custom 다이알로그 '),
              onPressed: () {
                Get.dialog(
                  Dialog(
                    child: _groupManagement(),
                  ),
                  barrierDismissible: false,
                  name: 'custom dialog test',
                );
                log('dialog closed.');
              },
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('show alert dialog'),
              onPressed: () {
                _showAlertDialog(context, DateTime.now().toString());
                log('dialog closed.');
              },
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('다이알로그 22'),
              onPressed: () {
                log('full screen dialog starting...');
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const FullScreenDialog(),
                    fullscreenDialog: true,
                  ),
                );
                log('full screen dialog closed');
              },
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('다이알로그 33'),
              onPressed: () {
                Get.defaultDialog(
                  title: '알림창',
                  middleText: '다이알로그 33: 기존 _resultText: $_resultText',
                  // content:  Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   // ignore: prefer_const_literals_to_create_immutables
                  //   children: <Widget>[
                  //   const Text('콘텐츠 영역 1'),
                  //   const Text('콘텐츠 영역 2'),
                  // ],
                  // ),
                  barrierDismissible: false,
                  radius: 20,
                  textConfirm: '확인',
                  textCancel: '취소',
                  onConfirm: () {
                    setState(() {
                      _resultText = 'OK 33';
                    });
                    log('onConfirm clicked.');
                    Get.back();
                  },
                  onCancel: () {
                    setState(() {
                      _resultText = 'CANCEL 33';
                    });
                    log('onCancel clicked.');
                    Get.back();
                  },
                );
              },
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('첫 번째'),
              onPressed: () {
                Get.snackbar(
                  '스넥바 타이틀입니다.',
                  '두번째 인자로 표시 내용을 전달해야 합니다.',
                  duration: const Duration(seconds: 30),
                  isDismissible: true,
                );
              },
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('두 번째'),
              onPressed: () {
                Get.snackbar(
                  '두번째 스넥바',
                  ' 여기에 내용을 표시해야 함, 30초 후에 자동으로 사라지거나 탭 하면 사라짐.',
                  duration: const Duration(seconds: 30),
                  isDismissible: true,
                  onTap: (_) => Get.back(),
                );
              },
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('세 번째'),
              onPressed: () {
                Get.snackbar(
                  ' 3 번째 스넥바 타이틀 ',
                  ' 60 초 후에 사라지지 않을 것으로 추정됨, 탭 해야만 스넥바가 닫힐 것으로 예상함.',
                  duration: const Duration(seconds: 60),
                  isDismissible: false,
                  onTap: (_) => Get.back(),
                );
              },
            ), // ElevatedButton
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            // ElevatedButton(
            //   child: const Text('숫자 증가'),
            //   onPressed:         _incrementCounter,
            // ), // ElevatedButton
            // ElevatedButton(
            //   child: const Text('그룹 생성'),
            //   onPressed: _createGroupCode,
            // ), // ElevatedButton
            // ElevatedButton(
            //   child: const Text('루트 그룹 생성'),
            //   onPressed: _createRouteCode,
            // ), // ElevatedButton
            // ElevatedButton(
            //   child: const Text('루트 내용 추가'),
            //   onPressed: _manageRoute,
            // ), // ElevatedButton
            // ElevatedButton(
            //   child: const Text('데이타베이스 제거'),
            //   onPressed: () => DatabaseHelper.instance.myDeleteDatabase(),
            // ), // ElevatedButton
            // ElevatedButton(
            //   child: const Text('데이타베이스 제거'),
            //   onPressed: () => DatabaseHelper.instance.myDeleteDatabase(),
            // ), // ElevatedButton
          ],
        ), // Column
      ), // Center
    ); // Scaffold
  } // build

  Widget _groupManagement() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: <Widget>[
          Text(
            '카테고리 관리',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '카테고리 이름:',
              hintText: '카테고리 이름을 10자 이내로 입력하세요.',
            ),
          ), // TextFormField
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              String value = _controller.text.trim();

              // if(!_isValid(context, value)) return;

              log('text value($value)');
              _controller.clear();
              setState(() {});
            },
            child: const Text('저장'),
          ), // ElevatedButton
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('닫기'),
          ), // ElevatedButton
        ],
      ), // Column
    ); // GestureDetector
  } // _groupManagement

  void _showAlertDialog(BuildContext context, String name) async {
    TextEditingController dialogController = TextEditingController(text: name);
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('카테고리 관리'),
          content: Column(
            children: <Widget>[
              Text(
                '카테고리 관리',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: dialogController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '카테고리 이름:',
                  hintText: '카테고리 이름을 10자 이내로 입력하세요.',
                ),
              ), // TextFormField
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                child: const Text('저장'),
                onPressed: () {
                  String value = _controller.text.trim();

                  // if(!_isValid(context, value)) return;

                  log('text value($value)');
                  _controller.clear();
                  setState(() {});
                },
              ), // ElevatedButton
            ],
          ), // GestureDetector
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
              },
            ),
          ],
        );
      },
    );
    dialogController.dispose();
  } // _showAlertDialog

} // class


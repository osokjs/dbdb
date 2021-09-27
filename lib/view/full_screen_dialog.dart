import 'package:flutter/material.dart';

class FullScreenDialog extends StatefulWidget {
  const FullScreenDialog({Key? key}) : super(key: key);

  @override
  _FullScreenDialogState createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6200EE),
        title: const Text('다이알로그 타이틀'),
      ),
      body: const Center(
        child: Text("내용 부분: Full-screen dialog"),
      ),
    );

  }
}

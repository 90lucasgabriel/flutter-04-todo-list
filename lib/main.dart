import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Todo List',
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Container(),
      backgroundColor: Colors.white,
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/data.json');
  }

  Future<File> _setData() async {
    String data = json.encode(_todoList);
    File file = await _getFile();

    return file.writeAsString(data);
  }

  Future<String> _getData() async {
    try {
      File file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}

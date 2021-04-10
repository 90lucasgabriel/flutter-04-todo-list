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
  List _todoList = [
    {'title': 'Task 1', 'accomplished': false},
    {'title': 'Task 2', 'accomplished': true},
    {'title': 'Task 3', 'accomplished': true},
    {'title': 'Task 4', 'accomplished': false},
    {'title': 'Task 5', 'accomplished': false},
    {'title': 'Task 6', 'accomplished': false},
    {'title': 'Task 7', 'accomplished': true},
    {'title': 'Task 8', 'accomplished': true},
    {'title': 'Task 9', 'accomplished': false},
    {'title': 'Task 0', 'accomplished': false},
    {'title': 'Task 11', 'accomplished': false},
    {'title': 'Task 12', 'accomplished': true},
    {'title': 'Task 13', 'accomplished': true},
    {'title': 'Task 14', 'accomplished': false},
    {'title': 'Task 15', 'accomplished': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_todoList[index]['title']),
                    value: _todoList[index]['accomplished'],
                    secondary: CircleAvatar(
                      child: Icon(_todoList[index]['accomplished']
                          ? Icons.check
                          : Icons.error),
                    ),
                  );
                }),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Create a task',
                      labelStyle: TextStyle(color: Colors.teal),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.teal),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                )
              ],
            ),
          ),
        ],
      ),
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

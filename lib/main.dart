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
  TextEditingController _taskController = TextEditingController();
  List _todoList = [];

  void _handleAddTask() {
    Map<String, dynamic> task = Map();
    task = {
      'title': _taskController.text,
      'accomplished': false,
    };

    setState(() {
      _todoList.add(task);
    });
    _taskController.text = '';
  }

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
                    activeColor: Colors.teal,
                    title: Text(_todoList[index]['title']),
                    value: _todoList[index]['accomplished'],
                    secondary: CircleAvatar(
                      child: Icon(_todoList[index]['accomplished']
                          ? Icons.check
                          : Icons.error),
                      backgroundColor: _todoList[index]['accomplished']
                          ? Colors.teal
                          : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _todoList[index]['accomplished'] = value;
                      });
                    },
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
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Create a task',
                      labelStyle: TextStyle(color: Colors.teal),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _handleAddTask,
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

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

  Map<String, dynamic> _taskRemoved;
  int _taskRemovedIndex;

  @override
  initState() {
    super.initState();

    _getData().then((data) {
      setState(() {
        _todoList = json.decode(data);
      });
    });
  }

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
    _setData();
  }

  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if (a['accomplished'] && !b['accomplished']) {
          return 1;
        }

        if (!a['accomplished'] && b['accomplished']) {
          return -1;
        }

        return 0;
      });
    });

    _setData();

    return null;
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
            child: RefreshIndicator(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _todoList.length,
                  itemBuilder: _buildItem,
                ),
                onRefresh: _handleRefresh),
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

  Widget _buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (direction) {
        _taskRemoved = Map.from(_todoList[index]);
        _taskRemovedIndex = index;

        setState(() {
          _todoList.removeAt(index);
        });

        _setData();

        Widget snackbar = SnackBar(
          content: Text('Task removed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _todoList.insert(_taskRemovedIndex, _taskRemoved);
              });
              _setData();
            },
          ),
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 90, left: 8, right: 8),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
      child: CheckboxListTile(
        activeColor: Colors.teal,
        title: Text(_todoList[index]['title']),
        value: _todoList[index]['accomplished'],
        secondary: CircleAvatar(
          child: Icon(
              _todoList[index]['accomplished'] ? Icons.check : Icons.error),
          backgroundColor:
              _todoList[index]['accomplished'] ? Colors.teal : Colors.grey,
          foregroundColor: Colors.white,
        ),
        onChanged: (value) {
          setState(() {
            _todoList[index]['accomplished'] = value;
            _setData();
          });
        },
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

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

import 'dart:convert';

void main() {
  runApp(EnhancedToDoApp());
}

class EnhancedToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal.shade800,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: ToDoListScreen(),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<Map<String, dynamic>> _tasks = [];

  TextEditingController _taskController = TextEditingController();

  String _selectedCategory = 'General';

  String _selectedPriority = 'Medium';

  @override
  void initState() {
    super.initState();

    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? tasksString = prefs.getString('tasks');

    if (tasksString != null) {
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(json.decode(tasksString));
      });
    }
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('tasks', json.encode(_tasks));
  }

  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _tasks.add({
          "task": task,
          "isComplete": false,
          "category": _selectedCategory,
          "priority": _selectedPriority,
          "dueDate": null,
        });
      });

      _taskController.clear();

      _saveTasks();
    }
  }

  void _updateTask(int index, String updatedTask) {
    setState(() {
      _tasks[index]["task"] = updatedTask;
    });

    _saveTasks();
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]["isComplete"] = !_tasks[index]["isComplete"];
    });

    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });

    _saveTasks();
  }

  void _showEditTaskDialog(int index) {
    _taskController.text = _tasks[index]["task"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Update task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                _taskController.clear();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateTask(index, _taskController.text);

                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: ['General', 'Work', 'Personal']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value as String;
                  });
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: _selectedPriority,
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Priority'),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value as String;
                  });
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      _tasks[_tasks.length - 1]["dueDate"] =
                          DateFormat('yyyy-MM-dd').format(selectedDate);
                    });
                  }
                },
                child: Text('Set Due Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                _taskController.clear();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTask(_taskController.text);

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enhanced To-Do List')),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(12.0),
              leading: Checkbox(
                value: task["isComplete"],
                onChanged: (_) => _toggleTaskCompletion(index),
              ),
              title: Text(
                task["task"],
                style: TextStyle(
                  decoration: task["isComplete"]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task["dueDate"] != null) Text("Due: ${task["dueDate"]}"),
                  Text(
                      "Category: ${task["category"]} | Priority: ${task["priority"]}"),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteTask(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

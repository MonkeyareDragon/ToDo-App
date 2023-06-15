import 'package:flutter/material.dart';
import 'package:frontend/Constants/api.dart';
import 'package:frontend/Models/todo.dart';
import 'package:frontend/Widgets/to_do_container.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'dart:convert';

import '../Widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  int done = 0;
  List<Todo> myTodos = [];
  bool isloading = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void _showModel() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Add Your To//Do",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                  controller: titleController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  controller: descController,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => _postData(
                      title: titleController.text, desc: descController.text),
                  child: const Text("Add"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _postData({String title = '', String desc = ''}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(api),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'desc': desc,
          'isDone': false,
        }),
      );
      if (response.statusCode == 201) {
        setState(() {
          myTodos = [];
        });
        fetchdata();
      } else {
        print("Error is created while posting!");
      }
    } catch (e) {
      print("Error is $e");
    }
  }

  void fetchdata() async {
    try {
      http.Response response = await http.get(Uri.parse(api));
      var data = json.decode(response.body);
      data.forEach((todo) {
        Todo a1 = Todo(
          id: todo['id'],
          title: todo['title'],
          desc: todo['desc'],
          isDone: todo['isDone'],
          date: todo['date'],
        );
        if (todo['isDone']) {
          done += 1;
        }
        myTodos.add(a1);
      });
      print(myTodos.length);
      setState(() {
        isloading = false;
      });
    } catch (e) {
      print("Error is $e");
    }
  }

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  void deleteTodo(String id) async {
    try {
      http.Response response = await http.delete(Uri.parse(api + '/' + id));
      setState(() {
        myTodos = [];
      });
      fetchdata();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: customAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            PieChart(
              dataMap: {
                "Done": done.toDouble(),
                "Incomplete": (myTodos.length - done).toDouble()
              },
            ),
            isloading
                ? const CircularProgressIndicator()
                : Column(
                    children: myTodos.map(
                      (e) {
                        return TodoContainer(
                          onPress: () => deleteTodo(e.id.toString()),
                          id: e.id,
                          title: e.title,
                          desc: e.desc,
                          isDone: e.isDone,
                        );
                      },
                    ).toList(),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModel();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
  int done = 0;
  List<Todo> myTodos = [];
  bool isloading = true;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: customAppBar(),
        body: Column(
          children: [
            PieChart(
              dataMap: {
                "Done": done.toDouble(),
                "Incomplete": (myTodos.length - done).toDouble()
              },
            ),
            isloading
                ? const CircularProgressIndicator()
                : ListView(
                    children: myTodos.map(
                      (e) {
                        return TodoContainer(
                          id: e.id,
                          title: e.title,
                          desc: e.desc,
                          isDone: e.isDone,
                        );
                      },
                    ).toList(),
                  ),
          ],
        ));
  }
}

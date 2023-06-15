import 'package:flutter/material.dart';
import 'package:frontend/Constants/api.dart';
import 'package:frontend/Models/todo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> myTodos = [];
  void fetchdata() async {
    try{
      http.Response response = await http.get(Uri.parse(api));
      var data = json.decode(response.body);
      data.forEach((todo){
        Todo a1 = Todo(
          id: todo['id'], 
          title: todo['title'], 
          desc: todo['desc'], 
          isDone: todo['isDone'], 
          date: todo['date'],
          );
        myTodos.add(a1);
      });
      print(myTodos.length);
    }
    catch(e){
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
      appBar: AppBar(),
    );
  }
}

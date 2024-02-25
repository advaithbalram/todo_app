import 'package:app/Constants/colors.dart';
import 'package:app/Models/todo.dart';
import 'package:app/Widgets/todo_container.dart';
import 'package:flutter/material.dart';
import 'package:app/Constants/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/Widgets/app_bar.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int done = 0;
  List<Todo> myTodos = [];
  bool isLoading = true;

  void _showModel() {
    String title = "";
    String description = "";
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Add your Todo",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () =>
                      _postData(title: title, description: description),
                  child: Text("Add"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchData() async {
    try {
      //final response = await http.get(Uri.parse(api));
      http.Response response = await http.get(Uri.parse(api));
      print(response.body);
      var data = json.decode(response.body);
      data.forEach((todo) {
        Todo t = Todo(
            id: todo['id'] ?? 0,
            title: todo['title'] ?? '',
            description: todo['description'] ?? '',
            isDone: todo['isDone']);
        if (todo['isDone']) {
          done += 1;
        }
        myTodos.add(t);
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error is $e");
    }
  }

  void _postData({String title = "", String description = ""}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(api),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'description': description,
          'isDone': false,
        }),
      );
      if (response.statusCode == 201) {
        setState(() {
          myTodos = [];
        });
        fetchData();
      } else {
        print("Something went wrong");
      }
    } catch (e) {
      print("Error is $e");
    }
  }

  void delete_todo(String id) async {
    try {
      await http.delete(Uri.parse(api + id + '/'));
      setState(() {
        myTodos = [];
      });
      fetchData();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
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
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: myTodos.map((e) {
                      return TodoContainer(
                        id: e.id,
                        onPress: () => delete_todo(e.id.toString()),
                        title: e.title,
                        description: e.description,
                        isDone: e.isDone,
                      );
                    }).toList(),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModel();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

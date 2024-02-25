// import 'package:app/Constants/colors.dart';
// import 'package:app/Models/todo.dart';
// import 'package:app/Widgets/todo_container.dart';
// import 'package:flutter/material.dart';
// import 'package:app/Constants/api.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:app/Widgets/app_bar.dart';
// import 'package:pie_chart/pie_chart.dart';

// class HelperFunction {
//   void fetchData() async {
//     try {
//       //final response = await http.get(Uri.parse(api));
//       http.Response response = await http.get(Uri.parse(api));
//       print(response.body);
//       var data = json.decode(response.body);
//       data.forEach((todo) {
//         Todo t = Todo(
//             id: todo['id'] ?? 0,
//             title: todo['title'] ?? '',
//             description: todo['description'] ?? '',
//             isDone: todo['isDone']);
//         if (todo['isDone']) {
//           done += 1;
//         }
//         myTodos.add(t);
//       });
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error is $e");
//     }
//   }

//   void _postData({String title = "", String description = ""}) async {
//     try {
//       http.Response response = await http.post(
//         Uri.parse(api),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           'title': title,
//           'description': description,
//           'isDone': false,
//         }),
//       );
//       if (response.statusCode == 201) {
//         setState(() {
//           myTodos = [];
//         });
//         fetchData();
//       } else {
//         print("Something went wrong");
//       }
//     } catch (e) {
//       print("Error is $e");
//     }
//   }

//   void delete_todo(String id) async {
//     try {
//       await http.delete(Uri.parse(api + id + '/'));
//       setState(() {
//         myTodos = [];
//       });
//       fetchData();
//     } catch (e) {
//       print(e);
//     }
//   }
// }

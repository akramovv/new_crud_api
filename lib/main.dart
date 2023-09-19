import 'package:flutter/material.dart';
import 'package:new_crud_api/screens/to_do_list.dart';
import 'package:new_crud_api/services/database_helper.dart';
import 'package:new_crud_api/services/todo_services.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var dbHelper = DBHelper();
    var service = TodoService();
    InternetConnectivity()
        .observeInternetConnection
        .listen((bool hasInternetAccess) async {
      if (hasInternetAccess) {
        print('Online');
        var list = await dbHelper.getDataList();
        var filteredList =
            list.where((element) => element.isSynced == false).toList();
        await Future.forEach(filteredList, (element) async {
          if (element.isDeleted == true) {
            await service.deleteById(element.id!);
          } else if (element.id == null) {
            await service.addTodo(element);
          } else {
            await service.updateData(element.id!, element);
          }
        });
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,
        primaryColor: Colors.black12,),
      home: const TodoListPage(),
    );
  }
}

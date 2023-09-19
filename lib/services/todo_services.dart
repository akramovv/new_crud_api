import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_crud_api/model/task_model.dart';
import 'package:new_crud_api/services/database_helper.dart';

DBHelper dbHelper = DBHelper();

class TodoService {
  Future<bool> deleteById(String id) async {
    try {
      final url = 'https://api.nstack.in/v1/todos/$id';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);
      return response.statusCode == 200;
    } catch (e) {
      var list = await dbHelper.getDataList();
      var item = list.firstWhere((element) => element.id == id);
      if(item.isDeleted==false){
        item.isDeleted = true;
        item.isSynced = false;
        dbHelper.update(item);
        return true;
      }else {
        return false;
      }
    }
  }

  Future<List<TodoModel>> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      var list = result.map((e) => TodoModel.fromMap(e)).toList();
      return dbHelper.insertAll(list);
    } catch (e) {
      return dbHelper.getDataList();
    }
  }

  Future<bool> updateData(String id, TodoModel model) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    try {
      final response = await http.put(
        uri,
        body: jsonEncode(model.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      if (model.isSynced == true) {
        dbHelper.update(TodoModel(
          id: id,
          dbId: model.dbId,
          title: model.title,
          description: model.description,
          isSynced: false,
        ));
      }
    }
    return true;
  }

  Future<bool> addTodo(TodoModel model) async {
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    try {
      final response = await http.post(
        uri,
        body: jsonEncode(model.toMap()),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 201;
    } catch (e) {
      if (model.isSynced == true) {
        dbHelper.insert(TodoModel(
          id: '',
          title: model.title,
          description: model.description,
          isSynced: false,
        ));
      }
    }
    return true;
  }
}

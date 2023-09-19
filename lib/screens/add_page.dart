import 'package:flutter/material.dart';
import 'package:new_crud_api/model/task_model.dart';
import 'package:new_crud_api/services/todo_services.dart';

import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final TodoModel? todo;

  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TodoService service = TodoService();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo.title;
      final description = todo.description;
      titleController.text = title!;
      descController.text = description!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Text'),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(isEdit ? 'Update' : 'Submit'),
              )),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not  call updated without todo sata');
      return;
    }
    final id = todo.id;
    final isSuccess = await service.updateData(id!, body);
    if (isSuccess) {
      showSuccessMessage(context, message: 'Updation Success');
    } else {
      showErrorMessage(context, message: 'Updation failed');
    }
  }

  Future<void> submitData() async {
    //Submit data to the server

    final isSuccess = await service.addTodo(body);

    if (isSuccess) {
      titleController.text = '';
      descController.text = '';
      showSuccessMessage(
        context,
        message: 'Creation Success',
      );
    } else {
      showErrorMessage(context, message: 'Creation failed');
    }
  }

  TodoModel get body {
    final title = titleController.text;
    final description = descController.text;
    return TodoModel(id:  widget.todo?.id,title: title,dbId: widget.todo?.dbId, description: description, isSynced: true,);
  }
}

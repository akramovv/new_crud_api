import 'package:flutter/material.dart';
import 'package:new_crud_api/screens/add_page.dart';
import 'package:new_crud_api/services/todo_services.dart';
import 'package:new_crud_api/widget/todo_card.dart';

import '../model/task_model.dart';
import '../utils/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  final TodoService service = TodoService();
  List<TodoModel> items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Stack(
              children: [
                Center(
                  child: Text('No Todo item',
                      style: Theme.of(context).textTheme.displayMedium),
                ),
                ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: items.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return TodoCard(
                        index: index,
                        item: item,
                        deleteById: deleteById,
                        navigateEdit: navigateToEditPage,
                      );
                    })
              ],
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return TodoCard(
                    index: index,
                    item: item,
                    deleteById: deleteById,
                    navigateEdit: navigateToEditPage,
                  );
                }),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateToAddPage();
          },
          label: const Text('Add Todo')),
    );
  }

  Future<void> navigateToEditPage(TodoModel item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddTodoPage(
              todo: item,
            ));
    await Navigator.push(context, route);
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await service.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element.id != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: 'Deletion failed');
    }
  }

  Future<void> fetchTodo() async {
    final response = await service.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}

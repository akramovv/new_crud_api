import 'package:flutter/material.dart';
import 'package:new_crud_api/model/task_model.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final TodoModel item;
  final Function(TodoModel)navigateEdit;
  final Function(String)deleteById;
  const TodoCard({super.key, required this.index, required this.item, required this.navigateEdit, required this.deleteById});

  @override
  Widget build(BuildContext context) {
    final id=item.id;
    return Card(
      child: ListTile(
        leading: Text('${index + 1}'),
        title: Text("${item.title}"),
        subtitle: Text("${item.description}"),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              navigateEdit(item);
            } else if (value == 'delete') {
              deleteById(id!);
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ];
          },
        ),
      ),
    );
  }
}

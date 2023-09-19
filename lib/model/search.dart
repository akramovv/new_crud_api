import 'package:flutter/material.dart';
import 'package:new_crud_api/model/task_model.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => Center(
   child: Text(query),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<TodoModel> items = [];
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        return ListTile(
          title: Text((item) as String),
          onTap: () {
            query = (item) as String;
            showResults(context);
          },
        );
      },
    );
  }
}

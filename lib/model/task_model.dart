
class TodoModel {
  final String? id;
  final int? dbId;
  final String? title;
  final String? description;
  final bool? isSynced;

  TodoModel({
    this.id,
    this.dbId,
    this.title,
    this.description,
    this.isSynced,
  });

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res['_id'],
        dbId = null,
        title = res['title'],
        isSynced = true,
        description = res['description'];

  TodoModel.fromDbMap(Map<String, dynamic> res)
      : id = res['todoID'],
        dbId = res['id'],
        title = res['title'],
        isSynced = res['isSynced'] == 1,
        description = res['description'];

  Map<String, Object?> toMap() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "isSynced": isSynced,
    };
  }

  Map<String, Object?> toDbMap() {
    return {
      "todoId": id,
      "title": title,
      "description": description,
      "isSynced": isSynced,
    };
  }
}

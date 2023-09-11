class TodoModel {
  final String? id;
  final int? dbId;
  final String? title;
  final String? description;
  bool? isSynced;
  bool? isDeleted;

  TodoModel(
      {this.id,
      this.dbId,
      this.title,
      this.description,
      this.isSynced,
      this.isDeleted});

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res['_id'],
        dbId = null,
        title = res['title'],
        isSynced = true,
        description = res['description'],
        isDeleted = false;

  TodoModel.fromDbMap(Map<String, dynamic> res)
      : id = res['todoID'],
        dbId = res['id'],
        title = res['title'],
        isSynced = res['isSynced'] == 1,
        description = res['description'],
        isDeleted = res['isDeleted'] != 0;

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
      "isDeleted": isDeleted,
    };
  }
}

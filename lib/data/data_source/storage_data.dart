import 'package:krainet/domain/task.dart';

abstract class StorageData {
  const StorageData();

  Future<List<Task>> getTasks(String id);

  Future<void> saveTask(Task task);

  Future<void> deleteTask(Task task);
}

class TaskNotFoundException implements Exception {}

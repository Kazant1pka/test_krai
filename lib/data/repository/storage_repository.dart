import 'package:krainet/data/data_source/storage_data.dart';
import 'package:krainet/domain/task.dart';

class StorageRepository {
  const StorageRepository({
    required StorageData storageData,
  }) : _storageData = storageData;

  final StorageData _storageData;

  Future<List<Task>> getTasks(String uid) => _storageData.getTasks(uid);

  Future<void> saveTask(Task task) => _storageData.saveTask(task);

  Future<void> deleteTask(Task task) => _storageData.deleteTask(task);
}

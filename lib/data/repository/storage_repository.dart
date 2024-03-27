import 'package:krainet/data/data_source/storage_data.dart';
import 'package:krainet/domain/task.dart';

//Репозиторий для связи слоя данных и слоя отображения
class StorageRepository {
  const StorageRepository({
    required StorageData storageData,
  }) : _storageData = storageData;

  final StorageData _storageData;
  //Получение задач из базы данных
  Future<List<Task>> getTasks(String uid) => _storageData.getTasks(uid);
  //Сохранение задачи в базу данных
  Future<void> saveTask(Task task) => _storageData.saveTask(task);
  //Удаление задачи из базы данных по её id
  Future<void> deleteTask(Task task) => _storageData.deleteTask(task);
}

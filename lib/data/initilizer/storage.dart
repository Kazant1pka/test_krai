import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:krainet/data/data_source/storage_data.dart';
import 'package:krainet/domain/task.dart';

class Storage extends StorageData {
  Storage({required FirebaseFirestore plugin}) : _db = plugin {
    _init();
  }

  FirebaseFirestore _db;

  void _init() {
    _db = FirebaseFirestore.instance;
  }

  @override
  Future<List<Task>> getTasks(String id) async {
    var tasks = <Task>[];
    await _db.collection(id).get().then(
      (querySnapshot) {
        tasks = querySnapshot.docs.map((e) => Task.fromJson(e.data())).toList();
      },
      onError: (e) => '',
    );
    return tasks;
  }

  @override
  Future<void> saveTask(Task task) async {
    await _db.collection(task.userId).doc(task.id).set(task.toJson());
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _db.collection(task.userId).doc(task.id).delete();
  }
}

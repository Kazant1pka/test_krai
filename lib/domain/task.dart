import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

//Класс задач
class Task extends Equatable {
  Task({
    required this.title,
    required this.userId,
    String? id,
    this.description = '',
    this.isCompleted = false,
    DateTime? endsTask,
  })  : endsTask = endsTask ?? DateTime.now(),
        assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        id = id ?? const Uuid().v4();
  //Метод получения задачи из базы
  factory Task.fromJson(JsonMap json) => Task(
        title: json['title'] as String,
        id: json['id'] as String?,
        userId: json['userId'] as String,
        description: json['description'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
        endsTask: (json['endsTask'] as Timestamp).toDate(),
      );

  final String id;
  final String userId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime endsTask;
  //Метод получения объекта задачи без инициализации всех его полей
  Task copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? endsTask,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      endsTask: endsTask ?? this.endsTask,
    );
  }

  //Метод конвертации задачи для сохранения её в базе данных
  Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
        'id': instance.id,
        'userId': instance.userId,
        'title': instance.title,
        'description': instance.description,
        'isCompleted': instance.isCompleted,
        'endsTask': instance.endsTask,
      };

  JsonMap toJson() => _$TaskToJson(this);

  @override
  List<Object> get props =>
      [id, userId, title, description, isCompleted, endsTask];
}

typedef JsonMap = Map<String, dynamic>;

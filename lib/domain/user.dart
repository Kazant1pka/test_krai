import 'package:equatable/equatable.dart';

//Класс пользователя, с методовами, которые отвечают за его существование

class User extends Equatable {
  const User({
    this.id,
    this.email,
    this.name,
  });

  final String? email;
  final String? id;
  final String? name;

  static const empty = User();

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name];
}

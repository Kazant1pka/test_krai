import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

//Сущность для ввода пароля и его валидация
class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    return value!.length >= 8 ? null : PasswordValidationError.invalid;
  }
}

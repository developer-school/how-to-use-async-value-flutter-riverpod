import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required int id,
    required String title,
  }) = _Todo;

  const Todo._();

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {

  const TodoModel(
      this.title,
      this.description,
      this.isAlarmRequired,
      this.selectedDate,
      this.selectedTime,
      this.isComplete,
      this.createdAt
  );

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final bool isAlarmRequired;

  @HiveField(3)
  final DateTime selectedDate;

  @HiveField(4)
  final int selectedTime;

  @HiveField(5)
  final bool isComplete;

  @HiveField(6)
  final String createdAt;
}
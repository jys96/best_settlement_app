import 'expense.dart';

class ScheduleModel {
  final String title;
  final int totalSpent;
  final List<String> participants;
  final List<ExpenseModel> expenses;

  ScheduleModel({
    required this.title,
    required this.totalSpent,
    required this.participants,
    required this.expenses,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {

    return ScheduleModel(
      title: json['scheduleInfo']['title'],
      totalSpent: json['scheduleInfo']['totalSpent'],
      participants: List<String>.from(json['participants']),
      expenses: (json['expenses'] as List)
          .map((e) => ExpenseModel.fromJson(e))
          .toList(),
    );
  }
}

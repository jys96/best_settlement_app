import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'schedule.g.dart';

@HiveType(typeId: 0)
class ScheduleModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int totalExpense;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final List<String> participants;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.totalExpense,
    required this.date,
    required this.participants,
  });

  @override
  String toString() {
    return 'schedule(id: $id, title: $title, totalSpent: $totalExpense, date: $date, participants: $participants)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'totalExpense': totalExpense,
      'date': date,
      'participants': participants,
    };
  }

  /// JSON 데이터를 ExpenseModel 객체로 매핑
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final uuid = Uuid();

    return ScheduleModel(
      id: uuid.v4(),
      title: json['scheduleInfo']['title'],
      totalExpense: json['scheduleInfo']['totalSpent'],
      date: json['scheduleInfo']['date'] ?? '-',
      participants: List<String>.from(json['participants']),
    );
  }
}

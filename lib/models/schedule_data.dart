import 'dart:convert';

/// 여행 정보 모델
class ScheduleInfo {
  final String title;
  final int totalSpent;

  ScheduleInfo({required this.title, required this.totalSpent});

  // JSON 데이터를 ScheduleInfo 객체로 매핑
  factory ScheduleInfo.fromJson(Map<String, dynamic> json) {
    return ScheduleInfo(
      title: json['title'],
      totalSpent: json['totalSpent'],
    );
  }
}

/// 지출 항목 모델
class Expense {
  final String category;
  final int amount;
  final List<String> paidBy;
  final List<String>? excluded;
  final List<String>? included;
  final int order;

  Expense({
    required this.category,
    required this.amount,
    required this.paidBy,
    this.excluded,
    this.included,
    required this.order,
  });

  // JSON 데이터를 Expense 객체로 매핑
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      category: json['category'],
      amount: json['amount'],
      paidBy: List<String>.from(json['paidBy']),
      excluded: json['excluded'] != null ? List<String>.from(json['excluded']) : null,
      included: json['included'] != null ? List<String>.from(json['included']) : null,
      order: json['order'],
    );
  }
}

/// 전체 여행 데이터 모델
class ScheduleData {
  final ScheduleInfo scheduleInfo;
  final List<String> participants;
  final List<Expense> expenses;

  ScheduleData({required this.scheduleInfo, required this.participants, required this.expenses});

  // JSON 데이터를 ScheduleData 객체로 매핑
  factory ScheduleData.fromJson(Map<String, dynamic> json) {

    return ScheduleData(
      scheduleInfo: ScheduleInfo.fromJson(json['scheduleInfo']),
      participants: List<String>.from(json['participants']),
      expenses: (json['expenses'] as List).map((e) => Expense.fromJson(e)).toList(),
    );
  }
}
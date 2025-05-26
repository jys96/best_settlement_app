import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 1)
class ExpenseModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final int amount;

  @HiveField(2)
  final List<String> paidBy;

  @HiveField(3)
  final List<String> included;

  @HiveField(4)
  final int order;

  @HiveField(5)
  final String scheduleId;

  @HiveField(6)
  final String id;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.included,
    required this.order,
    required this.scheduleId,
  });

  @override
  String toString() {
    return 'expense(id: $id, title: $title, amount: $amount, paidBy: $paidBy, included: $included, order: $order, scheduleId: $scheduleId)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'paidBy': paidBy,
      'included': included,
      'order': order,
      'scheduleId': scheduleId,
    };
  }

  /// JSON 데이터를 ExpenseModel 객체로 매핑
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'] ?? json['category'],
      amount: json['amount'],
      paidBy: List<String>.from(json['paidBy']),
      included: List<String>.from(json['included']),
      order: json['order'],
      scheduleId: json['scheduleId']
    );
  }
}

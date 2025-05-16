class ExpenseModel {
  final String category;
  final int amount;
  final List<String> paidBy;
  final List<String> included;
  final int order;

  ExpenseModel({
    required this.category,
    required this.amount,
    required this.paidBy,
    required this.included,
    required this.order,
  });

  @override
  String toString() {
    return 'expense(category: $category, amount: $amount, paidBy: $paidBy, included: $included, order: $order)';
  }

  /// JSON 데이터를 ExpenseModel 객체로 매핑
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      category: json['category'],
      amount: json['amount'],
      paidBy: List<String>.from(json['paidBy']),
      included: List<String>.from(json['included']),
      order: json['order'],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/expense.dart';

class ExpenseViewModel extends ChangeNotifier {
  static const String boxName = 'expenses';

  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> get expenses => _expenses;

  final _box = Hive.box<ExpenseModel>(boxName);
  late Box<ExpenseModel> _expenseBox;

  // 데이터 로드
  void loadExpenses() {
    _expenses = _box.values.toList();
    notifyListeners();
  }

  // Hive 박스 오픈
  Future<void> openBox() async {
    await Hive.openBox<ExpenseModel>(boxName);
    loadExpenses();
  }

  // 모델 타입으로 변환 후 데이터 추가
  Future<void> transAddExpense(expense) async {
    final transExpense = ExpenseModel.fromJson(expense);
    addExpense(transExpense);
  }

  // 데이터 추가
  Future<void> addExpense(ExpenseModel expense) async {
    await _box.add(expense);
    loadExpenses();
  }

  // 데이터 삭제
  Future<void> deleteExpenseById(String scheduleId, String expenseId) async {
    final keyToDelete = _box.keys.firstWhere(
      (key) => _box.get(key)?.id == expenseId,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await _box.delete(keyToDelete);
      await reorderExpensesAfterDeletion(scheduleId);
      loadExpenses();
    }
  }

  // 모든 expense를 order 순서대로 다시 재정렬하는 로직
  Future<void> reorderExpensesAfterDeletion(String scheduleId) async {
    // List<ExpenseModel> expenses = _box.values.toList();
    final expenses = _box.values.where((e) => e.scheduleId == scheduleId).toList();
    expenses.sort((a, b) => a.order.compareTo(b.order));

    for (int i = 0; i < expenses.length; i++) {
      ExpenseModel expense = expenses[i];

      if (expense.order != i) {
        ExpenseModel updated = ExpenseModel(
          id: expense.id,
          title: expense.title,
          amount: expense.amount,
          paidBy: expense.paidBy,
          included: expense.included,
          order: i,
          scheduleId: expense.scheduleId,
        );

        final key = _box.keyAt(_box.values.toList().indexOf(expense));
        await _box.put(key, updated);
      }
    }
  }

  // 초기화 (모든 데이터 삭제)
  Future<void> clearExpenses() async {
    await _box.clear();
    loadExpenses();
  }

  // 특정 schedule의 expense 조회
  List<ExpenseModel> getExpensesBySchedule(String scheduleId) {
    return _box.values
                .where((e) => e.scheduleId == scheduleId)
                .toList();
  }
  // 전체 데이터 확인 (print 이용)
  @override
  String toString() {
    return 'ExpenseViewModel(expenses: $_expenses)';
  }

  void printExpenses() {
    loadExpenses();
    for (var expense in _expenses) {
      print(expense);
    }
  }

}

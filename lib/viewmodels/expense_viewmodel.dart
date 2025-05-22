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

  void printExpenses() {
    loadExpenses(); // 데이터 로드 후
    for (var expense in _expenses) {
      print(expense);
    }
  }

  // Hive 박스 오픈
  Future<void> openBox() async {
    await Hive.openBox<ExpenseModel>(boxName);
    loadExpenses();
  }

  // 데이터 추가
  Future<void> addExpense(ExpenseModel expense) async {
    await _box.add(expense);
    loadExpenses();
  }

  // 데이터 수정
  Future<void> updateExpense(int index, ExpenseModel expense) async {
    await _box.putAt(index, expense);
    loadExpenses();
  }

  // 데이터 삭제
  Future<void> deleteExpense(int index) async {
    await _box.deleteAt(index);
    loadExpenses();
  }

  // 초기화
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
}

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import '../models/schedule.dart';
import '../models/expense.dart';

import '../viewmodels/schedule_viewmodel.dart';
import '../viewmodels/expense_viewmodel.dart';

class JsonService {
  final ScheduleViewModel scheduleViewModel;
  final ExpenseViewModel expenseViewModel;

  JsonService({required this.scheduleViewModel, required this.expenseViewModel,});

  /// JSON 파일을 읽고 ScheduleModel 리스트로 변환
  Future<dynamic> loadSchedules(String filePath) async {
    try {
      final String response = await rootBundle.loadString(filePath);
      final data = json.decode(response);
      final List<dynamic> datas = data['datas'];
      // print('[json service] datas => ${datas}');;

      await scheduleViewModel.openBox();
      await expenseViewModel.openBox();

      final scheduleBox = scheduleViewModel.box;

      scheduleViewModel.loadSchedules();
      // print('[json service] scheduleBox => ${scheduleViewModel.schedules}');

      // schedule 데이터가 없는 경우 추가
      if (scheduleBox.isEmpty) {
        for (var e in datas) {
          await saveSchedules(e);
        }
      }

      return datas;
    } catch (e) {
      print('[json_service] => JSON 로딩 실패: $e');
      throw Exception("Failed to load schedule data");
    }
  }

  Future<void> saveSchedules(jsonData) async {
    final schedules = ScheduleModel.fromJson(jsonData);
    await scheduleViewModel.addSchedule(schedules);

    final scheduleId = schedules.id;
    print('[saveSchedules] scheduleId => ${scheduleId}');
    final List<dynamic> expensesJson = jsonData['expenses'] ?? [];
    // print('[saveSchedules] expensesJson => ${expensesJson}');
    for (var expenseJson in expensesJson) {
      expenseJson['scheduleId'] = scheduleId;
      await saveExpense(expenseJson);
    }
  }

  Future<void> saveExpense(expenseJson) async {
    final expense = ExpenseModel.fromJson(expenseJson);
    await expenseViewModel.addExpense(expense);
    print('[saveExpense] expense => $expense');
  }
}

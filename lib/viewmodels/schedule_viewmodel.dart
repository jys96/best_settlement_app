import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/schedule.dart';

class ScheduleViewModel extends ChangeNotifier {
  static const String boxName = 'schedules';

  List<ScheduleModel> _schedules = [];
  List<ScheduleModel> get schedules => _schedules;

  final _box = Hive.box<ScheduleModel>(boxName);
  Box<ScheduleModel> get box => _box;
  late Box<ScheduleModel> _scheduleBox;

  // 데이터 로드
  void loadSchedules() {
    _schedules = _box.values.toList();
    notifyListeners();
  }

  // Hive 박스 오픈
  Future<void> openBox() async {
    await Hive.openBox<ScheduleModel>(boxName);
    loadSchedules();
  }

  // 데이터 추가
  Future<void> addSchedule(ScheduleModel schedule) async {
    await _box.add(schedule);
    loadSchedules();
  }

  // 데이터 수정
  Future<void> updateSchedule(int key, ScheduleModel schedule) async {
    await _box.put(key, schedule);
    loadSchedules();
  }

  // 데이터 삭제
  Future<void> deleteSchedule(int key) async {
    await _box.delete(key);
    loadSchedules();
  }

  // 초기화
  Future<void> clearSchedule() async {
    await _box.clear();
    loadSchedules();
  }

  @override
  String toString() {
    return 'ScheduleViewModel(schedules: $_schedules)';
  }
}

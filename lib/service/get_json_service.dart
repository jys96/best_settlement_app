import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/schedule.dart';

class JsonService {
  /// JSON 파일을 읽고 ScheduleModel 리스트로 변환
  Future<List<ScheduleModel>> loadSchedules(String filePath) async {
    try {
      final String response = await rootBundle.loadString(filePath);
      final data = json.decode(response);

      // 최상위 "datas" 리스트를 순회하며 ScheduleModel로 변환
      final List<dynamic> datas = data['datas'];
      final schedules = datas.map((e) => ScheduleModel.fromJson(e)).toList();

      return schedules;
    } catch (e) {
      print('[get_json_service] JSON 로딩 실패: $e');
      throw Exception("Failed to load schedule data");
    }
  }
}

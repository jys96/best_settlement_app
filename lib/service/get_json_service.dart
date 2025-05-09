import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/schedule_data.dart';

class JsonService {
  /// JSON 파일을 읽어서 ScheduleData 모델로 변환하는 메서드
  Future<ScheduleData> loadScheduleData(String filePath) async {
    try {
      final String response = await rootBundle.loadString(filePath);
      final data = json.decode(response);

      return ScheduleData.fromJson(data);
    } catch (e) {
      print('JSON 로딩 실패: $e');
      throw Exception("Failed to load travel data");
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/schedule.dart';
import 'models/expense.dart';

import 'viewmodels/schedule_viewmodel.dart';
import 'viewmodels/expense_viewmodel.dart';

import 'views/list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // Hive 어댑터 등록
  Hive.registerAdapter(ScheduleModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());

  /// hive 데이터의 문제로 json데이터를 다시 저장해야하는 경우에만 주석 해제
  // 기존 데이터 삭제 (개발 중 임시 처리)
  // await Hive.deleteBoxFromDisk('schedules');
  // await Hive.deleteBoxFromDisk('expenses');

  // Box 열기
  await Hive.openBox<ScheduleModel>('schedules');
  await Hive.openBox<ExpenseModel>('expenses');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ScheduleViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseViewModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '정산 하자',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.cyan,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white
          )
      ),
      home: ListPage()
    );
  }
}

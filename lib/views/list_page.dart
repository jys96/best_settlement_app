import 'package:best_settlement_app/viewmodels/expense_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/format.dart';
import '../service/json_service.dart';

import '../viewmodels/schedule_viewmodel.dart';

import 'detail_page.dart';
import 'add_schedule_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  /// hive 데이터의 문제로 json데이터를 다시 저장해야하는 경우에만 주석 해제
  // final JsonService jsonService = JsonService(scheduleViewModel: ScheduleViewModel(), expenseViewModel: ExpenseViewModel());
  late ScheduleViewModel scheduleViewModel;

  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    scheduleViewModel = context.read<ScheduleViewModel>();
    scheduleViewModel.openBox(); // Hive 박스 오픈 및 초기 데이터 로드
  }

  @override
  Widget build(BuildContext context) {
    /// hive 데이터의 문제로 json데이터를 다시 저장해야하는 경우에만 주석 해제
    // jsonService.loadSchedules('assets/travel_expenses_updated.json');

    return Scaffold(
      appBar: AppBar(
        title: Text("일정 목록"),
      ),
      body: Consumer<ScheduleViewModel>(
        builder: (context, vm, child) {
          schedules = vm.schedules.map((e) => e.toJson()).toList();

          if (schedules.isEmpty) {
            return const Center(child: Text('저장된 일정이 없습니다.'));
          }

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final value = schedules[index];

              return Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(value['title']),
                  subtitle: Text('총 사용 금액: ${formatCurrency(value['totalExpense'])}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(value['date'] ?? '-')
                    ],
                  ),
                  onTap: () {
                    // 클릭 시 상세 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(schedule: vm.schedules[index]),
                      ),
                    );
                  },
                ),
              );
            },
              // Positioned(
              //   bottom: 20,
              //   right: 20,
              //   child: FloatingActionButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => AddSchedulePage()),
              //       );
              //     },
              //     child: Icon(Icons.format_list_bulleted_add, size: 36,),
              //   )
              // )
          );
        }
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../service/get_json_service.dart';
import '../service/format.dart';
import 'detail_page.dart';
import 'add_schedule_page.dart';

class ListPage extends StatelessWidget {
  final JsonService jsonService;
  const ListPage({Key? key, required this.jsonService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("여행 일정 목록"),
      ),
      body: FutureBuilder<List<ScheduleModel>>(
        future: jsonService.loadSchedules('assets/travel_expenses_updated.json'),
        builder: (context, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (data.hasError) {
            return Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
          } else if (!data.hasData) {
            return Center(child: Text('데이터가 없습니다.'));
          } else {
            final datas = data.data!;
            return Stack(
              children: [
                ListView.builder(
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    final value = datas[index];
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(value.title),
                        subtitle: Text('총 사용 금액: ${formatCurrency(value.totalSpent)}'),
                        onTap: () {
                          // 클릭 시 상세 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(datas: value),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddSchedulePage()),
                      );
                    },
                    child: Icon(Icons.format_list_bulleted_add, size: 36,),
                  )
                )
              ]
            );
          }
        },
      ),
    );
  }
}
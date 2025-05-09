import 'package:flutter/material.dart';
import '../service/get_json_service.dart';
import '../models/schedule_data.dart';

class ListPage extends StatelessWidget {
  final JsonService jsonService;
  const ListPage({Key? key, required this.jsonService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('일정 목록')),
      body: FutureBuilder(
        future: jsonService.loadScheduleData('assets/travel_expenses_updated.json'),
        builder: (context, value) {
          if (value.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (value.hasError) {
            return Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
          } else if (!value.hasData) {
            return Center(child: Text('데이터가 없습니다.'));
          } else {
            final datas = value.data!;

            return ListView.separated(
              itemCount: 1, // 임시
              itemBuilder: (context, index) {
                final info = datas.scheduleInfo;

                return ListTile(
                  // leading: CircleAvatar(radius: 25, backgroundColor: Colors.purple),
                  title: Text(info.title),
                  subtitle: Text('${info.totalSpent}'),
                  onTap: () {
                    final data = datas.expenses;
                    print('on TAP!! ${data}');
                    // Navigator.pushNamed(context, '/Detail/$index'); // 상세 페이지로 이동
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
          }
        }
      ),
    );
  }
}
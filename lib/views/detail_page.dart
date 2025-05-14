import 'package:best_settlement_app/models/schedule.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final ScheduleModel datas;
  const DetailPage({Key? key, required this.datas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(datas.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "총 사용 금액: ₩${datas.totalSpent}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "참여자: ${datas.participants.join(', ')}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: datas.expenses.length,
              itemBuilder: (context, index) {
                final expense = datas.expenses[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(expense.category),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('금액: ₩${expense.amount}'),
                        Text('지불자: ${expense.paidBy.join(', ')}'),
                        Text('포함된 사람: ${expense.included.join(', ')}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

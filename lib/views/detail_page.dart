import 'package:flutter/material.dart';
import '../models/schedule.dart';
import 'add_expense_page.dart';
import 'settlement_page.dart';

class DetailPage extends StatefulWidget {
  final ScheduleModel datas;
  const DetailPage({Key? key, required this.datas}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, dynamic>> expenses = [];

  @override
  void initState() {
    super.initState();
    expenses = widget.datas.expenses.map((e) => {
      "category": e.category,
      "amount": e.amount,
      "paidBy": e.paidBy,
      "included": e.included,
      "order": e.order,
    }).toList();
  }

  void _addExpense(Map<String, dynamic> expense) {
    setState(() {
      expenses.add(Map<String, Object>.from(expense));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.datas.title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettlementPage(schedule: widget.datas),
                ),
              );
            },
            child: Text(
              "정산 결과 보기",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 16, 0, 20),
            child: Column(
              children: [
                Text(
                  "총 사용 금액: ₩${widget.datas.totalSpent}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "참여자: ${widget.datas.participants.join(', ')}",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(expense['category']),
                    subtitle: Text('금액: ₩${expense['amount']}'),
                    // trailing: Text('참여: ${expense['included'].join(", ")}'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('지불자: ${expense['paidBy'].join(", ")}'),
                        Text('참여: ${expense['included'].join(", ")}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => FractionallySizedBox(
              heightFactor: 0.9,
              child:  AddExpensePage(
                participants: widget.datas.participants,
                onAddExpense: _addExpense,
              )
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

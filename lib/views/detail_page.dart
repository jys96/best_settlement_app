import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/schedule.dart';

import '../service/format.dart';
import '../service/toast.dart';

import '../viewmodels/expense_viewmodel.dart';

import 'add_expense_page.dart';
import 'settlement_page.dart';

class DetailPage extends StatefulWidget {
  final ScheduleModel schedule;
  const DetailPage({Key? key, required this.schedule}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ExpenseViewModel expenseViewModel;

  List<Map<String, dynamic>> expenses = [];

  /// 지출 항목 추가 이벤트
  void _addExpense(Map<String, dynamic> expense) {
    final lastOrder = expenses.isNotEmpty ? expenses.last['order'] : 0;

    expense['order'] = lastOrder + 1;
    expense['scheduleId'] = widget.schedule.id;

    setState(() {
      expenses.add(Map<String, Object>.from(expense));
      expenseViewModel.transAddExpense(expense);
      ToastUtil.show('항목이 추가되었습니다.');
    });
  }

  @override
  void initState() {
    super.initState();
    expenseViewModel = context.read<ExpenseViewModel>();
    expenseViewModel.openBox(); // Hive 박스 오픈 및 초기 데이터 로드
  }

  @override
  Widget build(BuildContext context) {
    final scheduleId = widget.schedule.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schedule.title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettlementPage(datas: widget.schedule),
                ),
              );
            },
            child: Text(
              "정산 결과 보기",
              style: TextStyle(color: Colors.purple),
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
                  "총 사용 금액: ${formatCurrency(widget.schedule.totalExpense)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "참여자: ${widget.schedule.participants.join(', ')}",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 10),
          Consumer<ExpenseViewModel>(
            builder: (context, vm, child) {
              // 지출 항목을 추가할 수 있으므로 전역 변수에 지출내역 저장
              expenses = vm.getExpensesBySchedule(scheduleId).map((e) => e.toJson()).toList();

              if (expenses.isEmpty) {
                return const Center(child: Text('저장된 지출 항목이 없습니다.'));
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final expenseId = expense['id'];

                    return Dismissible(
                      key: ValueKey(expenseId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          expenseViewModel.deleteExpenseById(scheduleId, expenseId);
                        });
                      },
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ListTile(
                          title: Text(expense['title']),
                          subtitle: Text('금액: ${formatCurrency(expense['amount'])}'),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('결제: ${expense['paidBy'].join(", ")}'),
                              Text('참여: ${expense['included'].join(", ")}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => FractionallySizedBox(
              heightFactor: 0.9,
              child: AddExpensePage(
                participants: widget.schedule.participants,
                onAddExpense: _addExpense,
              )
            ),
          );
        },
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}

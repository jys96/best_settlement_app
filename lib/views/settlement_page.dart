import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../service/settlement_calculator_service.dart';

class SettlementPage extends StatelessWidget {
  final ScheduleModel schedule;

  const SettlementPage({Key? key, required this.schedule}) : super(key: key);

  /// 각 참여자의 정산 금액 계산
  Map<String, int> calculateBalances() {
    Map<String, int> balances = {for (var p in schedule.participants) p: 0};

    for (var expense in schedule.expenses) {
      int splitAmount = (expense.amount / expense.included.length).round();

      // 금액 지불자 빼기
      for (var payer in expense.paidBy) {
        balances[payer] = (balances[payer] ?? 0) + expense.amount;
      }

      // 각 포함된 사람에게 금액 나누기
      for (var included in expense.included) {
        balances[included] = (balances[included] ?? 0) - splitAmount;
      }
    }
    return balances;
  }

  @override
  Widget build(BuildContext context) {
    final balances = calculateBalances();
    final settlements = calculateSettlement(balances);

    return Scaffold(
      appBar: AppBar(
        title: Text("정산 결과"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "정산 결과",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: settlements.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.arrow_forward),
                    title: Text(settlements[index]),
                  );
                },
              ),
            ),
            if (settlements.isEmpty)
              Center(
                child: Text("정산할 금액이 없습니다."),
              ),
          ],
        ),
      ),
    );
  }
}

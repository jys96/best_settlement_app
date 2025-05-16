import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/schedule.dart';
import '../service/settlement_calculator_service.dart';

class SettlementPage extends StatelessWidget {
  final ScheduleModel datas;
  const SettlementPage({Key? key, required this.datas}) : super(key: key);

  /// 각 참여자의 정산 금액 계산
  Map<String, int> calculateBalances() {
    Map<String, int> balances = {for (var p in datas.participants) p: 0};
    for (var expense in datas.expenses) {
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

  testfunc() {
    final balance = {for (var p in datas.participants) p: 0.0};
    print(datas.expenses.toString());
    // 1. 각 항목마다 개인별 부담 계산
    for (var expense in datas.expenses) {
    // print(expense.toString());
      final share = expense.amount / expense.included.length;
      for (var user in expense.included) {
        balance[user] = balance[user]! - share;
      }
      // balance[expense.payer] = balance[expense.payer]! + expense.amount;
      for (var payer in expense.paidBy) {
        balance[payer] = (balance[payer] ?? 0) + expense.amount;
      }
    }

    print('test 1 => ${balance}');

    // 2. 정산 로직
    final payers = <Map<String, dynamic>>[];
    final receivers = <Map<String, dynamic>>[];

    balance.forEach((person, amount) {
      if (amount < 0) {
        payers.add({"person": person, "amount": -amount});
      } else if (amount > 0) {
        receivers.add({"person": person, "amount": amount});
      }
    });

    print('test 2 => ${payers}');
    print('test 2 => ${receivers}');

    // 3. 최소 거래 매칭
    final transactions = <String>[];
    for (var payer in payers) {
      while (payer["amount"] > 0) {
        final receiver = receivers.firstWhere((r) => r["amount"] > 0);
        final transfer = (payer["amount"] < receiver["amount"]) ? payer["amount"] : receiver["amount"];

        transactions.add("${payer["person"]} -> ${receiver["person"]} : ${transfer.toStringAsFixed(0)}원");

        payer["amount"] -= transfer;
        receiver["amount"] -= transfer;
      }
    }

    print('test 3 => ${transactions}');

    // 4. 결과 출력
    transactions.forEach(print);
  }

  @override
  Widget build(BuildContext context) {
    final balances = calculateBalances();
    final settlements = calculateSettlement(balances);
    testfunc();

    return Scaffold(
      appBar: AppBar(
        title: Text("정산 결과"),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              final StringBuffer buffer = StringBuffer();
              buffer.writeln('여행 정산 결과 (${datas.title})');
              buffer.writeln('---------------------------------');
              buffer.writeln(settlementTexts.join("\n"));
              buffer.writeln('---------------------------------');

              SharePlus.instance.share(  // 공유 기능 호출
                ShareParams(text: buffer.toString())
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: settlements.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: settlements[index],
                  );
                },
              ),
            ),
            if (settlements.isEmpty)
              Center(
                child: Text("정산할 금액이 없습니다."),
              ),

              /// 정산 완료 버튼(임시 비활성화)
              // SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (context) {
              //         return AlertDialog(
              //           title: Text('정산 완료'),
              //           content: Text('정산을 완료 처리하시겠습니까?'),
              //           actions: [
              //             TextButton(
              //               onPressed: () => Navigator.pop(context),
              //               child: Text('취소'),
              //             ),
              //             TextButton(
              //               onPressed: () {
              //                 Navigator.pop(context);
              //                 ScaffoldMessenger.of(context).showSnackBar(
              //                   SnackBar(
              //                     content: Text('정산이 완료되었습니다.'),
              //                   ),
              //                 );
              //               },
              //               child: Text('확인'),
              //             ),
              //           ],
              //         );
              //       },
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: Size(double.infinity, 50),
              //   ),
              //   child: Text('정산 완료'),
              // )
          ],
        ),
      ),
    );
  }
}

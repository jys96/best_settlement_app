import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/schedule.dart';
import 'dart:math';
import '../service/format.dart';

List<String> settlementTexts = [];  // 공유용 텍스트는 외부에서 따로 관리

class SettlementPage extends StatelessWidget {
  final ScheduleModel datas;
  const SettlementPage({Key? key, required this.datas}) : super(key: key);

  calculate() {
    settlementTexts.clear(); // 기존 공유용 텍스트 초기화

    // 1. 참여자별로 총 지출 계산
    Map<String, int> totalSpent = {for (var p in datas.participants) p: 0};

    for (var expense in datas.expenses) {
      int splitAmount = (expense.amount / expense.included.length).round();
      for (var person in expense.included) {
        totalSpent[person] = (totalSpent[person] ?? 0) - splitAmount;
      }
      for (var payer in expense.paidBy) {
        totalSpent[payer] = (totalSpent[payer] ?? 0) + expense.amount ~/ expense.paidBy.length;
      }
    }

    // 2. Positive(더 낸 사람)과 Negative(덜 낸 사람) 나누기
    List<MapEntry<String, int>> positive = [];
    List<MapEntry<String, int>> negative = [];

    totalSpent.forEach((key, value) {
      if (value > 0) {
        positive.add(MapEntry(key, value));
      } else if (value < 0) {
        negative.add(MapEntry(key, -value));
      }
    });

    // 금액 순으로 정렬
    positive.sort((a, b) => b.value.compareTo(a.value));
    negative.sort((a, b) => b.value.compareTo(a.value));

    // 3. 최소 거래 계산
    List<Widget> settlementWidgets = [];

    int i = 0, j = 0;

    while (i < positive.length && j < negative.length) {
      int amount = min(positive[i].value, negative[j].value);

      // 공유용 텍스트
      settlementTexts.add("${negative[j].key} → ${positive[i].key} : ${formatCurrency(amount)}");

      positive[i] = MapEntry(positive[i].key, positive[i].value - amount);
      negative[j] = MapEntry(negative[j].key, negative[j].value - amount);

      // 화면 노출용 위젯
      settlementWidgets.add(
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("${negative[j].key} "),
              Icon(Icons.arrow_right_alt, size: 30, color: Colors.blueAccent),
              Text(" ${positive[i].key} : ${formatCurrency(amount)}")
            ],
          )
      );

      if (positive[i].value == 0) i++;
      if (negative[j].value == 0) j++;
    }

    return(settlementWidgets);
  }

  @override
  Widget build(BuildContext context) {
    final settlements = calculate();

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

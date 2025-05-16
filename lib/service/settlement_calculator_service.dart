import 'package:flutter/material.dart';
import 'dart:math';
import 'format.dart';

List<String> settlementTexts = [];  // 공유용 텍스트는 외부에서 따로 관리

List<Widget> calculateSettlement(Map<String, int> expenses) {
  settlementTexts.clear(); // 기존 텍스트 초기화

  List<Widget> settlementWidgets = [];  // 화면 노출용 위젯
  List<MapEntry<String, int>> positive = [];
  List<MapEntry<String, int>> negative = [];

  // 총 금액 계산 및 분류
  expenses.forEach((name, value) {
    if (value < 0) {
      negative.add(MapEntry(name, value.abs()));
    } else if (value > 0) {
      positive.add(MapEntry(name, value));
    }
  });

  // 정렬 (정산을 최소한의 거래로 최적화하기 위해)
  negative.sort((a, b) => a.value.compareTo(b.value));
  positive.sort((a, b) => a.value.compareTo(b.value));

  // 예외 처리: 모두 정확하게 결제한 경우 계산할 필요가 없으므로 빈값을 리턴
  if (negative.isEmpty && positive.isEmpty) {
    
    return settlementWidgets;
  }

  // 정산 계산 로직
  int i = 0, j = 0;

  while (i < positive.length && j < negative.length) {
    int amount = min(positive[i].value, negative[j].value);

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

    // 공유용 텍스트
    String formattedText = "${negative[j].key} → ${positive[i].key} : ${formatCurrency(amount)}";
    settlementTexts.add(formattedText);

    if (positive[i].value == 0) i++;
    if (negative[j].value == 0) j++;
  }

  return settlementWidgets;
}

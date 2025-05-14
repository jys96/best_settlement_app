List<String> calculateSettlement(Map<String, int> expenses) {
  // 지불해야 할 금액과 받아야 할 금액 리스트 생성
  List<MapEntry<String, int>> positive = [];
  List<MapEntry<String, int>> negative = [];

  // 총 금액 계산 및 분류
  expenses.forEach((name, balance) {
    if (balance > 0) {
      positive.add(MapEntry(name, balance));
    } else if (balance < 0) {
      negative.add(MapEntry(name, -balance));
    }
  });

  List<String> settlement = [];
  int i = 0, j = 0;

  // 정산 계산
  while (i < positive.length && j < negative.length) {
    int amount = positive[i].value < negative[j].value
        ? positive[i].value
        : negative[j].value;

    settlement.add("${negative[j].key} -> ${positive[i].key} : ₩$amount");

    positive[i] = MapEntry(positive[i].key, positive[i].value - amount);
    negative[j] = MapEntry(negative[j].key, negative[j].value - amount);

    if (positive[i].value == 0) i++;
    if (negative[j].value == 0) j++;
  }

  return settlement;
}

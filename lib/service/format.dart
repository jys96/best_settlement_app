import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  final formatter = NumberFormat('#,###');
  return '${formatter.format(amount)}원';
}
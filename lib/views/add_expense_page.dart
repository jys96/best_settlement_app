import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../service/toast.dart';

class AddExpensePage extends StatefulWidget {
  final List<String> participants;
  final Function(Map<String, dynamic>) onAddExpense;

  const AddExpensePage({
    Key? key,
    required this.participants,
    required this.onAddExpense,
  }) : super(key: key);

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  // final TextEditingController _dateController = TextEditingController();
  String? _selectedPayer;
  final List<String> _selectedParticipants = [];
  DateTime? _selectedDate;

  /// 날짜와 시간을 선택하는 다이얼로그
  // Future<void> _pickDateTime() async {
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //   );
  //   if (picked != null) {
  //     final time = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //     );
  //     if (time != null) {
  //       final dateTime = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
  //       setState(() {
  //         _selectedDate = dateTime;
  //         _dateController.text = dateTime.toString();
  //       });
  //     }
  //   }
  // }

  /// 지출 항목 생성
  void _submitExpense() {
    if (_titleController.text.isEmpty) {
      ToastUtil.show('항목명을 입력해주세요.');
      return;
    }
    if (_amountController.text.isEmpty) {
      ToastUtil.show('금액을 입력해주세요.');
      return;
    }
    if (_selectedPayer == null) {
      ToastUtil.show('결제자를 선택해주세요.');
      return;
    }
    if (_selectedParticipants.isEmpty) {
      ToastUtil.show('참여자들을 선택해주세요.');
      return;
    }

    final uuid = Uuid();

    final newExpense = {
      "id": uuid.v4(),
      "title": _titleController.text,
      "amount": int.parse(_amountController.text),
      "paidBy": [_selectedPayer],
      "included": _selectedParticipants,
      // "date": _selectedDate?.toString() ?? ''
    };

    widget.onAddExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ??
          children: [
            TextField(  // 항목명
              controller: _titleController,
              decoration: InputDecoration(labelText: '항목명'),
            ),
            TextField(  // 금액
              controller: _amountController,
              decoration: InputDecoration(labelText: '금액'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Column( // 결제자
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '결제자',
                    style: Theme.of(context).inputDecorationTheme.labelStyle ?? TextStyle(fontSize: 16, color: Colors.black54)
                ),
                SizedBox(
                  child: DropdownButton<String>(
                    value: _selectedPayer,
                    hint: Text('결제자를 선택하세요'),
                    isExpanded: true,
                    items: widget.participants.map((participant) {
                      return DropdownMenuItem<String>(
                        value: participant,
                        child: Text(participant),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPayer = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Column( // 참여자
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '참여자',
                  style: Theme.of(context).inputDecorationTheme.labelStyle ?? TextStyle(fontSize: 16, color: Colors.black54)
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 6.0,
                  children: widget.participants.map((participant) {
                    return FilterChip(
                      label: Text(participant),
                      selected: _selectedParticipants.contains(participant),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedParticipants.add(participant);
                          } else {
                            _selectedParticipants.remove(participant);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            // TextField(
            //   controller: _dateController,
            //   decoration: InputDecoration(
            //     labelText: '날짜 (선택)',
            //     suffixIcon: IconButton(
            //       icon: Icon(Icons.calendar_today),
            //       onPressed: _pickDateTime,
            //     ),
            //   ),
            //   readOnly: true,
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitExpense,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60)
              ),
              child: Text('항목 추가'),
            ),
          ],
        ),
      ),
    );
  }
}

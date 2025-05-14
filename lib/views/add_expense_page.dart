import 'package:flutter/material.dart';

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
  final TextEditingController _dateController = TextEditingController();
  String? _selectedPayer;
  final List<String> _selectedParticipants = [];
  DateTime? _selectedDate;

  /// 날짜와 시간을 선택하는 다이얼로그
  Future<void> _pickDateTime() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        final dateTime = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
        setState(() {
          _selectedDate = dateTime;
          _dateController.text = dateTime.toString();
        });
      }
    }
  }

  /// 지출 항목 생성
  void _submitExpense() {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedPayer == null ||
        _selectedParticipants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필수 항목을 입력해주세요.')),
      );
      return;
    }

    final newExpense = {
      "category": _titleController.text,
      "amount": int.parse(_amountController.text),
      "paidBy": [_selectedPayer],
      "included": _selectedParticipants,
      "order": DateTime.now().millisecondsSinceEpoch,
      "date": _selectedDate?.toString() ?? ''
    };

    widget.onAddExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '항목명 (필수)'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: '금액 (필수)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _selectedPayer,
              hint: Text('지출자 선택 (필수)'),
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
            Wrap(
              spacing: 4.0,
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
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: '날짜 (선택)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDateTime,
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitExpense,
              child: Text('지출 추가'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

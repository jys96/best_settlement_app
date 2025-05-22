// import 'package:flutter/material.dart';
import 'detail_page.dart';
import '../models/schedule.dart';

// class AddSchedulePage extends StatefulWidget {
//   @override
//   _AddSchedulePageState createState() => _AddSchedulePageState();
// }

// class _AddSchedulePageState extends State<AddSchedulePage> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _participantController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   final List<String> _participants = [];
//   DateTime? _selectedDate;
//
//   /// 날짜 선택 다이얼로그
//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _dateController.text = "${picked.year}-${picked.month}-${picked.day}";
//       });
//     }
//   }
//
//   /// 참여자 추가하기
//   void _addParticipant() {
//     final participant = _participantController.text.trim();
//     if (participant.isNotEmpty) {
//       setState(() {
//         _participants.add(participant);
//         _participantController.clear();
//       });
//     }
//   }
//
//   /// 일정 생성 후 DetailPage로 이동
//   void _createSchedule() {
//     if (_titleController.text.isEmpty || _participants.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('여행명과 참여자는 필수 입력 항목입니다.')),
//       );
//       return;
//     }
//
//     //   final newSchedule = ScheduleModel(
//     //     title: _titleController.text,
//     //     totalSpent: 0,
//     //     participants: _participants,
//     //     expenses: [],
//     //   );
//     //
//     //   Navigator.pushReplacement(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => DetailPage(datas: newSchedule),
//     //     ),
//     //   );
//     // }
//
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('새 일정 생성'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: '여행명 (필수)'),
//               ),
//               TextField(
//                 controller: _dateController,
//                 decoration: InputDecoration(
//                   labelText: '날짜 (선택)',
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.calendar_today),
//                     onPressed: _pickDate,
//                   ),
//                 ),
//                 readOnly: true,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _participantController,
//                       decoration: InputDecoration(labelText: '참여자 추가'),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.add),
//                     onPressed: _addParticipant,
//                   ),
//                 ],
//               ),
//               Wrap(
//                 children: _participants
//                     .map((p) => Chip(label: Text(p)))
//                     .toList(),
//               ),
//               Spacer(),
//               ElevatedButton(
//                 onPressed: _createSchedule,
//                 child: Text('일정 생성'),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.green,
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }
// }
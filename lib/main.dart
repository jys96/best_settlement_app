import 'package:flutter/material.dart';
import 'service/get_json_service.dart';
import 'views/list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final JsonService jsonService = JsonService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '정산 하자',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.cyan,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white
          )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ListPage(jsonService: jsonService),
        // '/addSchedule': (context) => AddSchedulePage(),
        // '/Detail/:id': (context) => DetailPage(),
        // '/addExpense/:tripId': (context) => AddExpensePage(),
        // '/settlement/:tripId': (context) => SettlementPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

final kFirstDay = DateTime(2000, 1, 1);
final kLastDay = DateTime(2099, 12, 31);

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppState(),
    child: const MyApp(),
  ));
}

class AppState extends ChangeNotifier {
  DateTime focusedDay = DateTime.now();

  void focus(DateTime dateTime) {
    focusedDay = dateTime;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'table_calendar issue #651 demo',
      initialRoute: '/page1/page2', // <-- This is important to reproduce table_calendar issue #651
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const HomePage());
        } else if (settings.name == '/page1') {
          return MaterialPageRoute(builder: (_) => const Page1());
        } else if (settings.name == '/page1/page2') {
          return MaterialPageRoute(builder: (_) => const Page2());
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Page1'),
          onPressed: () => Navigator.of(context).pushNamed('/page1'),
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page1')),
      body: Column(
        children: [
          Consumer<AppState>(
            builder: (_, appState, __) {
              return TableCalendar(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: appState.focusedDay,
              );
            },
          ),
          ElevatedButton(
            child: const Text('Go to Page2'),
            onPressed: () => Navigator.of(context).pushNamed('/page1/page2'),
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page2')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '''
This small app demonstrates issue #651 of table_calendar:
Select a date in a different month and then try to go back to Page1''',
            textAlign: TextAlign.center,
          ),
          Consumer<AppState>(
            builder: (_, appState, __) {
              return ElevatedButton(
                child: const Text('Select date'),
                onPressed: () async {
                  final dateTime = await showDatePicker(
                    context: context,
                    initialDate: appState.focusedDay,
                    firstDate: kFirstDay,
                    lastDate: kLastDay,
                  );
                  if (dateTime != null) {
                    appState.focus(dateTime);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

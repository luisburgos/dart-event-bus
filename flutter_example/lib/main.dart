import 'package:flutter/material.dart';
import 'package:flutter_example/events.dart';
import 'package:flutter_example/utils/logger.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';
import 'footer.dart';
import 'listener_view.dart';

void main() {
  eventBus.on().listen((event) => logger('event fired:  ${event.runtimeType}'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: _buildTheme(Brightness.dark),
    );
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fireLabelBText = '';
  String fireLabelAText = '';
  int counterA = 0;
  int counterB = 0;

  final ScrollController _listener1Controller = ScrollController();
  final ScrollController _listener2Controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListenerView(
                title: 'Listener 1',
                eventsListController: _listener1Controller,
                onOutputAppended: (totalEvents) {
                  _scrollDown(_listener1Controller, totalEvents);
                },
              ),
            ),
            Expanded(
              child: ListenerView(
                title: 'Listener 2',
                eventsListController: _listener2Controller,
                onOutputAppended: (totalEvents) {
                  _scrollDown(_listener2Controller, totalEvents);
                },
              ),
            ),
            Footer(
              titleA: 'Fire EventA $fireLabelAText',
              titleB: 'Fire EventB $fireLabelBText',
              onFireATap: () {
                eventBus.fire(
                  MyEventA('Received Event A [$counterA]'),
                );
                setState(() {
                  fireLabelAText = '--> fired [$counterA]';
                  counterA++;
                });
              },
              onFireBTap: () {
                eventBus.fire(
                  MyEventB('Received Event B [$counterB]'),
                );
                setState(() {
                  fireLabelBText = '--> fired [$counterB]';
                  counterB++;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _scrollDown(ScrollController controller, int totalEvents) {
    if (!controller.hasClients || totalEvents < 7) {
      return;
    }

    print('TOTAL_EVENTS: $totalEvents');
    print('INIT: ${controller.initialScrollOffset}');
    print('OUT?: ${controller.position.outOfRange}');
    print('MAX: ${controller.position.maxScrollExtent}');
    print('MIN: ${controller.position.minScrollExtent}');
    print('VPORT: ${controller.position.viewportDimension}');

    controller.animateTo(
      controller.position.maxScrollExtent + kListItemVerticalPadding * 4,
      duration: const Duration(milliseconds: 10),
      curve: Curves.easeInOutQuint,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';

import 'constants.dart';
import 'events.dart';
import 'wrappers.dart';

class ListenerView extends StatefulWidget {
  const ListenerView({
    Key? key,
    required this.title,
    this.eventsListController,
    this.onOutputAppended,
  }) : super(key: key);

  final String title;
  final ScrollController? eventsListController;
  final Function(int)? onOutputAppended;

  @override
  State<ListenerView> createState() => _ListenerViewState();
}

class _ListenerViewState extends State<ListenerView> {
  List<EventData> events = [];
  StreamSubscription? subscription;
  Type? listeningType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //TODO: Move magic number to constants
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListViewHeader(
            widget.title,
            onResetTap: () => reset(),
          ),
          //TODO: Move magic number to constants
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              color: kShadowColorGrey,
              padding: const EdgeInsets.symmetric(
                vertical: kListItemVerticalPadding,
                horizontal: kListItemHorizontalPadding,
              ),
              child: ListenerViewEventsList(
                events: events,
                controller: widget.eventsListController,
              ),
            ),
          ),
          //TODO: Move magic number to constants
          const SizedBox(height: 40),
          ListenerViewActions(
            onListenToEventATap: () => listenForEventA(),
            onListenToEventBTap: () => listenForEventB(),
            onPauseTap: () => pause(),
            onResumeTap: () => resume(),
            onCancelTap: () => cancel(),
          ),
        ],
      ),
    );
  }

  void listenForEventA() {
    if (subscription != null) {
      appendOutput(
          'WARNING: Already listening for an event of type $listeningType');
    } else {
      // -------------------------------------------------
      // Listen for Event A
      // -------------------------------------------------
      subscription = eventBus.on<MyEventA>().listen((event) {
        appendEvent(event);
      });
      listeningType = MyEventA;
      appendOutput('INFO: Listening for Event A');
    }
    setState(() {});
  }

  void listenForEventB() {
    if (subscription != null) {
      appendOutput(
          'WARNING: Already listening for an event of type $listeningType');
    } else {
      // -------------------------------------------------
      // Listen for Event B
      // -------------------------------------------------
      subscription = eventBus.on<MyEventB>().listen((MyEventB event) {
        appendEvent(event);
      });
      listeningType = MyEventB;
      appendOutput('INFO: Listening for Event B');
    }
    setState(() {});
  }

  void pause() {
    if (subscription != null) {
      subscription!.pause();
      appendOutput('INFO: Subscription paused.');
    } else {
      appendOutput('INFO: No subscription, cannot pause!');
    }
    setState(() {});
  }

  void resume() {
    if (subscription != null) {
      subscription!.resume();
      appendOutput('INFO: Subscription resumed.');
    } else {
      appendOutput('INFO: No subscription, cannot resume!');
    }
    setState(() {});
  }

  void cancel() {
    if (subscription != null) {
      subscription!.cancel();
      subscription = null;
      appendOutput('INFO: Subscription canceled.');
    } else {
      appendOutput('INFO: No subscription, cannot cancel!');
    }
    setState(() {});
  }

  void appendOutput(String text) {
    setState(() {
      events.add(EventData('$text\n'));
      if (widget.onOutputAppended != null) {
        widget.onOutputAppended!(events.length);
      }
    });
  }

  void appendEvent(dynamic event) {
    setState(() {
      events.add(EventData('${event.text}\n'));
      if (widget.onOutputAppended != null &&
          event.runtimeType == listeningType) {
        widget.onOutputAppended!(events.length);
      }
    });
  }

  void reset() {
    cancel();
    setState(() {
      events.clear();
    });
  }
}

class ListViewHeader extends StatelessWidget {
  const ListViewHeader(
    this.title, {
    Key? key,
    required this.onResetTap,
  }) : super(key: key);

  final String title;
  final Function() onResetTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            height: 1.2,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        NeoPopButton(
          color: Colors.red,
          onTapUp: onResetTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'CANCEL & CLEAR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EventData {
  EventData(this.name);
  final String name;
}

class ListenerViewEventsList extends StatelessWidget {
  const ListenerViewEventsList({
    Key? key,
    required this.events,
    this.controller,
  }) : super(key: key);

  final List<EventData> events;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        child: EventListViewTile('No events yet'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      controller: controller,
      itemCount: events.length,
      itemBuilder: (_, index) {
        final event = events[index];
        return EventListViewTile(event.name);
      },
    );
  }
}

class EventListViewTile extends StatelessWidget {
  const EventListViewTile(
    this.content, {
    Key? key,
  }) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Text(
      '> $content',
      style: GoogleFonts.robotoMono(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

class ListenerViewActions extends StatelessWidget {
  const ListenerViewActions({
    Key? key,
    required this.onListenToEventATap,
    required this.onListenToEventBTap,
    required this.onPauseTap,
    required this.onResumeTap,
    required this.onCancelTap,
  }) : super(key: key);

  final Function() onListenToEventATap;
  final Function() onListenToEventBTap;
  final Function() onPauseTap;
  final Function() onResumeTap;
  final Function() onCancelTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            NeoPopElevatedStrokesButtonWrapper(
              title: 'Listen for EventA',
              color: kPopYellowColor,
              onTapUp: onListenToEventATap,
            ),
            NeoPopElevatedStrokesButtonWrapper(
              title: 'Listen for EventB',
              color: kPopYellowColor,
              onTapUp: onListenToEventBTap,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            NeoPopElevatedStrokesButtonWrapper(
              title: 'Pause',
              color: kBorderColorGreen,
              onTapUp: onPauseTap,
            ),
            NeoPopElevatedStrokesButtonWrapper(
              title: 'Resume',
              color: kBorderColorGreen,
              onTapUp: onResumeTap,
            ),
            NeoPopElevatedStrokesButtonWrapper(
              title: 'Cancel',
              color: kBorderColorGreen,
              onTapUp: onCancelTap,
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:basic_layout/listrepo.dart';
import 'package:basic_layout/newsmodel.dart';

class EventListView extends StatefulWidget {
  @override
  _EventListViewState createState() => new _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  List<Client> events = [];

  @override
  void initState() {
    super.initState();

    EventRepository.getEvents().then((List<Client> events) {
      setState(() {
        this.events = events;
        print("allData length is: " + events.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          child: events.length == 0
              ? new Center(child: new CircularProgressIndicator())
              : new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: events.length,
            itemBuilder: (_, index) {
              return _buildRow(events[index]);
            },
          )),
    );
  }

  Widget _buildRow(Client event) {

  }
}

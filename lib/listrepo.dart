import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:basic_layout/listdata.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:basic_layout/constant.dart';
import 'package:basic_layout/newsmodel.dart';

class EventRepository {

  static const EVENT_TABLE_NAME = "event";
  static const String KEY_LAST_FETCH = "last_fetch";
  static const int MILLISECONDS_IN_HOUR = 3600000;
  static const int REFRESH_THRESHOLD = 24 * MILLISECONDS_IN_HOUR;

  static Future<List<Client>> getEvents() async {
    List<Client> events = [];
    if (await _shouldRefreshLocalEvents()) {
      events = await _getEventsFromApi(http.Client());
      _setLastRefreshToNow();
      _persistEventsInDatabase(events);
    } else {
      events = await _getEventsFromDatabase();
    }
    return events;
  }

  static Future<List<Client>> _getEventsFromApi(http.Client client) async {
    String url;
    url = Constant.base_url +
        "everything?q=flutter&apiKey=" +
        Constant.key;
    final response = await client.get(url);
    final parsed = json.decode(response.body);
    print('api called');
    return (parsed["articles"] as List)
        .toList();
  }

  static Future<List<Client>> _getEventsFromDatabase() async {
    Database dbClient = await EventsDatabase().db;
    List<Map<String, dynamic>> eventRecords = await dbClient.query(EVENT_TABLE_NAME);
    return eventRecords.map((record) => Client.fromMap(record)).toList();
  }

  static Future<bool> _shouldRefreshLocalEvents() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    int lastFetchTimeStamp = prefs.getInt(KEY_LAST_FETCH);

    if (lastFetchTimeStamp == null) {
      print("last timestamp is null");
      return true;
    }

    return(new DateTime.now().millisecondsSinceEpoch - lastFetchTimeStamp) > (REFRESH_THRESHOLD);
  }

  static void _setLastRefreshToNow() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    print("refresh called");
    prefs.setInt(KEY_LAST_FETCH, new DateTime.now().millisecondsSinceEpoch);
  }

  static void _persistEventsInDatabase(List<Client> events) async {
    Database dbClient = await EventsDatabase().db;

    dbClient.delete(EVENT_TABLE_NAME);

    events.forEach((event) async {
      int eventId = await dbClient.insert(EVENT_TABLE_NAME, event.toMap());
      print(eventId.toString());
    });
  }

}
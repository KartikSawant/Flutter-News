import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}
const String spKey = 'myBool';
FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
void fcmSubscribe() {
  firebaseMessaging.subscribeToTopic('APP');
}

void fcmUnSubscribe() {
  firebaseMessaging.unsubscribeFromTopic('APP');
}
class _SettingPageState extends  State<SettingPage> with AutomaticKeepAliveClientMixin<SettingPage> {
  SharedPreferences sharedPreferences;
  bool _testValue;
  bool isSwitched=true;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      _testValue = sharedPreferences.getBool(spKey);
      // will be null if never previously saved
      if (_testValue == null) {
        _testValue = true;
        persist(_testValue); // set an initial value
      }
      setState(() {});
    });
  }

  void persist(bool value) {
    setState(() {
      _testValue = value;
    });
    sharedPreferences?.setBool(spKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Settings"),
        ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title:new Text("Notifications", style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),) ,
            value: _testValue,
            onChanged: (value) {
              setState(() {
                _testValue = value;
                if(!_testValue){
                  print("false");
                  fcmUnSubscribe();
                }
                else{
                  fcmSubscribe();
                }
                persist(_testValue); // set an initial value
              });
            },
          )
        ],
      )
    );
  }
}

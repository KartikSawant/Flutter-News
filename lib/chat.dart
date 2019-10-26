import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin<MyHomePage>{
  bool get wantKeepAlive => true;
  final chat = const Color(0xffDCF8C6);
  TextEditingController taskTitleInputController;
  @override
  initState() {
    taskTitleInputController = new TextEditingController();
    super.initState();
  }
  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report chat"),
      ),
      body:Column(
        children: <Widget>[
          Expanded(
            child: Container(
                padding: const EdgeInsets.only(top: 10.0, left:70.0, right: 10.0,bottom:10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('tasks').orderBy('time', descending: true).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Text('Loading...');
                      default:
                        return new ListView(
                          controller: _scrollController,
                          reverse: true,
                          shrinkWrap: true,
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return new CustomCard(
                              title: document['title'],
                              time: document['time'],
                            );
                          }).toList(),
                        );
                    }
                  },
                )),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: TextFormField(
                autofocus: false,
                maxLines: null,
                decoration: InputDecoration(hintText: 'Type your message',
                    suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: () => {if (taskTitleInputController.text.isNotEmpty) {
                      Firestore.instance
                          .collection('tasks')
                          .add({
                        "title": taskTitleInputController.text,
                        "time": DateTime.now()
                          })
                          .then((result) => {
                            taskTitleInputController.clear(),
                      })
                          .catchError((err) => print(err))
                    }})),
                controller: taskTitleInputController,
              ),
          ),
        ],
      )
    );
  }
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          children: <Widget>[
            Text("Please add your message"),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Title:'),
                controller: taskTitleInputController,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                taskTitleInputController.clear();
                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (taskTitleInputController.text.isNotEmpty) {
                  Firestore.instance
                      .collection('tasks')
                      .add({
                    "title": taskTitleInputController.text,
                    "time": DateTime.now()
                      })
                      .then((result) => {
                    Navigator.pop(context),
                    taskTitleInputController.clear(),
                  })
                      .catchError((err) => print(err));
                }
              })
        ],
      ),
    );
  }
}
class CustomCard extends StatelessWidget {
  CustomCard({@required this.title, this.time});

  final title;
  final time;

  @override
  Widget build(BuildContext context){
    int c=time.millisecondsSinceEpoch;
    var format = new DateFormat('dd-MM-yyyy   hh:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(c * 1000);
    var t= '';
    t = format.format(date);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(0.0),
          bottomRight: Radius.circular(25.0),
          bottomLeft: Radius.circular(25.0)
        ),
        child: Container(
            padding: const EdgeInsets.only(top: 5.0,left:5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title, style: new TextStyle(fontWeight: FontWeight.normal,fontSize: 17.0,color: Colors.black),),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(t.toString(), style: new TextStyle(fontWeight: FontWeight.w200,fontSize: 10.0,color: Colors.grey),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:8.0,bottom: 8.0),
                      child: Icon(Icons.check, size: 15.0,color: Colors.blue,),
                    ),
                  ],
                ),
              ],
            ),
            color: Color(0xffDCF8C6),
      ),

      ),
    );

  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:basic_layout/newsmodel.dart';
import 'package:basic_layout/ListDatabase.dart';
import 'description.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:async';

class SavePage extends StatefulWidget {
  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage>
    with AutomaticKeepAliveClientMixin<SavePage> {
  static String tag = "SavePage-tag";

  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    int id = 0;
    return Scaffold(
      body: new SafeArea(
          child: new Column(
        children: [
          new Expanded(
              flex: 1,
              child: new Container(
                width: width,
                color: Colors.white,
                child: new GestureDetector(
                  child: new FutureBuilder<List<Client>>(
                    future: DBProvider.db.getClient(id),
                    builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Client item = snapshot.data[index];
                            return ListTile(
                              title: Text(item.image),
                              leading: Text(item.title),
                              onTap: () {
                                var url = item.url;
                                var title = item.title;
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new WebPage(url, title),
                                    )
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              )),
        ],
      )),
    );
  }
}

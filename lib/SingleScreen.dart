import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'dart:async';
import 'dart:convert';
import 'description.dart';
import 'package:basic_layout/newsmodel.dart';
import 'package:basic_layout/database.dart';
import 'package:basic_layout/ListDatabase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class SavePages extends StatefulWidget {
  @override
  SavePages(this.text1);
  final int text1;
  _SavePagesState createState() => _SavePagesState(text1);
}

class _SavePagesState extends State<SavePages> with AutomaticKeepAliveClientMixin<SavePages>
{

  ///////////////////////////////
  final formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }
  String name;
  String image;
  String url;

  void _submit(BuildContext context){
    final form = formKey.currentState;
    _query();
  }
  final dbHelper = DatabaseHelper.instance;
  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
  void _insert(String name, String image, String url) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnEmail: image,
      DatabaseHelper.columnPass: url,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  ///////////////////////////////


  _SavePagesState(this.text);
  final int text;
  static String tag = "SavePages-tag";
  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    super.build(context);
    var width = MediaQuery.of(context).size.width;
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
                        future: fetchNews(http.Client(), text),
                        builder: (context, snapshot) {
                          final List<Client> news= snapshot.data;
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ?     ListView.builder(
                            itemCount: news.length,
                            itemBuilder: (context, index) {
                              var image=news[index].image;
                              if(image == null){
                                image='https://countrylakesdental.com/wp-content/uploads/2016/10/orionthemes-placeholder-image.jpg';
                              }
                              return new Card(
                                child: new ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: image,
                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                    width: 90.0,
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(news[index].title),
                                  ),
                                  onTap: () {
                                    var image = news[index].image;
                                    print(image);
                                    var url = news[index].url;
                                    var title = news[index].title;
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (BuildContext context) => new WebPage(url,title),
                                        ));
                                  },
                                ),
                              );
                            },
                          )
                              :     ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context,index) {
                              return new Card(
                                child: new ListTile(
                                  leading: Shimmer(
                                    child: Container(
                                      height: 100.0,
                                      width: 90.0,
                                      color: Colors.white,
                                    ),
                                    gradient: LinearGradient(begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [0.1, 0.5, 0.9],
                                      colors: [
                                        Colors.grey,
                                        Colors.white,
                                        Colors.grey,
                                      ],
                                    ),
                                    loop: 5,
                                  ),
                                  title: Shimmer(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:12.0,bottom: 8.0,),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 13.0,
                                            color: Colors.white,
                                          ),
                                          Divider(
                                            height: 46.0,
                                            color: Colors.transparent,
                                          ),
                                        ],
                                      ),
                                    ),
                                    gradient: LinearGradient(begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [0.1, 0.5, 0.9],
                                      colors: [
                                        Colors.grey,
                                        Colors.white,
                                        Colors.grey,
                                      ],
                                    ),
                                    loop: 5,
                                  ),
                                  onTap: () {},
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )),
              ),
            ],
          )),
    );
  }
}

Future<List<Client>> fetchNews(http.Client client,id) async {
  String url;
  if (id == 1) {
    url = Constant.base_url +
        "top-headlines?country=in&category=sports&apiKey=" +
        Constant.key;
  } else if (id == 2) {
    url = Constant.base_url +
        "top-headlines?country=in&category=business&apiKey=" +
        Constant.key;
  } else if (id == 3) {
    url = Constant.base_url +
        "top-headlines?country=in&category=technology&apiKey=" +
        Constant.key;
  } else if (id == 4) {
    url = Constant.base_url +
        "everything?q=apple&apiKey=" +
        Constant.key;
  } else if (id == 5) {
    url = Constant.base_url +
        "everything?q=google&apiKey=" +
        Constant.key;
  }
  final response = await client.get(url);
  final parsed = json.decode(response.body);

  return (parsed["articles"] as List)
      .map<Client>((json) => new Client.fromMap(json))
      .toList();
}
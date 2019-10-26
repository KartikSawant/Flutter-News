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

class GridPage extends StatefulWidget {
  @override
  GridPage(this.text1);
  final int text1;
  _GridPageState createState() => _GridPageState(text1);
}

class _GridPageState extends State<GridPage> with AutomaticKeepAliveClientMixin<GridPage>
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


  _GridPageState(this.text);
  final int text;
  static String tag = "GridPage-tag";
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
                              ?     GridView.builder(
                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemCount: news.length,
                            itemBuilder: (context, index) {
                              var image=news[index].image;
                              if(image == null){
                                image=news[0].image;
                              }
                              return new Card(
                                child: new GridTile(
                                  child: new Text(''),
                                  header: CachedNetworkImage(
                                    imageUrl: image,
                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                    height: 90.0,
                                  ),
                                  footer: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(news[index].title),
                                  ),
                                ),
                              );
                            },
                          )
                              :     GridView.builder(
                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemCount: 10,
                            itemBuilder: (context,index) {
                              return new Card(
                                child: new GridTile(
                                  child: new Text(''),
                                  header: Shimmer(
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
                                  footer: Shimmer(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:12.0,bottom: 8.0,),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 13.0,
                                            color: Colors.white,
                                          ),
                                          Divider(
                                            height: 10.0,
                                            color: Colors.transparent,
                                          ),
                                          Container(
                                            height: 13.0,
                                            color: Colors.white,
                                          ),
                                          Divider(
                                            height: 10.0,
                                            color: Colors.transparent,
                                          ),
                                          Container(
                                            height: 13.0,
                                            color: Colors.white,
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
        "everything?q=bitcoin&sortBy=publishedAt&apiKey=" +
        Constant.key;
  } else if (id == 3) {
    url = Constant.base_url +
        "top-headlines?sources=techcrunch&apiKey=" +
        Constant.key;
  } else if (id == 4) {
    url = Constant.base_url +
        "everything?q=apple&apiKey=" +
        Constant.key;
  } else if (id == 5) {
    url = Constant.base_url +
        "everything?q=flutter&apiKey=" +
        Constant.key;
  }
  final response = await client.get(url);
  final parsed = json.decode(response.body);

  return (parsed["articles"] as List)
      .map<Client>((json) => new Client.fromMap(json))
      .toList();
}
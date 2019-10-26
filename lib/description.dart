import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final url;
  final title;
  WebPage(this.url,this.title);
  @override
  _WebPageState createState() => _WebPageState(this.url,this.title);
}

class _WebPageState extends State<WebPage> {
  final _url;
  final _title;
  static String tag = 'description-page';
  final _key = UniqueKey();
  _WebPageState(this._url,this._title);
  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text(_title),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.share, color: Colors.white),
              onPressed: () => Share.share(_url),
            )
          ],
        ),
        body: IndexedStack(
          index: _stackToView,
          children: [
            Column(
              children: < Widget > [
                Expanded(
                    child: WebView(
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: _url,
                      onPageFinished: _handleLoad,
                    )
                ),
              ],
            ),
            Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        )
    );
  }
}


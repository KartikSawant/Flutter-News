import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool isSwitched = true;
  final TextEditingController textEditingController = new TextEditingController();
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Your message has been delivered"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    textEditingController.clear();
  }
  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);

    } else {
      throw 'Could not launch $url';
    }
    textEditingController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Contact Us"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left:8.0,right:8.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: TextFormField(
                      maxLines: null,
                      autofocus: true,
                      style: TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Material(
                  child: new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 8.0),
                    child: new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: () => _launchURL('kartiksawant100@gmail.com', 'Flutter News App Issue', textEditingController.text.toString()),
                      color: Colors.black,
                    ),
                  ),
                  color: Colors.white,
                ),
              ],
            ),
            width: double.infinity,
            height: 50.0,
            decoration: new BoxDecoration(
                border: new Border(top: new BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
          ),
        ),
    );
  }
}

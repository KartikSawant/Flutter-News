import 'package:flutter/material.dart';
import 'description.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: FadeInImage.assetNetwork(placeholder: 'assets/images/place.png', image: 'https://ichef.bbci.co.uk/news/660/cpsprodpb/A732/production/_107220824_tim-cook-wwdc.jpg',height: 200.0,),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Apple dissolves iTunes into new apps', style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebPage('https://www.bbc.com/news/technology-48501890#topic-tags','Apple dissolves iTunes into new apps')),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Image.network('https://ichef.bbci.co.uk/news/660/cpsprodpb/B3EB/production/_107195064_053436762.jpg',width: 90.0,),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('US demands social media details from visa applicants', style: new TextStyle(fontSize: 20.0),),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebPage('https://www.bbc.com/news/world-us-canada-48486672#topic-tags','US demands social media details from visa applicants')),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Image.network('https://ichef.bbci.co.uk/news/660/cpsprodpb/A732/production/_107220824_tim-cook-wwdc.jpg',width: 90.0,),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Dark net drug sales on the rise in England', style: new TextStyle(fontSize: 20.0),),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebPage('https://www.bbc.com/news/technology-48466271#topic-tags','Dark net drug sales on the rise in England')),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Image.network('https://ichef.bbci.co.uk/news/320/cpsprodpb/12E59/production/_107210477_gettyimages-1064393016.jpg',width: 90.0,),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('YouTuber faces jail for prank on homeless man', style: new TextStyle(fontSize: 20.0),),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebPage('https://www.bbc.com/news/technology-48495744#topic-tags','YouTuber faces jail for prank on homeless man')),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Image.network('https://ichef.bbci.co.uk/news/660/cpsprodpb/B3EB/production/_107195064_053436762.jpg',width: 90.0,),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('US demands social media details from visa applicants', style: new TextStyle(fontSize: 20.0),),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebPage('https://www.bbc.com/news/world-us-canada-48486672#topic-tags','US demands social media details from visa applicants')),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Image.network('https://ichef.bbci.co.uk/news/660/cpsprodpb/A732/production/_107220824_tim-cook-wwdc.jpg',width: 90.0,),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Dark net drug sales on the rise in England', style: new TextStyle(fontSize: 20.0),),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebPage('https://www.bbc.com/news/technology-48466271#topic-tags','Dark net drug sales on the rise in England')),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Image.network('https://ichef.bbci.co.uk/news/320/cpsprodpb/12E59/production/_107210477_gettyimages-1064393016.jpg',width: 90.0,),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('YouTuber faces jail for prank on homeless man', style: new TextStyle(fontSize: 20.0),),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebPage('https://www.bbc.com/news/technology-48495744#topic-tags','YouTuber faces jail for prank on homeless man')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

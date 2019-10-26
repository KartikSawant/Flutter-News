import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:basic_layout/Login.dart';
import 'package:basic_layout/FirstScreen.dart';
import 'package:basic_layout/LoadScreen.dart';
import 'package:basic_layout/GridScreen.dart';
import 'package:basic_layout/SingleScreen.dart';
import 'package:basic_layout/Settings.dart';
import 'package:image_picker/image_picker.dart';
import 'chat.dart';
import 'themes.dart';
import 'custom_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  runApp(
    CustomTheme(
      child: MyApp(),
    ),
  );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic themes demo',
      theme: CustomTheme.of(context),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeScreenState();
  }
}
const String spKey = 'myBool';

class HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin<HomeScreen>{
  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }
  SharedPreferences sharedPreferences;
  bool dark;
  bool darkc=false;
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      dark = sharedPreferences.getBool(spKey);
      // will be null if never previously saved
      if (dark == null) {
        dark = true;
        persist(dark); // set an initial value
      }
      setState(() {});
    });
  }
  void persist(bool value) {
    setState(() {
      dark = value;
    });
    sharedPreferences?.setBool(spKey, value);
  }

  bool get wantKeepAlive => true;
  File cameraFile;
  var platform = MethodChannel('crossingthestreams.io/resourceResolver');
  var text= 'New User';
  var log="Login";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          bottom: new PreferredSize(
            preferredSize: new Size(50.0, 50.0),
            child: new Container(
              color: Colors.blue[900],
              child: new TabBar(
                isScrollable: true,
                tabs: [
                  new Container(
                    height: 50.0,
                    child: new Tab(text: 'Headlines'),
                  ),
                  new Container(
                    height: 50.0,
                    child: new Tab(text: 'Sports'),
                  ),
                  new Container(
                    height: 50.0,
                    child: new Tab(text: 'Business'),
                  ),
                  new Container(
                    height: 50.0,
                    child: new Tab(text: 'Technology'),
                  ),
                  new Container(
                    height: 50.0,
                    child: new Tab(text: 'Apple'),
                  ),
                  new Container(
                    height: 50.0,
                    child: new Tab(text: 'Google'),
                  ),
                ],
              ),
            ),
          ),
          title:Image.asset('assets/images/logo.png'),

        ),
        body: TabBarView(
          children: [
            FirstScreen(),
            SavePage(1),
            SavePage(2),
            SavePage(3),
            GridPage(4),
            SavePages(5),
          ],
        ),

        drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                new DrawerHeader(
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only( right: 8.0, bottom: 8.0, top:8.0),
                          child: displaySelectedFile(cameraFile),
                        ),
                        new Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 34.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(text,style: new TextStyle(fontSize: 20.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: new Text("ceo",style: new TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400 ), ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )



                ),
                new Divider(
                  color: Colors.black,
                  height: 1.0,
                ),
                new ListTile(
                  leading: Icon(Icons.dashboard),
                  title: new Text('DashBoard',style: new TextStyle(fontSize: 20.0)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                new Divider(
                  color: Colors.black,
                  height: 1.0,
                ),
                new ListTile(
                  leading: Icon(Icons.settings),

                  title: new Text('Setting',style: new TextStyle(fontSize: 20.0)),
                  onTap: () {
                    if(text=="New User"){
                      waitfordetails(context);
                    }
                    else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingPage(),
                          ));
                    }
                  },
                ),
                new Divider(
                  color: Colors.black,
                  height: 1.0,
                ),
                new ListTile(
                  leading: Icon(Icons.phone),
                  title: new Text('Contact Us',style: new TextStyle(fontSize: 20.0)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ));
                  },
                ),
                new Divider(
                  color: Colors.black,
                  height: 1.0,
                ),
                new ListTile(
                  leading: Icon(Icons.rate_review),
                  title:  new Text(log,style: new TextStyle(fontSize: 20.0)),
                  onTap: () {
                    waitfordetails(context);
                  },
                ),
                new Divider(
                  color: Colors.black,
                  height: 1.0,
                ),
                new ListTile(
                  leading: Icon(Icons.brightness_3),
                  title:  new Text("Night Mode",style: new TextStyle(fontSize: 20.0)),
                  onTap: () {
                    if(darkc==false) {
                      _changeTheme(context, MyThemeKeys.DARKER);
                      darkc = true;
                      persist(true); // set an initial value

                    }
                    else
                      {
                        _changeTheme(context, MyThemeKeys.LIGHT);
                        darkc=false;
                        persist(false); // set an initial value

                      }
                  },
                ),
              ],
            )),
      ),

    );
  }
  Widget displaySelectedFile(File file) {
    imageSelectorCamera() async {
      if(text=="New User"){
        waitfordetails(context);
      }
      else {
        cameraFile = await ImagePicker.pickImage(
          source: ImageSource.camera,
        );
        print("You selected camera image : " + cameraFile.path);
        setState(() {});
      }
    }
    return new Container(
      height: 50.0,
      width: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: OutlineButton(

          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0)),
          onPressed: imageSelectorCamera,
          padding: EdgeInsets.all(0.0),
          child: file == null
              ? ClipRRect(
            borderRadius: new BorderRadius.circular(25.0),
            child: Image.asset(
              'assets/images/user.png',
              height: 50.0,
              width: 50.0,
              fit: BoxFit.fill,
            ),
          )
              : ClipRRect(
            borderRadius: new BorderRadius.circular(25.0),
            child: Image.file(file,
              height: 50.0,
              width: 50.0,
              fit: BoxFit.fill,
            ),
          )
      ),
    );
  }
  void waitfordetails(BuildContext context) async {

    log="Login";
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      text = result;
      if(text.compareTo('New User') != 0){
        log="Logout";
      }
    });
  }
}
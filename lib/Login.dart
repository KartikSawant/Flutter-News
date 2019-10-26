import 'package:flutter/material.dart';
import 'dart:async';
import 'package:basic_layout/database.dart';
import 'package:basic_layout/RegisterForm.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;
  bool passwordVisible;
  String _email;
  String _password;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  void dispose() {
    super.dispose();
  }


  void _submit(BuildContext context){
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _query();
    }
  }
  void _query() async {
    Database db = await DatabaseHelper.instance.database;
    var flag=0;
    var mail;
    var passw;
    for(int i=0;i<15;i++) {
      List<Map> result = await db.rawQuery('SELECT email FROM my_table WHERE _id=?', [i]);
      mail = result.toString();
      List<Map> resultpass = await db.rawQuery('SELECT password FROM my_table WHERE _id=?', [i]);
      passw = resultpass.toString();
      if(mail.contains(_email)){
        if(passw.contains(_password)) {
          flag=1;
          print(mail);
        }
        else{
          print(passw);
        }
      }
    }
    if(flag==0)
      {
        loginFail();
      }
    else
      {
        Navigator.pop(context, _email);
      }
  }
  void loginFail() {
    final snackbar = new SnackBar(
      content: new Text("Wrong Password"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }


  Future<bool> _onWillPop() {
    Navigator.pop( context, 'New User');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          key: scaffoldKey,
          appBar: new AppBar(
            title: new Text("Login"),
          ),
          body: new Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Form(
              key: formKey,
              child: new ListView(
                children: <Widget>[
                  new CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 48.0,
                    child: Image.asset('assets/images/user.png'),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                  ),
                  new TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    validator: (val) =>
                    !val.contains('@') ? 'Invalid Email' : null,
                    onSaved: (val) => _email = val,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                  ),
                  new TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (val) =>
                    val.length <6  ? 'Password too short' : null,
                    onSaved: (val) => _password = val,
                    obscureText: passwordVisible,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                  ),

                  new RaisedButton(
                    child: new Text(
                      "Login",
                      style: new TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      _submit(context);
                    },
                  ),
                  new FlatButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()),),
                      child: new Text('Register'))
                ],
              ),
            ),
          )),
    );
  }
}
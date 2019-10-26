import 'package:flutter/material.dart';
import 'dart:async';
import 'package:basic_layout/database.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;

  String _email;
  String _password;
  String _name;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit(BuildContext context){
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _insert();
      Navigator.pop(context, 'New User');
    }
  }
  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _name,
      DatabaseHelper.columnEmail: _email,
      DatabaseHelper.columnPass: _password,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text("Email : $_email, password : $_password"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
  Future<bool> _onWillPop() {
    Navigator.pop(context, 'New User');
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          key: scaffoldKey,
          appBar: new AppBar(
            title: new Text("Register"),
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
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    validator: (val) =>
                    val.isNotEmpty == false ? 'Enter name' : null,
                    onSaved: (val) => _name = val,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                  ),
                  new TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                    ),
                    validator: (val) =>
                    val.length <6  ? 'Password too short' : null,
                    onSaved: (val) => _password = val,
                    obscureText: true,
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                  ),
                  new RaisedButton(
                    child: new Text(
                      "Register",
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
                  new Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                  ),
                  new RaisedButton(
                    elevation: 0.0,
                    child: new Text(
                      "Query",
                      style: new TextStyle(color: Colors.white),
                    ),
                    color: Colors.transparent,
                    onPressed: () {
                      _query();
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
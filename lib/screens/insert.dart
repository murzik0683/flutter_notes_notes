import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_notes_notes/database/databasehelper.dart';
import 'package:flutter_notes_notes/models/note.dart';

import 'package:sqflite/sqlite_api.dart';

class InsertNote extends StatefulWidget {
  Function updateListView;
  InsertNote(this.updateListView);
  @override
  _InsertNoteState createState() => _InsertNoteState();
}

class _InsertNoteState extends State<InsertNote> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  String _name = '', _email = '', _desc = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Insert Note",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: ColorFiltered(
                //красный цвет логотипа
                colorFilter: ColorFilter.matrix(<double>[
                  0.393,
                  0.769,
                  0.189,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: FlutterLogo(
                  //textColor: Colors.green,
                  size: 100.0,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          hintText: "Name"),
                      onSaved: (value) {
                        _name = value!;
                      },
                      validator: (value) {
                        if (value!.length <= 0) return 'Name cannot be empty';
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextFormField(
                  //     decoration: InputDecoration(
                  //         prefixIcon: Icon(Icons.email),
                  //         border: OutlineInputBorder(),
                  //         hintText: "Email"),
                  //     onSaved: (value) {
                  //       _email = value!;
                  //     },
                  //     validator: (value) {
                  //       if (value!.length <= 0)
                  //         return 'Email cannot be empty';
                  //       else if (EmailValidator.validate(value) == false)
                  //         return 'Not a valid email';
                  //     },
                  //     keyboardType: TextInputType.emailAddress,
                  //   ),
                  // ),
                  //SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.note),
                          border: OutlineInputBorder(),
                          hintText: "Description"),
                      maxLength: 225,
                      onSaved: (value) {
                        _desc = value!;
                      },
                      validator: (value) {
                        if (value!.length > 255)
                          return 'Maximum 255 characters allowed';
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.indigo)),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Note note = Note(_name, _email, _desc);
                        insertnote(context, note);
                      }
                    },
                    //splashColor: Colors.blue,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void insertnote(BuildContext context, Note note) {
    Future<Database> dbfuture = databaseHelper.initialeDatabase();
    dbfuture.then((database) {
      databaseHelper.insertNote(note).then((res) {
        if (res != 0) {
          //Scaffold.of(context).showSnackBar(SnackBar(content:Text("Note Deleted Successfully")));
          print("Note inserted Successfuly");
          widget.updateListView();
          Navigator.pop(context);
        } else
          //Scaffold.of(context).showSnackBar(SnackBar(content:Text("Unable to delete Note")));
          print("Unable to insert note");
      });
    });
  }
}

class CustomColors {
  static const Color purpleColor = Colors.purple;
  static const Color blueColor = Colors.blue;
  static const Color lightblueColor = Color(0xFF73B6EC);
  static const Color blackColor = Colors.black;
  static const Color redColor = Colors.red;
}

//Цвет темы
MaterialColor createThemeColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

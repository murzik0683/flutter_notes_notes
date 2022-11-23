import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_notes_notes/database/databasehelper.dart';
import 'package:flutter_notes_notes/models/note.dart';

import 'package:sqflite/sqlite_api.dart';

class UpdateNote extends StatefulWidget {
  Note note;
  Function updateListView;
  UpdateNote(this.note, this.updateListView);
  @override
  _UpdateNoteState createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final _formKeyU = GlobalKey<FormState>();
  String _name = '', _email = '', _desc = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Update Note",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: FlutterLogo(
                textColor: Colors.green,
                size: 100.0,
              ),
            ),
            SizedBox(height: 40.0),
            Form(
              key: _formKeyU,
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
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                          hintText: "Email"),
                      onSaved: (value) {
                        _email = value!;
                      },
                      validator: (value) {
                        if (value!.length > 0) {
                          if (EmailValidator.validate(value) == false)
                            return 'Not a valid email';
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                  ElevatedButton(
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
                      if (_formKeyU.currentState!.validate()) {
                        _formKeyU.currentState!.save();
                        Note note = Note(_name, _email, _desc);
                        updateNote(context, note);
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateNote(BuildContext context, Note note) {
    Future<Database> dbfuture = databaseHelper.initialeDatabase();
    dbfuture.then((database) {
      databaseHelper.updateNote(widget.note.id, note).then((res) {
        if (res != 0) {
          print("Note Updated");
          widget.updateListView();
          Navigator.pop(context);
        } else {
          print("Unable to update");
          Navigator.pop(context);
        }
        //Scaffold.of(context).showSnackBar(SnackBar(content:Text("Unable to delete Note")));
      });
    });
  }
}

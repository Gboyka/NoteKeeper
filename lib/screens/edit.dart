// this is our second screen for editing the notes

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/screens/note_list.dart';
import 'package:notekeeper/utils/db_helper.dart';
import 'package:notekeeper/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class NoteEdit extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  final bool lock;

  NoteEdit(this.note, this.appBarTitle,this.lock);

  @override
  State<StatefulWidget> createState() {
    return NoteEditState(this.note, this.appBarTitle,this.lock);
  }
}

class NoteEditState extends State<NoteEdit> {
  String appBarTitle;
  Note note;
  bool lock=false;

  NoteEditState(this.note, this.appBarTitle,this.lock);

  TextEditingController title = TextEditingController();
  TextEditingController details = TextEditingController();

  DatabaseHelper helper = DatabaseHelper(); //singleton instance

  bool check = false;
  var _formKey = GlobalKey<FormState>(); //validation layer
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    title.text = note.title; //update textFields using controllers
    details.text = note.description;

    bool locked=lock;


    return WillPopScope(
        //when we press the actual back back button
        onWillPop: () {
          moveToLastScreen();
          return; // defined at last
        },
        child: Scaffold(
            appBar: AppBar(
              //app bar back button
              // by default back button is present with  goto back screen function
              leading: IconButton(
                  icon: Icon(Icons.arrow_back), //  but we can also
                  onPressed: () {
                    moveToLastScreen(); //defined at last
                  } //  add extra control and Functionality
                  ),

              title: Text(appBarTitle, style: TextStyle()),
            ),
            body: Form(
                key: _formKey,
                child: Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: ListView(
                      children: <Widget>[

                        Row(
                          children: <Widget>[
                            Text('Important', style: textStyle),
                            Checkbox(
                              activeColor: Colors.red,
                              value: check,
                              onChanged: (newValue) {
                                setState(() {
                                  setPriority(newValue);
                                  if (check)
                                    note.priority = 1;
                                  else
                                    note.priority = 0;
                                });
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: TextFormField(
                            //autofocus: true,
                            readOnly: locked,
                            validator: (value)
                            {
                              if(value.isEmpty)
                                {
                                  return "Empty Title";
                                }
                              else
                                return null;
                            },
                            controller: title,
                            style: textStyle,
                            onChanged: (value) {
                              updateTitle();
                            },
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(

                                labelText: 'Title',
                                hintText: 'Enter Title',
                                //errorText: 'Empty !',
                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        Padding(

                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: TextFormField(
                            readOnly: locked,
                            textAlignVertical: TextAlignVertical(y: 0.5),
                            keyboardType: TextInputType.multiline,
                            maxLines: 9,
                            controller: details,
                            style: textStyle,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              updateDescription();
                            },
                            decoration: InputDecoration(
                                // labelText: 'Details',
                                hintText: 'Start Writing...',
                                labelText: 'Details',

                                labelStyle: textStyle,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),

                       Padding(
                           padding: EdgeInsets.only(left:85.0,top:25),


                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 15.0),
                                      color: Colors.white,
                                      elevation: 8.0,
                                      splashColor: Colors.blue,
                                      textColor:
                                      Theme.of(context).primaryColorLight,
                                      child: Icon(
                                        Icons.edit,
                                        size: 50.0,
                                        color: Colors.red,
                                      ),
                                      shape: CircleBorder()
                                          //borderRadius:
                                        //  BorderRadius.circular(75.0))
                                          ,
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _delete();
                                        }
                                        else
                                        {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(content: Text("Enter Title"),)
                                          );
                                        }
                                      },
                                    )),
//                                Container(
//                                  width: 10.0,
//                                ),
                                Expanded(
                                    child: RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 15.0),
                                      color: Colors.white,
                                      elevation: 8.0,
                                      splashColor: Colors.black87,
                                      textColor:
                                      Theme.of(context).primaryColorLight,
                                      child: Icon(
                                        Icons.save,
                                        size: 50.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      shape: CircleBorder()
                                       // borderRadius: BorderRadius.circular(75.0),
                                      ,
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _save();
                                        }
                                        else
                                        {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(content: Text("Empty Title"),)
                                          );
                                        }
                                      },
                                    )),
                              ],
                            )),],
                    )
                )
            )
        )
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true); //move to home screen
  }

  void updateTitle() {
    note.title = title.text;
  }

  void updateDescription() {
    note.description = details.text;
  }

  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;

    if (note.id != null) {
      //case 1: update operation existing note
      result = await helper.updateNote(note);
    } else //case 2: insert operation new note
    {
      result = await helper.insertNote(note);
    }

    if (result != 0) //success
      _showAlert('Status', 'Saved Successfully');
    else //failed
      _showAlert('Status', 'Problem Saving Note');
  }

  void _showAlert(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _editNote()
  {


  }


  void _delete() async {
    //2 cases
    //case1. deleting new node that has come after pressing FAB of homescreen
    //case2. deleting existing note wiht valid ID.
    moveToLastScreen();
    if (note.id == null) {
      _showAlert('Status', 'Oops!No Note Deleted');
    }

    int result = await helper.deleteNote(note.id);
    if (result != 0)
      _showAlert('Status', 'Deleted !');
    else
      _showAlert("Status", 'Something Wrong.!');
  }

  void setPriority(bool val) {
    if (val)
      check = true;
    else
      check = false;
  }
}

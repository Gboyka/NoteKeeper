// this is our second screen for editing the notes

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteEdit extends StatefulWidget {
  String appBarTitle;

  NoteEdit(String title) {
    appBarTitle = title;
  }

  @override
  State<StatefulWidget> createState() {
    return NoteEditState(appBarTitle);
  }
}

class NoteEditState extends State<NoteEdit> {
  String appBarTitle;

  NoteEditState(this.appBarTitle);

  TextEditingController title = TextEditingController();
  TextEditingController details = TextEditingController();
  int _priority = 0;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    return WillPopScope(
        //when we press the actual back back button
        onWillPop: () {
          moveToLastScreen();
          return; // defined at last
        },
        child: Scaffold(
            appBar: AppBar(
              //app bar back butto
              // by default back button is present with  goto back screen function
              leading: IconButton(
                  icon: Icon(Icons.arrow_back), //  but we can also
                  onPressed: () {
                    moveToLastScreen(); //defined at last
                  } //  add extra control and Functionality
                  ),

              title: Text(appBarTitle, style: TextStyle()),
            ),
            body: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: TextField(
                        controller: title,
                        style: textStyle,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: TextField(
                        controller: details,
                        style: textStyle,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            labelText: 'Details',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 65.0,
                        ),
                        Text('Primary', style: textStyle),
                        Container(
                          width: 120.0,
                        ),
                        Text('Secondary', style: textStyle)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Radio(
                          activeColor: Colors.red,
                          value: 0,
                          groupValue: _priority,
                          onChanged: (newValue) {
                            setState(() {
                              _priority = 0;
                            }
                            );
                          },
                        )
                        ),
                        Expanded(
                            child: Radio(
                          activeColor: Colors.lightGreen,
                          value: 1,
                          groupValue: _priority,
                          onChanged: (newValue) {
                            setState(() {
                              _priority = 1;
                            }
                            );
                          },
                        )
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 5.0),
                                  color: Colors.white,
                                   elevation: 8.0,
                                    splashColor: Colors.black87,
                                    textColor: Theme.of(context).primaryColorLight,
                                        child: Icon(
                                    Icons.save,
                                    size: 50.0,
                                    color: Theme.of(context).primaryColor,
                              ),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(75.0),
                              ),
                              onPressed: () {},
                            )
                            ),
                            Container(
                              width: 40.0,
                            ),
                            Expanded(
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 5.0),
                                  color: Colors.white,
                                  elevation: 8.0,
                                  splashColor: Colors.blue,
                                  textColor: Theme.of(context).primaryColorLight,
                                  child: Icon(
                                  Icons.delete_forever,
                                  size: 50.0,
                                 color: Colors.red,
                              ),
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(75.0)),
                              onPressed: () {},
                            )
                            ),
                          ],
                        )
                    )
                  ],
                )
            )
        )
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}

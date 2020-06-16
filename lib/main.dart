import 'package:flutter/material.dart';
import 'package:notekeeper/screens/note_list.dart';
import 'package:notekeeper/screens/edit.dart';

void main() {
  runApp(
      MaterialApp(
        title:'NoteKeeper',
        debugShowCheckedModeBanner: false,
        theme:ThemeData(
            primarySwatch: Colors.teal //primary Color of the App
        ),
        home:NoteEdit(), // Home Screen


      )
  );
}


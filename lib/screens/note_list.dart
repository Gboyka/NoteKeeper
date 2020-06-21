import 'package:flutter/material.dart';
import 'package:notekeeper/screens/edit.dart';
import 'package:notekeeper/utils/db_helper.dart';
import 'package:notekeeper/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';


class NoteList extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return NoteListState(); //return state which is defined down below
  }
}

class NoteListState extends State<NoteList> {

  int count = 0;

  DatabaseHelper databaseHelper=DatabaseHelper(); //singleton instance
  List<Note> noteList; //display nodes in listView

  @override
  Widget build(BuildContext context) {

    if(noteList==null){
      noteList=List<Note>(); //instantiate note list object if initially null.
      updateListView();//defined below
    }


    return Scaffold(
        appBar: AppBar(
          title: Text('Notes'),
        ),
        body: getNoteListView(), //Return listView
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //add on tapped
              //(title,date,priority)
              navigateToDetail(Note('','',0),'Add Note');
            },
            backgroundColor: Colors.green,
            tooltip: 'Add Note',
            child: Icon(
              Icons.add,
              size: 30.0,
            )));
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder // build the List using itemBuilder
        (
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
            //Card like list
            color: Colors.white,
            elevation: 4.0,
            child: ListTile(
              leading: CircleAvatar(
                // leading icon Type in circle
                backgroundColor: getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority)
              ),
              title: Text(this.noteList[position].title,style: titleStyle,),
              subtitle: Text(this.noteList[position].date),
              trailing:GestureDetector(
              child:Icon(
                Icons.delete,
                color: Colors.grey,
              ),
                onTap: (){
                _delete(context,noteList[position]);
                },

              ),
              //move to edit screen on tap
              onTap: () {
                navigateToDetail(this.noteList[position],"Edit Note"); //defined in the end
              },
            ));
      },
    );
  }

  // open Note Edit Screen
  void navigateToDetail(Note note,String title) async{
    bool result=await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteEdit(note,title);
    }));
    if(result)
      updateListView();

  }

  //returns priority color
  Color getPriorityColor(int priority){
    switch(priority) {
      case 1:
        return Colors.red;
        break;
       default:
        return Colors.green;
    }
  }



  //return priority icon

  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 0:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.chevron_right);
    }

  }
//delete Note
  void _delete(BuildContext context,Note note) async{
    int result =await databaseHelper.deleteNote(note.id);
    if(result!=0){
      _showSnackBar(context,"Deleted");
      updateListView();
    }
  }


void _showSnackBar(BuildContext context,String message)
{
  final snackBar=SnackBar(content: Text(message),);
  Scaffold.of(context).showSnackBar(snackBar);
}

void updateListView(){
    final Future<Database> dbFuture=databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture=databaseHelper.getNoteList();
      noteListFuture.then((noteList){     //update UI
        setState(() {
          this.noteList=noteList; //update note list
          this.count=noteList.length;
        });
      });
    });
}

}

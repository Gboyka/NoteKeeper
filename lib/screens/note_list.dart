import 'package:flutter/material.dart';
import 'package:notekeeper/screens/edit.dart';


class NoteList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return NoteListState(); //return state which is defined down below
  }

}

class NoteListState extends State<NoteList>{
  int count=0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title:Text('Notes'),
        ),
        body:getNoteListView(), //Return listView
        floatingActionButton: FloatingActionButton(
            onPressed: (){
              //add on tapped

            },
            backgroundColor: Colors.lightGreen,
            tooltip:'Add Note' ,
            child:Icon(Icons.add)

        )
    );

  }

  ListView getNoteListView(){
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder // build the List using itemBuilder
      (
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(            //Card like list
            color:Colors.white,
            elevation: 4.0,
            child:ListTile(
              leading: CircleAvatar(    // leading icon Type in circle
                backgroundColor:Colors.blue,
                child:Icon(Icons.timer),
              ),
              title: Text('Dummy Title',style:titleStyle,),
              subtitle: Text('Dummy Date'),
              trailing: Icon(Icons.delete,color: Colors.grey,),
              onTap:(){                                  //move to edit screen on tap
                //
              },
            )

        );
      },

    );
  }


}
import 'package:flutter/material.dart';
import 'note_details.dart';
import 'package:flutter_exercise/helper/database_helper.dart';
import 'package:flutter_exercise/models/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;

  @override
  Widget build(BuildContext context) {

    if(noteList == null){
      noteList = List<Note>();
      _updateListView();
    }

    return Scaffold(
       //app bar
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
      ),

      //---------------BODY--------------
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: getNoteListView(),
      ),

      //floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _navigateNoteDetailsScreen(Note("",2,""),"Add New Note");
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),

    );
  }

  ListView getNoteListView(){
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder:(BuildContext context,int position){
        //card view
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          elevation: 5.0,
          color: Colors.white,
          //list tile
          child: ListTile(
            //leading
            leading: CircleAvatar(
              backgroundColor: _getPriorityColor(noteList[position].priority),
              child: _getPriorityIcon(noteList[position].priority),
            ),
            title: Text(noteList[position].title,style: titleStyle,),
            subtitle: Text(noteList[position].date),
            trailing: GestureDetector(
                onTap: (){
                  _delete(noteList[position].id);
                },
                child: Icon(Icons.delete,color: Colors.red,)
            ),
            //on tap
            onTap: (){
             _navigateNoteDetailsScreen(noteList[position],"Edit Note");
            },
          ),
        );
      },
    );
  }

  //--------provide priority color---------
  Color _getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red;
        break;

      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }


  //---------provide priority icon---------
  Icon _getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;

      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  //------delete data from db----------
  void _delete(int id) async{
    int result = await databaseHelper.deleteNote(id);
    _showAlertDialog("Note Delete!", result != 0 ? "Note Deleted Successfully" : "Something went wrong");
    _updateListView();
  }

  //-------update listview
  void _updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
          setState(() {
            debugPrint("Length ${noteList.length}");
            this.noteList = noteList;
          });
      });
    });
  }

  //---------navigate screen----------------
  void _navigateNoteDetailsScreen(Note note, String title) async{
    bool isTrue = await Navigator.push(context, MaterialPageRoute(builder: (context)=> NoteDetails(note,title)));
    if(isTrue){
      _updateListView();
    }
  }

  void _showAlertDialog(String title, String message){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("Okay"),
            )
          ],
        );
      }
    );
  }
}

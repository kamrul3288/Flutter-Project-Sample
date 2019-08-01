import 'package:flutter/material.dart';
import 'package:flutter_exercise/constant/constant.dart';
import 'package:flutter_exercise/models/note.dart';
import 'package:flutter_exercise/helper/database_helper.dart';
import 'package:date_format/date_format.dart';


class NoteDetails extends StatefulWidget {
  String _appBarTitle;
  Note _note;
  NoteDetails(this._note,this._appBarTitle);
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {

    _titleController.text = widget._note.title;
    _descriptionController.text = widget._note.description;

    return WillPopScope(
      //handle back button click
      onWillPop: (){
        navigateNoteScreen();
      },

      child: Scaffold(
        //appbar
        appBar: AppBar(
          title: Text(widget._appBarTitle),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: ()=>navigateNoteScreen()
          ),
        ),

        //body
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 10.0),
          child: ListView(
            children: <Widget>[
              //----------drop down button-------------
              ListTile(
                title: DropdownButton(
                    items: kPriorities.map((String dropDownItem){
                      return DropdownMenuItem<String>(
                        value: dropDownItem,
                        child: Text(dropDownItem),
                      );
                    }).toList(),
                    value: _updatePriorityAsString(widget._note.priority),
                    onChanged: (selectedValue){
                      setState(() {
                        _updatePriorityAsInt(selectedValue);
                      });
                    },

                ),
              ),

              //--------------title edit text-----------
              Padding(
                padding: const EdgeInsets.only(top: 16.0,bottom: 16.0),
                child: TextField(
                  controller: _titleController,
                  onChanged: (value){
                    _updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    )
                  ),
                ),
              ),

              //-----------description edit text-------------
              Padding(
                padding: const EdgeInsets.only(top: 16.0,bottom: 16.0),
                child: TextField(
                  controller: _descriptionController,
                  onChanged: (value){
                    _updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                  ),
                ),
              ),

              //----------save and delete button-------------
              Padding(
                padding: const EdgeInsets.only(top: 16.0,bottom: 16.0),
                child: Row(
                  children: <Widget>[

                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        onPressed: (){
                          _saveDataToDb();
                        },
                        child: Text("Save",textScaleFactor: 1.5,),
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                      ),
                    ),

                    SizedBox(width: 10.0,),

                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        onPressed: (){
                          _delete();
                        },
                        child: Text("Delete",textScaleFactor: 1.5,),
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                      ),
                    )

                  ],
                ),
              )

            ],
          ),
        ),

      ),
    );
  }

  void navigateNoteScreen(){
    Navigator.pop(context,true);
  }
  void _updatePriorityAsInt(String value){
    switch(value){
      case "High":
        widget._note.priority = 1;
        break;
      case "Low":
        widget._note.priority = 2;
        break;
    }
  }

  String _updatePriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority = "High";
        break;
      case 2:
        priority = "Low";
        break;
    }
    return priority;
  }

  void _updateTitle(){
    widget._note.title = _titleController.text;
  }

  void _updateDescription(){
    widget._note.description = _descriptionController.text;
  }

  void _saveDataToDb() async{
    int result;
    widget._note.date = formatDate(DateTime.now(), [MM,' ',dd,',',yyyy]);
    if(widget._note.id != null){
      result = await _databaseHelper.updateNote(widget._note);
    }else{
      result = await _databaseHelper.insertNote(widget._note);
    }

    if(result != 0){
      _showAlertDialog("Note Save Successfully");
    }else{
      _showAlertDialog("Opps! Something went wrong");
    }
  }

  void _delete() async{
     if(widget._note.id == null){
       _showAlertDialog("Opps! You can't delete this note");
       return;
     }
     int result = await _databaseHelper.deleteNote(widget._note.id);
     _showAlertDialog(result != 0 ? "Note Deleted Successfully":"Opps! Something went wrong");
  }

  void _showAlertDialog(String message) async{
    await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Okay"),
              )
            ],
          );
        }
    );
    navigateNoteScreen();
  }



}

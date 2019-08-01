
class Note{
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;

  Note(this._title, this._priority, this._date,[this._description]);

  Note.withId(this._id, this._title, this._description, this._priority, this._date);

  String get date => _date;

  int get priority => _priority;

  String get description => _description;

  String get title => _title;

  int get id => _id;

  //convert a note object to dynamic
  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(_id != null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;

  }

  Note.fromMapObject(Map<String,dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }

  set date(String value) {
    _date = value;
  }

  set priority(int value) {
    _priority = value;
  }

  set description(String value) {
    _description = value;
  }

  set title(String value) {
    _title = value;
  }


}
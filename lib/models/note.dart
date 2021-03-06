

class Note{
  //attributes
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  //make description as optional parameter
  Note(this._title,this._date,this._priority,[this._description]);

  //Use named Constructor so that we will have one more constructor along with ID.
  //withId is name constructor
  Note.withId(this._id,this._title,this._date,this._priority,[this._description]);

  //getter and setter function
  int get id=>_id;

  String get title=>_title;

  String get date=>_date;

  String get description =>_description;

  int get priority=>_priority;

//no setter required for id ,it will be autogenerated by database

  set title(String newTitle){
    //add validation. Save only if
    if(newTitle.length<=255 && newTitle.length>0){
      this._title=newTitle;
    }
  }
    set description(String desc){
      //optional
      this._description=desc;
      }

      set priority(int check)
      {
        this._priority=check;
      }

      set date(String newDate) {
        this._date = newDate;
      }
      // now object conversion function to store and fetch from data
      //from note object to map object

  //Note to map
  Map<String,dynamic> toMap() {  // key=String(always) , value:dynamic(depends)
          //empty map object
        var map=Map<String,dynamic>();
        if(id!=null) {
          map['id'] = _id;
        }
        map['title']=_title;
        map['description']=_description;
        map['priority']=_priority;
        map['date']=_date;
        return map;
    }

    //map to Note conversion function
    Note.fromMapObject(Map<String,dynamic> map)
    {
      this._id=map['id'];
      this._title=map['title'];
      this.description=map['description'];
      this._priority=map['priority'];
      this.date=map['date'];
    }


  }



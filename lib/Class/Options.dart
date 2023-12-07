
import 'dart:convert';

class Options {
  int id = 0;
  String title = "";
  String descriptions = "";

  Options({int id=0,String fields=""}){
    if(fields!=""){
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      title = content["title"];
      descriptions = content["descriptions"];

    }
  }

}
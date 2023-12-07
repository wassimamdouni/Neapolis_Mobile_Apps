import 'dart:convert';

class Service {

  int id = 0;
  String nom = "";
  String descreptions = "";
  double prix = 0;
  Service({int id=0,String fields=""}){
    if (fields != "") {
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      nom = content["nom"];
      descreptions =content["descreptions"] ?? "";
      prix=content["prix"];
    }
  }
}

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class ListTransfer {
  int id = 0;
  String address_depart = "";
  String address_fin = "";
  double prix = 0;

  ListTransfer({int id=0,String fields=""}){
    if(fields!=""){
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      address_depart = content["address_depart"];
      address_fin = content["address_fin"];
      prix = content["prix"];

    }
  }

}
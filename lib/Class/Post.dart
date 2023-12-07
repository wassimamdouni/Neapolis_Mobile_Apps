
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:neapolis_admin/main.dart';

class Post {
  int id = 0;
  String title = "";
  String descriptions = "";
  DateTime date_depart = DateTime.now();
  DateTime date_fin = DateTime.now();
  String lien = "";
  String photo = "${url}media/default_image.jpg";

  imageDown(String source)async{
    try{
      var storageRef = FirebaseStorage.instance.refFromURL("gs://neapoliscar-991a1.appspot.com/");
      var url  = storageRef.child(source).getDownloadURL();
      photo=await url;
    }catch(e){
      photo = "${url}media/default_image.jpg";
    }
  }

  Post({int id=0,String fields=""}){
    if(fields!=""){
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      title = content["title"];
      descriptions = content["title"];
      date_depart = DateTime.parse(content["date_depart"]);
      date_fin = DateTime.parse(content["date_fin"]);
      lien = content["lien"];
      imageDown(content["photo"]);

    }
  }

}
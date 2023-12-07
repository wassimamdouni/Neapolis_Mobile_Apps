
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:neapolis_admin/main.dart';

class Marquer {
  int id = 0;
  String nom = "";
  String logo = "${url}media/default_profile_picture.png";

  imageDown(String source)async{
    try{
      var storageRef = FirebaseStorage.instance.refFromURL("gs://neapoliscar-991a1.appspot.com/");
      var url  = storageRef.child(source).getDownloadURL();
      logo=await url;
    }catch(e){
      logo = "${url}media/default_profile_picture.png";
    }
  }

  Marquer({int id=0,String fields=""}){
    if(fields!=""){
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      nom = content["nom"];
      imageDown(content["logo"]);

    }
  }

}
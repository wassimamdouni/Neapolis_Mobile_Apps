
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:neapolis_admin/main.dart';

class Admin{
  int id = 0;
  String nom_prenom = "";
  String telephone = "";
  String email = "";
  String mot_de_passe = "";
  String photo ="${url}media/default_profile_picture.png";
  String statutAdmin= "Deactivated";

  imageDown(String source)async{
    try{
      var storageRef = FirebaseStorage.instance.refFromURL("gs://neapoliscar-991a1.appspot.com/");
      var url  = await storageRef.child(source).getDownloadURL();
      photo=url;
    }catch(e){
      photo = "${url}media/default_profile_picture.png";
    }
  }

  Admin({int id=0,String fields=""}){
    if(fields!=""){
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      nom_prenom = content["nom_prenom"];
      telephone = content["telephone"];
      email = content["email"];
      mot_de_passe = content["mot_de_passe"];
      imageDown(content["photo"]);
      statutAdmin = content["statutAdmin"]=='Activated'?"Activated":"Deactivated";

    }
  }


}
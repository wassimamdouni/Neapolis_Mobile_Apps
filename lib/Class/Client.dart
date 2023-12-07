
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:neapolis_admin/main.dart';

class Client {

  int id = 0;
  String nomprenom = "";

  String cin = "";
  String numeroparmis = "";

  String telephone = "";
  String email = "";
  String mot_de_passe = "";

  String paye = "";
  String ville = "";
  String region = "";
  String numerorue = "";
  String nomentrprise = "";

  String photo ="${url}media/default_profile_picture.png";
  String photo_cin_passport ="${url}media/default_image.jpg";
  String photo_parmis ="${url}media/default_image.jpg";

  int points = 0;

  String statutClient= "Deactivated";


  imageDownphoto(String source)async{
    try{
      var storageRef = FirebaseStorage.instance.refFromURL("gs://neapoliscar-991a1.appspot.com/");
      var url  = storageRef.child(source).getDownloadURL();
      photo=await url;
    }catch(e){
      photo = "${url}media/default_profile_picture.png";
    }
  }
  imageDownphoto_cin_passport(String source)async{
    try{
      var storageRef = FirebaseStorage.instance.refFromURL("gs://neapoliscar-991a1.appspot.com/");
      var url  = storageRef.child(source).getDownloadURL();
      photo_cin_passport=await url;
    }catch(e){
      photo_cin_passport = "${url}media/default_image.jpg";
    }
  }
  imageDownphoto_parmis(String source)async{
    try{
      var storageRef = FirebaseStorage.instance.refFromURL("gs://neapoliscar-991a1.appspot.com/");
      var url  = storageRef.child(source).getDownloadURL();
      photo_parmis=await url;
    }catch(e){
      photo_parmis = "${url}media/default_image.jpg";
    }
  }

  Client({int id=0,String fields=""}){
    if(fields!=""){
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      nomprenom = content["nomprenom"];

      cin = content["cin_passport"];
      numeroparmis = content["numeroparmis"];

      telephone = content["telephone"];
      email = content["email"];
      mot_de_passe = content["mot_de_passe"];

      paye = content["paye"];
      ville = content["ville"];
      region = content["region"];
      numerorue = content["numerorue"];
      nomentrprise = content["nomentrprise"];

      imageDownphoto(content["photo"]);
      imageDownphoto_cin_passport(content["photo_cin_passport"]);
      imageDownphoto_parmis(content["photo_parmis"]);

      points = content["points"];

      statutClient = content["statutClient"]=='Activated'?"Activated":"Deactivated";
    }
  }

}
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:neapolis_admin/main.dart';

class Gallery {

  int id = 0;
  String photo ="${url}media/default_image.jpg";
  String titleGallery = "";

  imageDown(String source)async{
    try{
      var storageRef = FirebaseStorage.instance.refFromURL("gs://neapoliscar-991a1.appspot.com/");
      var url  = storageRef.child(source).getDownloadURL();
      photo=await url;
    }catch(e){
      photo = "${url}media/default_image.jpg";
    }
  }

  Gallery({int id=0,String fields=""}){
    if (fields != "") {
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      imageDown(content["photo"]);
      titleGallery =content["descreptions"] ?? "";

    }
  }
}
// ignore_for_file: non_constant_identifier_names, await_only_futures

import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Class/Marquer.dart';
import 'package:neapolis_admin/Class/Options.dart';
import 'package:neapolis_admin/main.dart';
class Voiture{

  String numero_series = "";
  String modele = "";
  String class_voiture = "";
  String annee = "";

  String boite = "";
  int nb_seats = 0;
  int nb_bags = 0;
  int nb_ports = 0;

  Color color=Colors.white;

  String etat = "";
  String description = "";

  double caution= 0;
  double prix_jour = 0;

  String photo = "${url}media/default_image.jpg";
  Marquer? marquer = Marquer();
  List<Options> listoptions =[];


  getMarquer(int id) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetMarquer'));
    request.fields.addAll({
      'idMarquer': id.toString()
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Marquer"]);
        String fields =json.encode(body02[0]["fields"]);
        int id=body02[0]["pk"];
        marquer = await Marquer(fields: fields,id:id);
      }
    }
    else {}
  }

  getOptions(String id) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetOptions'));
    request.fields.addAll({
      'idVoiture': id.toString()
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Options"]);
        for (int i=0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Options option = await Options(fields: fields,id:id);
          listoptions.add(option);
        }

      }
    }
    else {}
  }

  imageDown(String source)async{
    try{
      var storageRef = FirebaseStorage.instance.refFromURL("gs://neapoliscar-991a1.appspot.com/");
      var url  = storageRef.child(source).getDownloadURL();
      photo=await url;
    }catch(e){
      photo = "${url}media/default_image.jpg";
    }
  }

  Voiture({String id="",String fields=""}){
    if(fields!=""){
      Map<String, dynamic> content =json.decode(fields);
      numero_series = id;
      modele = content["modele"];
      class_voiture = content["class_voiture"];
      annee = content["annee"];

      boite = content["boite"];
      nb_seats = content["nb_seats"];
      nb_bags = content["nb_bags"];
      nb_ports = content["nb_bags"];

      color = content["color"]!=''?Color(int.parse(content["color"])):color=Colors.white;
      etat = content["etat"];
      description = content["description"]??"";

      caution= content["caution"];
      prix_jour = content["prix_jour"];

      imageDown(content["photo"]);

      getMarquer(content["id_marquer"]);
      getOptions(id);
    }
  }
}

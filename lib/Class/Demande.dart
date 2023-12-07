
// ignore_for_file: await_only_futures

import 'dart:convert';

import 'package:neapolis_admin/Class/Client.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Class/Service.dart';
import 'package:neapolis_admin/main.dart';


class Demande {

  int id = 0;
  String type = "";
  DateTime date = DateTime.now();
  String etat = "";
  Client client = Client();
  int nbServise =0;
  List<Service> listService=[];


  getClient(int id) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetClient'));
    request.fields.addAll({
      'idClient': id.toString()
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Client"]);
        String fields =json.encode(body02[0]["fields"]);
        int id=body02[0]["pk"];
        client = await Client(fields: fields,id:id);
      }
    }
    else {}
  }

  getService(int id) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetService'));
    request.fields.addAll({
      'idDemande': id.toString()
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Services"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Service service =await Service(fields: fields,id:id);
          listService.add(service);
        }
        nbServise=await listService.length;
      }
    }
    else {}
  }

  Demande({int id=0,String fields=""}){
    if (fields != "") {
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      type = content["type"];
      date =DateTime.parse(content["date"]);
      etat = content["etat"];
      getClient(content["id_client"]);
      getService(id);


    }
  }

}
// ignore_for_file: non_constant_identifier_names, await_only_futures, unnecessary_this

import 'dart:convert';

import 'package:neapolis_admin/Class/Demande.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Class/Service.dart';
import 'package:neapolis_admin/Class/Voiture.dart';
import 'package:neapolis_admin/main.dart';
class Reservation{

  int id =0;
  DateTime date_depar = DateTime.now();
  String bureau_predre_la_voiture = "";
  String bureau_deposer_la_voiture = "";
  DateTime date_arriver = DateTime.now();
  double total_prix=0;
  int days=3;
  List<Service> listServises=[];
  Demande demande = Demande();
  Voiture voiture = Voiture();



  getDemande(int id) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetDemande'));
    request.fields.addAll({
      'idDemande': id.toString()
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Demande"]);
        String fields =json.encode(body02[0]["fields"]);
        int id=body02[0]["pk"];
        this.demande = await Demande(fields: fields,id:id);
        await Future.delayed(const Duration(seconds: 1));
        for(int i=0;i<demande.listService.length;i++){
          this.total_prix=await total_prix+demande.listService[i].prix;
        }
        this.listServises=await demande.listService;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    else {}
  }

  getVoiture(String id) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetVoiture'));
    request.fields.addAll({
      'idVoiture': id
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02= await json.decode(body01["Voiture"]);
        String fields =json.encode(body02[0]["fields"]);
        String id=body02[0]["pk"];
        this.voiture = await Voiture(fields: fields,id:id);
        this.days=await date_arriver.difference(date_depar).inDays;
        this.total_prix=await voiture.prix_jour*days + voiture.caution;
      }
    }
    else {}
  }

  Reservation({int id=0,String fields=""}){
    if(fields!=""){
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      this.bureau_predre_la_voiture = content["bureau_predre_la_voiture"];
      this.bureau_deposer_la_voiture = content["bureau_predre_la_voiture"];
      this.date_depar = DateTime.parse(content["date_depar"]);
      this.date_arriver = DateTime.parse(content["date_arriver"]);
      getVoiture(content["numero_series"]);
      getDemande(content["id_demande"]);
    }

  }
}

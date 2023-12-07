
// ignore_for_file: await_only_futures

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Class/Demande.dart';
import 'package:neapolis_admin/main.dart';

class Annulation {

  int id = 0;
  DateTime date = DateTime.now();
  String description = "";
  Demande demande = Demande();

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
        demande = await Demande(fields: fields,id:id);
      }
    }
    else {}
  }

  Annulation({int id=0,String fields=""}){
    if (fields != "") {
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      date = DateTime.parse(content["date"]);
      description = content["description"];
      getDemande(content["id_demande"]);
    }
  }

}
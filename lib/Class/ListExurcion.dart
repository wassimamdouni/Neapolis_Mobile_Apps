
// ignore_for_file: non_constant_identifier_names, await_only_futures

import 'dart:convert';

import 'package:neapolis_admin/Class/Gallery.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';

class ListExurcion {
  int id = 0;
  String address_depart = "";
  String description = "";
  double prix = 0;
  List<Gallery> listGallery=[];

  getGallery(int id) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetGallery'));
    request.fields.addAll({
      'idlistExurcion': id.toString()
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Gallerys"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Gallery gallery = await Gallery(fields: fields,id:id);
          listGallery.add(gallery);
        }
      }
    }
    else {}
  }

  ListExurcion({int id=0,String fields=""}){
    if(fields!=""){
      Map<String, dynamic> content =json.decode(fields);
      this.id = id;
      address_depart = content["address_depart"];
      description = content["description"]??"";
      prix = content["prix"];
      getGallery(id);
    }
  }

}
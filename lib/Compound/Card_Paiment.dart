

// ignore_for_file: must_be_immutable, camel_case_types, deprecated_member_use, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:neapolis_admin/Class/Paiment.dart';
import 'package:neapolis_admin/Compound/Card_PaimentDetails.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Page/Client%20Pages/ClientDetails_Page.dart';
import 'package:neapolis_admin/main.dart';






class Card_Paiment extends StatefulWidget {
  Paiment paiment;
  //

  Card_Paiment({required this.paiment});

  @override
  State<Card_Paiment> createState() => _Card_PaimentState(paiment: paiment);
}

class _Card_PaimentState extends State<Card_Paiment> {

  Paiment paiment;
  bool isInternet = false;
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  _Card_PaimentState({required this.paiment});

  getPaiment() async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetPaiment'));
    request.fields.addAll({
      'idPaiment': paiment.id.toString()
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Paiment"]);
        String fields =json.encode(body02[0]["fields"]);
        int id=body02[0]["pk"];
        setState(() {
          paiment = Paiment(fields: fields,id:id);
        });
      }
    }
    else {}
  }

  @override
  void initState() {
    getPaiment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child:Column(
        children: [
          ListTile(
            leading:InkWell(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage:NetworkImage(paiment.demande.client.photo),
                onBackgroundImageError:(exception, stackTrace) => Container(),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClientDetails_Page(client: paiment.demande.client),));
              },
            ),
            title:Text(paiment.demande.client.nomprenom,style: Theme.of(context).textTheme.headline5,),
            subtitle:Column(
              children: [
                Row(children:[
                  Text("Type Demande:", style: Theme.of(context).textTheme.bodyText2),
                  Text(" ${paiment.demande.type}",style: Theme.of(context).textTheme.bodyText1),
                ]),
                Row(children:[
                  Text("Methode Paiment :", style: Theme.of(context).textTheme.bodyText2),
                  Text(paiment.type,style: Theme.of(context).textTheme.bodyText1),
                ]),
              ],
            ),
            trailing:InkWell(
              child: const Icon(Icons.more_vert),
              onTap: () {
                showBottomSheet(
                    backgroundColor:Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    context: context, builder: (context) {
                  return Card_PaimentDetails(paiment: paiment);
                });
                },
            ),
          ),
          const Divider(thickness: 1,indent: 20,endIndent: 20,color: light_cobalt_blue_shade,),
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 24,bottom: 10),
              child: Row(
                children: [
                  Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(paiment.date), style: Theme.of(context).textTheme.bodyText1
                  ),
                  Text(" | ${paiment.prix} TND", style: Theme.of(context).textTheme.bodyText2
                  ),
                ],
              )),
        ],
      ),
    );
  }

}
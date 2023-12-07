

// ignore_for_file: must_be_immutable, camel_case_types, deprecated_member_use, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neapolis_admin/Class/Client.dart';
import 'package:neapolis_admin/Page/Client Pages/ClientDetails_Page.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';






class Card_Client extends StatefulWidget {
  Client client;
  //

  Card_Client({required this.client});

  @override
  State<Card_Client> createState() => _Card_ClientState(client: client);
}

class _Card_ClientState extends State<Card_Client> {

  Client client;
  bool isInternet = false;
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  _Card_ClientState({required this.client});

  getClient() async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetClient'));
    request.fields.addAll({
      'idClient': client.id.toString()
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Client"]);
        String fields =json.encode(body02[0]["fields"]);
        int id=body02[0]["pk"];
        setState(() {
          client = Client(fields: fields,id:id);
        });
      }
    }
    else {}
  }

  @override
  void initState() {
    getClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child:Column(
        children: [
          ListTile(
            leading:CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:NetworkImage(client.photo),
              onBackgroundImageError:(exception, stackTrace) => Container(),
            ),
            title:Row(
              children: [
                Text(client.nomprenom,style: Theme.of(context).textTheme.headline5,),
                Text(" ${client.statutClient}",style: Theme.of(context).textTheme.subtitle2!.apply(color:client.statutClient=="Activated"?Colors.green:cinnabar_red_shade),),
              ],
            ),
            subtitle:Column(
              children: [
                Row(
                  children: [
                    Text("N◦CIN/Passport: ",style: Theme.of(context).textTheme.bodyText2),
                    Text(client.cin,style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
                Row(
                  children: [
                    Text("N◦Permit: ",style: Theme.of(context).textTheme.bodyText2),
                    Text(client.numeroparmis,style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ],
            ),

            trailing:InkWell(
              child: const Icon(Icons.more_vert),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClientDetails_Page(client: client),));
              },
            ),
          ),
          const Divider(thickness: 1,indent: 20,endIndent: 20,color: light_cobalt_blue_shade,),
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 24,bottom: 10),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars,color: rajah_orange,size: 16,),
                      Text(" (${client.points} Points)",style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                  Text(
                      " | ${client.numerorue} ${client.region}, ${client.ville}, ${client.paye}",
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              )),
        ],
      ),
    );
  }

}
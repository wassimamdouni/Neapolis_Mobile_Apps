
// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_final_fields, await_only_futures, deprecated_member_use, must_be_immutable, no_logic_in_create_state


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/Client.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:neapolis_admin/Decoration/colors.dart';



class ClientDetails_Page extends StatefulWidget {

  Client client;
  ClientDetails_Page({required this.client});

  @override
  State<ClientDetails_Page> createState() => _ClientDetails_PageState(client: client);
}

class _ClientDetails_PageState extends State<ClientDetails_Page> {

  Client client;
  _ClientDetails_PageState({required this.client});

  bool isInternet = false;
  bool loading = true;
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

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
        Client c= await Client(fields: fields,id:id);
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          client = c;
          loading=false;
        });
      }
    }
    else {}
  }

  activateClient(String statut)async{

    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/ActivateClient'));
    request.fields.addAll({
      'idClient': client.id.toString(),
      'statutClient': statut,
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        setState(() {
          client.statutClient=statut;
        });

      }
    }
    else {}
  }

  showSnackBar(String message){
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Center(child: Text(message)),
      backgroundColor: Colors.blueGrey,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  testInternet()async{
    try {

      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isInternet = true;
        });

      }
    } on SocketException catch (_) {
      setState(() {
        isInternet = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    testInternet();
    getClient();
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    PopupMenuButton dropdown_menus =PopupMenuButton(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon:const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child:ListTile(
            leading: const Icon(Icons.phone,),
            title: const Text("Appeler"),
            onTap: () => launch("tel://${client.telephone}"),
          ),
        ),
        PopupMenuItem(
          child:ListTile(
            leading: const Icon(Icons.sms,),
            title: const Text("Envoyer SMS",),
            onTap: () => launch("sms:${client.telephone}"),
          ),
        ),
        PopupMenuItem(
          child:ListTile(
            leading: const Icon(Icons.mail,),
            title: const Text("Envoyer Mail"),
            onTap: () => launch("mailto:${client.email}"),
          ),
        ),
        const PopupMenuDivider(
          height: 2,
        ),
        PopupMenuItem(
          child:ListTile(
            leading: Icon(client.statutClient=="Activated"?Icons.key:Icons.key_off,),
            title: Text(client.statutClient=="Activated"?"Désactiver":'Activer',),
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Center(child: Text(client.statutClient=="Activated"?"Désactiver le compte":'Activer le compte',style: Theme.of(context).textTheme.subtitle2,)),
                  content: Text('Êtes-vous sûr de vouloir vous ${client.statutClient=="Activated"?"Désactiver":'Activer'} le compte ?',style: Theme.of(context).textTheme.bodyText1),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel',),
                      child: Text('Cancel',style: Theme.of(context).textTheme.bodyText1),
                    ),
                    TextButton(
                      onPressed: (){
                        activateClient(client.statutClient=="Activated"?"Deactivated":'Activated');
                        Navigator.pop(context, 'Ok',);
                      },
                      child: Text(client.statutClient=="Activated"?"Désactiver":'Activer',style: Theme.of(context).textTheme.subtitle2),

                    ),
                  ],
                ),
              );

            },
          ),
        ),

      ],
    );
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            dropdown_menus
          ],
          centerTitle: true,
        ),
        body:isInternet
            ?loading
            ?Center(
          child: LoadingAnimationWidget.prograssiveDots(
            color: Colors.white,
            size: 30,
          ),
        )
            :ListView(
          children: [
            //Photo
            CircleAvatar(
              maxRadius: 80,
              backgroundColor: Colors.grey,
              backgroundImage:NetworkImage(client.photo),
              onBackgroundImageError:(exception, stackTrace) => Container(),
            ),
            //Title
            Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(client.nomprenom,style: Theme.of(context).textTheme.headline4),
                    Text('(${client.statutClient})',style: Theme.of(context).textTheme.subtitle2!.apply(color:client.statutClient=="Activated"?Colors.greenAccent:cinnabar_red_shade),),
                  ],
                )),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.assignment),
                    Text("Information",style: Theme.of(context).textTheme.headline5),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,size: 24,color:rajah_orange),
                              Text("N◦CIN/Passport ",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(client.cin,style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,size: 24,color:rajah_orange),
                              Text("N◦Permit ",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(client.numeroparmis,style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.call),
                    Text("Contact",style: Theme.of(context).textTheme.headline5),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,size: 24,color:rajah_orange),
                              Text("Email",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(client.email,style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,size: 24,color:rajah_orange),
                              Text("N◦Telephone ",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(client.telephone,style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),

                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on),
                    Text("Adresse",style: Theme.of(context).textTheme.headline5),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,size: 24,color:rajah_orange),
                              Text("Paye",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(client.paye,style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,size: 24,color:rajah_orange),
                              Text("Ville",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(client.ville,style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,size: 24,color:rajah_orange),
                              Text("Region",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(client.region,style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,size: 24,color:rajah_orange),
                              Text("Adresse 01",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(client.numerorue,style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,size: 24,color:rajah_orange),
                              Text("Nom d'entreprise",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(client.nomentrprise,style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.description),
                    Text("Document",style: Theme.of(context).textTheme.headline5),
                  ],
                ),
                SizedBox(height: 16,)
              ],

            ),

            Row(
              children: [
                client.photo_cin_passport!="${url}media/default_image.jpg"?Expanded(
                  child: InkWell(
                    child: Image.network(client.photo_cin_passport,errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white,),),
                    onTap: () {
                      scaffoldKey.currentState!.showBottomSheet((context) => SizedBox(
                          height: double.infinity,
                          child: Image.network(client.photo_cin_passport,errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white,),)));
                    },
                  ),
                ):Container(),
                client.photo_parmis!="${url}media/default_image.jpg"?Expanded(
                  child: InkWell(
                    child: Image.network(client.photo_parmis,errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white,),),
                    onTap: () {
                      scaffoldKey.currentState!.showBottomSheet((context) => SizedBox(
                          height: double.infinity,
                          child: Image.network(client.photo_parmis,errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white,),)));
                    },
                  ),
                ):Container(),

              ],
            )
          ],
        )
            :const Center(child: Text("Aucune Connexion Internet"),)
    );
  }
}

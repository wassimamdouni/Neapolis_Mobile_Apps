


// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_final_fields, await_only_futures, deprecated_member_use, must_be_immutable, no_logic_in_create_state


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/Voiture.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Page/Voiture%20Pages/VoitureUpdate_Page.dart';
import 'package:neapolis_admin/main.dart';
import 'package:neapolis_admin/Decoration/colors.dart';



class VoitureDetails_Page extends StatefulWidget {

  Voiture voiture;
  VoitureDetails_Page({required this.voiture});

  @override
  State<VoitureDetails_Page> createState() => _VoitureDetails_PageState(voiture: voiture);
}

class _VoitureDetails_PageState extends State<VoitureDetails_Page> {

  Voiture voiture;
  bool isInternet = false;
  bool loading = true;
  _VoitureDetails_PageState({required this.voiture});

  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  getVoiture() async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetVoiture'));
    request.fields.addAll({
      'idVoiture': voiture.numero_series
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);

      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Voiture"]);
        String fields =json.encode(body02[0]["fields"]);
        String id=body02[0]["pk"];
        Voiture v = await Voiture(fields: fields,id:id);
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          voiture = v;
          loading=false;
        });
        await Future.delayed(const Duration(milliseconds: 500));
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
    getVoiture();
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VoitureUpdate_Page(voiture: voiture)));
            }, icon: const Icon(Icons.edit)
            )
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
            :PageView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius:BorderRadius.circular(8),
                                child:Image.network(voiture.photo,
                                  fit: BoxFit.fitWidth,
                                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),)
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: CircleAvatar(
                              backgroundColor: voiture.color,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(child: Text("${voiture.marquer!.nom} ${voiture.modele} ${voiture.class_voiture} ${voiture.annee}",style: Theme.of(context).textTheme.headline4)),
                  ),
                  Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.assignment),
                              Text(" Information",style: Theme.of(context).textTheme.headline5),
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
                                        const Icon(Icons.tag,size: 24,color:rajah_orange),
                                        Text(" Numéro Série",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text(voiture.numero_series,style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.title,size: 24,color:rajah_orange),
                                        Text(" Etat",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text(voiture.etat,style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.title,size: 24,color:rajah_orange),
                                        Text(" Modele",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text(voiture.modele,style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.title,size: 24,color:rajah_orange),
                                        Text(" Class Voiture",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text(voiture.class_voiture,style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.title,size: 24,color:rajah_orange),
                                        Text("Annee",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text(voiture.annee,style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.assignment),
                              Text(" Plus Détails ",style: Theme.of(context).textTheme.headline5),
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
                                        const Icon(Icons.speed,size: 24,color:rajah_orange),
                                        Text(" Boîte de Vitesse",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text(voiture.boite,style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.event_seat,size: 24,color:rajah_orange),
                                        Text(" Nombre de Places",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text("${voiture.nb_seats}",style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.luggage,size: 24,color:rajah_orange),
                                        Text(" Nombre de Bags",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text("${voiture.nb_bags}",style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.sim_card,size: 24,color:rajah_orange),
                                        Text(" Nombre de Portes",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text("${voiture.nb_bags}",style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.payments),
                              Text(" Prix Total: ${voiture.prix_jour+voiture.caution} TND/Jour",style: Theme.of(context).textTheme.headline5),
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
                                        const Icon(Icons.payments,size: 24,color:rajah_orange),
                                        Text(" Prix",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text("${voiture.prix_jour} TND/Jour",style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.payments,size: 24,color:rajah_orange),
                                        Text(" Caution",style: Theme.of(context).textTheme.bodyText2),
                                      ],
                                    ),
                                    Text("${voiture.caution} TND",style: Theme.of(context).textTheme.bodyText1),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.comment),
                      Text(" Description",style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(voiture.description,style: Theme.of(context).textTheme.bodyText1)
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.settings),
                      Text(" Options",style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      child:Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children:List<Widget>.generate(voiture.listoptions.length,(index) {
                          return Chip(
                            label:Tooltip(
                              showDuration: const Duration(seconds: 3),
                              message: voiture.listoptions[index].descriptions,
                              child: Text(voiture.listoptions[index].title),
                            ),
                          );
                        },)
                      )
                    ),
                  ),
                  const SizedBox(height: 16,)
                ],
              ),
            ),
          ],
        )
            :const Center(child: Text("Aucune Connexion Internet"),)
    );
  }
}


// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, await_only_futures, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/Annulation.dart';
import 'package:neapolis_admin/Compound/Menu_Bar.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Page/Client%20Pages/ClientDetails_Page.dart';
import 'package:neapolis_admin/main.dart';

class List_of_Annulation_Page extends StatefulWidget {
  @override
  State<List_of_Annulation_Page> createState() => _List_of_Annulation_PageState();
}

class _List_of_Annulation_PageState extends State<List_of_Annulation_Page> {

  bool isInternet = false;
  bool loading = false;

  int result_total=0;
  List<Annulation>? listAnnulation=[];



  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  getAllAnnulations()async{
    setState(() {
      listAnnulation=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllAnnulation'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Annulations"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Annulation annulation =await Annulation(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listAnnulation!.add(annulation);
            result_total=listAnnulation!.length;
            loading=false;
          });
          await Future.delayed(const Duration(milliseconds: 500));
        }
        setState(() {
          loading=false;
        });
      }
    }
    else {}
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
  void initState(){
    testInternet();
    getAllAnnulations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: Image.asset(
            isThemeLight
                ?"images/App_Icon/App_icon.png"
                :"images/App_Icon/App_icon_dark.png",
          ),
          actions: [
            Builder(builder: (context) =>IconButton(
                icon: const Icon(Icons.menu),
                onPressed: ()=>Scaffold.of(context).openEndDrawer()
            ),),
            const SizedBox(width: 5,),
          ],
          title:const Text("List de Annulations"),
        ),
        endDrawer:Menu_Bar(),

        body:isInternet
            ?loading
            ?Center(
          child: LoadingAnimationWidget.prograssiveDots(
            color: Colors.white,
            size: 30,
          ),
        )
            :result_total!=0
            ?ListView.builder(
          itemCount: result_total,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:Column(
                children: [
                  ListTile(
                    leading:InkWell(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:NetworkImage(listAnnulation![index].demande.client.photo),
                        onBackgroundImageError:(exception, stackTrace) => Container(),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ClientDetails_Page(client: listAnnulation![index].demande.client),));
                      },
                    ),
                    title:Text(listAnnulation![index].demande.client.nomprenom,style: Theme.of(context).textTheme.headline5,),
                    subtitle:Column(
                      children: [
                        Row(children:[
                          Text("Type Demande:", style: Theme.of(context).textTheme.bodyText2),
                          Text(" ${listAnnulation![index].demande.type}",style: Theme.of(context).textTheme.bodyText1),
                        ]),
                        Row(children:[
                          Text("Type Demande: ", style: Theme.of(context).textTheme.bodyText2),
                          Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(listAnnulation![index].date),style: Theme.of(context).textTheme.bodyText1),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        )
            :const Center(child:Text("Aucune Annulation"))
            :const Center(child: Text("Aucune Connexion Internet"),)

    );
  }
}


// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, await_only_futures

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/Paiment.dart';
import 'package:neapolis_admin/Compound/Card_Paiment.dart';
import 'package:neapolis_admin/Compound/Menu_Bar.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';



class List_of_Paiment_Page extends StatefulWidget {
  @override
  State<List_of_Paiment_Page> createState() => _List_of_Paiment_PageState();
}

class _List_of_Paiment_PageState extends State<List_of_Paiment_Page> {

  bool isInternet = false;
  bool loading = false;

  int result_total=0;
  List<Paiment>? listPaiment=[];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  getAllPaiments()async{
    setState(() {
      listPaiment=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllPaiment'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Paiments"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Paiment paiment =await Paiment(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listPaiment!.add(paiment);
            result_total=listPaiment!.length;
            loading=false;
          });
          await Future.delayed(const Duration(milliseconds: 500));
        }
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
    getAllPaiments();
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
          title:const Text("List de Paiments"),
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
            return Card_Paiment(paiment: listPaiment![index]);
          },
        )
            :const Center(child:Text("Aucune Paiment"))
            :const Center(child: Text("Aucune Connexion Internet"),)

    );
  }
}

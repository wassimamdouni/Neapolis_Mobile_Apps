
// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, await_only_futures

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/Client.dart';
import 'package:neapolis_admin/Compound/Card_Client.dart';
import 'package:neapolis_admin/Compound/Menu_Bar.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';



class List_of_Client_Page extends StatefulWidget {
  @override
  State<List_of_Client_Page> createState() => _List_of_Client_PageState();
}

class _List_of_Client_PageState extends State<List_of_Client_Page> {

  bool isInternet = false;
  bool loading = true;

  String searchValue="";
  bool clear_Search =false;

  int result_total=0;
  List<Client>? listClient=[];

  TextEditingController search_controller=TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  getAllClients()async{
    setState(() {
      listClient=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllClient'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Clients"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Client client =await Client(fields: fields,id:id);
          setState(() {
            listClient!.add(client);
            result_total=listClient!.length;
            loading=false;
          });
          await await Future.delayed(const Duration(seconds: 1));
        }
        setState(() {
          loading=false;
        });
      }
    }
    else {}
  }

  SearchClient(String value)async{
    setState(() {
      listClient=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/SearchClient'));
    request.fields.addAll({
      'searchValue': value,
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Clients"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Client client =Client(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listClient!.add(client);
            result_total=listClient!.length;
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
    getAllClients();
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
            IconButton(icon: const Icon(Icons.search), onPressed: () {
              scaffoldKey.currentState!.showBottomSheet((context){
                return Column(
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                        return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: search_controller,
                            keyboardType: TextInputType.emailAddress,
                            decoration:InputDecoration(
                              hintText: 'Chercher',
                              prefixIcon: const Icon(Icons.search) ,
                              suffixIcon:searchValue==''?null:IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    searchValue="";
                                    search_controller.clear();
                                    getAllClients();
                                  });
                                },
                              ),
                            ),
                            onChanged:(value) {
                              setState((){
                                searchValue=value;
                                listClient=[];
                                result_total=0;
                              });
                              if(value!=''){
                                SearchClient(value);
                              }

                            },
                          ),
                        ),
                      );
                      },
                    ),
                  ],
                );
              },
                backgroundColor:Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)
                ),
              );
            }),
            const SizedBox(width: 5,),
            Builder(builder: (context) =>IconButton(
                icon: const Icon(Icons.menu),
                onPressed: ()=>Scaffold.of(context).openEndDrawer()
            ),),
            const SizedBox(width: 5,),
          ],
          title:const Text("List de Clients"),
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
            return Card_Client(client: listClient![index]);
          },
        )
            :const Center(child:Text("Aucune Client"))
            :const Center(child: Text("Aucune Connexion Internet"),)

    );
  }
}

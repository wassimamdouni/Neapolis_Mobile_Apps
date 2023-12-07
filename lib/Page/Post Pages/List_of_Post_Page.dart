//List_of_Post_Page


// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, body_might_complete_normally_nullable, camel_case_types, non_constant_identifier_names, await_only_futures, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/Post.dart';
import 'package:neapolis_admin/Compound/Card_Post.dart';
import 'package:neapolis_admin/Compound/Menu_Bar.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:neapolis_admin/main.dart';



class List_of_Post_Page extends StatefulWidget {
  @override
  State<List_of_Post_Page> createState() => _List_of_Post_PageState();
}

class _List_of_Post_PageState extends State<List_of_Post_Page> {


  bool isInternet = false;
  bool loading = true;

  int result_total_Post=0;
  List<Post> listPost=[];

  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  getAllPosts()async{
    setState(() {
      listPost=[];
      result_total_Post=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllPost'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Posts"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Post post =Post(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listPost.add(post);
            result_total_Post=listPost.length;
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
  void initState(){
    testInternet();
    getAllPosts();
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
            const SizedBox(width: 5,),
            Builder(builder: (context) =>IconButton(
                icon: const Icon(Icons.menu),
                onPressed: ()=>Scaffold.of(context).openEndDrawer()
            ),),
            const SizedBox(width: 16,),
          ],
          title:const Text("List de Posts"),
        ),
        endDrawer:Menu_Bar(),
        floatingActionButton: isInternet?Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 50),
          child: FloatingActionButton(onPressed: () =>Navigator.pushNamed(context, "PostInsertion Page"),
              backgroundColor: rajah_orange,
              child:const Icon(Icons.add)),
        ):Container(),

        body:isInternet
            ?loading
            ?Center(
          child: LoadingAnimationWidget.prograssiveDots(
            color: Colors.white,
            size: 30,
          ),
        )
            :result_total_Post!=0
            ?ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: result_total_Post,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Card_Post(post: listPost[index]);
          },
        )
            :const Center(child: Text("Aucune Post"))
            :const Center(child: Text("Aucune Connexion Internet"),)

    );
  }
}

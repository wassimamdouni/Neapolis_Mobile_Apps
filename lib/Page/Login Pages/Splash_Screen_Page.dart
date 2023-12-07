
// ignore_for_file: use_build_context_synchronously, camel_case_types, file_names, use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Splash_Screen_Page extends StatefulWidget{
  @override
  State<Splash_Screen_Page> createState()=>_Splash_Screen_PageState();

}
class _Splash_Screen_PageState extends State<Splash_Screen_Page>{

  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;
  bool isInternet = false;
  bool loginComplete =false;
  bool login =false;
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
        showSnackBar("Aucune Connexion Internet");
      });
    }
  }

  testLogin()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool login01 = prefs.getBool('login') ??false;
    if(login01){
      String email = prefs.getString('email') ??"";
      String password = prefs.getString('password') ??"";
      var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Test_Login_Admin'));
      request.fields.addAll({
        'email': email,
        'password': password
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString =await response.stream.bytesToString();
        Map<String, dynamic> body=json.decode(responseString);
        login=body["Response"]=="Success"?true:false;
        loginComplete=true;
      }
    }
    else{
      loginComplete=true;
    }
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      testInternet();
      if(isInternet) {
        testLogin();
        if(loginComplete) {

          if(login) {
            Navigator.pushReplacementNamed(context, "List of Reservation Page");
          } else {
            Navigator.pushReplacementNamed(context, "SignIn Page");
          }
          timer.cancel();
        }
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Image.asset(
              isThemeLight
                  ?"images/Image_Sets/Image_sets.png"
                  :"images/Image_Sets/Image_sets_dark.png",
            ),
          ),
          LoadingAnimationWidget.prograssiveDots(
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }

}


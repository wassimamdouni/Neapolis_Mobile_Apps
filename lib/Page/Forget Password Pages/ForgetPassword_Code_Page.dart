
// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPassword_Code_Page extends StatefulWidget {

  const ForgetPassword_Code_Page({Key? key}) : super(key: key);

  @override
  State<ForgetPassword_Code_Page> createState() => _ForgetPassword_Code_PageState();
}

class _ForgetPassword_Code_PageState extends State<ForgetPassword_Code_Page> {
  bool showState = true;
  String email = "";
  TextEditingController email_controller = TextEditingController();
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  String email_Error="";
  bool email_Validation=false;


  showSnackBar(String message){
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Center(child: Text(message)),
      backgroundColor: Colors.blueGrey,

    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  validation(){
    setState(() {
      email=email_controller.text;
      email_Validation=false;
      if (email=="") {
        email_Error = "La valeur ne peut pas être vide";
        email_Validation=true;
      }
      else if (!email.contains("@")) {
        email_Error = "L'adresse e-mail doit contenir un '@'";
        email_Validation=true;
      }
      else{
        email_Validation=false;
      }
    });
  }

  testInternet()async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      }
    } on SocketException catch (_) {

      showSnackBar("Aucune Connexion Internet");
    }
  }

  sendCode() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Forget_Password_Admin'));
    request.fields.addAll({
      'email': email
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body=json.decode(responseString);
      setState((){
        switch(body["Response"]){
          case "Exist" :
            prefs.setString('email',email);
            Navigator.pushNamed(context, "Check_ForgetPassword_Code Page");
            break;
          case "Not Exist" :
            email_Validation=true;
            email_Error="L’adresse e-mail n’est pas associé(e) à un compte";
            break;
          case "Deactivated" :
            showSnackBar("Compte Désactivé");
            break;
          case "Failed" :
            showSnackBar("Failed");
            break;
          default:
            email_Validation=true;
        }

      });
    }
    else {
      showSnackBar("StatusCode 505");
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body:ListView(
        padding:const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          //logo
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Image.asset(
              isThemeLight
                  ?"images/Image_Sets/Image_sets.png"
                  :"images/Image_Sets/Image_sets_dark.png",

            ),
          ),
          //Text Field of Login
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(8),
                child:Text("Email", style:Theme.of(context).textTheme.subtitle1,),
              ),
              TextFormField(
                controller: email_controller,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black45),
                decoration:InputDecoration(
                  hintText: 'Entrez l\'adresse e-mail',
                  errorText: email_Validation?email_Error:null,
                  prefixIcon: const Icon(Icons.email_rounded,) ,
                ),
              ),
            ],
          ),
          //Submit Button
          Container(
            margin:  const EdgeInsets.all(16),
            child: ElevatedButton(
                onPressed: ()async{
                  validation();
                  if(!email_Validation){
                    testInternet();
                    sendCode();
                  }
                },
                child:const Text("Se Connecter")
            ),
          ),
        ],
      ),
    );
  }
}

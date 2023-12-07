
// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, camel_case_types, non_constant_identifier_names, use_build_context_synchronously,, file_names file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Check_ForgetPassword_Code_Page extends StatefulWidget {

  @override
  State<Check_ForgetPassword_Code_Page> createState() => _Check_ForgetPassword_Code_PageState();
}

class _Check_ForgetPassword_Code_PageState extends State<Check_ForgetPassword_Code_Page> {
  bool resendEnable = true;
  String code='';
  String chiffre01 = "";
  String chiffre02 = "";
  String chiffre03 = "";
  String chiffre04 = "";
  TextEditingController chiffre01_controller = TextEditingController();
  TextEditingController chiffre02_controller = TextEditingController();
  TextEditingController chiffre03_controller = TextEditingController();
  TextEditingController chiffre04_controller = TextEditingController();

  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  showSnackBar(String message){
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Center(child: Text(message)),
      backgroundColor: Colors.blueGrey,

    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  validation() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Validation_Forget_Password'));
    request.fields.addAll({
      'email': email.toString(),
      'code':code
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body=json.decode(responseString);
      if(body["Response"]=="Success") {
        Navigator.pushNamed(context, "NewPassword Page");
      }
      else if(body["Response"]=="Not Correct") {
        showSnackBar(" Incorrect");
      }
      else if(body["Response"]=="Deactivated") {
        showSnackBar("Compte Désactivé");
      }
      else if(body["Response"]=="Failed") {
        showSnackBar("Failed");
      }


    }
    else {
      showSnackBar("StatusCode 505");
    }

  }

  resend_Code() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Resend_Code_Forget_Password'));
    request.fields.addAll({
      'email': email.toString(),
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body=json.decode(responseString);
      if(body["Response"]=="Success") {
        showSnackBar("Success");
      }else if(body["Response"]=="Deactivated") {
        showSnackBar("Compte Désactivé");
      }else if(body["Response"]=="Failed") {
        showSnackBar("Failed");
      }
    }

    else {
      showSnackBar("StatusCode 505");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding:const EdgeInsets.all(16),
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
          //title
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(16),
            child:Text("Vérification Rapide", style:Theme.of(context).textTheme.headline1,),
          ),
          //Information
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(8),
            child:Text("Entrez le code de vérification à 6 chiffres envoyé à Votre adresse e-mail",
              style:Theme.of(context).textTheme.bodyText1,),
          ),
          //Text Field of Code
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: TextFormField(
                    controller: chiffre01_controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration:const InputDecoration(
                      counterText: "",
                      hintText: '0',
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: TextFormField(
                    controller: chiffre02_controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration:const InputDecoration(
                      counterText: "",
                      hintText: '0',
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: TextFormField(
                    controller: chiffre03_controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration:const InputDecoration(
                      counterText: "",
                      hintText: '0',
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: TextFormField(
                    controller: chiffre04_controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration:const InputDecoration(
                      counterText: "",
                      hintText: '0',
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Submit
          Container(
            margin:  const EdgeInsets.all(16),
            child: ElevatedButton(
              child:const Text("Continuer"),
              onPressed: (){
                code = chiffre01_controller.text
                    +chiffre02_controller.text
                    +chiffre03_controller.text
                    +chiffre04_controller.text;
                validation();
              },
            ),
          ),
          //Code not Received ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Code non reçu, ", style:Theme.of(context).textTheme.subtitle1,),
              InkWell(
                splashColor:rajah_orange,
                child:Text(resendEnable?"Renvoyer le code?":"Renvoyer le code?(Après 5 Minutes)", style:Theme.of(context).textTheme.subtitle1?.apply(color: resendEnable?cinnabar_red:Colors.grey),),
                onTap: (){
                  if (resendEnable) {
                    setState(() {
                      resendEnable=false;
                    });
                    resend_Code();
                    Timer.periodic(const Duration(minutes: 5), (timer) {
                      setState(() {
                        resendEnable=true;
                      });
                    });
                  }
                },
              ),
            ],
          ),



        ],
      ),
    );
  }
}

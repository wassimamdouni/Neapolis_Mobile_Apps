
// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, deprecated_member_use, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NewPassword_Page extends StatefulWidget {

  @override
  State<NewPassword_Page> createState() => _NewPassword_PageState();
}

class _NewPassword_PageState extends State<NewPassword_Page> {
  bool showState1 = true;
  bool showState2 = true;
  String new_Password = "";
  String confirm_Password = "";
  TextEditingController new_Password_controller = TextEditingController();
  TextEditingController confirm_Password_controller = TextEditingController();

  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  String new_Password_Error="";
  String confirm_Password_Error="";
  bool new_Password_Validation=false;
  bool confirm_Password_Validation=false;



  validation(){
    setState(() {
      new_Password=new_Password_controller.text;
      confirm_Password=confirm_Password_controller.text;
      new_Password_Validation=false;
      confirm_Password_Validation=false;

      if (new_Password=="") {
        new_Password_Error = "La valeur ne peut pas être vide";
        new_Password_Validation=true;
      }
      else if (confirm_Password=="") {
        confirm_Password_Error = "La valeur ne peut pas être vide";
        confirm_Password_Validation=true;
      }
      else if (confirm_Password!=new_Password) {
        confirm_Password_Error = "Les mots de passe ne correspondent pas !";
        confirm_Password_Validation=true;
      }
      else{
        new_Password_Validation=false;
        confirm_Password_Validation=false;
      }
    });
  }

  login() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/New_Password_Admin'));
    request.fields.addAll({
      'email': email.toString(),
      'new_password': confirm_Password
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body=json.decode(responseString);
      setState((){

        if (body["Response"]=="Success"){
          prefs.remove("email");
          Navigator.pushReplacementNamed(context, "SignIn Page");
        }
        else if (body["Response"]=="Failed") {
          showSnackBar("Failed");
          new_Password_Validation = false;
          confirm_Password_Validation = false;
        }
      });
    }
    else {
      showSnackBar("StatusCode 505");
    }

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

      }
    } on SocketException catch (_) {

      showSnackBar("Aucune Connexion Internet");
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
          //Text Field of New Password
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(8),
                child:Text("Le nouveau mot de passe", style:Theme.of(context).textTheme.subtitle1,),
              ),
              TextFormField(
                controller: new_Password_controller,
                keyboardType: TextInputType.visiblePassword,
                style:  const TextStyle(color: Colors.black45),
                obscureText: showState1,
                decoration:InputDecoration(
                  hintText: 'Entrer Le nouveau mot de passe',
                  errorText: new_Password_Validation?new_Password_Error:null,
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon:InkWell(
                    onTap: (){setState(() {
                      showState1=!showState1;
                    });},
                    child:Icon(showState1?Icons.visibility:Icons.visibility_off,size: 24,),
                  ),
                ),
              ),
            ],
          ),
          //Text Field of Confirm Password
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(8),
                child:Text("Le confirme mot de passe",
                  style:Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextFormField(
                controller: confirm_Password_controller,
                keyboardType: TextInputType.visiblePassword,
                style:  const TextStyle(color: Colors.black45),
                obscureText: showState2,
                decoration:InputDecoration(
                  hintText: 'Confirmez le mot de passe',
                  errorText: confirm_Password_Validation?confirm_Password_Error:null,
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon:InkWell(
                    onTap: (){setState(() {
                      showState2=!showState2;
                    });},
                    child:Icon(showState2?Icons.visibility:Icons.visibility_off,size: 24,),
                  ),
                ),
              ),
            ],
          ),
          //Submit Button
          Container(
            margin:  const EdgeInsets.all(16),
            child: ElevatedButton(
                onPressed: (){
                  validation();
                  if(!new_Password_Validation && !confirm_Password_Validation){
                    testInternet();
                    login();
                  }
                },
                child:const Text("S'enregister")
            ),
          ),
        ],
      ),
    );
  }
}


// ignore_for_file: deprecated_member_use, camel_case_types, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SignIn_Page extends StatefulWidget {

  const SignIn_Page({Key? key}) : super(key: key);

  @override
  State<SignIn_Page> createState() => _SignIn_PageState();
}

class _SignIn_PageState extends State<SignIn_Page> {
  bool showState = true;
  String email = "";
  String password = "";
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  String email_Error="";
  String password_Error="";
  bool email_Validation=false;
  bool password_Validation=false;



  validation(){
    setState(() {
      email=email_controller.text;
      password=password_controller.text;
      email_Validation=false;
      password_Validation=false;
      if (email=="") {
        email_Error = "La valeur ne peut pas être vide";
        email_Validation=true;
      }
      else if (!email.contains("@")) {
        email_Error = "L'adresse e-mail doit contenir un '@'";
        email_Validation=true;
      }
      else if (password=="") {
        password_Error = "La valeur ne peut pas être vide";
        password_Validation=true;
      }
      else{
        email_Validation=false;
        password_Validation=false;
      }
    });
  }

  login() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Login_Admin'));
    request.fields.addAll({
      'email': email,
      'password': password
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body=json.decode(responseString);
      setState((){
        switch(body["Response"]){
          case "Activated" :
            prefs.setString('email',email);
            prefs.setString('password',password);
            Navigator.pushNamed(context, "Check_Login_Code Page");
            break;
          case "Not Exist" :
            email_Validation=true;
            email_Error="L’adresse e-mail n’est pas associé(e) à un compte";
            break;
          case "Password Incorrect" :
            password_Validation=true;
            password_Error="Le mot de passe est incorrect";
            break;
          case "Deactivated" :
            showSnackBar("Compte Désactivé");
            break;
          case "Failed" :
            showSnackBar("Failed");
            break;
          default:
            email_Validation=false;
            password_Validation=false;
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
      body:ListView(
        padding:const EdgeInsets.symmetric(horizontal: 16),
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
          //Bienvenue
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(16),
            child:Text("Bienvenue", style:Theme.of(context).textTheme.headline1,),
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
          //Text Field of Password
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(8),
                child:Text("Mot de passe",
                  style:Theme.of(context).textTheme.subtitle1,
                ),
              ),
              TextFormField(
                controller: password_controller,
                keyboardType: TextInputType.visiblePassword,
                style:  const TextStyle(color: Colors.black45),
                obscureText: showState,
                decoration:InputDecoration(
                  hintText: 'Entrer le mot de passe',
                  errorText: password_Validation?password_Error:null,
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon:InkWell(
                    onTap: (){setState(() {
                      showState=!showState;
                    });},
                    child:Icon(showState?Icons.visibility:Icons.visibility_off,size: 24,),
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
                  if(!email_Validation && !password_Validation){
                    testInternet();
                    login();
                  }
                },
                child:const Text("Se Connecter")
            ),
          ),
          //Forget Password
          Center(
            child: InkWell(
              child:Text("Mot de passe oublié ?", style:Theme.of(context).textTheme.subtitle1),
              onTap: ()=>Navigator.pushNamed(context, "ForgetPassword_Code Page"),
            ),
          ),


        ],
      ),
    );
  }
}

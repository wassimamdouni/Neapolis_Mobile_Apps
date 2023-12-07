// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:neapolis_admin/Page/AdminSetting.dart';
import 'package:neapolis_admin/Page/Annulation%20Pages/List_of_Annulation_Page.dart';
import 'package:neapolis_admin/Page/Client%20Pages/List_of_Client_Page.dart';
import 'package:neapolis_admin/Page/Exurcion%20Pages/List_of_Exurcion_Page.dart';
import 'package:neapolis_admin/Page/Forget%20Password%20Pages/Check_ForgetPassword_Code_Page.dart';
import 'package:neapolis_admin/Page/Forget%20Password%20Pages/ForgetPassword_Code_Page.dart';
import 'package:neapolis_admin/Page/Forget%20Password%20Pages/New_Password.dart';
import 'package:neapolis_admin/Page/Login%20Pages/Check_Login_Code_Page.dart';
import 'package:neapolis_admin/Page/Login%20Pages/SignIn_Page.dart';
import 'package:neapolis_admin/Decoration/standard_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:neapolis_admin/Page/Paiment%20Pages/List_of_Paiment_Page.dart';
import 'package:neapolis_admin/Page/Post%20Pages/List_of_Post_Page.dart';
import 'package:neapolis_admin/Page/Post%20Pages/PostInsertion_Page.dart';
import 'package:neapolis_admin/Page/Reservation%20Pages/List_of_Reservation_Page.dart';
import 'package:neapolis_admin/Page/Login Pages/Splash_Screen_Page.dart';
import 'package:neapolis_admin/Page/Transfer%20Pages/List_of_Transfer_Page.dart';
import 'package:neapolis_admin/Page/Voiture%20Pages/List_of_Voiture_Page.dart';
import 'package:neapolis_admin/Page/Voiture%20Pages/VoitureInsertion_Page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:neapolis_admin/firebase_api.dart';
import 'firebase_options.dart';

const String url="https://backend-liard-three.vercel.app/";

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: Themes_App.lightTheme,
      darkTheme: Themes_App.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: 'Splash_Screen Page',

      routes: {
        'Splash_Screen Page' : (context) =>Splash_Screen_Page(),
        'SignIn Page' : (context) =>const SignIn_Page(),
        'Check_Login_Code Page' : (context) =>Check_Login_Code_Page(),
        'Check_ForgetPassword_Code Page' : (context) =>Check_ForgetPassword_Code_Page(),
        'ForgetPassword_Code Page' : (context) => const ForgetPassword_Code_Page(),
        'NewPassword Page' : (context) => NewPassword_Page(),
        'List of Reservation Page' : (context) => List_of_Reservation_Page(),
        'List of Client Page' : (context) => List_of_Client_Page(),
        'List of Voiture Page' : (context) => List_of_Voiture_Page(),
        'VoitureInsertion Page' : (context) => VoitureInsertion_Page(),
        'AdminSetting Page' : (context) => AdminSetting_Page(),
        'List of Transfer Page' : (context) => List_of_Transfer_Page(),
        'List of Exurcion Page' : (context) => List_of_Exurcion_Page(),
        'List of Post Page' : (context) => List_of_Post_Page(),
        'PostInsertion Page' : (context) => PostInsertion_Page(),
        'List of Paiment Page' : (context) => List_of_Paiment_Page(),
        'List of Annulation Page' : (context) => List_of_Annulation_Page(),


      },
    );
  }
}

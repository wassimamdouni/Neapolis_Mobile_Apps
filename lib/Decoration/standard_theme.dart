
// ignore_for_file: camel_case_types, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neapolis_admin/Decoration/colors.dart';

class Themes_App {
  static final lightTheme =ThemeData(
      scaffoldBackgroundColor: alice_blue,

      drawerTheme: const DrawerThemeData(
        backgroundColor: light_cobalt_blue
      ),
      appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          titleTextStyle:TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
              color: indigo_blue,
              fontFamily:"Rubik"
          ),
          iconTheme: IconThemeData(
              color: indigo_blue,
              size: 24
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              statusBarColor:alice_blue,
              systemNavigationBarColor: alice_blue,
              systemNavigationBarDividerColor: alice_blue

          )
      ),

      iconTheme: const IconThemeData(color: indigo_blue),

      cardTheme: CardTheme(
        color:Colors.white,
        margin: const EdgeInsets.all(5),
        elevation: 2,
        shadowColor: indigo_blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      listTileTheme: const ListTileThemeData(
          iconColor:light_cobalt_blue,
          titleTextStyle: TextStyle(color:light_cobalt_blue,letterSpacing: 0.4)
      ),

      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor:indigo_blue,
        suffixIconColor:indigo_blue,

        hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5, color:light_cobalt_blue_shade, fontFamily:"Rubik"),

        filled: true,
        fillColor:Colors.white,
        alignLabelWithHint: true,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(width: 2, color:indigo_blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(width: 2, color:indigo_blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(width: 2, color:indigo_blue),
        ),
      ),

      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color:alice_blue,
              fontFamily:"Rubik"
          )),
          elevation: MaterialStatePropertyAll(2),
          backgroundColor: MaterialStatePropertyAll(indigo_blue),
          alignment: Alignment.center,
          padding: MaterialStatePropertyAll(EdgeInsets.all(16)),
          shape: MaterialStatePropertyAll(StadiumBorder()),
        ),
      ),

      //color: light_cobalt_blue,
      textTheme:const TextTheme(
        headline1: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            color: rajah_orange,
            fontFamily:"Rubik"
        ),
        headline2: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
            color: light_cobalt_blue,
            fontFamily:"Rubik"
        ),
        headline3: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: light_cobalt_blue,
            fontFamily:"Rubik"
        ),
        headline4: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
            color: rajah_orange,
            fontFamily:"Rubik"
        ),
        headline5: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            color: indigo_blue,
            fontFamily:"Rubik"
        ),
        headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.15,
            color: light_cobalt_blue,
            fontFamily:"Rubik"
        ),
        subtitle1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: light_cobalt_blue,
            fontFamily:"Rubik"
        ),
        subtitle2: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: rajah_orange,
            fontFamily:"Rubik"
        ),
        bodyText1: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            color:light_cobalt_blue,
            fontFamily:"Rubik"
        ),
        bodyText2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
            color:rajah_orange,
            fontFamily:"Rubik"
        ),
        button:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color:alice_blue,
            fontFamily:"Rubik"
        ),
        caption: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: Colors.black,
            fontFamily:"Rubik"
        ),
      )


  );

  static final darkTheme =ThemeData(
      scaffoldBackgroundColor: indigo_blue,

      drawerTheme: const DrawerThemeData(
          backgroundColor: indigo_blue
      ),

      appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          titleTextStyle:TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
              color: alice_blue,
              fontFamily:"Rubik"
          ),
          iconTheme: IconThemeData(
              color: alice_blue,
              size: 24
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            statusBarColor:indigo_blue,
            systemNavigationBarColor: indigo_blue,
            systemNavigationBarDividerColor: indigo_blue,
          )
      ),

      iconTheme: const IconThemeData(color: alice_blue),

      cardTheme: CardTheme(
        color:light_cobalt_blue,
        margin: const EdgeInsets.all(5),
        elevation: 2,
        shadowColor: indigo_blue_shade,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      listTileTheme: const ListTileThemeData(
          iconColor:indigo_blue,
          titleTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.25,
              color:indigo_blue,
              fontFamily:"Rubik"
          ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor:light_cobalt_blue,
        suffixIconColor:light_cobalt_blue,

        hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: Colors.black12,fontFamily:"Rubik"),

        filled: true,
        fillColor:light_cobalt_blue_shade,

        alignLabelWithHint: true,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 2, color:light_cobalt_blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 2, color:light_cobalt_blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 2, color:light_cobalt_blue),
        ),
      ),

      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll(TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color:alice_blue,
              fontFamily:"Rubik"
          )),
          elevation: MaterialStatePropertyAll(2),
          backgroundColor: MaterialStatePropertyAll(rajah_orange),
          alignment: Alignment.center,
          padding: MaterialStatePropertyAll(EdgeInsets.all(16)),
          shape: MaterialStatePropertyAll(StadiumBorder()),
        ),
      ),

      //color: light_cobalt_blue,
      textTheme:const TextTheme(
        headline1: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            color: rajah_orange,
            fontFamily:"Rubik"
        ),
        headline2: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
            color: light_cobalt_blue,
            fontFamily:"Rubik"
        ),
        headline3: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: light_cobalt_blue,
            fontFamily:"Rubik"
        ),
        headline4: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
            color: rajah_orange,
            fontFamily:"Rubik"
        ),
        headline5: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            color: alice_blue,
            fontFamily:"Rubik"
        ),
        headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.15,
            color: light_cobalt_blue,
            fontFamily:"Rubik"
        ),
        subtitle1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: alice_blue,
            fontFamily:"Rubik"
        ),
        subtitle2: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: rajah_orange,
            fontFamily:"Rubik"
        ),
        bodyText1: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            color:alice_blue,
            fontFamily:"Rubik"
        ),
        bodyText2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
            color:rajah_orange,
            fontFamily:"Rubik"
        ),
        button:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color:alice_blue,
            fontFamily:"Rubik"
        ),
        caption: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: Colors.black,
            fontFamily:"Rubik"
        ),
      )


  );
}

// ignore_for_file: deprecated_member_use, camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/Admin.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:neapolis_admin/main.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Menu_Bar extends StatefulWidget{

  @override
  State<Menu_Bar> createState() => _Menu_BarState();

}

class _Menu_BarState extends State<Menu_Bar>{

  Admin admin=Admin();

  bool isInternet = false;
  bool loading = true;


  getAdmin()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? admin_body = prefs.getString('Admin');
    Map<String, dynamic> body01 = json.decode(admin_body!);
    List<dynamic> body02= json.decode(body01["Admin"]);
    int id=body02[0]["pk"];
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAdmin'));
    request.fields.addAll({
      'idAdmin': id.toString()
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body03 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body04=json.decode(body03["Admin"]);
        String fields =json.encode(body04[0]["fields"]);
        prefs.setString("Admin", responseString);
        Admin a= Admin(fields: fields,id:id);
        await Future.delayed(const Duration(seconds:1));
        setState(() {
          admin= a;
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
  void initState() {
    testInternet();
    getAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Profile picture
            loading
                ?Center(child: LoadingAnimationWidget.prograssiveDots(
              color:light_cobalt_blue,
              size: 30,
            ),)
                :ListTile(
              title: Text(admin.nom_prenom,style: Theme.of(context).textTheme.headline5,),
              subtitle:Text(admin.email,style: Theme.of(context).textTheme.button),
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                child:ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child:Image.network(admin.photo,errorBuilder:(context, error, stackTrace) => Container(color: Colors.white,),)
                ),
              ),
              trailing: IconButton(onPressed: ()=>Navigator.pushNamed(context, "AdminSetting Page"),
                  icon: const Icon(Icons.expand_circle_down,color: Colors.white,)
              ),
            ),
            const Divider(color: Colors.white70,thickness: 1,indent: 15,endIndent: 15),

            //List of Post
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title:Text("Liste de Post",style: Theme.of(context).textTheme.bodyText1,),
                leading: const Icon(Icons.post_add_sharp),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "List of Post Page");
                },
              ),
            ),

            //List of Reservation
            Card(
              
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title:Text("Liste de Réservations",style: Theme.of(context).textTheme.bodyText1,),
                leading: const Icon(Icons.bookmark),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "List of Reservation Page");
                },
              ),
            ),

            //List of Transfer
            Card(
              
              
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title:Text("Liste de Transfers",style: Theme.of(context).textTheme.bodyText1,),
                leading: const Icon(Icons.local_taxi_outlined),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "List of Transfer Page");
                },


              ),
            ),

            //List of Excursion
            Card(
              
              
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title:Text("Liste de Excursions",style: Theme.of(context).textTheme.bodyText1,),
                leading: const Icon(Icons.luggage),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "List of Exurcion Page");
                },


              ),
            ),

            //List of Cars
            Card(
              
              
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title: Text("Liste de Voitures",style: Theme.of(context).textTheme.bodyText1,),
                leading: const Icon(Icons.airport_shuttle),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "List of Voiture Page");
                },


              ),
            ),

            //List of Clients
            Card(
              
              
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title:Text("Liste de Clients",style: Theme.of(context).textTheme.bodyText1,),
                leading: const Icon(Icons.group),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "List of Client Page");

                },


              ),
            ),

            //List of Paiement
            Card(
              
              
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title:Text("Liste de Paiements",style: Theme.of(context).textTheme.bodyText1,),
                leading: const Icon(Icons.credit_score),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "List of Paiment Page");
                },
              ),
            ),

            //List of Annulation
            Card(
              
              
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title:Text("Liste de Annulations",style: Theme.of(context).textTheme.bodyText1,),
                leading: const Icon(Icons.credit_card_off),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "List of Annulation Page");
                },


              ),
            ),

            //Log out
            Card(
              
              
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title:Text("Déconnecter",style: Theme.of(context).textTheme.bodyText1,),
                leading: const Icon(Icons.power_settings_new),
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Center(child: Text('Déconnecter',style: Theme.of(context).textTheme.subtitle2,)),
                      content: Text('Êtes-vous sûr de vouloir vous déconnecter ?',style: Theme.of(context).textTheme.caption!.apply(color:Colors.grey )),
                      actionsAlignment: MainAxisAlignment.spaceAround,
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context,),
                          child: Text('Cancel',style: Theme.of(context).textTheme.subtitle2),
                        ),
                        TextButton(
                          onPressed: ()async{
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('login',false);
                            Navigator.pushNamedAndRemoveUntil(context,"Splash_Screen Page", (Route<dynamic> route) => false);
                          },
                          child: Text('OK',style: Theme.of(context).textTheme.subtitle2),

                        ),
                      ],
                    ),
                  );

                },
              ),
            ),

          ],
        ),
      ),
    );
  }

}
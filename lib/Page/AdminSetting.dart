


// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_final_fields, await_only_futures, deprecated_member_use, must_be_immutable, no_logic_in_create_state, use_build_context_synchronously, avoid_unnecessary_containers


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/Admin.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AdminSetting_Page extends StatefulWidget {

  @override
  State<AdminSetting_Page> createState() => _AdminSetting_PageState();
}

class _AdminSetting_PageState extends State<AdminSetting_Page> {

  Admin admin = Admin();

  bool isInternet = false;
  bool loading = true;

  TextEditingController nom_prenom_Controller = TextEditingController();
  TextEditingController telephone_Controller = TextEditingController();
  TextEditingController email_Controller = TextEditingController();
  TextEditingController mot_de_passe_Controller = TextEditingController();
  TextEditingController confirm_mot_de_passe_Controller = TextEditingController();

  bool bodyValidation=false;

  File image=File("${url}media/default_profile_picture.png");
  bool imageUpload=false;

  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;




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
        Admin a= await Admin(fields: fields,id:id);
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          admin= a;
          nom_prenom_Controller.text=admin.nom_prenom;
          email_Controller.text=admin.email;
          telephone_Controller.text=admin.telephone;
          mot_de_passe_Controller.text=admin.mot_de_passe;
          image=File(admin.photo);
          loading=false;
        });
        await Future.delayed(const Duration(milliseconds: 500));

      }

    }
    else {}
  }

  validator(){
    setState(() {
      if(nom_prenom_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Nom Prenom\" ne peut pas être vide");
      }
      else if(email_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Email\" ne peut pas être vide");
      }
      else if(telephone_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Telephone\" ne peut pas être vide");
      }
      else if(mot_de_passe_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Mot de passe\" ne peut pas être vide");
      }
      else if(confirm_mot_de_passe_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Confirm Mot de passe\" ne peut pas être vide");
      }
      else{
        bodyValidation=true;
      }

    });


  }

  Update_Admin() async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Update_Admin'));
    request.fields.addAll({
      'id': admin.id.toString(),
      'nom_prenom': nom_prenom_Controller.text,
      'telephone': telephone_Controller.text,
      'email': email_Controller.text,
      'mot_de_passe': mot_de_passe_Controller.text,
      'confirm_mot_de_passe': confirm_mot_de_passe_Controller.text
    });
    if(imageUpload){
      request.files.add(await http.MultipartFile.fromPath('photo',image.path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        await Future.delayed(const Duration(milliseconds: 500));
        showSnackBar(body01["Response"]);
      }
      else{
        showSnackBar(body01["Response"]);
      }
    }
    else {}
  }

  @override
  void initState() {
    super.initState();
    testInternet();
    getAdmin();
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {
              validator();
              if(bodyValidation){
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Center(child: Text('Insertion',style: Theme.of(context).textTheme.subtitle2,)),
                    content: Text('Êtes-vous sûr de vouloir vous Enregistre les modifications ?',style: Theme.of(context).textTheme.caption!.apply(color:Colors.grey )),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context,),
                        child: Text('Cancel',style: Theme.of(context).textTheme.subtitle2),
                      ),
                      TextButton(
                        onPressed: ()async{
                          Update_Admin();
                          Navigator.pop(context);
                        },
                        child: Text('Modifier',style: Theme.of(context).textTheme.subtitle2),

                      ),
                    ],
                  ),
                );

              }
            }, icon: const Icon(Icons.save))
          ],
          centerTitle: true,
        ),
        body:loading
            ?Center(child: LoadingAnimationWidget.prograssiveDots(
            color: Colors.white,
            size: 30,
          ),)
            :isInternet
            ?SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width:double.infinity,
                child: InkWell(
                  child: imageUpload
                      ?CircleAvatar(
                    backgroundImage:FileImage(image),
                    backgroundColor: Colors.white,
                    onBackgroundImageError: (exception, stackTrace) =>Container() ,
                  )
                      :CircleAvatar(
                    backgroundImage:NetworkImage(image.path),
                    backgroundColor: Colors.white,
                    onBackgroundImageError: (exception, stackTrace) =>Container() ,
                  ),
                  onTap: ()async {
                    final ImagePicker picker = ImagePicker();
                    XFile? img = await picker.pickImage(source: ImageSource.gallery);
                    if (img!=null){
                      setState(() {
                        image=File(img.path);
                        imageUpload=true;
                      });
                    }
                  },
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(8),
                  child: Text('(${admin.statutAdmin})',style: Theme.of(context).textTheme.headline6!.apply(color:admin.statutAdmin=="Activated"?Colors.greenAccent:cinnabar_red_shade),)),
              Column(
                children: [
                  //Numéro Série
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Nom_Prenom :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      TextFormField(
                        controller:  nom_prenom_Controller,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.black45),
                        decoration:const InputDecoration(
                          hintText: 'Nom_Prenom',
                          prefixIcon: Icon(Icons.tag,) ,
                        ),
                      ),
                    ],
                  ),
                  //Telephone
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Telephone :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      TextFormField(
                        controller: telephone_Controller,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.black45),
                        decoration:const InputDecoration(
                          hintText: 'Telephone',
                          prefixIcon: Icon(Icons.tag,) ,
                        ),
                      ),
                    ],
                  ),
                  //Email
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Email :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      TextFormField(
                        controller: email_Controller,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.black45),
                        decoration:const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.tag,) ,
                        ),
                      ),
                    ],
                  ),
                  //Mot de passe
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Mot de passe :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      TextFormField(
                        controller: mot_de_passe_Controller,
                        keyboardType: TextInputType.visiblePassword,
                        style: const TextStyle(color: Colors.black45),
                        obscureText: true,
                        decoration:const InputDecoration(
                          hintText: 'Mot de passe',
                          prefixIcon: Icon(Icons.tag,) ,
                        ),
                      ),
                    ],
                  ),
                  //Confirmez Mot de passe
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Confirm Mot de passe:", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      TextFormField(
                        controller: confirm_mot_de_passe_Controller,
                        keyboardType: TextInputType.visiblePassword,
                        style: const TextStyle(color: Colors.black45),
                        obscureText: true,
                        decoration:const InputDecoration(
                          hintText: 'Confirmez Mot de passe',
                          prefixIcon: Icon(Icons.tag,) ,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
            :const Center(child: Text("Aucune Connexion Internet"),)
    );
  }
}

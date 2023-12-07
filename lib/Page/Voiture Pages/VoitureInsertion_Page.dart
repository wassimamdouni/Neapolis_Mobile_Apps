


// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_final_fields, await_only_futures, deprecated_member_use, must_be_immutable, no_logic_in_create_state, use_build_context_synchronously, avoid_unnecessary_containers


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neapolis_admin/Class/Marquer.dart';
import 'package:neapolis_admin/Class/Options.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';
import 'package:neapolis_admin/Decoration/colors.dart';



class VoitureInsertion_Page extends StatefulWidget {

  @override
  State<VoitureInsertion_Page> createState() => _VoitureInsertion_PageState();
}

class _VoitureInsertion_PageState extends State<VoitureInsertion_Page> {

  bool isInternet = false;

  TextEditingController numero_series_Controller = TextEditingController();
  TextEditingController modele_Controller = TextEditingController();
  TextEditingController class_voiture_Controller = TextEditingController();
  TextEditingController annee_Controller = TextEditingController();

  TextEditingController boite_Controller = TextEditingController();
  TextEditingController nb_seats_Controller = TextEditingController();
  TextEditingController nb_bags_Controller = TextEditingController();
  TextEditingController nb_ports_Controller = TextEditingController();


  TextEditingController etat_Controller = TextEditingController();
  TextEditingController description_Controller = TextEditingController();

  TextEditingController caution_Controller = TextEditingController();
  TextEditingController prix_jour_Controller = TextEditingController();


  Color color=Colors.white;

  File image_voiture=File("${url}media/default_image.jpg");
  bool imageUpload_voiture=false;

  bool bodyValidation=false;

  File image=File("${url}media/default_profile_picture.png");
  bool imageUpload=false;

  int result_total_Marquer=0;
  List<Marquer> listMarquer=[];

  int result_total_Option=0;
  List<Options> listOption=[];

  int indexMarqueSelected=-1;
  int indexMarqueUpdate=-1;

  TextEditingController titleOption_controller=TextEditingController();
  TextEditingController descriptionsOption_controller=TextEditingController();

  TextEditingController search_controller=TextEditingController();
  TextEditingController marqueTitleController=TextEditingController();
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  getAllMarquers()async{
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllMarquer'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Marquers"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Marquer marquer =Marquer(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listMarquer.add(marquer);
            result_total_Marquer=listMarquer.length;
          });
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    }
    else {}
  }

  Insert_Update_Marquer()async{
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Insert_Update_Marquer'));
    request.fields.addAll({
      'id':indexMarqueUpdate==-1?"0":listMarquer[indexMarqueUpdate].id.toString(),
      'nom': marqueTitleController.text
    });
    if(imageUpload){
      request.files.add(await http.MultipartFile.fromPath('logo',image.path));
    }
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(indexMarqueUpdate==-1){
        if(body01["Response"]=="Success") {
          List<dynamic> body02=json.decode(body01["Marquer"]);
          String fields =json.encode(body02[0]["fields"]);
          int id=body02[0]["pk"];
          Marquer marquer =Marquer(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listMarquer.add(marquer);
            result_total_Marquer=listMarquer.length;
            marqueTitleController.clear();
          });
          showSnackBar("Succès");
          await Future.delayed(const Duration(milliseconds: 500));
        }
        else if(body01["Response"]=="Exist") {
          showSnackBar("La marque est existé");
        }
      }
      else{
        if(body01["Response"]=="Success") {
          List<dynamic> body02=json.decode(body01["Marquer"]);
          String fields =json.encode(body02[0]["fields"]);
          int id=body02[0]["pk"];
          Marquer marquer =Marquer(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listMarquer[indexMarqueUpdate]=marquer;
            marqueTitleController.clear();
          });
          showSnackBar("Succès");
        }
        else if(body01["Response"]=="Not Exist") {
          showSnackBar("La marque n'est pas existé");
        }
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

  validator(){
    setState(() {
      if(numero_series_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Numero Series\" ne peut pas être vide");
      }
      else if(modele_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Modele\" ne peut pas être vide");
      }
      else if(class_voiture_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Class Voiture\" ne peut pas être vide");
      }
      else if(annee_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Annee\" ne peut pas être vide");
      }
      else if(boite_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Boite\" ne peut pas être vide");
      }
      else if(indexMarqueSelected==-1){
        bodyValidation=false;
        showSnackBar("Choisir la marque!");
      }
      else if(nb_seats_Controller.text.isEmpty){
        nb_seats_Controller.text="0";
        bodyValidation=false;
      }
      else if(nb_bags_Controller.text.isEmpty){
        nb_bags_Controller.text="0";
        bodyValidation=false;
      }
      else if(nb_ports_Controller.text.isEmpty){
        nb_ports_Controller.text="0";
        bodyValidation=false;
      }
      else if(caution_Controller.text.isEmpty){
        caution_Controller.text="0";
        bodyValidation=false;
      }
      else if(prix_jour_Controller.text.isEmpty){
        prix_jour_Controller.text="0";
        bodyValidation=false;
      }
      else{
        bodyValidation=true;
      }

    });


  }

  insertVoiture() async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/InserVoiture'));
    request.fields.addAll({
      'numero_series':numero_series_Controller.text ,
      'modele': modele_Controller.text,
      'class_voiture': class_voiture_Controller.text,
      'annee': annee_Controller.text,
      'boite': boite_Controller.text,
      'nb_seats': nb_seats_Controller.text,
      'nb_bags': nb_bags_Controller.text,
      'nb_ports': nb_ports_Controller.text,
      'color': color.value.toString(),
      'etat': etat_Controller.text,
      'description': description_Controller.text,
      'caution': caution_Controller.text,
      'prix_jour': prix_jour_Controller.text,
      'id_marquer': listMarquer[indexMarqueSelected].id.toString()
    });
    if(imageUpload_voiture){
      request.files.add(await http.MultipartFile.fromPath('photo',image_voiture.path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);

      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["Voiture"]);
        String id=body02[0]["pk"];

        for(int i=0;i<result_total_Option;i++){
          await insertOption(listOption[i].title, listOption[i].descriptions, id);
        }
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pop(context);
      }
      else{
        showSnackBar(body01["Response"]);
      }
    }
    else {}
  }

  insertOption(String title,String descriptions,String numero_series) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/InserOption'));
    request.fields.addAll({
      'title': title,
      'descriptions': descriptions,
      'numero_series': numero_series
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);

      if (body01["Response"] == "Success") {

        await Future.delayed(const Duration(milliseconds: 500));
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
    getAllMarquers();
    nb_ports_Controller.text="0";
    nb_bags_Controller.text="0";
    nb_seats_Controller.text="0";
    prix_jour_Controller.text="0";
    caution_Controller.text="0";
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
                    content: Text('Êtes-vous sûr de vouloir vous insérer la voiture ?',style: Theme.of(context).textTheme.caption!.apply(color:Colors.grey )),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context,),
                        child: Text('Cancel',style: Theme.of(context).textTheme.subtitle2),
                      ),
                      TextButton(
                        onPressed: ()async{
                          insertVoiture();
                          Navigator.pushNamedAndRemoveUntil(context,"List of Voiture Page", (Route<dynamic> route) => false);

                        },
                        child: Text('Insérer',style: Theme.of(context).textTheme.subtitle2),

                      ),
                    ],
                  ),
                );

              }
            }, icon: const Icon(Icons.save))
          ],
          centerTitle: true,
        ),
        body:isInternet
            ?PageView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius:BorderRadius.circular(8),
                          child:InkWell(
                            child: imageUpload_voiture
                                ?Image.file(image_voiture,
                              fit: BoxFit.fitWidth,
                              errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),
                            )
                                :Image.network(image_voiture.path,
                              fit: BoxFit.fitWidth,
                              errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white),
                            ),
                            onTap: ()async {
                              final ImagePicker picker = ImagePicker();
                              XFile? img = await picker.pickImage(source: ImageSource.gallery);
                              if (img!=null){
                                setState(() {
                                  image_voiture=File(img.path);
                                  imageUpload_voiture=true;
                                });
                              }
                            },

                          )
                      ),
                    ),
                  ),
                  //Center(child: Text("${voiture.marquer!.nom} ${voiture.modele} ${voiture.class_voiture} ${voiture.annee}",style: Theme.of(context).textTheme.headline4)),
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.assignment),
                                Text(" Information",style: Theme.of(context).textTheme.headline5),
                              ],
                            ),
                          ),
                          //Numéro Série
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child:Text("Numéro Série :", style:Theme.of(context).textTheme.subtitle1,),
                          ),
                          Container(
                            margin: const EdgeInsets.all(4),
                            child: TextFormField(
                              controller:  numero_series_Controller,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: Colors.black45),
                              decoration:const InputDecoration(
                                hintText: 'Numéro Série',
                                prefixIcon: Icon(Icons.tag,) ,
                              ),
                            ),
                          ),
                          //Etat
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child:Text("Etat :", style:Theme.of(context).textTheme.subtitle1,),
                          ),
                          Container(
                            margin: const EdgeInsets.all(4),
                            child: TextFormField(
                              controller: etat_Controller,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: Colors.black45),
                              decoration:const InputDecoration(
                                hintText: 'Etat',
                                prefixIcon: Icon(Icons.tag,) ,
                              ),
                            ),
                          ),
                          //Modele
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child:Text("Modele :", style:Theme.of(context).textTheme.subtitle1,),
                          ),
                          Container(
                            margin: const EdgeInsets.all(4),
                            child: TextFormField(
                              controller: modele_Controller,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: Colors.black45),
                              decoration:const InputDecoration(
                                hintText: 'Modele',
                                prefixIcon: Icon(Icons.tag,) ,
                              ),
                            ),
                          ),
                          //Class Voiture
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child:Text("Class Voiture :", style:Theme.of(context).textTheme.subtitle1,),
                          ),
                          Container(
                            margin: const EdgeInsets.all(4),
                            child: TextFormField(
                              controller: class_voiture_Controller,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(color: Colors.black45),
                              decoration:const InputDecoration(
                                hintText: 'Class Voiture',
                                prefixIcon: Icon(Icons.tag,) ,
                              ),
                            ),
                          ),
                          //Annee
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child:Text("Année :", style:Theme.of(context).textTheme.subtitle1,),
                          ),
                          Container(
                            margin: const EdgeInsets.all(4),
                            child: TextFormField(
                              controller: annee_Controller,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.black45),
                              decoration:const InputDecoration(
                                hintText: 'Annee',
                                prefixIcon: Icon(Icons.tag,) ,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.assignment),
                        Text(" Plus Détails ",style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                  ),
                  //Boîte de Vitesse
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Boîte de Vitesse :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      TextFormField(
                        controller: boite_Controller,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.black45),
                        decoration:const InputDecoration(
                          hintText: 'Boîte de Vitesse',
                          prefixIcon: Icon(Icons.speed,) ,
                        ),
                      ),
                    ],
                  ),
                  //Nb
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        //Nombre de Places
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child:Text("Nombre de Places :", style:Theme.of(context).textTheme.subtitle1,),
                              ),
                              Container(
                                margin: const EdgeInsets.all(4),
                                child: TextFormField(
                                  controller: nb_seats_Controller,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.black45),
                                  textAlign: TextAlign.center,
                                  decoration:const InputDecoration(
                                    hintText: '0',
                                    prefixIcon: Icon(Icons.event_seat,) ,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Nombre de Bags
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child:Text("Nombre de Bags :", style:Theme.of(context).textTheme.subtitle1,),
                              ),
                              Container(
                                margin: const EdgeInsets.all(4),
                                child: TextFormField(
                                  controller: nb_bags_Controller,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.black45),
                                  textAlign: TextAlign.center,
                                  decoration:const InputDecoration(
                                    hintText: '0',
                                    prefixIcon: Icon(Icons.luggage,) ,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Nombre de Portes
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child:Text("Nombre de Portes :", style:Theme.of(context).textTheme.subtitle1,),
                              ),
                              Container(
                                margin: const EdgeInsets.all(4),
                                child: TextFormField(
                                  controller: nb_ports_Controller,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.black45),
                                  textAlign: TextAlign.center,
                                  decoration:const InputDecoration(
                                    hintText: '0',
                                    prefixIcon: Icon(Icons.sim_card,) ,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Description
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.comment),
                          Text(" Description",style: Theme.of(context).textTheme.headline5),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(4),
                        child: TextFormField(
                          controller: description_Controller,
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: 10,
                          //initialValue: voiture.description,

                          style: const TextStyle(color: Colors.black45),
                          decoration:const InputDecoration(
                            hintText: 'Description',
                            prefixIcon: Icon(Icons.comment,) ,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Prix
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.payments),
                            Text(" Prix Total",style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child:Text("Prix :", style:Theme.of(context).textTheme.subtitle1,),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  child: TextFormField(
                                    controller: prix_jour_Controller,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.black45),
                                    textAlign: TextAlign.center,
                                    decoration:const InputDecoration(
                                      hintText: '0',
                                      prefixIcon: Icon(Icons.payments,) ,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 0
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child:Text("Caution :", style:Theme.of(context).textTheme.subtitle1,),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  child: TextFormField(
                                    controller: caution_Controller,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.black45),
                                    textAlign: TextAlign.center,
                                    decoration:const InputDecoration(
                                      hintText: '0',
                                      prefixIcon: Icon(Icons.payments,) ,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        //Options
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.workspace_premium),
                            Text(" Marque",style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                        Expanded(
                          flex: 2,
                          child: ListView.builder(
                            itemCount: result_total_Marquer+1,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              if (index==result_total_Marquer){
                                return InkWell(
                                  child: const Card(
                                    margin: EdgeInsets.all(8),
                                    shape: CircleBorder(side: BorderSide(width: 2,strokeAlign: 1),),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      maxRadius: 32,
                                      child: Icon(Icons.add,color: indigo_blue,size: 24,),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      indexMarqueSelected=-1;
                                      marqueTitleController.clear();
                                      image=File("${url}media/default_profile_picture.png");
                                    });
                                    scaffoldKey.currentState!.showBottomSheet((context){
                                      return StatefulBuilder(builder: (context, setState) {
                                        return Card(
                                          margin: const EdgeInsets.all(16),
                                          color: Colors.white,
                                          child: SingleChildScrollView(
                                            child: Container(
                                              margin:const EdgeInsets.all(8),
                                              padding: const EdgeInsets.all(24),
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    controller: marqueTitleController,
                                                    keyboardType: TextInputType.name,
                                                    decoration:const InputDecoration(
                                                      hintText: 'Name de Marque',
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.all(16),
                                                    width: 125,
                                                    height: 125,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.grey,
                                                      child: ClipOval(
                                                        child: InkWell(
                                                          child: imageUpload
                                                              ?Image.file(image,
                                                            fit: BoxFit.contain,
                                                            errorBuilder: (context, error, stackTrace) => Container(
                                                                color: Colors.grey,
                                                                child: const Icon(Icons.image,color: Colors.white,size: 32,)
                                                            ),
                                                          )
                                                              :Image.network(image.path,
                                                            errorBuilder: (context, error, stackTrace) => Container(
                                                                child: const Icon(Icons.image,color: Colors.white,size: 32,)
                                                            ),
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
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: const ButtonStyle(
                                                              backgroundColor: MaterialStatePropertyAll(Colors.white)
                                                          ),
                                                          child: Text('Cancel',style:Theme.of(context).textTheme.button!.apply(color: Colors.grey)),
                                                          onPressed: (){
                                                            setState(() {
                                                              marqueTitleController.clear();
                                                              imageUpload=false;
                                                              indexMarqueUpdate=-1;
                                                              image=File("${url}media/default_profile_picture.png");
                                                              Navigator.pop(context);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 16,),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            child: Text(indexMarqueUpdate==-1?'Insérer':'Modifier',),
                                                          ),
                                                          onPressed: (){
                                                            if(marqueTitleController.text!=""){
                                                              Insert_Update_Marquer();
                                                              Navigator.pop(context);                                                           }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },);
                                    },
                                        backgroundColor: Colors.transparent
                                    );
                                  },
                                );
                              }
                              else if (index<result_total_Marquer){
                                return InkWell(
                                  child: Card(
                                      margin: const EdgeInsets.all(8),
                                      shape: CircleBorder(side: BorderSide(width: 2,strokeAlign: 1,color:indexMarqueSelected==index?rajah_orange:Colors.black),),
                                      child: CircleAvatar(
                                        maxRadius: 32,
                                        backgroundColor: Colors.white,
                                        child: ClipOval(
                                          child: Image.network(
                                            listMarquer[index].logo,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                                child: const Icon(Icons.image,color: Colors.white,size: 32,)
                                            ),
                                            fit: BoxFit.contain,

                                          ),
                                        ),
                                      )
                                  ),
                                  onTap: (){
                                    setState(() {
                                      if(indexMarqueSelected==index){
                                        indexMarqueSelected=-1;
                                      }
                                      else{
                                        indexMarqueSelected=index;
                                      }

                                    });

                                  },
                                  onLongPress:() {
                                    setState(() {
                                      indexMarqueUpdate=index;
                                      marqueTitleController.text =listMarquer[index].nom;
                                      image=File(listMarquer[index].logo);
                                      scaffoldKey.currentState!.showBottomSheet((context){
                                        return StatefulBuilder(builder: (context, setState) {
                                          return Card(
                                            margin: const EdgeInsets.all(16),
                                            color: Colors.white,
                                            child: SingleChildScrollView(
                                              child: Container(
                                                margin:const EdgeInsets.all(8),
                                                padding: const EdgeInsets.all(24),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller: marqueTitleController,
                                                      keyboardType: TextInputType.name,
                                                      decoration:const InputDecoration(
                                                        hintText: 'Name de Marque',
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets.all(16),
                                                      width: 125,
                                                      height: 125,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.grey,
                                                        child: ClipOval(
                                                          child: InkWell(
                                                            child: imageUpload
                                                                ?Image.file(image,
                                                              fit: BoxFit.contain,
                                                              errorBuilder: (context, error, stackTrace) => Container(
                                                                  color: Colors.grey,
                                                                  child: const Icon(Icons.image,color: Colors.white,size: 32,)
                                                              ),
                                                            )
                                                                :Image.network(image.path,
                                                              errorBuilder: (context, error, stackTrace) => Container(
                                                                  child: const Icon(Icons.image,color: Colors.white,size: 32,)
                                                              ),
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
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            style: const ButtonStyle(
                                                                backgroundColor: MaterialStatePropertyAll(Colors.white)
                                                            ),
                                                            child: Text('Cancel',style:Theme.of(context).textTheme.button!.apply(color: Colors.grey)),
                                                            onPressed: (){
                                                              setState(() {
                                                                marqueTitleController.clear();
                                                                imageUpload=false;
                                                                indexMarqueUpdate=-1;
                                                                image=File("${url}media/default_profile_picture.png");
                                                                Navigator.pop(context);
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(width: 16,),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              child: Text(indexMarqueUpdate==-1?'Insérer':'Modifier',),
                                                            ),
                                                            onPressed: (){
                                                              if(marqueTitleController.text!=""){
                                                                Insert_Update_Marquer();
                                                                Navigator.pop(context);
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },);
                                      },
                                          backgroundColor: Colors.transparent
                                      );
                                    });
                                  },
                                );
                              }
                              else{
                                return Container();
                              }
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  //Color
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.color_lens),
                      Text(" Color",style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                  ColorPicker(
                    paletteType: PaletteType.hsv,
                    pickerColor: color, onColorChanged: (value) {
                      setState(() {
                        color=value;
                      });
                  },),
                  //Options

                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.settings),
                      Text(" Options",style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                        margin: const EdgeInsets.all(4),
                        child:SingleChildScrollView(
                          child: Wrap(
                              spacing: 4.0,
                              runSpacing: 4.0,
                              children:List<Widget>.generate(result_total_Option+1,(index) {
                                if(index==result_total_Option){
                                  return InputChip(
                                    avatar: const Icon(Icons.add),
                                    label:const Text("Ajouter"),
                                    onSelected: (value) {
                                      scaffoldKey.currentState!.showBottomSheet((context){
                                        return Card(
                                          margin: const EdgeInsets.all(16),
                                          color: Colors.white,
                                          child: SingleChildScrollView(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  keyboardType: TextInputType.name,
                                                  controller: titleOption_controller,
                                                  decoration:const InputDecoration(
                                                    hintText: 'Title de Option',
                                                  ),
                                                ),
                                                const SizedBox(height: 8,),
                                                TextFormField(
                                                  keyboardType: TextInputType.name,
                                                  controller: descriptionsOption_controller,
                                                  decoration:const InputDecoration(
                                                    hintText: 'Description',
                                                  ),
                                                ),
                                                const SizedBox(height: 8,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: const ButtonStyle(
                                                            backgroundColor: MaterialStatePropertyAll(Colors.white)
                                                        ),
                                                        child: Text('Cancel',style:Theme.of(context).textTheme.button!.apply(color: Colors.grey)),
                                                        onPressed: (){
                                                          titleOption_controller.clear();
                                                          descriptionsOption_controller.clear();
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16,),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          child: const Text('Ajouter',),
                                                        ),
                                                        onPressed: (){
                                                          if(titleOption_controller.text.isNotEmpty){
                                                            Options op=Options();
                                                            op.title=titleOption_controller.text;
                                                            op.descriptions=descriptionsOption_controller.text;
                                                            setState(() {
                                                              listOption.add(op);
                                                              result_total_Option++;
                                                            });
                                                            titleOption_controller.clear();
                                                            descriptionsOption_controller.clear();
                                                            Navigator.pop(context);
                                                          }else{
                                                            showSnackBar("La valeur de \"Title de Option\" ne peut pas être vide");

                                                          }

                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                        backgroundColor:Colors.transparent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),);
                                    },
                                  );
                                }
                                else{
                                  return Chip(
                                    onDeleted: () {
                                      setState(() {
                                        listOption.removeAt(index);
                                        result_total_Option--;
                                      });
                                    },
                                    label:Tooltip(
                                      showDuration: const Duration(seconds: 3),
                                      message: listOption[index].descriptions,
                                      child: Text(listOption[index].title),
                                    ),
                                  );
                                }
                              },)
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),

          ],
        )
            :const Center(child: Text("Aucune Connexion Internet"),)
    );
  }
}

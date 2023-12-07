


// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_final_fields, await_only_futures, deprecated_member_use, must_be_immutable, no_logic_in_create_state, use_build_context_synchronously, avoid_unnecessary_containers, unrelated_type_equality_checks


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:neapolis_admin/Class/Gallery.dart';
import 'package:neapolis_admin/Class/ListExurcion.dart';
import 'package:neapolis_admin/main.dart';

class ListListExurcion_Insersion_Update_Page extends StatefulWidget {

  ListExurcion listExurcion=ListExurcion();
  ListListExurcion_Insersion_Update_Page({required this.listExurcion});

  @override
  State<ListListExurcion_Insersion_Update_Page> createState() => _ListListExurcion_Insersion_Update_PageState(listExurcion: listExurcion);
}

class _ListListExurcion_Insersion_Update_PageState extends State<ListListExurcion_Insersion_Update_Page> {


  ListExurcion listExurcion=ListExurcion();
  _ListListExurcion_Insersion_Update_PageState({required this.listExurcion});

  bool isInternet = false;
  bool bodyValidation = false;

  TextEditingController address_depart_controller=TextEditingController();
  TextEditingController description_controller=TextEditingController();
  TextEditingController prix_controller=TextEditingController();


  int result_total_Gallery=0;
  List<Gallery> listGallery=[];
  List<Gallery> listGallerydelete=[];
  List<Gallery> listGalleryadd=[];

  File image=File("${url}media/default_image.jpg");
  bool imageUpload=false;

  TextEditingController titleGallery_controller=TextEditingController();

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
      if(address_depart_controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Title\" ne peut pas être vide");
      }
      else if(description_controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Descriptions\" ne peut pas être vide");
      }
      else if(prix_controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Lien\" ne peut pas être vide");
      }
      else{
        bodyValidation=true;
      }

    });


  }

  Insert_Update_ListExurcion()async{
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Insert_Update_ListExurcion'));
    request.fields.addAll({
      'id': listExurcion.id.toString(),
      'address_depart': address_depart_controller.text,
      'description': description_controller.text,
      'prix': prix_controller.text
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(listExurcion.id==0){
        if(body01["Response"]=="Success") {
          List<dynamic> body02=json.decode(body01["ListExurcion"]);
          int id=body02[0]["pk"];
          showSnackBar("Succès");
          for(int i=0;i<listGalleryadd.length;i++){
            await inserGallery(listGalleryadd[i],id);
            await Future.delayed(const Duration(seconds: 1));
          }
          await Future.delayed(const Duration(milliseconds: 500));
          for(int i=0;i<listGallerydelete.length;i++){
            await deleteGallery(listGallerydelete[i].id);
            await Future.delayed(const Duration(milliseconds: 500));
          }
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pushReplacementNamed(context, "List of Exurcion Page");
        }
        else if(body01["Response"]=="Exist") {
          showSnackBar("La marque est existé");
        }
      }
      else{
        if(body01["Response"]=="Success") {
          List<dynamic> body02=json.decode(body01["ListExurcion"]);
          int id=body02[0]["pk"];
          await Future.delayed(const Duration(seconds: 1));
          for(int i=0;i<listGalleryadd.length;i++){
            await inserGallery(listGalleryadd[i],id);
            await Future.delayed(const Duration(seconds: 1));
          }
          await Future.delayed(const Duration(milliseconds: 500));
          for(int i=0;i<listGallerydelete.length;i++){
            await deleteGallery(listGallerydelete[i].id);
            await Future.delayed(const Duration(milliseconds: 500));
          }
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pushReplacementNamed(context, "List of Exurcion Page");
        }
        else if(body01["Response"]=="Not Exist") {
          showSnackBar("La marque n'est pas existé");
        }
      }

    }
    else {}
  }

  inserGallery(Gallery gallery,int id) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/InserGallery'));
    request.fields.addAll({
      "idListExurcion":id.toString(),
      'title': gallery.titleGallery.toString(),
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
      }
      else{
        showSnackBar(body01["Response"]);
      }
    }
    else {}
  }

  deleteGallery(int id) async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/DeleteGallery'));
    request.fields.addAll({
      'id': id.toString()
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

  addG()async{
    Gallery g=await Gallery();
    g.titleGallery=titleGallery_controller.text;
    g.photo=image.path;

    setState(() {
      listGalleryadd.add(g);
      listGallery.add(g);
      result_total_Gallery++;
      titleGallery_controller.clear();
      imageUpload=false;
      image=File("${url}media/default_image.jpg");

    });
    await Future.delayed(const Duration(milliseconds: 500));
  }
  deleteG(int index)async{
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      if(listGallery[index].id!=0){
        listGallerydelete.add(listGallery[index]);
      }
      else{
        listGalleryadd.remove(listGallery[index]);
      }
      listGallery.remove(listGallery[index]);
      result_total_Gallery--;
    });
    await Future.delayed(const Duration(milliseconds: 500));
  }


  @override
  void initState() {
    super.initState();
    testInternet();
    address_depart_controller.text=listExurcion.address_depart;
    description_controller.text=listExurcion.description;
    prix_controller.text=listExurcion.prix.toString();
    listGallery=listExurcion.listGallery;
    result_total_Gallery=listExurcion.listGallery.length;
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
                    title: Center(child: Text(listExurcion.id==0?'Insértion':'Modification',style: Theme.of(context).textTheme.subtitle2,)),
                    content: Text('Êtes-vous sûr de vouloir vous Enregistre les modifications de la ListExurcion?',style: Theme.of(context).textTheme.bodyText1),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context,),
                        child: Text('Cancel',style: Theme.of(context).textTheme.subtitle1),
                      ),
                      TextButton(
                        onPressed: ()async{
                          Insert_Update_ListExurcion();
                        },
                        child: Text(listExurcion.id==0?'Insérer':'Modifier',style: Theme.of(context).textTheme.subtitle2),

                      ),
                    ],
                  ),
                );

              }
            }, icon: const Icon(Icons.save))
          ],
        ),
        body:isInternet
            ?Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.all(8),
                            child:Text("Address Depart :", style:Theme.of(context).textTheme.subtitle1,),
                          ),
                          TextFormField(
                            controller: address_depart_controller,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: Colors.black45),
                            decoration:const InputDecoration(
                              hintText: 'Address Depart',
                              prefixIcon: Icon(Icons.location_on,) ,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.all(8),
                            child:Text("Description :", style:Theme.of(context).textTheme.subtitle1,),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: description_controller,
                            minLines: 3,
                            maxLines: 10,
                            style: const TextStyle(color: Colors.black45),
                            decoration:const InputDecoration(
                              hintText: 'Description',
                              prefixIcon: Icon(Icons.comment,) ,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.all(8),
                            child:Text("Prix :", style:Theme.of(context).textTheme.subtitle1,),
                          ),
                          TextFormField(
                            controller: prix_controller,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: Colors.black45),
                            decoration:const InputDecoration(
                              hintText: 'Prix',
                              prefixIcon: Icon(Icons.speed,) ,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Gallery :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                    ],
                  ),
                  Expanded(
                      child:GridView.builder(
                        itemCount: (listGallery.length+1),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 4,mainAxisSpacing: 4),
                          itemBuilder: (context, index) {
                          if(index==result_total_Gallery){
                            return InkWell(
                                child: Container(color: Colors.white,
                                child: const Icon(Icons.add),),
                              onTap: () {
                                scaffoldKey.currentState!.showBottomSheet(
                                        (context) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
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
                                                            controller: titleGallery_controller,
                                                            keyboardType: TextInputType.name,
                                                            decoration:const InputDecoration(
                                                              hintText: 'Title Photo',
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: const EdgeInsets.all(16),
                                                            width: 250,
                                                            height: 250,
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
                                                                      titleGallery_controller.clear();
                                                                      imageUpload=false;
                                                                      image=File("${url}media/default_image.jpg");
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
                                                                    child: const Text('Insérer'),
                                                                  ),
                                                                  onPressed: (){
                                                                    if(titleGallery_controller.text.isEmpty){
                                                                      showSnackBar("La valeur de \"Title\" ne peut pas être vide");
                                                                    }
                                                                    else if (!imageUpload){
                                                                      showSnackBar("Choisir Photo !");
                                                                    }
                                                                    else{
                                                                      addG();
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
                                              });
                                        },
                                  backgroundColor: Colors.transparent
                                );
                              },
                            );
                          }
                          else{
                            if(listGallery[index].id==0){
                              return Container(
                                color: Colors.white,
                                child: InkWell(
                                  child: Image.file(File(listGallery[index].photo),fit: BoxFit.contain,errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white,),),
                                  onTap: () {
                                    scaffoldKey.currentState!.showBottomSheet((context) => Container(
                                        alignment: Alignment.center,
                                        height: double.infinity,
                                        child: Image.file(File(listGallery[index].photo),fit: BoxFit.contain,errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white,),)));
                                  },
                                  onLongPress: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: Center(child: Text('Supprimer',style: Theme.of(context).textTheme.subtitle2,)),
                                        content: Text('Êtes-vous sûr de vouloir vous Supprimer cette photo ?',style: Theme.of(context).textTheme.caption!.apply(color:Colors.grey )),
                                        actionsAlignment: MainAxisAlignment.spaceAround,
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context,),
                                            child: Text('Cancel',style: Theme.of(context).textTheme.subtitle2),
                                          ),
                                          TextButton(
                                            onPressed: (){
                                              deleteG(index);
                                              Navigator.pop(context,);
                                            },
                                            child: Text('Supprimer',style: Theme.of(context).textTheme.subtitle2),

                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            else{
                              return Container(
                                color: Colors.white,
                                child: InkWell(
                                  child: Image.network(listGallery[index].photo,fit: BoxFit.contain,errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white,),),
                                  onTap: () {
                                    scaffoldKey.currentState!.showBottomSheet((context) => Container(
                                        alignment: Alignment.center,
                                        height: double.infinity,
                                        child: Image.network(listGallery[index].photo,errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white,),)));
                                  },
                                  onLongPress: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: Center(child: Text('Supprimer',style: Theme.of(context).textTheme.subtitle2,)),
                                        content: Text('Êtes-vous sûr de vouloir vous Supprimer cette photo ?',style: Theme.of(context).textTheme.caption!.apply(color:Colors.grey )),
                                        actionsAlignment: MainAxisAlignment.spaceAround,
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context,),
                                            child: Text('Cancel',style: Theme.of(context).textTheme.subtitle2),
                                          ),
                                          TextButton(
                                            onPressed: (){
                                              deleteG(index);
                                              Navigator.pop(context,);
                                            },
                                            child: Text('Supprimer',style: Theme.of(context).textTheme.subtitle2),

                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }

                          },)
                  )
                ],
              ),
            )
            :const Center(child: Text("Aucune Connexion Internet"),)
    );
  }
}

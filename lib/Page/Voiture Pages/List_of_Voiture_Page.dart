
// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, body_might_complete_normally_nullable, camel_case_types, non_constant_identifier_names, await_only_futures, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/Marquer.dart';
import 'package:neapolis_admin/Class/Voiture.dart';
import 'package:neapolis_admin/Compound/Card_Voiture.dart';
import 'package:neapolis_admin/Compound/Menu_Bar.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:neapolis_admin/main.dart';



class List_of_Voiture_Page extends StatefulWidget {
  @override
  State<List_of_Voiture_Page> createState() => _List_of_Voiture_PageState();
}

class _List_of_Voiture_PageState extends State<List_of_Voiture_Page> {


  bool isInternet = false;
  bool loading = true;

  List<String> listOrdre=["Ascendant","Descendant"];
  String dropdownValueOrdre='';
  String searchValue="";

  int result_total_Voiture=0;
  List<Voiture> listVoiture=[];
  List<Voiture> oldlistVoiture=[];
  int result_total_Marquer=0;
  List<Marquer> listMarquer=[];

  File? image;
  bool imageUpload=false;

  int indexMarqueSelected=-1;
  int indexMarqueUpdate=-1;

  TextEditingController search_controller=TextEditingController();
  TextEditingController marqueTitleController=TextEditingController();

  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
      request.files.add(await http.MultipartFile.fromPath('logo',image!.path));
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

  getAllVoitures()async{
    setState(() {
      listVoiture=[];
      result_total_Voiture=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllVoiture'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Voitures"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          String id=body02[i]["pk"];
          Voiture voiture =Voiture(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listVoiture.add(voiture);
            result_total_Voiture=listVoiture.length;
          });
        }
        setState(() {
          loading=false;
        });
      }
      else{
        setState(() {
          loading=false;
        });
      }
    }
    else {}
  }

  searchVoiture()async{
    setState(() {
      searchValue=search_controller.text;
      indexMarqueSelected=-1;
      listVoiture=[];
      result_total_Voiture=0;
      loading=true;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/SearchVoiture'));
    request.fields.addAll({
      'searchValue': searchValue,
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Voitures"]);
        List<Voiture> listV=[];
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          String id=body02[i]["pk"];
          Voiture voiture =Voiture(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          listV.add(voiture);
        }
        if(dropdownValueOrdre=="Ascendant"){
          await TriePrixAscendant(listV);
          setState(() {
            loading=false;
          });
        }
        else if(dropdownValueOrdre=="Descendant"){
          await TriePrixDescendant(listV);
          setState(() {
            loading=false;
          });
        }
        else{
          setState(() {
            listVoiture=listV;
            result_total_Voiture=listVoiture.length;
            loading=false;
          });
        }
      }
      else{
        setState(() {
          loading=false;
        });
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

  TriePrixAscendant(List<Voiture> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].prix_jour > array[j + 1].prix_jour) {
          // Swapping using temporary variable
          Voiture temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      listVoiture=array;
      result_total_Voiture=listVoiture.length;
      loading=false;
    });
  }

  TriePrixDescendant(List<Voiture> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].prix_jour < array[j + 1].prix_jour) {
          // Swapping using temporary variable
          Voiture temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      listVoiture=array;
      result_total_Voiture=listVoiture.length;
      loading=false;
    });
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

  filterbyMarque()async{
    List<Voiture> listv=listVoiture;
    setState(() {
      oldlistVoiture=listVoiture;
      listVoiture=[];
      result_total_Voiture=0;
    });
    await Future.delayed(const Duration(seconds: 1));
    for(int i=0;i<listv.length;i++){
      if(listv[i].marquer!.id==listMarquer[indexMarqueSelected].id){
        setState(() {
          listVoiture.add(listv[i]);
          result_total_Voiture++;
        });
        await Future.delayed(const Duration(seconds: 1));

      }
    }
    setState(() {
      loading=false;
    });
  }

  @override
  void initState(){
    testInternet();
    getAllMarquers();
    getAllVoitures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
        appBar: AppBar(
          leading: Image.asset(
            isThemeLight
                ?"images/App_Icon/App_icon.png"
                :"images/App_Icon/App_icon_dark.png",
          ),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {
              scaffoldKey.currentState!.showBottomSheet((context) => Card(
                margin: const EdgeInsets.all(8),
                color:Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: search_controller,
                        keyboardType: TextInputType.emailAddress,
                        decoration:InputDecoration(
                          hintText: 'Chercher',
                          suffixIcon:IconButton(
                            icon: search_controller.text==""?Container():const Icon(Icons.cancel),
                            onPressed: () {
                              setState(() {
                                search_controller.clear();
                                searchValue="";
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchValue=search_controller.text;
                          });
                        },
                      ),
                      //Filter
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Prix/Jour :",style: Theme.of(context).textTheme.headline5!.apply(color: rajah_orange),),
                            DropdownMenu<String>(
                              hintText: "Ordre",
                              initialSelection: dropdownValueOrdre,
                              textStyle: Theme.of(context).textTheme.caption!.apply(color: Colors.grey),
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValueOrdre = value!;
                                });
                              },
                              dropdownMenuEntries: listOrdre.map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(value: value, label: value);
                              }).toList(),
                            )
                          ],
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
                                setState((){
                                  loading=true;
                                  search_controller.clear();
                                  dropdownValueOrdre='';
                                  listVoiture=[];
                                  result_total_Voiture=0;
                                  indexMarqueSelected=-1;
                                  getAllVoitures();
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
                                child: const Text('Chercher',),
                              ),
                              onPressed: ()async{
                                setState(() {
                                  loading=true;
                                });
                                if(search_controller.text!=''){
                                  searchVoiture();
                                }
                                else if(search_controller.text==''){
                                  if(dropdownValueOrdre=="Ascendant"){
                                    TriePrixAscendant(listVoiture);
                                  }
                                  else if(dropdownValueOrdre=="Descendant"){
                                    TriePrixDescendant(listVoiture);
                                    TriePrixDescendant(listVoiture);
                                  }
                                }
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
                backgroundColor:Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              );
            }),
            const SizedBox(width: 5,),
            Builder(builder: (context) =>IconButton(
                icon: const Icon(Icons.menu),
                onPressed: ()=>Scaffold.of(context).openEndDrawer()
            ),),
            const SizedBox(width: 16,),
          ],
          title:const Text("List de Voitures"),
        ),
        endDrawer:Menu_Bar(),
        floatingActionButton: isInternet?Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 50),
          child: FloatingActionButton(onPressed: () =>Navigator.pushNamed(context, "VoitureInsertion Page"),
              backgroundColor: rajah_orange,
              child:const Icon(Icons.add)),
        ):Container(),

        body:isInternet
            ?loading
            ?Center(
          child: LoadingAnimationWidget.prograssiveDots(
            color: Colors.white,
            size: 30,
          ),
        )
            :Column(
          children: [
            Expanded(
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
                            child: Icon(Icons.add,color:indigo_blue,size: 24,),
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
                                                    ?Image.file(image!,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error, stackTrace) => Container(
                                                      color: Colors.grey,
                                                      child: const Icon(Icons.image,color: Colors.white,size: 32,)
                                                  ),
                                                )
                                                    :Image.network(image!.path,
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
                        onTap: ()async{
                          if(indexMarqueSelected==index){
                            setState(() {
                              loading=true;
                              indexMarqueSelected=-1;
                              result_total_Voiture=0;
                              listVoiture=[];
                            });
                            await Future.delayed(const Duration(seconds: 1));
                            for(int i=0;i<oldlistVoiture.length;i++){
                              setState(() {
                                listVoiture.add(oldlistVoiture[i]);
                                result_total_Voiture++;
                                loading=false;
                              });
                            }
                          }
                          else if(indexMarqueSelected==-1){
                            setState(() {
                              loading=true;
                              indexMarqueSelected=index;
                              oldlistVoiture=listVoiture;
                            });
                            await filterbyMarque();
                          }
                          else{
                            setState(() {
                              loading=true;
                              indexMarqueSelected=index;
                              listVoiture=[];
                              result_total_Voiture=0;
                              listVoiture=oldlistVoiture;
                            });
                            await filterbyMarque();
                          }
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
                                                      ?Image.file(image!,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context, error, stackTrace) => Container(
                                                        color: Colors.grey,
                                                        child: const Icon(Icons.image,color: Colors.white,size: 32,)
                                                    ),
                                                  )
                                                      :Image.network(image!.path,
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
            Expanded(
              flex: 6,
              child: result_total_Voiture!=0
                  ?ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: result_total_Voiture,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Card_Voiture(voiture: listVoiture[index]);
                },
              )
                  :const Center(child: Text("Aucune Voiture")),
            ),
          ],
        )
            :const Center(child: Text("Aucune Connexion Internet"),)

    );
  }
}

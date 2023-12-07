


// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_final_fields, await_only_futures, deprecated_member_use, must_be_immutable, no_logic_in_create_state, use_build_context_synchronously, avoid_unnecessary_containers, unrelated_type_equality_checks


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:neapolis_admin/Class/Post.dart';
import 'package:neapolis_admin/main.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PostUpdate_Page extends StatefulWidget {

  Post post=Post();
  PostUpdate_Page({required this.post});

  @override
  State<PostUpdate_Page> createState() => _PostUpdate_PageState(post: post);
}

class _PostUpdate_PageState extends State<PostUpdate_Page> {


  Post post=Post();
  _PostUpdate_PageState({required this.post});

  bool isInternet = false;
  bool bodyValidation = false;

  TextEditingController title_Controller = TextEditingController();
  TextEditingController descriptions_Controller = TextEditingController();
  DateRangePickerController _datePickerController = DateRangePickerController();
  DateTime date_depart = DateTime.now();
  DateTime date_fin = DateTime.now().add(const Duration(days: 3));
  TextEditingController lien_Controller = TextEditingController();

  Color color=Colors.white;

  File image=File("${url}media/default_image.jpg");
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

  validator(){
    setState(() {
      if(title_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Title\" ne peut pas être vide");
      }
      else if(descriptions_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Descriptions\" ne peut pas être vide");
      }
      else if(lien_Controller.text.isEmpty){
        bodyValidation=false;
        showSnackBar("La valeur de \"Lien\" ne peut pas être vide");
      }
      else if(date_depart==Null || date_fin==Null){
        showSnackBar("Choisir Plage Date !");
      }
      else{
        bodyValidation=true;
      }

    });


  }

  updatePost() async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/UpdatePost'));
    request.fields.addAll({
      'id':post.id.toString(),
      'title': title_Controller.text,
      'descriptions': descriptions_Controller.text,
      'date_depart': DateFormat('yyyy-MM-dd HH:mm:ss').format(date_depart),
      'date_fin': DateFormat('yyyy-MM-dd HH:mm:ss').format(date_fin),
      'lien': lien_Controller.text
    });
    if(imageUpload){
      request.files.add(await http.MultipartFile.fromPath('photo',image.path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        Navigator.pushNamedAndRemoveUntil(context,"List of Post Page", (Route<dynamic> route) => false);
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
    title_Controller.text=post.title;
    descriptions_Controller.text=post.descriptions;
    date_depart=post.date_depart;
    date_fin=post.date_fin;
    lien_Controller.text=post.lien;
    image=File(post.photo);

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
                    title: Center(child: Text('Modification',style: Theme.of(context).textTheme.subtitle2,)),
                    content: Text('Êtes-vous sûr de vouloir vous Enregistre les modifications de la post?',style: Theme.of(context).textTheme.caption!.apply(color:Colors.grey )),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context,),
                        child: Text('Cancel',style: Theme.of(context).textTheme.subtitle1),
                      ),
                      TextButton(
                        onPressed: ()async{
                          updatePost();
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
        body:isInternet
            ?SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  //Photo
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: double.infinity,
                    height: 200,
                    child: ClipRRect(
                        borderRadius:BorderRadius.circular(8),
                        child:InkWell(
                          child: imageUpload
                              ?Image.file(image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),
                          )
                              :Image.network(image.path,
                            fit: BoxFit.fitWidth,
                            errorBuilder: (context, error, stackTrace) =>Container(color: Colors.white),
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

                        )
                    ),
                  ),
                  //Title
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Title :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      TextFormField(
                        controller:  title_Controller,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: Colors.black45),
                        decoration:const InputDecoration(
                          hintText: 'Title',
                          prefixIcon: Icon(Icons.title,) ,
                        ),
                      ),
                    ],
                  ),
                  //Description
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Description :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      TextFormField(
                        controller: descriptions_Controller,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(color: Colors.black45),
                        minLines: 3,
                        maxLines: 8,
                        decoration:const InputDecoration(
                          hintText: 'Description',
                          prefixIcon: Icon(Icons.tag,) ,
                        ),
                      ),
                    ],
                  ),
                  //Lien
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("Lien :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      TextFormField(
                        controller: lien_Controller,
                        keyboardType: TextInputType.url,
                        style: const TextStyle(color: Colors.black45),
                        decoration:const InputDecoration(
                          hintText: 'Lien',
                          prefixIcon: Icon(Icons.language,) ,
                        ),
                      ),
                    ],
                  ),
                  //Range Date
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(8),
                        child:Text("DeadLine :", style:Theme.of(context).textTheme.subtitle1,),
                      ),
                      Card(
                        color: Colors.white,
                        child: SfDateRangePicker(
                          controller: _datePickerController,
                          view: DateRangePickerView.month,
                          selectionMode: DateRangePickerSelectionMode.range,
                          headerHeight: 50,
                          enablePastDates: true,
                          showNavigationArrow: true,



                          initialSelectedRange: PickerDateRange(date_depart,date_fin),

                          onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                            if(dateRangePickerSelectionChangedArgs.value.startDate!=null){
                              date_depart=dateRangePickerSelectionChangedArgs.value.startDate;
                            }
                            if(dateRangePickerSelectionChangedArgs.value.endDate!=null){
                              date_fin=dateRangePickerSelectionChangedArgs.value.endDate;
                            }
                          },
                          headerStyle: const DateRangePickerHeaderStyle(
                            textStyle: TextStyle(color:Colors.white ,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            backgroundColor:rajah_orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
            :const Center(child: Text("Aucune Connexion Internet"),)
    );
  }
}

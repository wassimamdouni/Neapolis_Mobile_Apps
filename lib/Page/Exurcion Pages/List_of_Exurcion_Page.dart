
// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_final_fields, await_only_futures, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/ListExurcion.dart';
import 'package:neapolis_admin/Compound/Card_Exurcion.dart';
import 'package:neapolis_admin/Class/Exurcion.dart';
import 'package:neapolis_admin/Compound/Menu_Bar.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/Page/Exurcion%20Pages/ListExurcion_Insersion_Update_Page.dart';
import 'package:neapolis_admin/main.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class List_of_Exurcion_Page extends StatefulWidget {
  @override
  State<List_of_Exurcion_Page> createState() => _List_of_Exurcion_PageState();
}

class _List_of_Exurcion_PageState extends State<List_of_Exurcion_Page> {

  bool isInternet = false;
  bool loading = false;

  List<String> listTrie=["Prix","Date"];
  List<String> listOrdre=["Ascendant","Descendant"];
  String dropdownValueTrie='';
  String dropdownValueOrdre='';
  String searchValue="";
  DateTime date_Start=DateTime.now();
  DateTime date_End=DateTime.now();


  int result_total=0;
  List<Exurcion> listExurcion=[];
  List<ListExurcion> listListExurcion=[];

  TextEditingController search_controller=TextEditingController();
  DateRangePickerController _datePickerController = DateRangePickerController();

  TextEditingController address_depart_controller=TextEditingController();
  TextEditingController description_controller=TextEditingController();
  TextEditingController prix_controller=TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  getAllExurcion()async{
    setState(() {
      listExurcion=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllExurcion'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Exurcions"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Exurcion exurcion =Exurcion(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listExurcion.add(exurcion);
            result_total=listExurcion.length;
            loading = false;
          });
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    }
    else {}
  }

  SearchExurcion()async{
    setState(() {
      //loading=true;
      searchValue=search_controller.text;
      search_controller.clear();
      date_Start=_datePickerController.selectedRange!.startDate??DateTime.now();
      date_End=_datePickerController.selectedRange!.endDate??DateTime.now();
      listExurcion=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/SearchExurcion'));
    request.fields.addAll({
      'searchValue': searchValue,
      'date_Start': DateFormat('yyyy-MM-dd HH:mm:ss').format(date_Start),
      'date_End': DateFormat('yyyy-MM-dd HH:mm:ss').format(date_End),
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Exurcions"]);
        List<Exurcion> listR=[];
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Exurcion exurcion =Exurcion(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          listR.add(exurcion);
        }
        if(dropdownValueTrie=="Prix"){
          if(dropdownValueOrdre=="Ascendant"){
            await TriePrixAscendant(listR);
          }
          else if(dropdownValueOrdre=="Descendant"){
            await TriePrixDescendant(listR);
          }
        }
        else if(dropdownValueTrie=="Date"){
          if(dropdownValueOrdre=="Ascendant"){
            await TrieDateAscendant(listR);
          }
          else if(dropdownValueOrdre=="Descendant"){
            await TrieDateDescendant(listR);
          }
        }
        else{
          setState(() {
            listExurcion=listR;
            result_total=listExurcion.length;
            loading=false;
          });
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

  TriePrixAscendant(List<Exurcion> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].total_prix > array[j + 1].total_prix) {
          // Swapping using temporary variable
          Exurcion temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listExurcion=array;
      result_total=listExurcion.length;
      loading=false;
    });
  }

  TriePrixDescendant(List<Exurcion> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].total_prix < array[j + 1].total_prix) {
          // Swapping using temporary variable
          Exurcion temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listExurcion=array;
      result_total=listExurcion.length;
      loading=false;
    });
  }

  TrieDateAscendant(List<Exurcion> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].date_depar.compareTo(array[j + 1].date_depar) > 0) {
          // Swapping using temporary variable
          Exurcion temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listExurcion=array;
      result_total=listExurcion.length;
      loading=false;
    });
  }

  TrieDateDescendant(List<Exurcion> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].date_depar.compareTo(array[j + 1].date_depar) < 0) {
          // Swapping using temporary variable
          Exurcion temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listExurcion=array;
      result_total=listExurcion.length;
      loading=false;
    });
  }

  getListExurcion() async {
    setState(() {
      listListExurcion=[];
    });

    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllListExurcion'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["ListExurcions"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          ListExurcion lt = await ListExurcion(fields: fields,id:id);
          setState(() {
            listListExurcion.add(lt);
          });

        }

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
  void initState(){
    testInternet();
    getAllExurcion();
    getListExurcion();
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
              scaffoldKey.currentState!.showBottomSheet(
                      (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return Card(
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
                                    DropdownMenu<String>(
                                      hintText: "Trie",
                                      textStyle: Theme.of(context).textTheme.caption,
                                      onSelected: (String? value) {
                                        setState(() {
                                          dropdownValueTrie = value!;
                                        });
                                      },
                                      dropdownMenuEntries: listTrie.map<DropdownMenuEntry<String>>((String value) {
                                        return DropdownMenuEntry<String>(value: value, label: value);
                                      }).toList(),
                                    ),
                                    DropdownMenu<String>(
                                      hintText: "Ordre",
                                      textStyle: Theme.of(context).textTheme.caption,
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
                              //Calendar
                              Card(
                                color: Colors.white,
                                child: SfDateRangePicker(
                                  controller: _datePickerController,
                                  view: DateRangePickerView.month,
                                  selectionMode: DateRangePickerSelectionMode.range,
                                  headerHeight: 50,
                                  enablePastDates: true,
                                  showNavigationArrow: true,
                                  showTodayButton: true,
                                  showActionButtons: true,
                                  confirmText: "Confirme",


                                  onSubmit: (p0) {
                                    if(_datePickerController.selectedRange!=null){
                                      SearchExurcion();
                                      _datePickerController.selectedRange=null;
                                      Navigator.pop(context);

                                    }
                                    else{
                                      showSnackBar("Choisir Plage Date !");
                                    }

                                  },
                                  onCancel: () {
                                    setState(() {
                                      dropdownValueTrie="";
                                      dropdownValueOrdre="";
                                      searchValue="";
                                      search_controller.clear();
                                      _datePickerController.selectedRange=null;
                                      getAllExurcion();
                                      Navigator.pop(context);
                                    });
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
                        ),
                      ) ;
                    }
                    );
                  },
                  backgroundColor:Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
              );
            }),
            const SizedBox(width: 5,),
            Builder(builder: (context) =>IconButton(
                icon: const Icon(Icons.menu),
                onPressed: ()=>Scaffold.of(context).openEndDrawer()
            ),),
            const SizedBox(width: 16,),
          ],
          title:const Text("List de Exurcion"),
        ),
        endDrawer:Menu_Bar(),
        floatingActionButton: FloatingActionButton(backgroundColor: rajah_orange ,child: const Icon(Icons.edit_document), onPressed: () {

          scaffoldKey.currentState!.showBottomSheet(
                  (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
                      child: Column(
                        children: [
                          ListTile(
                            trailing: IconButton(onPressed: () {
                              ListExurcion lt=ListExurcion();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ListListExurcion_Insersion_Update_Page(listExurcion: lt),));
                            }, icon: const Icon(Icons.add)),
                            title: Row(
                              children: [
                                const Icon(Icons.assignment,color: indigo_blue,),
                                Text(" List Exurcion",style: Theme.of(context).textTheme.headline5),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: ListView.builder(itemCount: listListExurcion.length, itemBuilder: (context, index) {
                              return ListTile(
                                  title:Text(listListExurcion[index].address_depart,style: Theme.of(context).textTheme.bodyText1) ,
                                  subtitle:Text("${listListExurcion[index].prix} TND",style: Theme.of(context).textTheme.bodyText2),
                                  trailing: IconButton(onPressed:() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListListExurcion_Insersion_Update_Page(listExurcion: listListExurcion[index]),));
                                  }, icon: const Icon(Icons.edit,size: 16,)),
                              );
                            },),
                          ),
                        ],
                      ),
                    ),
                  ) ;
                }
                );
              },
              backgroundColor:Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
          );
        }),

        body:loading
            ?Center(
          child: LoadingAnimationWidget.prograssiveDots(
            color: Colors.white,
            size: 30,
          ),
        )
            :isInternet
            ?result_total!=0
            ?ListView.builder(
          itemCount: result_total,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Card_Exurcion(exurcion: listExurcion[index]);
          },
        )
            :const Center(child: Text("Aucune Réservation"))
            :const Center(child: Text("Aucune Connexion Internet"),)
    );
  }
}

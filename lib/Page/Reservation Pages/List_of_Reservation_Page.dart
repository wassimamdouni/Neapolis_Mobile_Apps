
// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_final_fields, await_only_futures, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Compound/Card_Reservation.dart';
import 'package:neapolis_admin/Class/Reservation.dart';
import 'package:neapolis_admin/Compound/Menu_Bar.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class List_of_Reservation_Page extends StatefulWidget {
  @override
  State<List_of_Reservation_Page> createState() => _List_of_Reservation_PageState();
}

class _List_of_Reservation_PageState extends State<List_of_Reservation_Page> {

  bool isInternet = false;
  bool loading = true;

  List<String> listTrie=["Prix","Date"];
  List<String> listOrdre=["Ascendant","Descendant"];
  String dropdownValueTrie='';
  String dropdownValueOrdre='';
  String searchValue="";
  DateTime date_Start=DateTime.now();
  DateTime date_End=DateTime.now();


  int result_total=0;
  List<Reservation> listReservation=[];

  TextEditingController search_controller=TextEditingController();
  DateRangePickerController _datePickerController = DateRangePickerController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  getAllReservitions()async{
    setState(() {
      listReservation=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllReservation'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Reservations"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Reservation reservation =Reservation(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listReservation.add(reservation);
            result_total=listReservation.length;
            loading = false;
          });
          await Future.delayed(const Duration(milliseconds: 500));
        }
        setState(() {
          loading = false;
        });
      }
    }
    else {}
  }

  SearchReservation()async{
    setState(() {
      loading=true;
      searchValue=search_controller.text;
      search_controller.clear();
      date_Start=_datePickerController.selectedRange!.startDate??DateTime.now();
      date_End=_datePickerController.selectedRange!.endDate??DateTime.now();
      listReservation=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/SearchReservation'));
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
        List<dynamic> body02=json.decode(body01["Reservations"]);
        List<Reservation> listR=[];
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Reservation reservation =Reservation(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          listR.add(reservation);
        }
        if(dropdownValueTrie=="Prix"){
          if(dropdownValueOrdre=="Ascendant"){
            await TriePrixAscendant(listR);
            setState(() {
              loading = false;
            });
          }
          else if(dropdownValueOrdre=="Descendant"){
            await TriePrixDescendant(listR);
            setState(() {
              loading = false;
            });
          }
        }
        else if(dropdownValueTrie=="Date"){
          if(dropdownValueOrdre=="Ascendant"){
            await TrieDateAscendant(listR);
            setState(() {
              loading = false;
            });
          }
          else if(dropdownValueOrdre=="Descendant"){
            await TrieDateDescendant(listR);
            setState(() {
              loading = false;
            });
          }
        }
        else{
          setState(() {
            listReservation=listR;
            result_total=listReservation.length;
            loading=false;
          });
        }


      }
      else{
        setState(() {
          loading = false;
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

  TriePrixAscendant(List<Reservation> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].total_prix > array[j + 1].total_prix) {
          // Swapping using temporary variable
          Reservation temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listReservation=array;
      result_total=listReservation.length;
      loading=false;
    });
  }

  TriePrixDescendant(List<Reservation> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].total_prix < array[j + 1].total_prix) {
          // Swapping using temporary variable
          Reservation temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listReservation=array;
      result_total=listReservation.length;
      loading=false;
    });
  }

  TrieDateAscendant(List<Reservation> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].date_depar.compareTo(array[j + 1].date_depar) > 0) {
          // Swapping using temporary variable
          Reservation temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listReservation=array;
      result_total=listReservation.length;
      loading=false;
    });
  }

  TrieDateDescendant(List<Reservation> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].date_depar.compareTo(array[j + 1].date_depar) < 0) {
          // Swapping using temporary variable
          Reservation temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listReservation=array;
      result_total=listReservation.length;
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

  @override
  void initState(){
    testInternet();
    getAllReservitions();
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
                  margin: const EdgeInsets.all(16),
                  color:Colors.white,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
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
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: DropdownMenu<String>(
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
                              ),
                              Expanded(
                                child: DropdownMenu<String>(
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
                                ),
                              )
                            ],
                          ),
                        ),
                        //Calendar
                        Card(
                          margin: const EdgeInsets.all(8),
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
                                SearchReservation();
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
                                getAllReservitions();
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
          title:const Text("List de Réservations"),
        ),
        endDrawer:Menu_Bar(),

        body:isInternet
            ?loading
            ?Center(
          child: LoadingAnimationWidget.prograssiveDots(
            color: Colors.white,
            size: 30,
          ),
        )
            :result_total!=0
            ?ListView.builder(
              itemCount: result_total,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Card_Reservation(reservation: listReservation[index]);
              },
            )
            :const Center(child: Text("Aucune Réservation"))
            :const Center(child: Text("Aucune Connexion Internet"),)

    );
  }
}

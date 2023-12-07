
// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_final_fields, await_only_futures, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neapolis_admin/Class/ListTransfer.dart';
import 'package:neapolis_admin/Compound/Card_Transfer.dart';
import 'package:neapolis_admin/Class/Transfer.dart';
import 'package:neapolis_admin/Compound/Menu_Bar.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class List_of_Transfer_Page extends StatefulWidget {
  @override
  State<List_of_Transfer_Page> createState() => _List_of_Transfer_PageState();
}

class _List_of_Transfer_PageState extends State<List_of_Transfer_Page> {

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
  List<Transfer> listTransfer=[];
  List<ListTransfer> listListTransfer=[];

  TextEditingController search_controller=TextEditingController();
  DateRangePickerController _datePickerController = DateRangePickerController();

  ListTransfer lt=ListTransfer();
  TextEditingController address_depart_controller=TextEditingController();
  TextEditingController address_fin_controller=TextEditingController();
  TextEditingController prix_controller=TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  getAllTransfer()async{
    setState(() {
      listTransfer=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllTransfer'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        List<dynamic> body02=json.decode(body01["Transfers"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Transfer transfer =Transfer(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listTransfer.add(transfer);
            result_total=listTransfer.length;
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

  SearchTransfer()async{
    setState(() {
      loading=true;
      searchValue=search_controller.text;
      search_controller.clear();
      date_Start=_datePickerController.selectedRange!.startDate??DateTime.now();
      date_End=_datePickerController.selectedRange!.endDate??DateTime.now();
      listTransfer=[];
      result_total=0;
    });
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/SearchTransfer'));
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
        List<dynamic> body02=json.decode(body01["Transfers"]);
        List<Transfer> listR=[];
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          Transfer transfer =Transfer(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          listR.add(transfer);
        }
        setState(() {
          loading = false;
        });
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
            listTransfer=listR;
            result_total=listTransfer.length;
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

  TriePrixAscendant(List<Transfer> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].total_prix > array[j + 1].total_prix) {
          // Swapping using temporary variable
          Transfer temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listTransfer=array;
      result_total=listTransfer.length;
      loading=false;
    });
  }

  TriePrixDescendant(List<Transfer> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].total_prix < array[j + 1].total_prix) {
          // Swapping using temporary variable
          Transfer temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listTransfer=array;
      result_total=listTransfer.length;
      loading=false;
    });
  }

  TrieDateAscendant(List<Transfer> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].date_depar.compareTo(array[j + 1].date_depar) > 0) {
          // Swapping using temporary variable
          Transfer temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listTransfer=array;
      result_total=listTransfer.length;
      loading=false;
    });
  }

  TrieDateDescendant(List<Transfer> array)async {
    int lengthOfArray = array.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (array[j].date_depar.compareTo(array[j + 1].date_depar) < 0) {
          // Swapping using temporary variable
          Transfer temp = await array[j];
          array[j] = await array[j + 1];
          array[j + 1] = await temp;
        }
      }
    }
    setState(() {
      listTransfer=array;
      result_total=listTransfer.length;
      loading=false;
    });
  }

  getListTransfer() async {
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/GetAllListTransfer'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> body01 = json.decode(responseString);
      if (body01["Response"] == "Success") {
        List<dynamic> body02=json.decode(body01["ListTransfers"]);
        for(int i =0;i<body02.length;i++){
          String fields =json.encode(body02[i]["fields"]);
          int id=body02[i]["pk"];
          ListTransfer lt = await ListTransfer(fields: fields,id:id);
          setState(() {
            listListTransfer.add(lt);
          });

        }

      }
    }
    else {}
  }

  Insert_Update_ListTransfer()async{
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Insert_Update_ListTransfer'));
    request.fields.addAll({
      'id': lt.id.toString(),
      'address_depart': address_depart_controller.text,
      'address_fin': address_fin_controller.text,
      'prix': prix_controller.text
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(lt.id==0){
        if(body01["Response"]=="Success") {
          List<dynamic> body02=json.decode(body01["ListTransfer"]);
          String fields =json.encode(body02[0]["fields"]);
          int id=body02[0]["pk"];
          ListTransfer lt01 =ListTransfer(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            listListTransfer.add(lt01);
            address_depart_controller.clear();
            address_fin_controller.clear();
            prix_controller.clear();
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
          List<dynamic> body02=json.decode(body01["ListTransfer"]);
          String fields =json.encode(body02[0]["fields"]);
          int id=body02[0]["pk"];
          ListTransfer lt01 =ListTransfer(fields: fields,id:id);
          await Future.delayed(const Duration(seconds: 1));
          for(int i =0;i<listListTransfer.length;i++){
            if(listListTransfer[i].id==lt.id){
              setState(() {
                listListTransfer[i]=lt01;
                lt=ListTransfer();
                address_depart_controller.clear();
                address_fin_controller.clear();
                prix_controller.clear();
              });
            }

          }
          await Future.delayed(const Duration(milliseconds: 500));
          showSnackBar("Succès");
        }
        else if(body01["Response"]=="Not Exist") {
          showSnackBar("La marque n'est pas existé");
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
    getAllTransfer();
    getListTransfer();
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
                                      SearchTransfer();
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
                                      getAllTransfer();
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
          title:const Text("List de Transfer"),
        ),
        endDrawer:Menu_Bar(),
        floatingActionButton: FloatingActionButton(backgroundColor: rajah_orange,child: const Icon(Icons.edit_document), onPressed: () {
          scaffoldKey.currentState!.showBottomSheet(
                  (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.assignment),
                              Text(" List Transfer",style: Theme.of(context).textTheme.headline5),
                              const Spacer(),
                            ],
                          ),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(itemCount: listListTransfer.length, itemBuilder: (context, index) {
                              return ListTile(
                                  title:Text("${listListTransfer[index].address_depart} -- ${listListTransfer[index].address_fin}",style: Theme.of(context).textTheme.bodyText1) ,
                                  subtitle:Text("${listListTransfer[index].prix} TND",style: Theme.of(context).textTheme.bodyText2),
                                  trailing: IconButton(onPressed:() {
                                    setState((){
                                      lt=listListTransfer[index];
                                      address_depart_controller.text=listListTransfer[index].address_depart;
                                      address_fin_controller.text=listListTransfer[index].address_fin;
                                      prix_controller.text=listListTransfer[index].prix.toString();

                                    });
                                  }, icon: const Icon(Icons.edit,size: 16,)),
                              );
                            },),
                          ),
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
                              child:Text("Address Fin :", style:Theme.of(context).textTheme.subtitle1,),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: address_fin_controller,
                              style: const TextStyle(color: Colors.black45),
                              decoration:const InputDecoration(
                                hintText: 'Address Fin',
                                prefixIcon: Icon(Icons.share_location,) ,
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
                          Row(
                            children: [
                              Expanded(child: ElevatedButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    setState((){
                                      address_depart_controller.clear();
                                      address_fin_controller.clear();
                                      prix_controller.clear();
                                      lt=ListTransfer();
                                    });
                                  }
                              )),
                              const SizedBox(width: 4,),
                              Expanded(child: ElevatedButton(
                                onPressed: () {
                                Insert_Update_ListTransfer();
                              },
                                child: Text(lt.id==0?"Ajouter":"Modifier"),
                              )
                              ),
                            ],
                          ),
                        ],
                      )




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
            return Card_Transfer(transfer: listTransfer[index]);
          },
        )
            :const Center(child: Text("Aucune Transfer"))
            :const Center(child: Text("Aucune Connexion Internet"),)
    );
  }
}

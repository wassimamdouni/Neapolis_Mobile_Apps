// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types, deprecated_member_use, no_logic_in_create_state, non_constant_identifier_names, sort_child_properties_last


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:neapolis_admin/Class/Paiment.dart';
import 'package:neapolis_admin/Page/Client Pages/ClientDetails_Page.dart';
import 'package:neapolis_admin/Decoration/colors.dart';


class Card_PaimentDetails extends StatefulWidget {
  Paiment paiment;

  Card_PaimentDetails({required this.paiment});

  @override
  State<Card_PaimentDetails> createState() => _Card_PaimentDetailsState(paiment: paiment);
}

class _Card_PaimentDetailsState extends State<Card_PaimentDetails> {

  Paiment paiment;
  bool isInternet = false;
  bool isThemeLight = SchedulerBinding.instance.platformDispatcher
      .platformBrightness == Brightness.light;

  _Card_PaimentDetailsState({required this.paiment});




  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        child:Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: CircleAvatar(
                maxRadius: 64,
                backgroundColor: Colors.grey,
                backgroundImage:NetworkImage(paiment.demande.client.photo),
                onBackgroundImageError:(exception, stackTrace) => Container(),
              ),
            ),
            //Information Client
            ListTile(
              leading: InkWell(
                child:CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:NetworkImage(paiment.demande.client.photo),
                  onBackgroundImageError:(exception, stackTrace) => Container(),
                ),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientDetails_Page(client: paiment.demande.client),));
                },
              ),
              title:Text(paiment.demande.client.nomprenom,style: Theme.of(context).textTheme.headline5,),
              subtitle:Text(paiment.demande.etat,style: Theme.of(context).textTheme.bodyText1),
            ),
            //Details
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.assignment),
                    Text(" Details",style: Theme.of(context).textTheme.headline5),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_available,color: rajah_orange,),
                              Text(" Date de Paiment ",style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                          Text(DateFormat('yyyy-MM-dd kk:mm').format(paiment.date),style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      TableRow(children:[
                        Row(
                          children: [
                            const Icon(Icons.event_available,size: 24,color:rajah_orange),
                            Text(" Type Demande:", style: Theme.of(context).textTheme.bodyText2),
                          ],
                        ),
                        Text(paiment.demande.type,style: Theme.of(context).textTheme.bodyText1),
                      ]),
                      TableRow(children:[
                        Row(
                          children: [
                            const Icon(Icons.event_available,size: 24,color:rajah_orange),
                            const SizedBox(width: 2,),
                            Text("Methode Paiment:", style: Theme.of(context).textTheme.bodyText2),
                          ],
                        ),
                        Text(paiment.type,style: Theme.of(context).textTheme.bodyText1),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            //Services
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.token),
                    Text(" Services",style: Theme.of(context).textTheme.headline5),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children:List<Widget>.generate(paiment.demande.listService.length, (index){
                      return Row(
                          children: [
                            const Icon(Icons.check_circle,color:rajah_orange,),
                            const SizedBox(width: 10),
                            Text(paiment.demande.listService[index].nom,style: Theme.of(context).textTheme.caption!.apply(color:Colors.black)),]
                      );
                    }
                    ),
                  ),
                ),
              ],
            ),
            //Price
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on),
                  Text("Total Prix: ${paiment.prix} TND",style: Theme.of(context).textTheme.headline5),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

}
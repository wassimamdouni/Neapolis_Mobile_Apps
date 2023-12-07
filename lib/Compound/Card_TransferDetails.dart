// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types, deprecated_member_use, no_logic_in_create_state, non_constant_identifier_names, sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:neapolis_admin/Class/Transfer.dart';
import 'package:neapolis_admin/Page/Client Pages/ClientDetails_Page.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:http/http.dart' as http;
import 'package:neapolis_admin/main.dart';

class Card_TransferDetails extends StatefulWidget {
  Transfer transfer;

  Card_TransferDetails({required this.transfer});

  @override
  State<Card_TransferDetails> createState() => _Card_TransferDetailsState(transfer: transfer);
}

class _Card_TransferDetailsState extends State<Card_TransferDetails> {

  Transfer transfer;
  bool isInternet = false;
  bool isThemeLight = SchedulerBinding.instance.platformDispatcher
      .platformBrightness == Brightness.light;

  _Card_TransferDetailsState({required this.transfer});



  update_Etat_Transfer(String etat)async{
    var request = http.MultipartRequest('POST', Uri.parse('${url}polls/Update_Etat_Transfer'));
    request.fields.addAll({
      'idTransfer': transfer.id.toString(),
      'etat': etat,
      'prix':transfer.total_prix.toString()
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString =await response.stream.bytesToString();
      Map<String, dynamic> body01=json.decode(responseString);
      if(body01["Response"]=="Success") {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          transfer.demande.etat=etat;
        });
        await Future.delayed(const Duration(milliseconds:500));
      }
    }
    else {}
  }

  @override
  Widget build(BuildContext context) {
    PopupMenuButton dropdown_menus = PopupMenuButton(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon:const Icon(Icons.more_vert),
      onSelected: (value) {
        update_Etat_Transfer(value);
      },

      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          value:"Attende",
          child:ListTile(
            enabled: !(transfer.demande.etat=="Attende"),
            leading: const Icon(Icons.hourglass_bottom,),
            title: const Text("Attende")

          ),
        ),
        PopupMenuItem(
          value: "En Cours",
          child:ListTile(
            enabled: !(transfer.demande.etat=="En Cours"),
            leading: const Icon(Icons.timelapse,),
            title: const Text("En Cours")

          ),
        ),
        PopupMenuItem(
          value: "Terminer",
          child:ListTile(
            enabled: !(transfer.demande.etat=="Terminer"),
            leading: const Icon(Icons.check_circle,),
            title: const Text("Terminer")
          ),
        ),
        PopupMenuItem(
          value: "Annuler",
          child:ListTile(
            enabled: !(transfer.demande.etat=="Annuler"),
            leading: const Icon(Icons.cancel),
            title: const Text("Annuler")

          ),
        ),
      ],
    );

    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        child:Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child:ClipRRect(
                      borderRadius:const BorderRadius.vertical(top: Radius.circular(16)),
                      child:Image.network(transfer.voiture.photo,
                        fit: BoxFit.fitWidth,
                        errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),)
                  ),
                ),
                Container(
                  child: Text("${transfer.voiture.marquer!.nom} ${transfer.voiture.modele} ${transfer.voiture.annee}",style: Theme.of(context).textTheme.headline1,),
                  margin: const EdgeInsets.all(16),
                ),
              ],
              alignment: Alignment.bottomCenter,
            ),
            ListTile(
              leading: InkWell(
                child:CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:NetworkImage(transfer.demande.client.photo),
                  onBackgroundImageError:(exception, stackTrace) => Container(),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClientDetails_Page(client: transfer.demande.client),));
                },
              ),
              title:Text(transfer.demande.client.nomprenom,style: Theme.of(context).textTheme.headline5,),
              subtitle:Text(transfer.demande.etat,style: Theme.of(context).textTheme.bodyText1),
              trailing:dropdown_menus,
            ),
            //Details
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
                          const Icon(Icons.event_available,size: 24,color:rajah_orange),
                          Text(" Date de départ ",style: Theme.of(context).textTheme.bodyText2),
                        ],
                      ),
                      Text(DateFormat('yyyy-MM-dd kk:mm').format(transfer.date_depar),style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  TableRow(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flag_circle_outlined,color: rajah_orange,size: 24,),
                          Text(" Adresse de départ ",style: Theme.of(context).textTheme.bodyText2)
                        ],
                      ),
                      Text(transfer.listTransfer.address_depart,style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  TableRow(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flag_circle,color: rajah_orange,size: 24,),
                          Text(" Adresse de retour ",style: Theme.of(context).textTheme.bodyText2)
                        ],
                      ),
                      Text(transfer.listTransfer.address_fin,style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                ],
              ),
            ),
            //Services
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
                children:List<Widget>.generate(transfer.listServises.length, (index){
                  return Row(
                      children: [
                        const Icon(Icons.check_circle,color:rajah_orange,),
                        const SizedBox(width: 10),
                        Text(transfer.listServises[index].nom,style: Theme.of(context).textTheme.caption!.apply(color:Colors.black)),]
                  );
                }
                ),
              ),
            ),
            //Price
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on),
                Text(" Total Prix: ${transfer.total_prix} TND",style: Theme.of(context).textTheme.headline5),
              ],
            ),
            const SizedBox(height: 24,)
          ],
        ),
      ),
    );

  }

}
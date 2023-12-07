

// ignore_for_file: must_be_immutable, camel_case_types, deprecated_member_use, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:neapolis_admin/Class/Reservation.dart';
import 'package:neapolis_admin/Page/Client Pages/ClientDetails_Page.dart';
import 'package:neapolis_admin/Compound/Card_ReservationDetails.dart';
import 'package:neapolis_admin/Decoration/colors.dart';



class Card_Reservation extends StatefulWidget {
  Reservation reservation;
  //

  Card_Reservation({required this.reservation});

  @override
  State<Card_Reservation> createState() => _Card_ReservationState(reservation: reservation);
}

class _Card_ReservationState extends State<Card_Reservation> {

  Reservation reservation;

  bool isInternet = false;
  bool loading = true;

  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  _Card_ReservationState({required this.reservation});



  @override
  Widget build(BuildContext context) {
    return Card(
      child:Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child:ClipRRect(
                    borderRadius:const BorderRadius.vertical(top: Radius.circular(16)),
                    child:Image.network(reservation.voiture.photo,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),)
                ),
              ),
              Container(
                child: Text("${reservation.voiture.marquer!.nom} ${reservation.voiture.modele} ${reservation.voiture.annee}",style: Theme.of(context).textTheme.headline1,),
                margin: const EdgeInsets.all(16),
              ),
            ],
            alignment: Alignment.bottomCenter,
          ),
          ListTile(
            leading: InkWell(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage:NetworkImage(reservation.demande.client.photo),
                onBackgroundImageError:(exception, stackTrace) => Container(),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClientDetails_Page(client: reservation.demande.client),));
              },
            ),
            title:Text(reservation.demande.client.nomprenom,style: Theme.of(context).textTheme.headline5,),
            subtitle:Text(reservation.demande.etat,style: Theme.of(context).textTheme.bodyText1),
            trailing:InkWell(
              child: const Icon(Icons.more_vert),
              onTap: () {
                showBottomSheet(
                    backgroundColor:Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    context: context, builder: (context) {
                  return Card_ReservationDetails(reservation: reservation);
                });
              },
            ),
          ),
          const Divider(thickness: 1,indent: 20,endIndent: 20,color: light_cobalt_blue_shade,),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 24,bottom: 10),
              child: Text(
              "${DateFormat('yyyy-MM-dd').format(reservation.date_depar)} --- ${DateFormat('yyyy-MM-dd').format(reservation.date_arriver)} | Prix: ${reservation.total_prix} TND ",
              style: Theme.of(context).textTheme.bodyText1)),
        ],
      ),
    );
  }

}
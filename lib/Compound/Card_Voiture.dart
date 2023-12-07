

// ignore_for_file: must_be_immutable, camel_case_types, deprecated_member_use, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:neapolis_admin/Class/Voiture.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:neapolis_admin/Page/Voiture%20Pages/VoitureDetails_Page.dart';


class Card_Voiture extends StatefulWidget {
  Voiture voiture;

  Card_Voiture({required this.voiture});

  @override
  State<Card_Voiture> createState() => _Card_VoitureState(voiture: voiture);
}

class _Card_VoitureState extends State<Card_Voiture> {

  Voiture voiture;
  bool isInternet = false;
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  _Card_VoitureState({required this.voiture});

  @override
  Widget build(BuildContext context) {
    return Card(
      child:Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child:ClipRRect(
                    borderRadius:const BorderRadius.vertical(top: Radius.circular(16)),
                    child:Image.network(voiture.photo,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),)
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: voiture.color,
                ),
              )
            ],
          ),
          ListTile(
            title: Text("${voiture.marquer!.nom} ${voiture.modele} ${voiture.annee}",style: Theme.of(context).textTheme.headline4,),
            subtitle:Text("${voiture.prix_jour} TND/Jour", style: Theme.of(context).textTheme.bodyText1),
            trailing:InkWell(
              child: const Icon(Icons.more_vert),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VoitureDetails_Page(voiture: voiture),));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16,),
            alignment: Alignment.centerLeft,
            child: Text(voiture.description,style: Theme.of(context).textTheme.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(thickness: 1,indent: 24,endIndent: 24,color: light_cobalt_blue_shade,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                elevation: 1,
                selectedColor: Colors.white,
                avatar: const Icon(Icons.event_seat,color: rajah_orange,),
                label: Text('${voiture.nb_seats} Places',style: const TextStyle(color: Colors.black),),
                selected: true,
              ),
              ChoiceChip(
                elevation: 1,
                selectedColor: Colors.white,
                avatar: const Icon(Icons.sim_card,color: rajah_orange,),
                label: Text('${voiture.nb_ports} Ports',style: const TextStyle(color: Colors.black),),
                selected: true,
              ),
              ChoiceChip(
                elevation: 1,
                selectedColor: Colors.white,
                avatar: const Icon(Icons.luggage,color: rajah_orange,),
                label: Text('${voiture.nb_bags} Bags',style: const TextStyle(color: Colors.black),),
                selected: true,
              ),
            ],
          ),
          const Divider(thickness: 1,indent: 48,endIndent: 48,color: light_cobalt_blue_shade,),




        ],
      ),
    );
  }

}
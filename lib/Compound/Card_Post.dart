

// ignore_for_file: must_be_immutable, camel_case_types, deprecated_member_use, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:neapolis_admin/Class/Post.dart';
import 'package:neapolis_admin/Decoration/colors.dart';
import 'package:neapolis_admin/Page/Post%20Pages/PostUpdate_Page.dart';
//import 'package:neapolis_admin/Page/Post%20Pages/PostDetails_Page.dart';


class Card_Post extends StatefulWidget {
  Post post;

  Card_Post({required this.post});

  @override
  State<Card_Post> createState() => _Card_PostState(post: post);
}

class _Card_PostState extends State<Card_Post> {

  Post post;
  bool isInternet = false;
  bool isThemeLight =SchedulerBinding.instance.platformDispatcher.platformBrightness==Brightness.light;

  _Card_PostState({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child:Column(
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child:ClipRRect(
                borderRadius:const BorderRadius.vertical(top: Radius.circular(16)),
                child:Image.network(post.photo,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),)
            ),
          ),
          ListTile(
            title: Text(post.title,style: Theme.of(context).textTheme.headline3!.apply(color: rajah_orange),),
            subtitle:Text(post.descriptions, overflow: TextOverflow.ellipsis,),
            trailing:InkWell(
              child: const Icon(Icons.edit),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostUpdate_Page(post: post),));
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text("Lien: ${post.lien}",
              style: Theme.of(context).textTheme.caption!.apply(color: Colors.black38),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(thickness: 1,indent: 20,endIndent: 20,color: light_cobalt_blue_shade,),
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 24,bottom: 10),
              child: Text(
                "${DateFormat('yyyy-MM-dd').format(post.date_depart)} --- ${DateFormat('yyyy-MM-dd').format(post.date_fin)}",
                style: Theme.of(context).textTheme.caption!.apply(color: Colors.black38),
              )
          ),
        ],
      ),
    );
  }

}
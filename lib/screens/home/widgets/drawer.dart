import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/Colors.dart';
import '../../login.ui/login_screen.dart';

Drawer drawer(BuildContext context){
  return Drawer(

    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(

            color: AppColor.colorBackground,
          ),
          child: Image.asset('assets/images/logoproject.png'),
        ),
        ListTile(
          title: const Text('Share App'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: const Text('Rate App'),
          onTap: () {
            // Update the state of the app.
            // ...
          },

        ),
        ListTile(
          title: const Text('Logout'),
          onTap: () async {
            Navigator.pop(context);


            showDialog(
                context: context,
                builder: (ctx) =>
            AlertDialog(
              title: const Text('Logout User'),
              content: const Text('Are you sure do you really want to logout?'),
              actions: <Widget>[
                ElevatedButton(
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
            backgroundColor:  AppColor.colorPrimary , // This is what you need!
            ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                    backgroundColor:  Colors.red , // This is what you need!
                  ),
                  onPressed: () async{

                    await FirebaseAuth.instance.signOut();

                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false);
                  },
                  child: const Text('Logout'),
                ),
              ],
            ));

            // Update the state of the app.
            // ...
          },

        ),
      ],
    ),
  );
}
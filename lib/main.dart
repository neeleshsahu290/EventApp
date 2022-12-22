import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterpoject/Screens/LoginScreen.dart';
import 'package:flutterpoject/res/Colors.dart';
import 'Screens/HomeScreen.dart';
import 'firebase_options.dart';

void main()   async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch:AppColor.colorPrimaryAccent,
          textTheme: const TextTheme(
            bodyText1: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color: Colors.black),
            button: TextStyle(color: Colors.black),
            caption: TextStyle(color: Colors.black),
            subtitle1: TextStyle(color: Colors.black), // <-- that's the one
            headline1: TextStyle(color: Colors.black),
            headline2: TextStyle(color: Colors.black),
            headline3: TextStyle(color: Colors.black),
            headline4: TextStyle(color: Colors.black),
            headline5: TextStyle(color: Colors.black),
            headline6: TextStyle(color: Colors.black),
          ),
          /*inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.orange,
            filled: true,
          )*/
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {

    Timer(const Duration(seconds: 3),
            ()=> Navigator.push(context,
          MaterialPageRoute(builder:
              (context) =>MainPage()
          )
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(child:  Image.asset('assets/images/logoproject.png'),),

    ),);
  }

}




class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   // final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<User?>( stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
      if(snapshot.hasData){

        return  const HomeScreen();
      }else{
        return LoginScreen();
      }
        });
  }

  
  
}




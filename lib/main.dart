import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpoject/helper/navigator_help.dart';
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/screens/home/ui/home_screen.dart';
import 'package:flutterpoject/screens/login.ui/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'firebase_options.dart';

void main()   async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()))



  ;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        builder: ((context, orientation, screenType) =>MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch:AppColor.colorPrimaryAccent,
      ),
      home: SplashScreen()
    )));
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
            ()=>navigatorPushReplace(context, MainPage())
      //           Navigator.push(context,
      //     MaterialPageRoute(builder:
      //         (context) =>MainPage()
      //     )
      // )
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
        return HomeScreen();

       // return  const HomeScreen();
      }else{
        return LoginScreen();
      }
        });
  }

  
  
}




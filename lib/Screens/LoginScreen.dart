
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/res/Dimensions.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'CreateAccountScreen.dart';
import 'HomeScreen.dart';


class LoginScreen  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginState();


}

class LoginState  extends  State<LoginScreen>{

  late TextEditingController _controllerEmail ,_controllerPassword ;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  late String email, password;
  final _formKey = GlobalKey<FormState>();

  //late Future<Loginmsg> Logincreate;
  bool _isLoading = false;
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(

      body: SingleChildScrollView(
        child: Container( height: MediaQuery.of(context).size.height,
          decoration:  BoxDecoration( color: AppColors().colorBackground
           /* gradient: LinearGradient(
                colors: [Color(23613865646561), Color(23666564366533)],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.5, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp
            ),*/
          ),
          child: Center( child: Card( margin: const EdgeInsets.all(8.0),
              elevation: ElevationSize().lightElevation,
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
            child: Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              child: Form( key: _formKey,
                child: Column( mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MarginSize().bigMargin,
                        vertical: MarginSize().smallMargin),
                    child: Text("Login",style: TextStyle(fontSize: TextSize().bigText,fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MarginSize().bigMargin,
                    vertical: MarginSize().smallMargin),
                    child: TextFormField(
                        controller: _controllerEmail ,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a email address';
                          }else if(EmailValidator.validate(value.trim())==false){
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail),
                          labelText: 'Email',
                          suffixStyle: const TextStyle(color: Colors.red),
                          hoverColor: Colors.green,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors().colorTextField),
                            borderRadius: BorderRadius.circular(ExtraDimen().inputTextFieldRadius,),
                          ),
                          floatingLabelStyle: TextStyle(color: AppColors().colorTextField),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ExtraDimen().inputTextFieldRadius,),
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:MarginSize().bigMargin,
                        vertical: MarginSize().smallMargin),
                    child: TextFormField(
                      controller: _controllerPassword,
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors().colorTextField),
                          borderRadius: BorderRadius.circular(ExtraDimen().inputTextFieldRadius,),
                        ),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              _togglePasswordView();
                            },
                            child: Icon(_isHidden
                                ? Icons.remove_moderator_outlined
                                : Icons.remove_red_eye_outlined)),
                        floatingLabelStyle: TextStyle(color: AppColors().colorTextField),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ExtraDimen().inputTextFieldRadius,),
                        ),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        //   ValidationMixin().emailValidationMixin(value!);
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MarginSize().bigMargin,
                        vertical: MarginSize().smallMargin),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Container(
                              constraints: const BoxConstraints.tightFor(),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ExtraDimen().inputTextFieldRadius,),
                                    ),),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    debugPrint(_controllerEmail.text +
                                        _controllerPassword.text);
                                    email = _controllerEmail.text;
                                    password = _controllerPassword.text;
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    login();
                                  }
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 50.0,
                                    child: const Text('Login')),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MarginSize().bigMargin,
                      vertical: MarginSize().smallMargin),
                    child: Container(alignment: Alignment.centerRight,width: double.infinity,
                      child: InkWell(
                          onTap: () {

                          },
                          child:  const Text("Forgot Password?")),
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal:MarginSize().bigMargin,
                        vertical: 0),
                    child: const Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    )
                  ),
                   Container(
                       alignment: Alignment.center,child: const Text("OR")),
                  Container(width: double.infinity,
                    child: IconButton(alignment: Alignment.center,
                      icon: Image.asset('assets/images/google.png'),
                      iconSize: 50,
                      onPressed: () {},
                    ),
                  ),
                  Container(alignment: Alignment.center,child:
                  InkWell(onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountScreen(),
                        ));
                  },child: const Text("Create New Account"))),
                ],
              ),

              ),
            )

          ),

          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }



  Future login() async{
    final bool isConnected = await InternetConnectionChecker().hasConnection;

    if(isConnected) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim()
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          snackBarMsg("User doesn't exist", context);
          exitLoading();
        } else if (e.code == 'wrong-password') {
          snackBarMsg("YOu have entered a wrong password", context);
          exitLoading();
        } else if (e.code == 'too-many_requests') {
          snackBarMsg(
              'Too many times you have entered a wrong credentials. Try again after some time',
              context);
          exitLoading();
        } else {
          snackBarMsg(e.toString(), context);
          exitLoading();
        }
      } catch (e) {
        snackBarMsg(e.toString(), context);
        exitLoading();
      }
    }else{
      noInternetSnackbar(context);
      exitLoading();
    }

  }




   void exitLoading(){
    setState(() {
      _isLoading=false;
    });
  }
  
  

}
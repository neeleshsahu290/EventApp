import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterpoject/assets/constants.dart' as Constants;
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/res/Dimensions.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'HomeScreen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccountScreen> {
  late TextEditingController _controllerEmail,
      _controllerPassword,
      _controllerRePassword,
      _controllerUsername;
  var email, password, name;
  var db = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
    _controllerRePassword = TextEditingController();
    _controllerUsername = TextEditingController();
  }

  @override
  void dispose() {
    _controllerPassword.dispose();
    _controllerEmail.dispose();
    _controllerRePassword.dispose();
    _controllerUsername.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration:  BoxDecoration( color: AppColors().colorBackground
          /*  gradient: LinearGradient(
                colors: [Color(23613865646561), Color(23666564366533)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.5, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp
            ),*/
          ),
          child: Center(
            child: Card(
                margin: EdgeInsets.all(8.0),
                elevation: ElevationSize().lightElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MarginSize().bigMargin,
                              vertical:
                                  MarginSize().smallMargin),
                          child: Text("Create New Account",
                              style: TextStyle(
                                  fontSize: TextSize().bigText,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MarginSize().bigMargin,
                              vertical:
                                  MarginSize().smallMargin),
                          child: TextFormField(
                              controller: _controllerUsername,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                labelText: 'Username',
                                suffixStyle: TextStyle(color: Colors.red),
                                hoverColor: Colors.green,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors().colorTextField),
                                  borderRadius: BorderRadius.circular(
                                    ExtraDimen().inputTextFieldRadius,
                                  ),
                                ),
                                floatingLabelStyle: TextStyle(
                                    color: AppColors().colorTextField),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                 ExtraDimen().inputTextFieldRadius,
                                  ),
                                ),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MarginSize().bigMargin,
                              vertical:
                                  MarginSize().smallMargin),
                          child: TextFormField(
                              controller: _controllerEmail,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a email address';
                                } else if (EmailValidator.validate(
                                        value.trim()) ==
                                    false) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.mail),
                                labelText: 'Email',
                                suffixStyle: TextStyle(color: Colors.red),
                                hoverColor: Colors.green,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors().colorTextField),
                                  borderRadius: BorderRadius.circular(
                                    ExtraDimen()
                                        .inputTextFieldRadius,
                                  ),
                                ),
                                floatingLabelStyle: TextStyle(
                                    color: AppColors().colorTextField),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    ExtraDimen()
                                        .inputTextFieldRadius,
                                  ),
                                ),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MarginSize().bigMargin,
                              vertical:
                                  MarginSize().smallMargin),
                          child: TextFormField(
                            controller: _controllerPassword,
                            //  obscureText: _isHidden,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors().colorTextField),
                                borderRadius: BorderRadius.circular(
                                  ExtraDimen().inputTextFieldRadius,
                                ),
                              ),
                              floatingLabelStyle: TextStyle(
                                  color:
                                      AppColors().colorTextField),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  ExtraDimen().inputTextFieldRadius,
                                ),
                              ),
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              //   ValidationMixin().emailValidationMixin(value!);
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              } else if (value.length < 6) {
                                return 'password must be more than 6 digit';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MarginSize().bigMargin,
                              vertical:
                                  MarginSize().smallMargin),
                          child: TextFormField(
                            controller: _controllerRePassword,
                            //  obscureText: _isHidden,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors().colorTextField),
                                borderRadius: BorderRadius.circular(
                                 ExtraDimen().inputTextFieldRadius,
                                ),
                              ),
                              floatingLabelStyle: TextStyle(
                                  color:
                                      AppColors().colorTextField),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(

                                      ExtraDimen().inputTextFieldRadius,
                                ),
                              ),
                              labelText: 'Re Enter Password',
                            ),
                            validator: (value) {
                              //   ValidationMixin().emailValidationMixin(value!);
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              } else if (_controllerPassword.text != value) {
                                return "Password Doesn't Match";
                              }

                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MarginSize().bigMargin,
                              vertical:
                                  MarginSize().smallMargin),
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      constraints:
                                          const BoxConstraints.tightFor(),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              ExtraDimen()
                                                  .inputTextFieldRadius,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            debugPrint(_controllerEmail.text +
                                                _controllerPassword.text);
                                            name = _controllerUsername.text;
                                            email = _controllerEmail.text;
                                            password = _controllerPassword.text;
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            signIn(email, password);
                                          }
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: 50.0,
                                            child: const Text('Create')),
                                      ),
                                    )),
                                  ],
                                ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MarginSize().bigMargin,
                                vertical: 0),
                            child: Divider(
                              color: Colors.black,
                              thickness: 0.5,
                            )),
                        Container(
                            alignment: Alignment.center, child: Text("OR")),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MarginSize().bigMargin,
                              vertical:
                                  MarginSize().smallMargin),
                          child: Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));*/
                                  },
                                  child: const Text("Already a User Login"))),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

//  createLogin(username, password);
  Future signIn(String email, String password) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
if(isConnected) {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    storedData();
    debugPrint("Successfully done");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      exitLoading();
      debugPrint('error : The password provided is too weak.');
      snackBarMsg('The password provided is too weak.', context);
    } else if (e.code == 'email-already-in-use') {
      exitLoading();
      debugPrint('error : The account already exists for that email.');
      snackBarMsg('The account already exists for that email.', context);
    } else {
      exitLoading();
      debugPrint('error : ${e.toString()}');
      snackBarMsg(e.code, context);
    }
  } catch (e) {
    exitLoading();
    debugPrint('error : ' + e.toString());
    snackBarMsg(e.toString(), context);
  }
}else{
  exitLoading();
  noInternetSnackbar(context);
}
  }

  Future storedData() async {
    debugPrint('error :Second Reach.');

    final user = FirebaseAuth.instance.currentUser;

    final data = <String, dynamic>{
      Constants.KEY_USERNAME: name,
      Constants.KEY_EMAIL: email,
      Constants.KEY_UID: user?.uid
    };

    // Add a new document with a generated ID
    db.collection(Constants.KEY_COLLECTION_USERS).doc(user?.uid).set(data).then(
        (value) {
      print("DocumentSnapshot successfully updated!");
      exitLoading();
      snackBarMsg("Successfully Account Created".toString(), context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false);
    }, onError: (e) {
      exitLoading();
      snackBarMsg(e.toString(), context);
    });
    //  .onError((e, _) => print("Error writing document: $e"));
  }



  void exitLoading() {
    setState(() {
      _isLoading = false;
    });
  }
}

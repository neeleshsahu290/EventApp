import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpoject/provider/create_acount_notifier.dart';
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/res/Dimensions.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:flutterpoject/widget/custom_container.dart';
import 'package:flutterpoject/widget/my_text.dart';
import 'package:flutterpoject/widget/primary_button.dart';
import 'package:flutterpoject/widget/primary_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final createAccountProvider =
    ChangeNotifierProvider.autoDispose<CreateAccountNotifier>((ref) {
  return CreateAccountNotifier();
});

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // String username,password,email,conformPassword = "";

    return Scaffold(
      body: SingleChildScrollView(
        child: CustomContainer(
          color: AppColor.colorPrimary,
          height: 100.h,
          child: Center(
            child: Card(
                margin: const EdgeInsets.all(8.0),
                elevation: cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Consumer(
                        builder: ((context, ref, child) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: horizontalMargin,
                                      vertical: verticalMargin),
                                  child: MyText(
                                    text: "Create New Account",
                                    fontSize: 20.sp,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                PrimaryTextField(
                                  controller: _controllerUsername,
                                  prefixIcon: Icons.person,
                                  inputType: TextInputType.emailAddress,
                                  maxLines: 1,
                                  hintText: 'Username',
                                  validator: (str) {
                                    if (str?.trim().isEmpty == true) {
                                      return "Enter your Name.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                PrimaryTextField(
                                  controller: _controllerEmail,
                                  prefixIcon: Icons.mail,
                                  inputType: TextInputType.emailAddress,
                                  maxLines: 1,
                                  hintText: 'Email',
                                  validator: (str) {
                                    if (str?.trim().isEmpty == true) {
                                      return "Email address is required.";
                                    } else if (!isValidEmail(str)) {
                                      return "Enter valid email Id";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                PrimaryTextField(
                                  controller: _controllerPassword,
                                  prefixIcon: Icons.lock,
                                  inputType: TextInputType.visiblePassword,
                                  maxLines: 1,
                                  isPasswordField: false,
                                  validator: (str) {
                                    if (str?.trim().isEmpty == true) {
                                      return "Password is required.";
                                    } else if (str!.length < 6) {
                                      return "Password Must be greater than 6 digits";
                                    } else {
                                      return null;
                                    }
                                  },
                                  hintText: 'Password',
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                PrimaryTextField(
                                  controller:_controllerRePassword,
                                  prefixIcon: Icons.lock,
                                  inputType: TextInputType.visiblePassword,
                                  maxLines: 1,
                                  isPasswordField: false,
                                  validator: (str) {
                                    if (str?.trim().isEmpty == true) {
                                      return "Password is required.";
                                    } else if (str != _controllerPassword.text) {
                                      return "Password doesn't match";
                                    } else {
                                      return null;
                                    }
                                  },
                                  hintText: 'Re Enter Password',
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                PrimaryButton(
                                  isLoading: ref
                                      .watch(createAccountProvider)
                                      .isLoading,
                                  btnText: 'Create',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      ref
                                          .read(createAccountProvider)
                                          .startLoading();
                                      ref
                                          .read(createAccountProvider)
                                          .CreateAccount(
                                              context,
                                              _controllerUsername.text,
                                              _controllerEmail.text,
                                              _controllerPassword.text);
                                    }
                                  },
                                ),
                                const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: horizontalMargin,
                                        vertical: 0),
                                    child: Divider(
                                      color: Colors.black,
                                      thickness: 0.5,
                                    )),
                                Container(
                                    alignment: Alignment.center,
                                    child: const Text("OR")),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: horizontalMargin,
                                      vertical: verticalMargin),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                              "Already a User Login"))),
                                ),
                              ],
                            ))),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

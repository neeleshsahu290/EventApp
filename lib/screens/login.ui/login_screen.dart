import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterpoject/helper/navigator_help.dart';
import 'package:flutterpoject/provider/login_screen_notifier.dart';
import 'package:flutterpoject/res/Colors.dart';
import 'package:flutterpoject/res/Dimensions.dart';
import 'package:flutterpoject/screens/login.ui/create_account_screen.dart';
import 'package:flutterpoject/utils/Utility.dart';
import 'package:flutterpoject/widget/custom_container.dart';
import 'package:flutterpoject/widget/my_text.dart';
import 'package:flutterpoject/widget/primary_button.dart';
import 'package:flutterpoject/widget/primary_text_field.dart';
import 'package:flutterpoject/widget/ripple.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


final loginScreenProvider =
ChangeNotifierProvider.autoDispose<LoginScreenNotifier>((ref) {
  return LoginScreenNotifier();
});

final createPwdVisibilityProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

// final createConfirmPwdVisibilityProvider =
//     StateProvider.autoDispose<bool>((ref) {
//   return false;
// });

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerEmail= TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
  }





  @override
  Widget build(BuildContext context) {
      String email, password;

    return Scaffold(
      backgroundColor: AppColor.colorPrimary,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: 100.h,
          color: AppColor.colorPrimary,
          child: Center(
            child:
            DelayedDisplay(
              delay: Duration(milliseconds: 500),
              child: Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Consumer(
                          builder: ((context, ref, child) => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: horizontalMargin,
                                      vertical: verticalMargin,
                                    ),
                                    child: MyText(
                                      text: 'Login',
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  PrimaryTextField(
                                    controller: _controllerEmail,
                                    prefixIcon: Icons.mail,
                                    inputType: TextInputType.emailAddress,
                                    maxLines: 1,
                                    onChanged: (p0) {
                                      email = p0;
                                    },
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
                                    isPasswordField: true,
                                    onChanged: (p0) {
                                      password = p0;
                                    },
                                    onSuffixIconTap: () =>
                                        ref
                                                .read(createPwdVisibilityProvider
                                                    .notifier)
                                                .state =
                                            !ref.read(createPwdVisibilityProvider),
                                    obscureText:
                                        ref.watch(createPwdVisibilityProvider),
                                    validator: (str) {
                                      if (str?.trim().isEmpty == true) {
                                        return "Password is required.";
                                      } else if (str!.length <= 5) {
                                        return "Password Must be greater than 6 digits";
                                      } else {
                                        return null;
                                      }
                                    },
                                    hintText: 'Password',
                                  ),
                                  const SizedBox(height: 20.0),
                                  PrimaryButton(
                                    isLoading: ref.watch(loginScreenProvider).isLoading,
                                    btnText: 'Login',
                                    onPressed: () {
                                      if(_formKey.currentState!.validate()){
                                        ref.read(loginScreenProvider).startLoading();
                                        ref.read(loginScreenProvider).login(context, _controllerEmail.text, _controllerPassword.text);


                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0, vertical: 10.0),
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: double.infinity,
                                      child: Ripple(
                                          onTap: () {},
                                          child: MyText(
                                            text: "Forgot Password?",
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 0),
                                      child: Divider(
                                        color: Colors.black,
                                        thickness: 0.5,
                                      )),
                                  Container(
                                      alignment: Alignment.center,
                                      child: MyText(
                                        text: "OR",
                                        fontSize: 15.sp,
                                      )),
                                  Container(
                                    width: double.infinity,
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      icon: Image.asset('assets/images/google.png'),
                                      iconSize: 50,
                                      onPressed: () {
                                        snackBarMsg('Yet to be Implemented', context);
                                      },
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Ripple(
                                          onTap: () {
                                            navigatorPush(
                                                context, const CreateAccountScreen());
                                          },
                                          child: MyText(
                                            text: "Create New Account",
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ))),
                                ],
                              ))),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }


}

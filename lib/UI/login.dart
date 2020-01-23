import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ocpua_app/bloc/auth/auth_bloc.dart';
import 'package:ocpua_app/bloc/auth/auth_event.dart';
import 'package:ocpua_app/resources/colors.dart';
import 'package:ocpua_app/resources/string.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthBloc _authBloc = AuthBloc.instance();

  bool showPassword = false;
  TextEditingController emailC = TextEditingController(),
      passC = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  FocusNode emailNode = FocusNode(), passNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 150,
            ),
            logo(),
            SizedBox(
              height: 50,
            ),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  textField(emailNode, emailC, AppStrings.email,
                      AppStrings.email, false),
                  SizedBox(
                    height: 16,
                  ),
                  textField(passNode, passC, AppStrings.password,
                      AppStrings.password, true),
                  SizedBox(
                    height: 20,
                  ),
                  signUpButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 50, right: 50, bottom: 20),
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }

  Widget textField(FocusNode node, TextEditingController controller,
      String labelText, String hintText, bool obscure) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(2),
      ),
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextFormField(
        focusNode: node,
        obscureText: obscure && !showPassword,
        controller: controller,
        autofocus: false,
        validator: (val) {
          if (labelText == AppStrings.email) {
            if (val.isEmpty || val == null || !EmailValidator.validate(val))
              return AppStrings.invalidEmail;
          }
          if (labelText == AppStrings.password) {
            if (val.isEmpty || val == null) return AppStrings.invalidPassword;
            if (val.length < 8) return AppStrings.shortPass;
          }
        },
        decoration: InputDecoration(
          suffix: labelText == AppStrings.password
              ? InkWell(
                  onTap: () => setState(() {
                        showPassword = !showPassword;
                      }),
                  child: Container(
                    child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ))
              : Container(
                  height: 0,
                  width: 0,
                ),
          contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 20),
          hintText: hintText,
          errorStyle: TextStyle(color: AppColors.red),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red, width: 2.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
      height: 55,
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            _authBloc.dispatch(
              Login(
                emailC.text,
                passC.text,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
                context, '/lineList', (r) => false);
          }
        },
        color: Colors.red,
        child: Text(
          AppStrings.signIn,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

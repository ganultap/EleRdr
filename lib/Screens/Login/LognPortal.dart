
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elecon_app/Controller/FirebaseController.dart';
import 'package:elecon_app/Screens/LoadingScreen/LoadingScreen.dart';
import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPortal extends StatefulWidget {
  const LoginPortal({ Key? key }) : super(key: key);

  @override
  _LoginPortalState createState() => _LoginPortalState();
}

class _LoginPortalState extends State<LoginPortal> {
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
  final FirebaseAuth firabaseAuth = FirebaseAuth.instance;
  bool obscure = true;

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
      }
    });
  }

  showToast(String text,sec,bgcolor){
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: sec,
      backgroundColor: bgcolor,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  validation() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      LoadingScreen1.showLoadingNoMsg(context);
      try{
        var result = await FirebaseController.loginUser(text);
        Navigator.pop(context);
        return result;
      }catch(e){
        Navigator.pop(context);
        showToast('Incorrect Username/Password',1,Colors.redAccent);
        return false;
      }
    }
    return false;
  }

  Widget _textFormField(String name, int controller, TextInputType type) {
    var obscures = name != 'Password' ? false : obscure;
    Widget showPassword = name != 'Password'
        ? SizedBox.shrink()
        : IconButton(
            icon: FaIcon(FontAwesomeIcons.eyeSlash,color: Colors.white,),
            onPressed: () {
              setState(() {
                obscure = obscure ? false : true;
              });
            },
          );

    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5,bottom: 5),
            child: TextFormField(
              obscureText: obscures,
              keyboardType: type,
              controller: text[controller],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  fillColor: Colors.deepPurple.shade400,
                  filled: true,
                  // labelText: name,
                  suffixIcon: showPassword,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(1),
                    borderSide: BorderSide.none
                  ),
              ),
              validator: (val) => val!.isNotEmpty ? null : "Invalid " + name,
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.purple[200],
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.purple[200],
        body: Form(
          key: _key,
          child: Padding(
            padding: EdgeInsets.only(left: 30,right: 30,bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 45
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 25),
                _textFormField("Email",0,TextInputType.text),
                _textFormField("Password",1,TextInputType.visiblePassword),
                SizedBox(height: 30),
                TextButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(size.width, 45)),
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurple.shade300),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1)
                      )
                    ) 
                  ),
                  onPressed: ()async{
                    if(await validation()){
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, 'Dashboard');
                    }
                  }, 
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.white,
                      // decoration: TextDecoration.underline
                    ),
                  )
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ) 
        )
      ),
    );
  }
}
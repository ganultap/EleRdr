import 'package:elecon_app/Controller/FirebaseController.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  ScrollController sc = ScrollController();
  List<TextEditingController> text = [];
  final _key = GlobalKey<FormState>();
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
      try{
        _key.currentState!.save();
        var result = await FirebaseController.registerUser(text);
        return result;
      }catch(e){
        return false;
      }
    }
    return false;
  }

  getDatePicker(controller){
   return DatePicker.showDatePicker(
    context,
    showTitleActions: true,
    minTime: DateTime(1980, 1, 1),
    maxTime: DateTime.now(),
    theme: DatePickerTheme(
        headerColor: Colors.purple,
        backgroundColor: Colors.purple.shade300,
        itemStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18),
        doneStyle:
            TextStyle(color: Colors.white, fontSize: 16)),
    onChanged: (date) {
    }, 
    onConfirm: (date) {
      setState(() {
        text[controller].text = date.toString().split(' ')[0];
      });
    }, 
    currentTime: DateTime.now(), locale: LocaleType.en);
  }

  Widget _textFormField(String name, int controller, TextInputType type) {
    var obscures = name != 'PASSWORD' ? false : obscure;
    Widget showPassword = name != 'PASSWORD'
        ? SizedBox.shrink()
        : IconButton(
            icon: FaIcon(FontAwesomeIcons.eyeSlash,color: Colors.white,),
            onPressed: () {
              setState(() {
                obscure = obscure ? false : true;
              });
            },
          );

    Widget showDateIcon = name != 'Date of Birth'
        ? SizedBox.shrink()
        : IconButton(
            icon: FaIcon(FontAwesomeIcons.calendar,color: Colors.white,),
            onPressed: () {
              getDatePicker(controller);
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
                  suffixIcon:  "PASSWORD" == name ? showPassword : showDateIcon,
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.purple[300],
        ),
        backgroundColor: Colors.purple[300],
        body: SingleChildScrollView(
          controller: sc,
          child: Container(
            // height: size.height,
            padding: EdgeInsets.all(45),
            child: Form(
              key: _key,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'CREATE NEW ACCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already Registered? Log in '
                            ),
                            TextSpan(
                              text: 'here',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold
                              ),
                              recognizer: TapGestureRecognizer()..onTap = ()=>{
                                Navigator.popAndPushNamed(context, 'LoginPortal')
                              }
                            )
                          ]
                        ),
                      ),
                    )
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _textFormField("Full name", 0, TextInputType.text),
                  _textFormField("EMAIL",1,TextInputType.text),
                  _textFormField("PASSWORD",2,TextInputType.text),
                  _textFormField("Date of Birth",3,TextInputType.datetime),
                  SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(size.width, 45)),
                      backgroundColor: MaterialStateProperty.all(Colors.pink[50]),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1)
                        )
                      ) 
                    ),
                    onPressed: () async {
                      if(await validation()){
                        Navigator.popAndPushNamed(context, 'SuccessRegister');
                      }else{
                        showToast('Incorrect Username/Password',1,Colors.redAccent);
                      }
                    }, 
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.deepPurple.shade400,
                        // decoration: TextDecoration.underline
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elecon_app/Models/Appliances.dart';
import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddAppliances extends StatefulWidget {
  const AddAppliances({ Key? key }) : super(key: key);

  @override
  _AddAppliancesState createState() => _AddAppliancesState();
}

class _AddAppliancesState extends State<AddAppliances> {
  List<TextEditingController> text = [];
  String username = "";
  final fb = FirebaseDatabase.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
        text[i].text = '';
      }
      initData();
    });
  }

  initData() async {
    username = await DataStorage.getData('email');
    setState(() {
      username = username.toString().split('@')[0];
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

  insertDb() async {
    String id = await DataStorage.getData('id');
    CollectionReference devices = await FirebaseFirestore.instance.collection('users').doc(id).collection('devices');
    devices.add(Appliances(
      text[0].value.text.toString(),
      text[0].value.text.toString(),
      int.parse(text[1].value.text),
      0.00,
      0.00
    ).toJson());
    fb.ref().child(username).update({
      text[0].value.text.toString(): "0.00/0.0000/0.0000/0.0000"
    });
    
  }

  Widget _textField(index,type){
    return TextField(
      keyboardType: type,
      controller: text[index],
      decoration: InputDecoration(
        fillColor: Colors.pink[50],
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1)
        ),
      ),
      style: TextStyle(
        fontSize: 25
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AlertDialog(
      title: Center(
        child: Text(
          'ADD APPLIANCES',
          style: TextStyle(
            fontSize: 30
          ),
          textAlign: TextAlign.center,
        ),
      ),
      content: Container(
        height: size.height*.4,
        child: Column(
          children: [
            SizedBox(height: 15,),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Name of Appliances',
                style: TextStyle(
                  fontSize: 25
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 15,),
            SizedBox(
              // width: 60,
              child: Center(
                child: _textField(0,TextInputType.text),
              ),
            ),
            SizedBox(height: 15,),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Watts (appliance):',
                style: TextStyle(
                  fontSize: 25
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 15,),
            SizedBox(
              // width: 60,
              child: Center(
                child: _textField(1,TextInputType.number),
              ),
            ),
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
              onPressed: (){
                insertDb();
                Navigator.pop(context);
                showToast('Appliance Added!',1,Colors.blueAccent);
              }, 
              child: Text(
                'ADD',
                style: TextStyle(
                  color: Colors.black,
                  // decoration: TextDecoration.underline
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
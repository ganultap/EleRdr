import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elecon_app/Models/UserModel.dart';
import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final formatCurrency =
      NumberFormat.simpleCurrency(locale: "fil", name: "PHP");
  List<TextEditingController> text = [];
  String kwhrate = "0.00";

  @override
  initState() {
    super.initState();
    initData();
    setState(() {
      for (int i = 0; i < 10; i++) {
        text.add(TextEditingController());
        text[i].text = '';
      }
    });
  }

  initData() async {
    String kwhpesorate = await DataStorage.getData('kwhpesorate');

    setState(() {
      kwhrate = kwhpesorate;
    });
  }

  saveSettings() async {
    try {
      double kwhpesorate = double.parse(text[0].text.toString());
      String id = await DataStorage.getData('id');
      DocumentReference user =
          await FirebaseFirestore.instance.collection('users').doc(id);
      var jsonobject = jsonDecode(jsonEncode((await user.get()).data()));
      UserModel userdata = UserModel.fromJson(jsonobject);
      userdata.kwhpesorate = kwhpesorate;
      user.set(userdata.toJson());
      await DataStorage.setData('kwhpesorate', kwhpesorate.toString());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  showToast(String text, sec, bgcolor) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: sec,
        backgroundColor: bgcolor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget _textField(index, type) {
    return TextField(
      keyboardType: type,
      controller: text[index],
      decoration: InputDecoration(
        fillColor: Colors.pink[50],
        filled: true,
        border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AlertDialog(
      title: Center(
        child: Text(
          'Settings',
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
      content: Container(
        height: size.height * .3,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Kwh Rate: ' + kwhrate,
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              // width: 60,
              child: Center(
                child: _textField(0, TextInputType.number),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(size.width, 45)),
                    backgroundColor: MaterialStateProperty.all(Colors.pink[50]),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1)))),
                onPressed: () async {
                  if (await saveSettings()) {
                    Navigator.pop(context);
                    showToast('Settings Saved', 1, Colors.blueAccent);
                  } else {
                    showToast('Invalid KwH Rate', 1, Colors.redAccent);
                  }
                },
                child: Text(
                  'SAVE',
                  style: TextStyle(
                    color: Colors.black,
                    // decoration: TextDecoration.underline
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

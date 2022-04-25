import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elecon_app/Controller/FirebaseController.dart';
import 'package:elecon_app/Models/Appliances.dart';
import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:currency_formatter/currency_formatter.dart';

class ConnectedAppliances extends StatefulWidget {
  const ConnectedAppliances({Key? key}) : super(key: key);

  @override
  _ConnectedAppliancesState createState() => _ConnectedAppliancesState();
}

class _ConnectedAppliancesState extends State<ConnectedAppliances> {
  final SampleAppliances sampleAppliances = SampleAppliances();
  late List listofappliances;
  late String username;
  final fb = FirebaseDatabase.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CurrencyFormatterSettings currencysettings = CurrencyFormatterSettings(
      symbol: '', thousandSeparator: ',', decimalSeparator: '.');
  CurrencyFormatter cf = CurrencyFormatter();

  @override
  initState() {
    super.initState();
    setState(() {
      username = "";
      listofappliances = [];
    });
    getAppliances();
    initData();
  }

  initData() async {
    username = await DataStorage.getData('email');
    setState(() {
      username = username.toString().split('@')[0];
    });
  }

  Future getAppliances() async {
    // final ref = await fb.ref().child(username).once();
    // List templistofappliances = ref.snapshot.children.toList();
    String id = await DataStorage.getData('id');
    QuerySnapshot devices = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('devices')
        .get();
    List deviceslist = devices.docs;
    for (QueryDocumentSnapshot d in deviceslist) {
      var device = jsonDecode(jsonEncode(d.data()));
      setState(() {
        listofappliances.add(Appliances(d.id, device['devicename'],
            device['watt'], device['kwh'], device['php']));
      });
    }
    // for(DataSnapshot e in templistofappliances){
    //   if(e.key.toString() == username){
    //     for(DataSnapshot d in e.children.toList()){
    //       setState(() {
    //         listofappliances.add(Appliances(d.key.toString(), d.key.toString(), double.parse(d.value.toString().split('/').last.replaceAll('}', '')),0.00));
    //       });
    //     }
    //   }
    // }
  }

  Future removeAppliances(Appliances device) async {
    await fb.ref().child(username).child(device.devicename).remove();

    String id = await DataStorage.getData('id');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('devices')
        .doc(device.id)
        .delete();
    setState(() {
      listofappliances = [];
    });
    getAppliances();
  }

  TableRow appliancesContainer(Appliances data) {
    return TableRow(children: [
      Container(
        padding: EdgeInsets.all(5),
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Center(
          child: Text(
            data.devicename,
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      Container(
        height: 40,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Center(
          child: Text(
            cf.format(data.php, currencysettings, decimal: 2),
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Container(
        height: 40,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Align(
            alignment: Alignment.center,
            child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  removeAppliances(data);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 10, right: 10),
      title: Center(
        child: Text(
          'APPLIANCES',
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
      ),
      content: Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width * .8,
        height: size.height * .6,
        child: Column(
          children: [
            Table(
              columnWidths: {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(4),
                2: FlexColumnWidth(1),
              },
              children: [
                    TableRow(children: [
                      Center(
                        child: Text(
                          'Device',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Consumption',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ])
                    // ]+sampleAppliances.getSampleAppliances().map<TableRow>((data)=> appliancesContainer(data)).toList(),
                  ] +
                  listofappliances
                      .map<TableRow>((data) => appliancesContainer(data))
                      .toList()
                      .reversed
                      .toList(),
            )
          ],
        ),
      ),
    );
  }
}

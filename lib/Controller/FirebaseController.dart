

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elecon_app/Models/Appliances.dart';
import 'package:elecon_app/Models/BillingHistoryM.dart';
import 'package:elecon_app/Models/UserModel.dart';
import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class FirebaseController{
  static final fb = FirebaseDatabase.instance;
  static final FirebaseAuth firabaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static loginUser(List<TextEditingController> data) async {
    try{
      await firabaseAuth.signInWithEmailAndPassword(email: data[0].value.text.toString().toLowerCase(), password: data[1].value.text.toString());
      await DataStorage.setData('email', data[0].value.text.toString().toLowerCase());
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      QuerySnapshot snapshot = await users.get();
      for(var d in snapshot.docs){
        var datadoc = jsonDecode(jsonEncode(d.data()));
        if(datadoc['email'] == data[0].value.text.toString().toLowerCase()){
          await DataStorage.setData('fullname', datadoc['fullname']);
          await DataStorage.setData('kwhpesorate', datadoc['kwhpesorate'].toString());
          await DataStorage.setData('id', d.id);
        }
      }
      return true;
    }catch(e){
      debugPrint(e.toString());
      return false;
    }
  }
  
  static registerUser(List<TextEditingController> data) async {
    try{
      firabaseAuth.createUserWithEmailAndPassword(email: data[1].value.text.toString(), password: data[2].value.text.toString());
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      users.add(
        UserModel(
          '', 
          data[0].value.text.toString(), 
          data[1].value.text.toString(), 
          data[2].value.text.toString(),
          data[3].value.text.toString(),
          0.00
        ).toJson()
      );
      return true;
    }catch(e){
      debugPrint(e.toString());
      return false;
    }
  }

  static calculateAppliancesConsumption() async {
    try{
      if(await DataStorage.isInStorage('id')){
        String id = await DataStorage.getData('id');
        String kwhpesorate = await DataStorage.getData('kwhpesorate');
        String username = (await DataStorage.getData('email')).toString().split('@')[0];

        final ref = await fb.ref().child(username).once();
        List devicelistrealtime = ref.snapshot.children.toList();

        QuerySnapshot devices = await FirebaseFirestore.instance.collection('users').doc(id).collection('devices').get();
        List deviceslistfirestore = devices.docs;

        for(DataSnapshot dr in devicelistrealtime){
          for(QueryDocumentSnapshot d in deviceslistfirestore){
            var device = jsonDecode(jsonEncode(d.data())); 
            if(device['devicename'] == dr.key){
              Appliances appl = Appliances(d.id, device['devicename'], device['watt'],device['kwh'],device['php']);
              appl.php = double.parse(dr.value.toString().split('/')[3]) * double.parse(kwhpesorate);
              await updateDeviceFirestore(appl.toJson());
            }
          }
        }
      }
      return true;
    }catch(e){
      debugPrint('error');
      debugPrint(e.toString());
      return false;
    }
  }
  
  static calculateAppliancesBillMonthly() async {
    try{
      if(await DataStorage.isInStorage('id')){
        double totalkwh = 0.00;
        double totalbill = 0.00;
        String id = await DataStorage.getData('id');
        String kwhpesorate = await DataStorage.getData('kwhpesorate');
        String username = (await DataStorage.getData('email')).toString().split('@')[0];
        DocumentReference user = FirebaseFirestore.instance.collection('users').doc(id);

        BillingHistoryM bh = BillingHistoryM('',DateTime.now().toString(),0.00,0.00);
        DocumentReference billinghistory = await user.collection('billing_history').add(bh.toMap());
        String currentbillingid = (await billinghistory.get()).id; 

        final ref = await fb.ref().child(username).once();
        List devicelistrealtime = ref.snapshot.children.toList();

        QuerySnapshot devices = await user.collection('devices').get();
        List deviceslistfirestore = devices.docs;

        for(DataSnapshot dr in devicelistrealtime){
          for(QueryDocumentSnapshot d in deviceslistfirestore){
            var device = jsonDecode(jsonEncode(d.data())); 
            if(device['devicename'] == dr.key){
              Appliances appl = Appliances(d.id, device['devicename'], device['watt'],device['kwh'],device['php']);
              appl.php = double.parse(dr.value.toString().split('/')[3]) * double.parse(kwhpesorate);
              totalkwh = totalkwh + appl.kwh;
              totalbill = totalbill + appl.php;

              await user.collection('billing_history').doc(currentbillingid).collection('billing_devices').add(appl.toJson());
              appl.kwh = 0.00;
              appl.php = 0.00;
              await updateDeviceFirestore(appl.toJson());
              await updateDeviceRealtime(device['devicename'], "0.00/0.0000/0.0000/0.0000");
            }
          }
        }
        bh.id = currentbillingid;
        bh.bills = totalbill;
        bh.totalkwh = totalkwh;
        // if(totalkwh == 0.0000){
        //   await user.collection('billing_history').doc(currentbillingid).delete();
        // }else{
        //   await user.collection('billing_history').doc(currentbillingid).update(bh.toMap());
        // }
        await user.collection('billing_history').doc(currentbillingid).update(bh.toMap());
      }
      return true;
    }catch(e){
      debugPrint('error');
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<BillingHistoryM>> getBillingHistory() async {
    List<BillingHistoryM> billhislist = [];
    try{
      String id = await DataStorage.getData('id');
      DocumentReference user = FirebaseFirestore.instance.collection('users').doc(id);
      QuerySnapshot billinghistory = await user.collection('billing_history').orderBy('date').get();
      for(QueryDocumentSnapshot bh in billinghistory.docs){
        var bhdata = jsonDecode(jsonEncode(bh.data()));
        billhislist.add(BillingHistoryM.fromJson(bhdata));

      }
      return billhislist;
    }catch(e){
      debugPrint(e.toString());
      return billhislist;
    }
  }

  static Future<List<Appliances>> getBillingHistoryDevices(bhid) async {
    List<Appliances> appliances = [];
    try{
      String id = await DataStorage.getData('id');
      DocumentReference user = FirebaseFirestore.instance.collection('users').doc(id);
      QuerySnapshot billinghistoryapp = await user.collection('billing_history').doc(bhid).collection('billing_devices').get();
      for(QueryDocumentSnapshot bhapp in billinghistoryapp.docs){
        var bhappdata = jsonDecode(jsonEncode(bhapp.data()));
        appliances.add(Appliances.fromJson(bhappdata));
      }
      return appliances;
    }catch(e){
      debugPrint(e.toString());
      return appliances;
    }
  }

  static addDeviceFirestore(data) async {

  }

  static updateDeviceFirestore(data) async {
    String id = await DataStorage.getData('id');
    await FirebaseFirestore.instance.collection('users').doc(id).collection('devices').doc(data['id']).update(data);

  }

  static removeDeviceFirestore(id) async {

  }

  static addDeviceRealtime(devicename) async {

  }
  
  static updateDeviceRealtime(devicename,value) async {
    String username = (await DataStorage.getData('email')).toString().split('@')[0];

    fb.ref().child(username).update({
      devicename.toString(): value.toString()
    });
  }
  
  static removeDeviceRealtime(devicename) async {

  }

}
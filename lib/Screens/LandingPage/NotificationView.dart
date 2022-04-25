import 'package:elecon_app/Controller/FirebaseController.dart';
import 'package:elecon_app/Models/BillingHistoryM.dart';
import 'package:elecon_app/Models/Notifications.dart';
import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({ Key? key }) : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final ScrollController _sc = ScrollController();
  double totalconsumption = 0.00;
  bool ischangecolor = true;

  List<BillingHistoryM> datalist = [];
  

  @override
  initState() {
    super.initState();
    initData();
  }

  initData() async {
    var datalisttemp = await FirebaseController.getBillingHistory();
    setState(() {
      for(BillingHistoryM bh in datalisttemp){
        totalconsumption += bh.totalkwh;
      }
      datalist = datalisttemp;
    });
  }

  Widget defaultNotificationCard(){
    return Card(
      elevation: 2,
      color: ischangecolor ? Colors.white70 : null,
      child: Container(
        height: 60,
        margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child:  Center(
          child: Text(
            'Nothing to Show',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      )
    );
  }

  Widget _notificationCard(BillingHistoryM data){
    ischangecolor = !ischangecolor;
    return Card(
      elevation: 2,
      color: ischangecolor ? Colors.white70 : null,
      child: Container(
        height: 60,
        margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child:  Center(
          child: Text(
            '${data.date.toString().split(' ')[0]}: ${data.totalkwh.toString()} kWh',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      )
    );
  }
  
  Widget _totalNotificationCard(){
    ischangecolor = !ischangecolor;
    return Card(
      elevation: 2,
      color: ischangecolor ? Colors.white70 : null,
      child: Container(
        height: 50,
        margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child:  Center(
          child: Text(
            'Total Consumption: ${totalconsumption.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 60,right: 50),
      controller: _sc,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: datalist.isNotEmpty ? 
          (datalist.map<Widget>((data)=>_notificationCard(data)).toList())+[_totalNotificationCard()]:
          [defaultNotificationCard()],
      ),
    );
  }
}
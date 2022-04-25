import 'package:elecon_app/Screens/Dialogs/AddAppliances.dart';
import 'package:elecon_app/Screens/Dialogs/BillingHistory.dart';
import 'package:elecon_app/Screens/Dialogs/ConnectedAppliances.dart';
import 'package:elecon_app/Screens/Dialogs/ElectricityCalculator.dart';
import 'package:elecon_app/Screens/Dialogs/EstimateBilling.dart';
import 'package:elecon_app/Screens/Dialogs/Recommendation.dart';
import 'package:elecon_app/Screens/Dialogs/Settings.dart';
import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({ Key? key }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _sc = ScrollController();

  Widget itemButton(name,icon){
    return ListTile(
      leading: FaIcon(icon,color: Colors.white,size: 35,),//must be FAicon
      title: Text(
        name,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          decoration: TextDecoration.underline
        ),
      ),
      onTap: (){
        // destination == "MyStore" ? storeButton(destination) : Navigator.pushNamed(context, destination);
        // refreshState();
        if(name == 'Logout'){
          DataStorage.clearStorage();
          Navigator.popAndPushNamed(context, '/');
        }
        else if(name == 'Dashboard'){
          Navigator.popAndPushNamed(context, 'Dashboard');
        }
        else if(name == 'Electricity Calculator'){
          showElectricityCalculator();
        }
        else if(name == 'Estimated Bill'){
          showEstimatedBilling();
        }
        else if(name == 'Billing History'){
          showBillingHistory();
        }
        else if(name == 'Tips & Recommendation'){
          showRecommendation();
        }
        else if(name == 'kWh Reading'){
          Navigator.pushNamed(context, 'KwhReading');
        }
        else if(name == 'Add Device'){
          showAddDevice();
        }
        else if(name == 'Connected Devices'){
          showConnectedDevice();
        }
        else if(name == 'Settings'){
          showSettngs();
        }
      },
    );
  }

  Future<dynamic> showElectricityCalculator(){
    return showDialog(
      context: context, 
      builder: (context) => const ElectricityCalculator()
    );
  }
  
  Future<dynamic> showEstimatedBilling(){
    return showDialog(
      context: context, 
      builder: (context) => const EstimateBilling()
    );
  }
  
  Future<dynamic> showBillingHistory(){
    return showDialog(
      context: context, 
      barrierColor: Colors.black87,
      builder: (context) => const BillingHistory()
    );
  }
  
  Future<dynamic> showRecommendation(){
    return showDialog(
      context: context,
      builder: (context) => const Recommendation()
    );
  }
  
  Future<dynamic> showAddDevice(){
    return showDialog(
      context: context,
      builder: (context) => const AddAppliances()
    );
  }
  
  Future<dynamic> showConnectedDevice(){
    return showDialog(
      context: context,
      builder: (context) => const ConnectedAppliances()
    );
  }
  
  Future<dynamic> showSettngs(){
    return showDialog(
      context: context,
      builder: (context) => const Settings()
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
        children: [
          itemButton('Electricity Calculator',FontAwesomeIcons.calculator),
          SizedBox(height: 10,),
          itemButton('Estimated Bill',FontAwesomeIcons.lightbulb),
          SizedBox(height: 10,),
          itemButton('Billing History',FontAwesomeIcons.history),
          SizedBox(height: 10,),
          itemButton('Tips & Recommendation',FontAwesomeIcons.stickyNote),
          SizedBox(height: 10,),
          itemButton('kWh Reading',FontAwesomeIcons.bookReader),
          SizedBox(height: 10,),
          itemButton('Dashboard',FontAwesomeIcons.objectGroup),
          SizedBox(height: 10,),
          itemButton('Add Device',FontAwesomeIcons.plusCircle),
          SizedBox(height: 10,),
          itemButton('Connected Devices',FontAwesomeIcons.networkWired),
          SizedBox(height: 10,),
          itemButton('Settings',FontAwesomeIcons.cog),
          SizedBox(height: 10,),
          itemButton('Logout',FontAwesomeIcons.signOutAlt),
        ],
      ),
    );
  }
}
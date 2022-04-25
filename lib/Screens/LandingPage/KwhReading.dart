import 'dart:convert';

import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';

class KwhReading extends StatefulWidget {
  const KwhReading({ Key? key }) : super(key: key);

  @override
  _KwhReadingState createState() => _KwhReadingState();
}

class _KwhReadingState extends State<KwhReading> {
  final ScrollController _sc = ScrollController();
  final dref = FirebaseDatabase.instance.ref();
  late String username = "";

   @override
  initState() {
    super.initState();
    setState(() {
    });
    initData();
  }

  initData() async {
    username = await DataStorage.getData('email');
    setState(() {
      username = username.toString().split('@')[0];
    });
  }


  SfRadialGauge _guageRadial(name,current,min,max,color,unit){
    return SfRadialGauge(
      title: GaugeTitle(
        text: name,
        textStyle: TextStyle(fontSize: 13.0,color: Colors.grey.shade400),
        alignment: GaugeAlignment.near
      ),
      axes: <RadialAxis>[
        RadialAxis(
          minimum: double.parse(min), 
          maximum: double.parse(max), 
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: double.parse(min),
                endValue: double.parse(current),
                color: color,
                startWidth: 10,
                endWidth: 10
              ),
            GaugeRange(
                startValue: double.parse(current),
                endValue: double.parse(max),
                color: Colors.black87,
                startWidth: 10,
                endWidth: 10
              ),
          ], 
          axisLineStyle: AxisLineStyle(
            cornerStyle: CornerStyle.bothCurve,
          ),
          showLabels: false,
          showFirstLabel: true,
          showLastLabel: true,
          showTicks: false,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: current,
                          style: TextStyle(
                            fontSize: 25,
                            color: color
                          )
                        ),
                        TextSpan(
                          text: unit,
                          style: TextStyle(
                            fontSize: 15,
                            color: color
                          )
                        )
                      ]
                    )
                  )
                ),
                angle: 0,
                positionFactor: 0.1
              )
          ]
        )
      ]
    );
  }

  Widget deviceContainer(data){
    return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              data.key.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
              ),
            ),
          ),
          SizedBox(height: 1,),
          Container(
            padding: const EdgeInsets.all(1.0),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                if(index == 0){
                  return _guageRadial('VOLTAGE',data.value.toString().split('/')[0],'0','250',Colors.blue[300],'V');
                }
                if(index == 1){
                  return _guageRadial('CURRENT',data.value.toString().split('/')[1],'0','10',Colors.orange.shade400,'A');
                }
                if(index == 2){
                  return _guageRadial('POWER',data.value.toString().split('/')[2],'0','10',Colors.pink.shade400,'W');
                }
                if(index == 3){
                  return _guageRadial('KWH',data.value.toString().split('/')[3],'0','1000',Colors.deepPurple.shade400,'kWh');
                }
                return Container();
              },
            ),
          ),
          SizedBox(height: 10,),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 180,
          leading: Align(
            alignment: Alignment.topLeft,
            child: BackButton()
          ),
          title: Container(
            padding: EdgeInsets.only(top: 80),
            alignment: Alignment.bottomCenter,
            child: Text(
              'KWH READING',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // titleSpacing: 20,
          actions: [
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     margin: EdgeInsets.only(top: 10,right: 10),
            //     child: IconButton(
            //       onPressed: () {
                    
            //       },
            //       icon: FaIcon(FontAwesomeIcons.bell,color: Colors.white,size: 40,),
            //     ),
            //   )
            // )
            SizedBox(width: 50,)
          ],
          backgroundColor: Colors.purple[300],
        ),
        backgroundColor: Colors.purple[300],
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Colors.grey[900],
          width: size.size.width*1,
          height: size.size.height*.80,
          padding: EdgeInsets.all(10),
          child: FirebaseAnimatedList(
            shrinkWrap: true,
            query: dref.child(username+'/'),
            itemBuilder: (context, snapshot, animation, index) {
              if(username == snapshot.key.toString()){
                List<Widget> children_data = [];
                for(var data in snapshot.children.toList()){
                  children_data.add(deviceContainer(data));
                }
                return Column(
                  children: children_data,
                );
              }
              return Center();
            },
          ),
        )
      ),
    );
  }
}
import 'package:elecon_app/Controller/FirebaseController.dart';
import 'package:elecon_app/Models/ChartKwhUsage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({ Key? key }) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<ChartKwhUsage> datalist = []; 
  

  @override
  initState() {
    super.initState();
    initData();
  }

  initData() async {
    var datalisttemp = await FirebaseController.getBillingHistory();

    setState(() {
      for(var i = 0;i<datalisttemp.length;i++){
        if(i == 5){
          break;
        }
        ChartKwhUsage chart_data = ChartKwhUsage(i.toString(),datalisttemp[i].date.split(' ')[0],datalisttemp[i].totalkwh);
        datalist.add(chart_data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'RECENT KWH USAGE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10,),
          Center(
            child: SfCartesianChart(
              series: <ChartSeries<ChartKwhUsage, String>>[
                BarSeries(
                  dataSource: datalist, 
                  xValueMapper: (ChartKwhUsage usage,_) => usage.date, 
                  yValueMapper: (ChartKwhUsage usage,_) => usage.kwh
                )
              ],
              primaryXAxis: CategoryAxis(),
              enableAxisAnimation: true,
              enableSideBySideSeriesPlacement: true,
              isTransposed: true,
            ),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text(
              'Press Home button for menu.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 25
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
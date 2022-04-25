import 'package:elecon_app/Controller/FirebaseController.dart';
import 'package:elecon_app/Models/Appliances.dart';
import 'package:elecon_app/Models/BillingHistoryM.dart';
import 'package:elecon_app/Utils/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class EstimateBilling extends StatefulWidget {
  const EstimateBilling({Key? key}) : super(key: key);

  @override
  _EstimateBillingState createState() => _EstimateBillingState();
}

class _EstimateBillingState extends State<EstimateBilling> {
  final formatCurrency =
      NumberFormat.simpleCurrency(locale: "fil", name: "PHP");
  List<BillingHistoryM> datalist = [];
  List<Map<String, List<Appliances>>> billhistorydevices = [];
  String kwhrate = "0.00";

  @override
  initState() {
    super.initState();
    initData();
  }

  initData() async {
    var datalisttemp = await FirebaseController.getBillingHistory();
    String kwhpesorate = await DataStorage.getData('kwhpesorate');
    for (BillingHistoryM data in datalisttemp) {
      if (data.id != '') {
        billhistorydevices.add({
          data.id: await FirebaseController.getBillingHistoryDevices(data.id)
        });
      }
    }
    setState(() {
      kwhrate = kwhpesorate;
      datalist = datalisttemp;
    });
  }

  Future<dynamic> showDevicesBreakdownDialog(id) {
    var size = MediaQuery.of(context);
    double totalCost = 0.0;
    var datalistdevices = [];
    for (Map data in billhistorydevices) {
      data.forEach((key, value) {
        if (key == id) {
          datalistdevices = value;
        }
      });
    }
    for (Appliances device in datalistdevices) {
      totalCost += device.php;
    }
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Breakdown Cost'),
              content: Container(
                height: size.size.height * 0.6,
                child: Column(
                  children: datalistdevices
                          .map((device) => deviceBreakdownContainer(device))
                          .toList() +
                      [
                        deviceBreakdownContainer(
                            Appliances('', 'Total', 0, 0.0, totalCost))
                      ],
                ),
              ),
            ));
  }

  Widget deviceBreakdownContainer(Appliances device) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(device.devicename),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(formatCurrency.format(device.php).toString()),
        ),
      ],
    );
  }

  Widget defaultEstimatedBillContainer() {
    var size = MediaQuery.of(context);
    return AlertDialog(
        content: Container(
      height: size.size.height * 0.4,
      child: Center(
        child: Text('Nothing to Show'),
      ),
    ));
  }

  Widget estimatedBillContainer(BillingHistoryM data) {
    bool showBreakdownTrigger = true;
    var size = MediaQuery.of(context);
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(10),
        height: size.size.height * .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Reading Cycle:',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                data.date.toString().split(' ')[0],
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'POWER RATE: $kwhrate/kWh',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
              textAlign: TextAlign.left,
            ),
            Text(
              'kWh Consumption ' + data.totalkwh.toString(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'Estimated Bill: ',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]),
                // textAlign: TextAlign.center,
              ),
              TextSpan(
                text: formatCurrency.format(data.bills).toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[300]),
                // textAlign: TextAlign.center,
              ),
            ])),
            SizedBox(
              height: 10,
            ),
            Center(
              child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                      fixedSize: MaterialStateProperty.all(Size(100, 10)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple.shade300),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)))),
                  onPressed: () {
                    showDevicesBreakdownDialog(data.id);
                    showBreakdownTrigger = !showBreakdownTrigger;
                  },
                  child: Text(
                    'Breakdown',
                    style: TextStyle(
                      color: Colors.white,
                      // decoration: TextDecoration.underline
                    ),
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: 180,
                child: Center(
                  child: Text(
                    'The estimated bill does not include other charges from your electric company',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey[400]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context);
    return Center(
        child: SingleChildScrollView(
      child: Container(
        height: size.size.height * .6,
        width: size.size.width,
        // padding: EdgeInsets.only(left: 10,right: 10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: CarouselSlider(
                  items: datalist.isNotEmpty
                      ? datalist.reversed
                          .map((BillingHistoryM data) =>
                              estimatedBillContainer(data))
                          .toList()
                      : [defaultEstimatedBillContainer()],
                  options: CarouselOptions(
                      reverse: true,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      viewportFraction: 1,
                      height: size.size.height,
                      enableInfiniteScroll: false)),
            ),
          ],
        ),
      ),
    ));
  }
}

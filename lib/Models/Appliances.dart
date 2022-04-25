class Appliances {
  String id,devicename;
  int watt;
  double kwh,php;

  Appliances(
    this.id,
    this.devicename,
    this.watt,
    this.kwh,
    this.php,
  );

  Appliances.fromJson(Map<String, dynamic> json)
      : id= json['id'],
        devicename= json['devicename'],
        watt= json['watt'],
        kwh= json['kwh'],
        php= json['php'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "devicename": devicename,
        "watt": watt,
        "kwh": kwh,
        "php": php
      };

}

class Appliance{
  late String devicename;
  late String detail;

  Map<String, dynamic> toMap() {
    return {
      devicename: detail,
    };
  }

}

class SampleAppliances{

  SampleAppliances();

  getSampleAppliances(){
    List<Appliances> data = [
      Appliances('0', 'Television',25, 3.5,0.00),
      Appliances('1', 'Refrigator',800, 6.4,0.00)
    ];

    return data;
  }
}

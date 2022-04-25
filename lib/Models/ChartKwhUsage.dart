class ChartKwhUsage {
  final String id,date;
  final double kwh;

  ChartKwhUsage(
    this.id,
    this.date,
    this.kwh,
  );

}

class SampleChartKwhUsage{

  SampleChartKwhUsage();

  getSampleChartKwhUsage(){
    List<ChartKwhUsage> data = [
      ChartKwhUsage('0', '07/11/21', 32.00),
      ChartKwhUsage('1', '08/11/21', 90.00),
      ChartKwhUsage('2', '09/11/21', 50.00),
      ChartKwhUsage('3', '10/11/21', 80.00)
    ];

    return data;
  }
}
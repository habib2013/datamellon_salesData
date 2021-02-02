import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 List<dynamic> data;

  
  Timer timer;
  List<charts.Series<Marketing, String>> _seriesData;


  Future<http.Response> makeRequest() async{
    var body = {"angular_test": "angular-developer",};
    var url =  'https://g54qw205uk.execute-api.eu-west-1.amazonaws.com/DEV/stub';

    var response = await http.post(url,
        headers: {"Content-type": "application/json",},
        body: json.encode(body) );

    print(response.statusCode);
    var respBody = json.decode(response.body);
      print(respBody[0]['Order ID']);


    setState(() {
       data = respBody;
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesData = List<charts.Series<Marketing, String>>();
    timer = new Timer.periodic(new Duration(seconds: 2), (t) => makeRequest());

    // _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: data == null ? CircularProgressIndicator() : createChart()

    );
  }

  charts.Series<Marketing, String> createSeries(String id, int i) {

    return charts.Series<Marketing, String>(
      id: id,
      domainFn: (Marketing marketing, _) => data[i]['State'],
      measureFn: (Marketing marketing, _) => int.parse(data[i]['Quantity']),
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      fillColorFn: (Marketing marketing, _) =>
          charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      // Marketing(this.product_name, this.sales, this.quantity,this.discount,this.profit);
      data: [

           Marketing(data[i]['Product Name'], data[i]['Sales'], data[i]['Quantity'], data[i]['Discount'], data[i]['Profit'])

      ],
    );
  }

  Widget createChart() {
    List<charts.Series<Marketing, String>> seriesList = [];
    for (int i = 0; i < 100; i++) {
      String id = 'WZG${i + 1}';
      seriesList.add(createSeries(id, i));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1976d2),
          //backgroundColor: Color(0xff308e1c),
          bottom: TabBar(
            indicatorColor: Color(0xff9962D0),
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.solidChartBar),
              ),
              Tab(icon: Icon(FontAwesomeIcons.chartPie)),
              Tab(icon: Icon(FontAwesomeIcons.chartLine)),
            ],
          ),
          title: Text('Flutter Charts'),
        ),
      body: TabBarView(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: charts.BarChart(
              seriesList,
              barGroupingType: charts.BarGroupingType.grouped,
            ),
          ),
          Padding(
               padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Pie Chart'),
                ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text('Pie Chart'),
            ),
          ),
        ],
      ),
    );



    // return new charts.BarChart(
    //   seriesList,
    //   barGroupingType: charts.BarGroupingType.grouped,
    // );


  }

}

class Marketing {
  int row_id;
  int order_id;
  String order_date;
  String ship_mode;
  int customer_id;
  String customer_name;
  String segment;
  String country;
  String city;
  String state;
  String postal_code;
  String region;
  String product_id;
  String category;
  String sub_category;
  String product_name;
  String sales;
  String quantity;
  String discount;
  String profit;


  Marketing(this.product_name, this.sales, this.quantity,this.discount,this.profit);


}



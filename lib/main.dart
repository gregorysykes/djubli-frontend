import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Car{
  var id;
  var username;
  var carName;
  var promotionEndDate;
  var description;
  var price;
  var address;
  var mileage;
  var carPicture;

  Car({
    this.id,
    this.username,
    this.carName,
    this.promotionEndDate,
    this.description,
    this.price,
    this.address,
    this.mileage,
    this.carPicture
  });

  Car.fromJson(Map<String,dynamic> json){
    id = json['id'];
    carName = json['car_name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['car_name'] = carName;
    data['price'] = price;
    return data;
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DjuBli',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'DjuBli'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int carLength = 0;
  
  @override
  void initState(){
    super.initState();
    int carLength = 0;
    _getCarData();
  }

  _getCarData() async{
    try{
      final responseData = await http.get(Uri.parse('http://192.168.29.111:3001/api/cars/'));
      if(responseData.statusCode == 200){
        // final data = jsonDecode(responseData.body);
        final List result = jsonDecode(responseData.body);
        return result.map((e) => Car.fromJson(e)).toList();
        // setState(() {
        //   carLength = result.length;
        // });
      }
    }catch (e){
      print(e.toString());
    }
  }

  void _submitCar(){
    _getCarData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Car>>(
          builder: (context,snapshot){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context,index){
                return CarCard(name: snapshot.data![index].carName, price: snapshot.data![index].price);
              },
            );
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: MaterialLocalizations.of(context)
                .modalBarrierDismissLabel,
            barrierColor: Colors.black45,
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (BuildContext buildContext,
                Animation animation,
                Animation secondaryAnimation) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: MediaQuery.of(context).size.height -  80,
                  padding: EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Material(
                        child: Text('New Car',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                      const Material(
                          child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                            hintText: 'Car Name',
                          ),
                        ),
                      ),
                      const Material(
                          child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                            hintText: 'Price',
                          ),
                        ),
                      ),
                      const Material(
                          child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                            hintText: 'Mileage',
                          ),
                        ),
                      ),
                      const Material(
                          child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                            hintText: 'Address',
                          ),
                        ),
                      ),
                      const Material(
                        child: TextField(
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                            hintText: 'Description',
                          ),
                        )
                      ),
                      ElevatedButton(
                        onPressed: _submitCar,
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}

class CarCard extends StatelessWidget {
  const CarCard({super.key,required this.name,required this.price});
  
  final String name;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Card tapped.');
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
              child: SizedBox(
              width: 300,
              height: 100,
              child: Column(
                children: [
                  Text(this.name),
                  Text(this.price.toString())
                ]
              ),
            )
          ),
        ),
      ),
    );
  }
}

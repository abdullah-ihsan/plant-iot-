import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mmbd_project/components/data_change_dialog.dart';
import 'package:mmbd_project/components/plant_card.dart';
import 'package:mmbd_project/models/Plant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mmbd_project/models/PlantList.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String temp = PlantList.plants[0].temperature;
  String humid = PlantList.plants[0].humidity;
  String soilMoist = PlantList.plants[0].soilMoisture;
  String lastWater = PlantList.plants[0].lastWatered;
  String lastFan = PlantList.plants[0].lastFanOn;
  String iD = PlantList.plants[0].id;
  String name = PlantList.plants[0].plantName;
  String type = PlantList.plants[0].plantType;
  int index_for_data = 0;
  int DEFAULT_moisture = 50;
  int DEFAULT_temp = 20;
  //String? stringResponse;
  //Map? mapResponse;
  List? listResponse;
  int? listLength;
  List<Plant> _plantList = [];

  postData(String id) async {
    var response = await http.post(
        Uri.parse(
            "https://shielded-scrubland-58514-f731e17d6ad1.herokuapp.com/updateThreshold/"),
        body: {
          "moisture_threshold": DEFAULT_moisture.toString(),
          "temperature_threshold": DEFAULT_temp.toString(),
          "id": id,
        });
  }

  postNames(String id, String name, String type) async {
    var response = await http.post(
        Uri.parse(
            "https://shielded-scrubland-58514-f731e17d6ad1.herokuapp.com/updateName/"),
        body: {
          "plantName": name,
          "plantType": type,
          "id": id,
        });
  }

  Future fetchData() async {
    http.Response response;
    response = await http.get(Uri.parse(
        "https://shielded-scrubland-58514-f731e17d6ad1.herokuapp.com/getData/"));
    if (response.statusCode == 200) {
      setState(() {
        //stringResponse = response.body;
        listResponse = json.decode(response.body);
        listLength = listResponse!.length;
        _plantList.clear();
        for (int i = 0; i < listLength!; i++) {
          _plantList?.add(Plant(
              id: listResponse![i]['id'],
              id_: listResponse![i]['_id'],
              plantName: listResponse![i]['plantName'],
              plantType: listResponse![i]['plantType'],
              temperature: listResponse![i]['temperature'],
              humidity: listResponse![i]['humidity'],
              soilMoisture: listResponse![i]['soil_moisture'],
              lastWatered:
                  listResponse![i]['time_water'].toString().substring(0, 1) ==
                          '1'
                      ? "N/A"
                      : listResponse![i]['time_water']
                          .toString()
                          .substring(11, 16) /* ? "true" : "false" */,
              lastFanOn:
                  listResponse![i]['time_water'].toString().substring(0, 1) ==
                          "1"
                      ? "N/A"
                      : listResponse![i]['time_water']
                          .toString()
                          .substring(11, 16) /* ? "true" : "false" */,
              plantGraphic: 'assets/plant.json'));
        }
        PlantList.makePlantList(_plantList);
      });
    }
    //print(listResponse![0]['time_water'].toString().split("\d{2}:\d{2}"));
    print('api re-fetched');
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      fetchData();
      setState(() {}); // Trigger a rebuild
    });
    //for()
  }

  Widget build(BuildContext context) {
    return Consumer<PlantList>(
      builder: (context, value, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: DrawerListing(
                  icon: Icons.info,
                  text: "About",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AlertDialog(
                                title:
                                    Text("IOT based plant monitoring system"),
                                content: Text(
                                    "An MMBD Project by:\n Muhammad Abdullah Ihsan\n Nawab Aarij Imam\n Muhammad Ali\n Sibte Najam"),
                              ))),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                itemBuilder: (context, index, realIndex) {
                  Plant p = value.getPlants()[index];
                  temp = p.temperature;
                  humid = p.humidity;
                  soilMoist = p.soilMoisture;
                  return GestureDetector(
                    onLongPress: () => openDialog(),
                    child: PlantCard(
                      plantAnimation: p.plantGraphic ?? "",
                      plantName: p.plantName,
                      plantType: p.plantType,
                    ),
                  );
                },
                options: CarouselOptions(
                    //height: 500,
                    aspectRatio: 5 / 6,
                    enableInfiniteScroll: false,
                    scrollPhysics: BouncingScrollPhysics(),
                    onPageChanged: (index, reason) {
                      setState(() {
                        Plant p = value.getPlants()[index];
                        temp = p.temperature;
                        humid = p.humidity;
                        soilMoist = p.soilMoisture;
                        lastWater = p.lastWatered;
                        lastFan = p.lastFanOn;
                        iD = p.id;
                        name = p.plantName;
                        type = p.plantType;
                      });
                      index_for_data = index;
                    }),
                itemCount: PlantList.plants.length,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PlantValueCard(
                        icon: const Icon(Icons.thermostat),
                        valueType: "Temperature",
                        plantValue:
                            value.getPlants()[index_for_data].temperature,
                      ),
                      PlantValueCard(
                        icon: const Icon(Icons.foggy),
                        valueType: "Humidity",
                        plantValue: value.getPlants()[index_for_data].humidity,
                      ),
                      PlantValueCard(
                        icon: const Icon(Icons.water_drop),
                        valueType: "Soil Moisture",
                        plantValue:
                            value.getPlants()[index_for_data].soilMoisture,
                      ),
                      PlantValueCard(
                        icon: const Icon(Icons.timelapse),
                        valueType: "Last Watered",
                        plantValue:
                            value.getPlants()[index_for_data].lastWatered,
                      ),
                      PlantValueCard(
                        icon: const Icon(Icons.air),
                        valueType: "Last Fan on",
                        plantValue: value.getPlants()[index_for_data].lastFanOn,
                      ),
                    ],
                  ),
                ),
              ),
              //FloatingActionButton(onPressed: () => postData(iD))
              Container(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => DataChangeDialog(
          DEFAULT_moisture: DEFAULT_moisture,
          DEFAULT_temp: DEFAULT_temp,
          name: name,
          type: type,
          id: iD,
          onValuesChanged: (newMoisture, newTemp) {
            setState(() {
              // Update the values in the HomePage class
              DEFAULT_temp = newTemp;
              DEFAULT_moisture = newMoisture;
            });
          },
          postData: (id) => postData(id),
          postNames: (id, name, type) => postNames(id, name, type),
        ),
      );
}

class PlantValueCard extends StatelessWidget {
  const PlantValueCard({
    super.key,
    required this.valueType,
    required this.plantValue,
    required this.icon,
  });

  final String valueType;
  final String plantValue;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        width: 300,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  plantValue,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 73, 73, 73)),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  valueType,
                  style: const TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 128, 128, 128)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 15.0),
                  child: icon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListing extends StatelessWidget {
  DrawerListing({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class DataChangeDialog extends StatefulWidget {
  DataChangeDialog({
    super.key,
    required this.DEFAULT_moisture,
    required this.DEFAULT_temp,
    required this.id,
    required this.onValuesChanged,
    required this.postData,
    required this.postNames,
    required this.name,
    required this.type,
  });

  int DEFAULT_moisture;
  int DEFAULT_temp;
  final String id;
  final Function(int, int) onValuesChanged;
  final Function(String) postData;
  final Function(String, String, String) postNames;

  String name;
  String type;

  @override
  State<DataChangeDialog> createState() => _DataChangeDialogState();
}

class _DataChangeDialogState extends State<DataChangeDialog> {
  final _namecontroller = TextEditingController();
  final _typecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Plant Details"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //const Text("Plant Name:"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: _namecontroller,
                decoration: InputDecoration(
                  hintText: "Plant Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            //const Text("Plant Type:"),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: TextField(
                controller: _typecontroller,
                decoration: InputDecoration(
                  hintText: "Plant Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const Text("Moisture Threshold: "),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Slider(
                value: widget.DEFAULT_moisture.toDouble(),
                max: 100,
                min: 0,
                divisions: 100,
                label: widget.DEFAULT_moisture.toString(),
                onChanged: (double value) => {
                  setState(() {
                    widget.DEFAULT_moisture = value.toInt();
                  }),
                },
              ),
            ),
            const Text("Temperature Threshold: "),
            Slider(
              value: widget.DEFAULT_temp.toDouble(),
              max: 50,
              min: -50,
              divisions: 100,
              label: widget.DEFAULT_temp.toString(),
              onChanged: (double value) => {
                setState(() {
                  widget.DEFAULT_temp = value.toInt();
                }),
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            widget.onValuesChanged(
              widget.DEFAULT_moisture,
              widget.DEFAULT_temp,
            );
            setState(() {
              widget.name = _namecontroller.text;
              widget.type = _typecontroller.text;
            });
            widget.postData(widget.id);
            widget.postNames(widget.id, widget.name, widget.type);
            Navigator.pop(
              context,
            );
          },
          child: Text('DONE'),
        )
      ],
    );
  }
}

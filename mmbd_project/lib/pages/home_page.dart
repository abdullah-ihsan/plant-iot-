import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
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

  //String? stringResponse;
  //Map? mapResponse;
  List? listResponse;
  int? listLength;
  List<Plant> _plantList = [];

  Future apicall() async {
    http.Response response;
    response = await http.get(Uri.parse(
        "https://shielded-scrubland-58514-f731e17d6ad1.herokuapp.com/getData/"));
    if (response.statusCode == 200) {
      setState(() {
        //stringResponse = response.body;
        listResponse = json.decode(response.body);
        listLength = listResponse!.length;

        for (int i = 0; i < listLength!; i++) {
          _plantList?.add(Plant(
              plantName: listResponse![i]['_id'],
              plantType: listResponse![i]['id'],
              temperature: listResponse![i]['temperature'],
              humidity: listResponse![i]['humidity'],
              soilMoisture: listResponse![i]['soil_moisture'],
              lastWatered: listResponse![i]['valveOn'] ? "true" : "false",
              lastFanOn: listResponse![i]['fanOn'] ? "true" : "false",
              plantGraphic: 'assets/plant.json'));
        }

        PlantList.makePlantList(_plantList);
      });
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
    //for()
  }

  Widget build(BuildContext context) {
    return Consumer<PlantList>(
      builder: (context, value, child) => Scaffold(
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
                  icon: Icons.add,
                  text: "Add new plant",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Placeholder())),
                ),
              ),
              DrawerListing(
                icon: Icons.list,
                text: "List of plants",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Placeholder())),
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
                  return PlantCard(
                    plantAnimation: p.plantGraphic ?? "",
                    plantName: p.plantName,
                    plantType: p.plantType,
                  );
                },
                options: CarouselOptions(
                    height: 400,
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
                      });
                    }),
                itemCount: PlantList.plants.length,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PlantValueCard(
                        icon: const Icon(Icons.thermostat),
                        valueType: "Temperature:",
                        plantValue: temp,
                      ),
                      PlantValueCard(
                        icon: const Icon(Icons.foggy),
                        valueType: "Humidity:",
                        plantValue: humid,
                      ),
                      PlantValueCard(
                        icon: const Icon(Icons.water_drop),
                        valueType: "Soil Moisture:",
                        plantValue: soilMoist,
                      ),
                      PlantValueCard(
                        icon: const Icon(Icons.timelapse),
                        valueType: "Last Watered:",
                        plantValue: lastWater,
                      ),
                      PlantValueCard(
                        icon: const Icon(Icons.air),
                        valueType: "Last Fan on:",
                        plantValue: lastFan,
                      ),
                      listResponse == null
                          ? Text("Waiting")
                          : Text(listResponse![0].toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 15.0),
              child: icon,
            ),
            Text(
              valueType,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 73, 73, 73)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                plantValue,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 73, 73, 73)),
              ),
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

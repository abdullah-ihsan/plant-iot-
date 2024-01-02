import 'package:flutter/material.dart';
import 'package:mmbd_project/models/Plant.dart';

class PlantList extends ChangeNotifier {
  static List<Plant> plants = [
    Plant(
        plantName: "My Plant",
        plantType: "Sample Plant",
        temperature: "1",
        humidity: "2",
        soilMoisture: "3",
        lastWatered: "1200",
        lastFanOn: "0200",
        plantGraphic: "assets/plant.json"),
    Plant(
        plantName: "My Plant 2",
        plantType: "Sample Plant 2",
        temperature: "4",
        humidity: "5",
        soilMoisture: "6",
        lastWatered: "1400",
        lastFanOn: "1230",
        plantGraphic: "assets/plant.json"),
    Plant(
        plantName: "My Plant 3",
        plantType: "Sample Plant 3",
        temperature: "7",
        humidity: "8",
        soilMoisture: "9",
        lastWatered: "2015",
        lastFanOn: "1830",
        plantGraphic: "assets/plant.json"),
  ];

  List<Plant> getPlants() {
    return plants;
  }

  static void addPlant(Plant plant) {
    plants.add(plant);
  }

  static void makePlantList(List<Plant> pl) {
    plants = pl;
  }
}

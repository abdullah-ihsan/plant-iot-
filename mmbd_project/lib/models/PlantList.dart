import 'package:flutter/material.dart';
import 'package:mmbd_project/models/Plant.dart';

class PlantList extends ChangeNotifier {
  static List<Plant> plants = [
    Plant(
      plantName: "Loading...",
      plantType: "Loading...",
      temperature: "",
      humidity: "",
      soilMoisture: "",
      lastWatered: "1024-01-03T17:58:47.275Z",
      lastFanOn: "1024-01-03T17:58:47.275Z",
      plantGraphic: "assets/plant.json",
      id: "L",
      id_: "L_",
    ),
  ];

  List<Plant> getPlants() {
    return plants;
  }

  static void addPlant(Plant plant) {
    plants.add(plant);
  }

  static void makePlantList(List<Plant> pl) {
    plants = new List.from(pl);
  }
}

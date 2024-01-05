import 'dart:convert';
import 'package:http/http.dart' as http;

class Plant {
  final String? plantGraphic;
  final String plantName;
  final String plantType;

  //change this later as per requirement

  ///////////////////////////////
  final String temperature;
  final String humidity;
  final String soilMoisture;
  final String lastWatered;
  final String lastFanOn;
  final String id;
  final String id_;
  ///////////////////////////////

  Plant({
    required this.plantName,
    required this.plantType,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.lastWatered,
    required this.lastFanOn,
    required this.id,
    required this.id_,
    this.plantGraphic,
  });

  /* factory Plant.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'temperature': String temperature,
        'humidity': String humidity,
        'soil_moisture': String soilMoisture,
        '_id': String plantName, // temp
        'id': String plantType, // temp
        'fanOn': bool fanOn,
        'valveOn': bool valveOn,
      } =>
        Plant(
          plantName: plantName,
          plantType: plantType,
          temperature: temperature,
          humidity: humidity,
          soilMoisture: soilMoisture,
          lastWatered: valveOn ? "true" : "false",
          lastFanOn: fanOn ? "true" : "false",
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  } */
}

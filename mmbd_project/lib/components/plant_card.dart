import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PlantCard extends StatelessWidget {
  PlantCard({
    super.key,
    required this.plantAnimation,
    required this.plantName,
    required this.plantType,
  });

  final String plantAnimation;
  final String plantName;
  final String plantType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        margin:
            const EdgeInsets.only(left: 12.5, right: 12.5, top: 20, bottom: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        width: 300,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Lottie.asset(plantAnimation),
            ),
            Text(
              plantName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              plantType,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bimmer_wheels/models/wheel_data.dart';

class Tile {
  final String name;
  final String imageUrl;
  final String description;
  final int cardSizeX;
  final int cardSizeY;
  final WheelData wheelData;

  Tile({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.cardSizeX,
    required this.cardSizeY,
    required this.wheelData,
  });
}
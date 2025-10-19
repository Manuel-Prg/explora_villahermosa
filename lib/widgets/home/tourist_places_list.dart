// lib/widgets/home/tourist_places_list.dart
import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../utils/responsive_utils.dart';
import 'place_card.dart';

class TouristPlacesList extends StatelessWidget {
  final DeviceType deviceType;

  const TouristPlacesList({
    super.key,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    final places = PlaceModel.getTouristPlaces();
    final cardHeight = deviceType == DeviceType.desktop
        ? 220.0
        : (deviceType == DeviceType.tablet ? 200.0 : 180.0);

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: places.length,
        itemBuilder: (context, index) {
          return PlaceCard(
            place: places[index],
            deviceType: deviceType,
          );
        },
      ),
    );
  }
}

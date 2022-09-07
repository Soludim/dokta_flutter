import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/place.dart';
import '../widgets/search.dart';
import '../services/geolocator_service.dart';
import '../services/places_service.dart';
import 'package:provider/provider.dart';

class Locate extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();

  Locate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(create: (context) => locatorService.getLocation()),
        ProxyProvider<Position, Future<List<Place>>>(
          update: (context, position, places) {
            return (position != null)
                ? placesService.getPlaces(position.latitude, position.longitude)
                : null;
          },
        )
      ],
      child: Scaffold(
          appBar: AppBar(
            title: Text('Nearest ${PlacesService.place}'),
          ),
          body: const Search(),
      ),
    );
  }
}
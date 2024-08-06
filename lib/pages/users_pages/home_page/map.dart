import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //controller
  late GoogleMapController mapController;
  //markersları saklayan set
  final Set<Marker> markers = {};

  //vetlerin konumlarını saklayan liste
  final List<Map<String, dynamic>> vets = [
    {
      'name': 'Güneşli Vet',
      'position': LatLng(41.233120, 28.494989),
    },
    {
      'name': 'Vetropol Vet',
      'position': LatLng(41.018639, 28.826580),
    },
    {
      'name': 'Şeftali Vet',
      'position': LatLng(36.765380, 28.812290),
    },
    {
      'name': 'Vetorium',
      'position': LatLng(40.9982813, 28.9982813),
    },
  ];

  @override
  void initState() {
    super.initState();
    addMarkers();
  }

  //controllerı tanımlama
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  //marker oluşturma
  void addMarkers() {
    for (var vet in vets) {
      markers.add(
        Marker(
          markerId: MarkerId(vet['name']),
          position: vet['position'],
          infoWindow: InfoWindow(
            title: vet['name'],
          ),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: vets[0]['position'],
          zoom: 12.0,
        ),
        markers: markers,
      ),
    );
  }
}

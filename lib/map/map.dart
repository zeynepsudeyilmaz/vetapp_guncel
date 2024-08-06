import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController mapController; //controller
  final LatLng initialPosition =
      const LatLng(41.0082, 28.9784); //ilk gösterilecek olan, varsayılan konum
  LatLng? userLocation; //kullanıcı konumu

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    //konum servislerinin açık olup olmadığını kontrol etme
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Konum servisleri etkin değil.');
    }
    LocationPermission permission;
    //uygulamanın konum verilerine erişim olup olmadığını kontrol etme
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //izin verilmemişse izin iste
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Konum izni verilmedi.');
      }
    }
    //kullanıcının konumunu al
    Position position = await Geolocator.getCurrentPosition(
      //en yüksek doğrulukta al konum bilgisini
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      //kullanıcı konumunu latlng olarak al
      userLocation = LatLng(position.latitude, position.longitude);
    });
    //haritayı kullanıcı konumuna zoomlar
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(userLocation!, 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          //başlangıç konumu
          target: initialPosition,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}

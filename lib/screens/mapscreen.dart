import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Set<Marker> _markers = {};
  late BitmapDescriptor mapMarker;

  @override
  void initState() {
    super.initState();
    setCustomMarkers();
    loadMarkersFromJson();
  }

  void setCustomMarkers() async {
    mapMarker =
        await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/mapicon.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('id-1'),
          position: const LatLng(3.140853, 101.693207),
          icon: mapMarker,
          infoWindow: const InfoWindow(
            title: "Beebag Shop 1",
            snippet: 'A Historical Place',
          ),
        ),
      );
    });
  }

  void loadMarkersFromJson() async {
    // Load JSON from assets
    String jsonString = await rootBundle.loadString('assets/stores.json');
    List<dynamic> locations = json.decode(jsonString);

    // Add markers for each location
    for (var location in locations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location['place_id']),
          position: LatLng(location['businessLocation']['lat'].toDouble(), location['businessLocation']['lng'].toDouble()),
          icon: mapMarker,
          infoWindow: InfoWindow(
            title: location['businessName'],
            snippet: location['businessName'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maps Screen"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: const CameraPosition(
          target: LatLng(3.140853, 101.693207),
          zoom: 15,
        ),
      ),
    );
  }
}

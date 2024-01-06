import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullScreenMapPage extends StatefulWidget {
  final LatLng initialPosition;

  FullScreenMapPage({Key? key, required this.initialPosition})
      : super(key: key);

  @override
  _FullScreenMapPageState createState() => _FullScreenMapPageState();
}

class _FullScreenMapPageState extends State<FullScreenMapPage> {
  late GoogleMapController mapController;
  LatLng? currentMapPosition;

  @override
  void initState() {
    super.initState();
    currentMapPosition = widget.initialPosition;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _selectLocation() {
    if (currentMapPosition != null) {
      Navigator.of(context).pop(currentMapPosition);
    } else {
      // Caso currentMapPosition seja null, mostrar um aviso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Por favor, mova o mapa para selecionar uma localização')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa em Tela Cheia'),
        // Estilização adicional do AppBar, se necessário
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 16.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: _onMapCreated,
            onCameraMove: (position) => currentMapPosition = position.target,
            zoomControlsEnabled: false,
          ),
          Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),
          Positioned(
            bottom: 20,
            right: 20, // Posicionamento do botão
            child: ElevatedButton(
              onPressed: _selectLocation,
              child: Text('Selecionar local'),
            ),
          ),
        ],
      ),
    );
  }
}

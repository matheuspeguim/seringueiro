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
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Adiciona um marcador inicial baseado na posição inicial recebida.
    _markers.add(
      Marker(
        markerId: MarkerId("initialPosition"),
        position: widget.initialPosition,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Move a câmera para a posição inicial assim que o mapa estiver pronto.
    _mapController.moveCamera(CameraUpdate.newLatLng(widget.initialPosition));
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selectedLocation'),
          position: location,
        ),
      );
    });
    // Move a câmera para a nova localização selecionada.
    _mapController.moveCamera(CameraUpdate.newLatLng(location));
  }

  void _confirmSelection() {
    if (_markers.isNotEmpty) {
      LatLng selectedLocation = _markers.first.position;
      Navigator.of(context).pop(selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione uma Localização'),
      ),
      body: GoogleMap(
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: MapType.satellite,
        onMapCreated: _onMapCreated,
        onTap: _onMapTapped,
        initialCameraPosition: CameraPosition(
          target: widget.initialPosition,
          zoom: 15.0,
        ),
        markers: _markers,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmSelection,
        icon: Icon(Icons.check),
        label: Text('Confirmar Localização'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

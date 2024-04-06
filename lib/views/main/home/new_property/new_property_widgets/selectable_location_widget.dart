import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/services/utilidade_service.dart';
import 'package:flutter_seringueiro/views/main/home/new_property/new_property_widgets/full_screen_map_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SelectableLocationWidget extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  SelectableLocationWidget({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _SelectableLocationWidgetState createState() =>
      _SelectableLocationWidgetState();
}

class _SelectableLocationWidgetState extends State<SelectableLocationWidget> {
  LatLng? currentLocation;
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    bool permissionGranted =
        await UtilidadeService.verificarEObterPermissaoLocalizacao(context);
    if (!permissionGranted) {
      setState(() {
        isLoading = false;
        errorMessage =
            'Permissão de localização negada. Por favor, habilite a permissão nas configurações do dispositivo.';
      });
      return;
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        _updateMarker(currentLocation!);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erro ao obter a localização atual.';
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (currentLocation != null) {
      _updateMarker(currentLocation!);
    }
  }

  void _updateMarker(LatLng location) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId("currentLocation"),
        position: location,
      ));
    });
    _mapController?.moveCamera(CameraUpdate.newLatLng(location));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectNewLocation(),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildMap(),
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    } else {
      return AbsorbPointer(
          absorbing: true,
          child: GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition: CameraPosition(
              target: currentLocation ?? LatLng(0, 0),
              zoom: 15,
            ),
            onMapCreated: _onMapCreated,
            markers: _markers,
            mapToolbarEnabled: false,
            compassEnabled: false,
            buildingsEnabled: false,
            zoomGesturesEnabled: false,
            zoomControlsEnabled: false,
            scrollGesturesEnabled: false,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
          ));
    }
  }

  void _selectNewLocation() async {
    final LatLng? newLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) =>
            FullScreenMapPage(initialPosition: currentLocation ?? LatLng(0, 0)),
      ),
    );

    if (newLocation != null) {
      setState(() {
        currentLocation = newLocation;
        _updateMarker(
            newLocation); // Atualiza o marcador com a nova localização
      });
      widget.onLocationSelected(newLocation); // Notifica o widget pai
    }
  }
}

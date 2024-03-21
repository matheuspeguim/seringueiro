import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FieldActivityDetailsDialog {
  final String propertyId;
  final String fieldActivityId;
  final BuildContext context;

  FieldActivityDetailsDialog({
    required this.propertyId,
    required this.fieldActivityId,
    required this.context,
  });

  Future<List<LatLng>> _fetchActivityPoints() async {
    try {
      final QuerySnapshot activityPointsSnapshot = await FirebaseFirestore
          .instance
          .collection('activity_points')
          .where('fieldActivityId', isEqualTo: fieldActivityId)
          .get();

      return activityPointsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final latitude = data['latitude'] as double? ?? 0.0;
        final longitude = data['longitude'] as double? ?? 0.0;
        return LatLng(latitude, longitude);
      }).toList();
    } catch (e) {
      print("Erro ao buscar os detalhes da atividade: $e");
      throw Exception('Falha ao buscar pontos de atividade');
    }
  }

  void show() async {
    try {
      final activityPoints = await _fetchActivityPoints();
      if (activityPoints.isNotEmpty) {
        _showActivityPointsDialog(activityPoints);
      } else {
        _showErrorDialog('Não há pontos de atividade para exibir.');
      }
    } catch (e) {
      // Se o erro for uma exceção do Firestore, você pode tentar acessar o código de erro e a mensagem
      // para uma depuração mais específica, por exemplo:
      // if (e is FirebaseException) {
      //   _showErrorDialog("Erro do Firestore: ${e.code} - ${e.message}");
      // } else {
      _showErrorDialog("Erro ao buscar pontos de atividade: $e");
      // }
    }
  }

  void _showActivityPointsDialog(List<LatLng> activityPoints) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes da Atividade'),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: CameraPosition(
                target: activityPoints.first,
                zoom: 18,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId('activity_route'),
                  points: activityPoints,
                  color: Colors.red,
                  width: 3,
                ),
              },
              markers: Set.from(activityPoints.map(
                (point) => Marker(
                  markerId: MarkerId(point.toString()),
                  position: point,
                ),
              )),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

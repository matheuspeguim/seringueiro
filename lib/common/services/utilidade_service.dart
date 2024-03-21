import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class UtilidadeService {
  static Future<bool> verificarEObterPermissaoLocalizacao(
      BuildContext context) async {
    // Verifica a permissão de localização em primeiro plano
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      // Solicita a permissão de localização em primeiro plano
      status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        // Se a permissão foi negada, mostra um diálogo explicando a necessidade da permissão
        await _mostrarDialogoPermissaoNegada(context);
        return false;
      }
    }

    // Solicita a permissão de localização em segundo plano
    if (Platform.isIOS || Platform.isAndroid) {
      var statusBackground = await Permission.locationAlways.status;
      if (!statusBackground.isGranted) {
        // Solicita a permissão de localização em segundo plano
        statusBackground = await Permission.locationAlways.request();
        if (!statusBackground.isGranted) {
          // Se a permissão foi negada, mostra um diálogo explicativo
          await _mostrarDialogoPermissaoNegada(context);
          return false;
        }
      }
    }

    return true; // Permissão concedida
  }

  static Future<void> _mostrarDialogoPermissaoNegada(
      BuildContext context) async {
    // Mostra um diálogo informando que a permissão foi negada e a necessidade de habilitá-la nas configurações
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Permissão de Localização Necessária'),
          content: Text(
              'Este aplicativo precisa das permissões de localização para funcionar corretamente.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Abrir Configurações'),
              onPressed: () async {
                // Abre as configurações do aplicativo para o usuário habilitar a permissão manualmente
                var url = Uri.parse('app-settings:');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  // Mostra uma mensagem de erro se não for possível abrir as configurações
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Não foi possível abrir as configurações do aplicativo.')));
                }
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class UtilidadeService {
  static Future<bool> verificarEObterPermissaoLocalizacao(
      BuildContext context) async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();

      if (!status.isGranted) {
        // Se a permissão ainda não for concedida, mostrar o diálogo
        await showDialog<void>(
          context: context,
          barrierDismissible:
              false, // O usuário deve tocar em um botão para fechar o diálogo
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Permissão de Localização Necessária'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'O processo de sangria não pode ser iniciado sem a permissão de localização.'),
                    Text(
                        'Por favor, habilite a permissão de localização nas configurações do sistema.'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar Sangria'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Fecha o diálogo
                    // Adicione aqui qualquer lógica adicional necessária para cancelar a sangria
                  },
                ),
                TextButton(
                  child: Text('Abrir Configurações'),
                  onPressed: () async {
                    // Abre as configurações do aplicativo
                    var url = Uri.parse('app-settings:');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Não foi possível abrir as configurações do aplicativo.';
                    }
                  },
                ),
              ],
            );
          },
        );
        return false; // Retorna false pois a permissão não foi concedida
      }
    }
    return true; // Retorna true se a permissão foi concedida
  }
}

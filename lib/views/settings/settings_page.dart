import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = false;
  bool _isManualRainData = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      _isManualRainData = prefs.getBool('manualRainData') ?? false;
    });
  }

  Future<void> _updatePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        title: Text('Configurações'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      body: ListView(
        children: <Widget>[
          Divider(),
          Padding(padding: EdgeInsets.only(left: 2)),
          Text("Notificações"),
          SwitchListTile(
            title: Text('Habilitar Notificações'),
            value: _isNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _isNotificationsEnabled = value;
                _updatePreference('notificationsEnabled', value);
              });
            },
          ),
          Divider(),
          Text("Propriedades"),
          SwitchListTile(
            title: Text('Dados de Chuva Automáticos'),
            subtitle: Text(
                'Escolha entre usar o histórico de chuvas fornecidos pelo serviço meteorológico ou inserí-los manualmente.'),
            value: _isManualRainData,
            onChanged: (bool value) {
              setState(() {
                _isManualRainData = value;
                _updatePreference('manualRainData', value);
              });
            },
          ),
        ],
      ),
    );
  }
}

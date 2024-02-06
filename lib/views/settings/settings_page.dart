import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;
  bool _useWeatherServiceForRain = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      _useWeatherServiceForRain =
          prefs.getBool('useWeatherServiceForRain') ?? true;
    });
  }

  Future<void> _updateNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _updateRainDataPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useWeatherServiceForRain', value);
    setState(() {
      _useWeatherServiceForRain = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Habilitar Notificações'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _updateNotifications,
            ),
          ),
          ListTile(
            title: Text('Usar Serviço de Meteorologia para Dados de Chuva'),
            trailing: Switch(
              value: _useWeatherServiceForRain,
              onChanged: _updateRainDataPreference,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/config/theme_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;
  bool _useWeatherServiceForRain = true;
  ThemeModeSetting _themeModeSetting = ThemeModeSetting.system;

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
      // Carregar a preferência de tema
      int themeModeIndex =
          prefs.getInt('themeModeSetting') ?? ThemeModeSetting.system.index;
      _themeModeSetting = ThemeModeSetting.values[themeModeIndex];
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

  Future<void> _updateThemeModeSetting(ThemeModeSetting? value) async {
    if (value == null) return; // Se o valor for nulo, simplesmente retorne.

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeModeSetting', value.index);

    setState(() {
      _themeModeSetting = value;
    });

    // Atualize o tema do aplicativo conforme necessário
    // Nota: Você pode precisar de um callback ou evento para atualizar o MaterialApp.
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
          ListTile(
            title: Text('Tema do Aplicativo'),
            trailing: DropdownButton<ThemeModeSetting>(
              value: _themeModeSetting,
              onChanged: _updateThemeModeSetting,
              items: ThemeModeSetting.values.map((setting) {
                return DropdownMenuItem<ThemeModeSetting>(
                  value: setting,
                  child: Text(setting.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

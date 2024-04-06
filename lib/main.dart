import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_seringueiro/common/config/theme_settings.dart';
import 'package:flutter_seringueiro/common/models/weather/current_weather.dart';
import 'package:flutter_seringueiro/common/models/weather/daily_feels_like.dart';
import 'package:flutter_seringueiro/common/models/weather/daily_temperature.dart';
import 'package:flutter_seringueiro/common/models/weather/daily_weather.dart';
import 'package:flutter_seringueiro/common/models/weather/hourly_weather.dart';
import 'package:flutter_seringueiro/common/models/weather/minutely_weather.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_alert.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_condition.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_response.dart';
import 'package:flutter_seringueiro/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'views/login/login_page_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Intl.defaultLocale = 'pt_BR';

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialização do Hive
  await Hive.initFlutter();
  Hive
    ..registerAdapter(CurrentWeatherAdapter())
    ..registerAdapter(DailyFeelsLikeAdapter())
    ..registerAdapter(DailyTemperatureAdapter())
    ..registerAdapter(DailyWeatherAdapter())
    ..registerAdapter(HourlyWeatherAdapter())
    ..registerAdapter(MinutelyWeatherAdapter())
    ..registerAdapter(WeatherAlertAdapter())
    ..registerAdapter(WeatherConditionAdapter())
    ..registerAdapter(WeatherResponseAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      title: 'Seringueiro',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: LoginPageWrapper(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Erro ao inicializar o aplicativo')),
    );
  }
}

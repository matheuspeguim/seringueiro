import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_seringueiro/common/config/theme_settings.dart';
import 'package:flutter_seringueiro/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'views/login/login_page_wrapper.dart';
import 'common/services/storage_service/local_storage_service.dart';
// Importe seus adapters do Hive aqui

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Intl.defaultLocale = 'pt_BR';

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialização específica para plataformas que não são web
  await Hive.initFlutter();
  Hive
    ..registerAdapter(TimestampAdapter())
    ..registerAdapter(DurationAdapter())
    ..registerAdapter(FieldActivityAdapter())
    ..registerAdapter(ActivityPointAdapter())
    ..registerAdapter(WeatherDataAdapter())
    ..registerAdapter(GeoPointAdapter());

  LocalStorageService localStorageService = LocalStorageService();
  await localStorageService.init();
  await localStorageService.verificarConexaoESincronizarSeNecessario();

  bool initializationSuccess = await _initializeApp();

  runApp(MyApp(initializationSuccess: initializationSuccess));
}

Future<bool> _initializeApp() async {
  try {
    // Inicialização específica do serviço de armazenamento local, apenas para mobile
    LocalStorageService localStorageService = LocalStorageService();
    await localStorageService.init();
    await localStorageService.verificarConexaoESincronizarSeNecessario();

    return true;
  } catch (_) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  final bool initializationSuccess;

  MyApp({required this.initializationSuccess});

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
      home: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (initializationSuccess) {
              return LoginPageWrapper();
            } else {
              return ErrorScreen();
            }
          }
          return LoadingScreen();
        },
      ),
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_seringueiro/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'views/login/login_page_wrapper.dart';
import 'widgets/custom_Circular_Progress_indicator.dart';
import 'services/storage_service/local_storage_service.dart';
// Importe seus adapters do Hive aqui

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Intl.defaultLocale = 'pt_BR';

  // Inicialize o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa o Hive
  await Hive.initFlutter();
  Hive
    ..registerAdapter(TimestampAdapter())
    ..registerAdapter(DurationAdapter())
    ..registerAdapter(FieldActivityAdapter())
    ..registerAdapter(ActivityPointAdapter())
    ..registerAdapter(WeatherDataAdapter())
    ..registerAdapter(GeoPointAdapter());

  // Crie uma instância do seu serviço de armazenamento local
  LocalStorageService localStorageService = LocalStorageService();
  await localStorageService.init();
  // Verifique e sincronize sangrias, se necessário
  await localStorageService.verificarConexaoESincronizarSeNecessario();

  bool initializationSuccess = await _initializeApp();

  runApp(MyApp(initializationSuccess: initializationSuccess));
}

Future<bool> _initializeApp() async {
  try {
    // Coloque aqui outras operações de inicialização
    // Inicialização específica do serviço de armazenamento local
    LocalStorageService localStorageService = LocalStorageService();
    await localStorageService.init();

    // Verifique e sincronize dados se necessário
    await localStorageService.verificarConexaoESincronizarSeNecessario();

    //await _limparBancoDeDadosHive();

    return true; // Retorna true se tudo correr bem
  } catch (_) {
    return false; // Retorna false em caso de erro
  }
}

Future<void> _limparBancoDeDadosHive() async {
  final directory = await getApplicationDocumentsDirectory();
  final hiveDirectory = Directory(directory.path + '/hive');
  if (hiveDirectory.existsSync()) {
    hiveDirectory.deleteSync(recursive: true);
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
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerTheme: DividerThemeData(
          color: Colors.grey,
          space: 50,
          indent: 20,
          endIndent: 20,
          thickness: 0.5,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              // Navega para a próxima página se a inicialização for bem-sucedida
              return LoginPageWrapper();
            } else {
              // Mostra uma tela de erro se a inicialização falhar
              return ErrorScreen();
            }
          }
          // Mostra um indicador de carregamento enquanto aguarda
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
      body: Center(child: CustomCircularProgressIndicator()),
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

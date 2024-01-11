import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/storage_service/local_storage_service.dart';
import 'package:flutter_seringueiro/views/login/login_bloc.dart';
import 'package:flutter_seringueiro/views/login/login_page_wrapper.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  intl.Intl.defaultLocale = 'pt_BR';

  // Inicialize o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Limpa o Hive (utilizar quando der erro de incompatibilidade)
  await _limparBancoDeDadosHive();

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

  runApp(
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: MyApp(),
    ),
  );
}

Future<void> _limparBancoDeDadosHive() async {
  final directory = await getApplicationDocumentsDirectory();
  final hiveDirectory = Directory(directory.path + '/hive');
  if (hiveDirectory.existsSync()) {
    hiveDirectory.deleteSync(recursive: true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: LoginPageWrapper(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/local_storage_service.dart';
import 'package:flutter_seringueiro/views/login/login_bloc.dart';
import 'package:flutter_seringueiro/views/login/login_page_wrapper.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  intl.Intl.defaultLocale = 'pt_BR';

  // Inicialize o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialize o Hive
  await Hive.initFlutter(); // Adicionando a inicialização do Hive
  Hive
    ..registerAdapter(TimestampAdapter())
    ..registerAdapter(SangriaAdapter())
    ..registerAdapter(PontoDeSangriaAdapter())
    ..registerAdapter(WeatherDataAdapter());

  // Crie uma instância do seu serviço de armazenamento local
  LocalStorageService localStorageService = LocalStorageService();
  await localStorageService.init();

  // Verifique e sincronize sangrias, se necessário
  await localStorageService.verificarConexaoESincronizarSeNecessario();

  // Limpe a Box do Hive
  var box = await Hive.openBox('sangriasLocalCache');
  await box.clear();

  runApp(
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: MyApp(),
    ),
  );
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: LoginPageWrapper(), // ou outra página inicial conforme necessário
    );
  }
}

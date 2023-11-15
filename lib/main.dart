import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/views/home_page.dart';
import 'package:flutter_seringueiro/views/login_page.dart';
import 'package:flutter_seringueiro/views/login_page_wrapper.dart';
import 'package:flutter_seringueiro/views/registration_page.dart';
import 'package:flutter_seringueiro/views/signup_page.dart';
import 'package:flutter_seringueiro/views/user_data/personal_info_page.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/blocs/registration/registration_bloc.dart';
import 'package:flutter_seringueiro/services/via_cep_service.dart'; // Importe seu ViaCepService
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  intl.Intl.defaultLocale = 'pt_BR';
  // Inicialize o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistrationBloc>(
      create: (context) => RegistrationBloc(
          viaCepService: ViaCepService()), // Substitua com a instância correta
      child: MaterialApp(
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
      ),
    );
  }
}

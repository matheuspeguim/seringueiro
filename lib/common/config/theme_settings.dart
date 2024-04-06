import 'package:flutter/material.dart';

enum ThemeModeSetting { system, light, dark }

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF4CAF50), // Verde Vibrante como cor primária
    onPrimary: Colors.white, // Para ícones e texto em cima do primário
    secondary: Color.fromARGB(
        255, 151, 205, 165), // Para destacar elementos secundários
    onSecondary: Colors.white, // Para ícones e texto em cima do secundário
    error: Colors.red, // Cor para erros
    onError: Colors.white, // Para ícones e texto em cima de erros
    background: Color(0xFFFFFFFF), // Branco puro para o fundo principal
    onBackground:
        Color(0xFF333333), // Cinza escuro para texto e ícones em cima do fundo
    surface: Color(
        0xFFDDDDDD), // Cinza muito claro para elementos de UI e divisórias
    onSurface: Color(
        0xFF333333), // Cinza escuro para texto e ícones em cima da superfície
  ),
  fontFamily: 'Montserrat',
  textTheme: TextTheme(
    displayLarge: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
    bodyLarge: TextStyle(
        fontSize: 14.0, fontFamily: 'Open Sans', color: Color(0xFF757575)),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    color: Color(0xFFF0F0F0),
    iconTheme: IconThemeData(color: Color(0xFF333333)),
    titleTextStyle: TextStyle(
        color: Color(0xFF333333), fontSize: 20.0, fontWeight: FontWeight.bold),
  ),
  dividerTheme: DividerThemeData(
    space: 32,
    indent: 40,
    endIndent: 40,
    color: Color(0xFFE0E0E0),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF66BB6A), // Verde Vibrante adaptado para o modo escuro
    onPrimary: Color(0xFF121212), // Para ícones e texto em cima do primário
    secondary: Color.fromARGB(255, 50, 100,
        60), // Adaptado para o modo escuro, mantendo a energia e foco
    onSecondary: Color(0xFF121212), // Para ícones e texto em cima do secundário
    error: Colors.red.shade800, // Cor para erros adaptada para o modo escuro
    onError: Colors.white, // Para ícones e texto em cima de erros
    background:
        Color(0xFF121212), // Cinza escuro profundo para o fundo principal
    onBackground: Color(0xFFE0E0E0), // Para texto e ícones em cima do fundo
    surface: Color(0xFF1E1E1E), // Para diferenciação sutil de elementos
    onSurface: Color(0xFFE0E0E0), // Para texto e ícones em cima da superfície
  ),
  fontFamily: 'Montserrat',
  textTheme: TextTheme(
    displayLarge: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
    bodyLarge: TextStyle(
        fontSize: 14.0, fontFamily: 'Open Sans', color: Color(0xFFBDBDBD)),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    color: Color(0xFF1E1E1E),
    iconTheme: IconThemeData(color: Color(0xFFE0E0E0)),
    titleTextStyle: TextStyle(
        color: Color(0xFFE0E0E0), fontSize: 20.0, fontWeight: FontWeight.bold),
  ),
  dividerTheme: DividerThemeData(
    space: 16,
    indent: 40,
    endIndent: 40,
    color: Color(0xFF373737),
  ),
);

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.light,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
        TargetPlatform.values,
        value: (dynamic _) => const ZoomPageTransitionsBuilder(),
      ),
    ),
    canvasColor: const Color(0xFF000000),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    unselectedWidgetColor: const Color(0xFF664FF0),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: const Color(0xFF000000),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF232835),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Color(0xFF000000)),
    textTheme: const TextTheme(
      headline1: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      headline2: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      headline3: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      headline4: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      headline5: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      headline6: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      button: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      bodyText1: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      bodyText2: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark,
    pageTransitionsTheme: PageTransitionsTheme(
      builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
        TargetPlatform.values,
        value: (dynamic _) => const ZoomPageTransitionsBuilder(),
      ),
    ),
    canvasColor: Colors.white,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    unselectedWidgetColor: const Color(0xFF664FF0),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFF4F4F4),
    ),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.white),
    textTheme: const TextTheme(
      headline1: TextStyle(
          color: Color(0xFF000000),
          fontSize: 24,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      headline2: TextStyle(
          color: Color(0xFF000000),
          fontSize: 20,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      headline3: TextStyle(
          color: Color(0xFF000000),
          fontSize: 18,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      headline4: TextStyle(
          color: Color(0xFF000000),
          fontSize: 16,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      headline5: TextStyle(
          color: Color(0xFF000000),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      headline6: TextStyle(
          color: Color(0xFF000000),
          fontSize: 12,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      button: TextStyle(
          color: Color(0xFF000000),
          fontSize: 16,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600),
      bodyText1: TextStyle(
          color: Color(0xFF000000),
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
      bodyText2: TextStyle(
          color: Color(0xFF000000),
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal),
    ),
  );
}

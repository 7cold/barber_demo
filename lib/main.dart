import 'package:barbearia/const/const.dart';
import 'package:barbearia/ui/root.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  await Supabase.initialize(
    url: 'https://dblszqggrgwxjjyeifzl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRibHN6cWdncmd3eGpqeWVpZnpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTc4NTcwNDgsImV4cCI6MjAzMzQzMzA0OH0.cgvkzQUPIGNzepgbAFwfU7kA2FtBIInHIW_a6r2GNAs',
  );

  await GetStorage.init();
  runApp(const MyApp());
}

//teste
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: Preferencias.nomeApp,
        opaqueRoute: true,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        themeMode: c.modoEscuro.value == true ? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData(
          useMaterial3: true,
          dividerColor: Colors.transparent,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.pink,
        ),
        theme: ThemeData(
          dividerColor: Colors.transparent,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.pink,
          useMaterial3: true,
        ),
        home: const Root(),
      ),
    );
  }
}

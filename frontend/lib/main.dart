import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/screen/DashboardScreen.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de nb_utils
  await initialize();

  // Nota: Firebase se inicializaría aquí una vez configurado el archivo google-services.json
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet Hackathon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: WAPrimaryColor,
        scaffoldBackgroundColor: WAScaffoldColor,
        fontFamily: 'Roboto', // O la fuente que prefieras
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: const DashboardScreen(), // Empezaremos directamente en el Dashboard para el maquetado
    );
  }
}

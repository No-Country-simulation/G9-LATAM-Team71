import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/screen/DashboardScreen.dart';
import 'package:wallet_flutter/screen/LoginScreen.dart';
import 'package:wallet_flutter/services/api_service.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de nb_utils
  await initialize();
  
  // Cargar sesión guardada en SharedPreferences
  await ApiService.loadSession();
  
  // Verificamos si tenemos token
  bool isLoggedIn = getStringAsync('jwt_token').isNotEmpty;

  // Nota: Firebase se inicializaría aquí una vez configurado el archivo google-services.json
  // await Firebase.initializeApp();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, this.isLoggedIn = false});

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
      home: isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}

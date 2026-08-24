import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:wallet_flutter/models/transaction_models.dart';
import 'package:nb_utils/nb_utils.dart';

class ApiService {
  static String get baseUrl {
    return 'http://192.168.1.6:8080/api/v1';
  }
  
  static String? _jwtToken;
  static String? _usuarioId;

  static Future<void> loadSession() async {
    _jwtToken = getStringAsync('jwt_token');
    _usuarioId = getStringAsync('usuario_id');
    if (_jwtToken!.isEmpty) _jwtToken = null;
    if (_usuarioId!.isEmpty) _usuarioId = null;
  }

  static Future<void> logout() async {
    _jwtToken = null;
    _usuarioId = null;
    await removeKey('jwt_token');
    await removeKey('usuario_id');
  }

  static Future<bool> login(String correo, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': correo,
          'contrasena': contrasena,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jwtToken = data['token'];
        _usuarioId = data['id'];
        
        await setValue('jwt_token', _jwtToken);
        await setValue('usuario_id', _usuarioId);
        return true;
      } else {
        throw "Credenciales incorrectas o error en BD (${response.statusCode})";
      }
    } catch (e) {
      if (e is String) rethrow;
      throw "Error de red: verifica tu Firewall e IP (${e.toString()})";
    }
  }

  static Future<bool> register({
    required String nombre,
    required String apellido,
    required String correo, 
    required String contrasena
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'apellido': apellido,
          'correo': correo,
          'contrasena': contrasena,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jwtToken = data['token'];
        _usuarioId = data['id'];
        
        await setValue('jwt_token', _jwtToken);
        await setValue('usuario_id', _usuarioId);
        return true;
      } else {
        throw "Error al registrar: ${response.body}";
      }
    } catch (e) {
      if (e is String) rethrow;
      throw "Error de red: verifica tu Firewall e IP (${e.toString()})";
    }
  }

  static Future<ClasificarTransaccionResponse?> predecirTransaccion({
    required String tipoFlujo,
    required double monto,
    required String descripcion,
  }) async {
    
    final url = Uri.parse('$baseUrl/transacciones/predecir');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (_jwtToken != null) 'Authorization': 'Bearer $_jwtToken',
        },
        body: jsonEncode({
          'tipo_flujo': tipoFlujo,
          'monto': monto,
          'descripcion': descripcion,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return ClasificarTransaccionResponse.fromJson(data);
      } else {
        print("Error predecir: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error en predecirTransaccion: $e");
      return null;
    }
  }

  static Future<bool> guardarTransaccion({
    required String tipoFlujo,
    required String cualidadFlujo,
    required String categoria,
    required double monto,
    required String descripcion,
  }) async {
    
    final url = Uri.parse('$baseUrl/transacciones');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (_jwtToken != null) 'Authorization': 'Bearer $_jwtToken',
          if (_usuarioId != null) 'Usuario-ID': _usuarioId!,
        },
        body: jsonEncode({
          'tipo_flujo': tipoFlujo,
          'cualidad_flujo': cualidadFlujo,
          'categoria': categoria,
          'fecha': DateTime.now().toIso8601String(),
          'monto': monto,
          'descripcion': descripcion,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Error en guardarTransaccion: $e");
      return false;
    }
  }

  static Future<DashboardResponse?> getDashboardData() async {
    final url = Uri.parse('$baseUrl/analisis/dashboard');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (_jwtToken != null) 'Authorization': 'Bearer $_jwtToken',
          if (_usuarioId != null) 'Usuario-ID': _usuarioId!,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return DashboardResponse.fromJson(data);
      } else {
        print("Error obteniendo dashboard: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error de red en getDashboardData: $e");
      return null;
    }
  }

  static Future<bool> actualizarPerfil({
    required double ingresoMensual,
    required double deuda,
    required String frecuenciaAhorro,
  }) async {
    final url = Uri.parse('$baseUrl/usuarios/perfil');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (_jwtToken != null) 'Authorization': 'Bearer $_jwtToken',
          if (_usuarioId != null) 'Usuario-ID': _usuarioId!,
        },
        body: jsonEncode({
          'ingreso_mensual': ingresoMensual,
          'nivel_endeudamiento': deuda,
          'frecuencia_ahorro': frecuenciaAhorro,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Error en actualizarPerfil: $e");
      return false;
    }
  }
}

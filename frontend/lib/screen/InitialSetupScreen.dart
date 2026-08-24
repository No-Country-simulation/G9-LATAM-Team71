import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/screen/DashboardScreen.dart';
import 'package:wallet_flutter/services/api_service.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _ingresoController = TextEditingController();
  final _deudaController = TextEditingController();
  String _frecuenciaAhorro = 'MENSUAL';

  bool _isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      double ingreso = double.parse(_ingresoController.text);
      double deuda = double.parse(_deudaController.text);
      double porcentajeDeuda = (ingreso > 0) ? (deuda / ingreso) * 100 : 0;

      // Limitar a un maximo de 999.99% para evitar errores en base de datos
      if (porcentajeDeuda > 999.99) porcentajeDeuda = 999.99;

      final success = await ApiService.actualizarPerfil(
        ingresoMensual: ingreso,
        deuda: porcentajeDeuda,
        frecuenciaAhorro: _frecuenciaAhorro,
      );

      setState(() => _isLoading = false);

      if (success) {
        if (!mounted) return;
        toast("Perfil configurado correctamente");
        const DashboardScreen().launch(context, isNewTask: true);
      } else {
        toast("Error al guardar la configuración");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WAScaffoldColor,
      appBar: AppBar(
        title: Text("Configuración Inicial", style: boldTextStyle(color: Colors.white)),
        backgroundColor: WAPrimaryColor,
        automaticallyImplyLeading: false, // No permitir volver atrás
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "¡Bienvenido a FinanceAI!",
                style: boldTextStyle(size: 24, color: WAPrimaryColor),
              ),
              8.height,
              Text(
                "Para poder ofrecerte las mejores predicciones y calcular tus metas, necesitamos conocer un poco más de tu situación financiera actual.",
                style: secondaryTextStyle(size: 16),
              ),
              24.height,
              
              // Ingreso Mensual
              Text("¿Cuál es tu ingreso mensual aproximado?", style: boldTextStyle()),
              8.height,
              TextFormField(
                controller: _ingresoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.attach_money),
                  hintText: "Ej. 15000",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Requerido";
                  if (double.tryParse(value) == null) return "Número inválido";
                  return null;
                },
              ),
              24.height,

              // Deuda Total
              Text("¿Cuánto sumas en deudas actualmente?", style: boldTextStyle()),
              8.height,
              TextFormField(
                controller: _deudaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.money_off),
                  hintText: "Ej. 2000 (pon 0 si no tienes)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Requerido";
                  if (double.tryParse(value) == null) return "Número inválido";
                  return null;
                },
              ),
              24.height,

              // Frecuencia de Ahorro
              Text("¿Con qué frecuencia planeas ahorrar?", style: boldTextStyle()),
              8.height,
              DropdownButtonFormField<String>(
                value: _frecuenciaAhorro,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: "SEMANAL", child: Text("Semanal")),
                  DropdownMenuItem(value: "QUINCENAL", child: Text("Quincenal")),
                  DropdownMenuItem(value: "MENSUAL", child: Text("Mensual")),
                  DropdownMenuItem(value: "ANUAL", child: Text("Anual")),
                ],
                onChanged: (val) {
                  setState(() {
                    if (val != null) _frecuenciaAhorro = val;
                  });
                },
              ),
              32.height,

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WAPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading 
                    ? const SizedBox(
                        height: 20, width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : Text("Guardar y Continuar", style: boldTextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

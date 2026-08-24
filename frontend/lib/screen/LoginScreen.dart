import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/screen/DashboardScreen.dart';
import 'package:wallet_flutter/services/api_service.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool isRegister = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WAScaffoldColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isRegister ? "Crear cuenta" : "Iniciar Sesión", style: boldTextStyle(size: 30)),
              8.height,
              Text(
                isRegister ? "Regístrate para empezar a organizar tus finanzas" : "Ingresa tus datos para continuar", 
                style: secondaryTextStyle()
              ),
              32.height,
              
              if (isRegister) ...[
                AppTextField(
                  controller: nameController,
                  textFieldType: TextFieldType.NAME,
                  decoration: _inputDeco(hint: "Nombre", icon: Icons.person),
                ),
                16.height,
                AppTextField(
                  controller: apellidoController,
                  textFieldType: TextFieldType.NAME,
                  decoration: _inputDeco(hint: "Apellido", icon: Icons.person_outline),
                ),
                16.height,
              ],

              AppTextField(
                controller: emailController,
                textFieldType: TextFieldType.EMAIL,
                decoration: _inputDeco(hint: "Correo Electrónico", icon: Icons.email),
              ),
              16.height,
              
              AppTextField(
                controller: passController,
                textFieldType: TextFieldType.PASSWORD,
                decoration: _inputDeco(hint: "Contraseña", icon: Icons.lock),
              ),
              32.height,
              
              isLoading
                ? const Center(child: CircularProgressIndicator(color: WAPrimaryColor))
                : AppButton(
                    text: isRegister ? "Registrarse" : "Entrar",
                    color: WAPrimaryColor,
                    textStyle: boldTextStyle(color: Colors.white),
                    width: context.width(),
                    onTap: _submit,
                  ),
              
              16.height,
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isRegister = !isRegister;
                    });
                  },
                  child: Text(
                    isRegister ? "¿Ya tienes cuenta? Inicia sesión" : "¿No tienes cuenta? Regístrate",
                    style: primaryTextStyle(color: WAPrimaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      toast("Llenar los campos requeridos");
      return;
    }

    setState(() => isLoading = true);

    String? errorMessage;
    bool success = false;
    
    if (isRegister) {
      if (nameController.text.isEmpty || apellidoController.text.isEmpty) {
        toast("Ingresa tu nombre y apellido");
        setState(() => isLoading = false);
        return;
      }
      try {
        success = await ApiService.register(
          nombre: nameController.text, 
          apellido: apellidoController.text,
          correo: emailController.text, 
          contrasena: passController.text
        );
      } catch (e) {
        errorMessage = e.toString();
      }
    } else {
      try {
        success = await ApiService.login(
          emailController.text, 
          passController.text
        );
      } catch (e) {
        errorMessage = e.toString();
      }
    }

    setState(() => isLoading = false);

    if (success) {
      if (!mounted) return;
      const DashboardScreen().launch(context, isNewTask: true);
    } else {
      // Si la API devolvió falso, probablemente ApiService capturó el error. 
      // Vamos a intentar obtener el último error de ApiService.
      toast(errorMessage ?? "Error de red o credenciales incorrectas. Verifica tu IP y Firewall.");
    }
  }

  InputDecoration _inputDeco({required String hint, required IconData icon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: WAPrimaryColor)),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      fillColor: Colors.white,
      hintText: hint,
      prefixIcon: Icon(icon, color: WAPrimaryColor),
      filled: true,
    );
  }
}

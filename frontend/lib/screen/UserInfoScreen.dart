import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/component/AppScaffold.dart';
import 'package:wallet_flutter/models/transaction_models.dart';
import 'package:wallet_flutter/services/api_service.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late Future<DashboardResponse?> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = ApiService.getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Información del Usuario",
      body: FutureBuilder<DashboardResponse?>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: WAPrimaryColor));
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Error al cargar la información"));
          }

          final user = snapshot.data!.usuario;
          final analisis = snapshot.data!.analisis;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: WAPrimaryColor,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                16.height,
                Text("${user.nombre} ${user.apellido}".trim(), style: boldTextStyle(size: 24)),
                8.height,
                Text(user.correo, style: secondaryTextStyle(size: 16)),
                24.height,
                
                _buildInfoCard(
                  title: "Perfil Financiero",
                  value: analisis.perfilFinanciero.isEmpty ? "No definido" : analisis.perfilFinanciero,
                  icon: Icons.analytics_outlined,
                  color: Colors.blue,
                ),
                16.height,
                _buildInfoCard(
                  title: "Ingreso Mensual",
                  value: "\$${analisis.ingresoMensual.toStringAsFixed(2)}",
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
                16.height,
                _buildInfoCard(
                  title: "Nivel de Endeudamiento",
                  value: "${analisis.nivelEndeudamiento.toStringAsFixed(2)}%",
                  icon: Icons.money_off,
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationRoundedWithShadow(12, backgroundColor: Colors.white),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: secondaryTextStyle(size: 14)),
                4.height,
                Text(value, style: boldTextStyle(size: 16)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

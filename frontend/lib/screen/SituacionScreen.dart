import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/component/AppScaffold.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

class SituacionScreen extends StatefulWidget {
  const SituacionScreen({super.key});

  @override
  State<SituacionScreen> createState() => _SituacionScreenState();
}

class _SituacionScreenState extends State<SituacionScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Situación Financiera",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Análisis Semanal", style: boldTextStyle(size: 20)),
            Text("Consejos personalizados de la IA", style: secondaryTextStyle()),
            24.height,
            
            _buildConsejoCard(
              "Optimización de Suscripciones",
              "Detectamos \$40 en suscripciones recurrentes no vitales. Cancelarlas acelerará tu meta de 'Fondo de Emergencia' en 2 meses.",
              Icons.lightbulb,
              Colors.orange,
            ),
            16.height,
            
            _buildConsejoCard(
              "Gastos Variables",
              "Tus gastos variables representan un 15% de tus ingresos, lo cual es muy sano. Mantén este ritmo.",
              Icons.check_circle,
              Colors.green,
            ),
            16.height,
            
            _buildConsejoCard(
              "Alerta de Presupuesto",
              "Has gastado el 80% de tu presupuesto en 'Alimentación' y aún queda una semana del mes.",
              Icons.warning,
              Colors.red,
            ),
            
            24.height,
            Text("Resumen de Comportamiento", style: boldTextStyle()),
            16.height,
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: boxDecorationRoundedWithShadow(12, backgroundColor: Colors.white),
              child: Column(
                children: [
                  _buildSummaryRow("Total Ingresos", "\$4,500", Colors.green),
                  const Divider(),
                  _buildSummaryRow("Fijo Vital", "\$300", WATextPrimaryColor),
                  _buildSummaryRow("Fijo No Vital", "\$40", WATextPrimaryColor),
                  _buildSummaryRow("Variable", "\$420", WATextPrimaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsejoCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationRoundedWithShadow(12, backgroundColor: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: boldTextStyle()),
              8.height,
              Text(description, style: secondaryTextStyle()),
            ],
          ).expand(),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: primaryTextStyle()),
          Text(value, style: boldTextStyle(color: color)),
        ],
      ),
    );
  }
}

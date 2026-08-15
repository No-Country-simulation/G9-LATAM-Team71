import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/component/AppScaffold.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

class MetasScreen extends StatefulWidget {
  const MetasScreen({super.key});

  @override
  State<MetasScreen> createState() => _MetasScreenState();
}

class _MetasScreenState extends State<MetasScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Metas Financieras",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tus Objetivos", style: boldTextStyle(size: 20)),
            Text("Seguimiento de ahorro y metas", style: secondaryTextStyle()),
            24.height,
            
            _buildMetaItem(
              "Fondo de Emergencia",
              "Objetivo: \$20,000",
              0.65,
              "Ahorrado: \$13,000",
              "Meta para el 31 de Dic, 2026. Vas por buen camino, ¡sigue así!",
            ),
            16.height,
            
            _buildMetaItem(
              "Viaje a Japón",
              "Objetivo: \$50,000",
              0.15,
              "Ahorrado: \$7,500",
              "Ahorro mensual sugerido: \$2,500 para llegar a tiempo.",
            ),
            16.height,
            
            _buildMetaItem(
              "Nueva Laptop",
              "Objetivo: \$15,000",
              0.90,
              "Ahorrado: \$13,500",
              "¡Casi lo logras! Falta muy poco para tu nueva herramienta.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem(String title, String subtitle, double progress, String detail, String description) {
    return Container(
      decoration: boxDecorationRoundedWithShadow(12, backgroundColor: Colors.white),
      child: ExpansionTile(
        title: Text(title, style: boldTextStyle()),
        subtitle: Text(subtitle, style: secondaryTextStyle()),
        leading: CircleAvatar(
          backgroundColor: WAPrimaryColor.withOpacity(0.1),
          child: const Icon(Icons.flag, color: WAPrimaryColor),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: WAPrimaryColor.withOpacity(0.1),
                  color: WAPrimaryColor,
                  minHeight: 8,
                ).cornerRadiusWithClipRRect(4),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(detail, style: boldTextStyle(size: 14)),
                    Text("${(progress * 100).toInt()}%", style: boldTextStyle(color: WAPrimaryColor)),
                  ],
                ),
                16.height,
                Text(description, style: secondaryTextStyle()),
                16.height,
                AppButton(
                  text: "Añadir Fondos",
                  color: WAPrimaryColor,
                  textStyle: boldTextStyle(color: Colors.white),
                  width: context.width(),
                  onTap: () {
                    toast("Funcionalidad próximamente");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

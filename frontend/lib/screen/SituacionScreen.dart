import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/component/AppScaffold.dart';
import 'package:wallet_flutter/utils/WAColors.dart';
import 'package:wallet_flutter/models/transaction_models.dart';
import 'package:wallet_flutter/services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';

class SituacionScreen extends StatefulWidget {
  const SituacionScreen({super.key});

  @override
  State<SituacionScreen> createState() => _SituacionScreenState();
}

class _SituacionScreenState extends State<SituacionScreen> {
  late Future<DashboardResponse?> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _dashboardFuture = ApiService.getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Situación Financiera",
      body: FutureBuilder<DashboardResponse?>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: WAPrimaryColor));
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error al cargar situación"),
                  8.height,
                  ElevatedButton(
                    onPressed: () => setState(() => _fetchData()),
                    child: const Text("Reintentar"),
                  )
                ],
              ),
            );
          }

          final analisis = snapshot.data!.analisis;
          final recomendaciones = analisis.recomendaciones;
          final transacciones = analisis.transaccionesDelMes;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _fetchData());
              await _dashboardFuture;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tu Salud Financiera", style: boldTextStyle(size: 20)),
                  Text("Panorama general de tus finanzas", style: secondaryTextStyle()),
                  24.height,
                  
                  // Card de Resumen General
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: boxDecorationRoundedWithShadow(12, backgroundColor: Colors.white),
                    child: Column(
                      children: [
                        _buildSummaryRow("Ingreso Mensual", "\$${NumberFormat('#,##0.00', 'en_US').format(analisis.ingresoMensual)}", Colors.green),
                        const Divider(),
                        _buildDebtRow(analisis.nivelEndeudamiento),
                        const Divider(),
                        _buildSummaryRow("Perfil Financiero", analisis.perfilFinanciero.isEmpty ? "NO DEFINIDO" : analisis.perfilFinanciero, WATextPrimaryColor),
                        const Divider(),
                        _buildSummaryRow("Dinero Disponible", "\$${NumberFormat('#,##0.00', 'en_US').format(analisis.dineroDisponible)}", WAPrimaryColor),
                      ],
                    ),
                  ),

                  32.height,
                  Text("Distribución de Gastos", style: boldTextStyle(size: 20)),
                  Text("Dónde estás gastando tu dinero este mes", style: secondaryTextStyle()),
                  16.height,
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: boxDecorationRoundedWithShadow(12, backgroundColor: Colors.white),
                    child: _buildPieChart(transacciones),
                  ),

                  32.height,
                  Text("Flujo de Caja Mensual", style: boldTextStyle(size: 20)),
                  Text("Comparativa de lo que entra vs lo que sale", style: secondaryTextStyle()),
                  16.height,
                  _buildCashFlowSection(transacciones),

                  32.height,
                  Text("Análisis Inteligente", style: boldTextStyle(size: 20)),
                  Text("Recomendaciones generadas por IA", style: secondaryTextStyle()),
                  16.height,
                  
                  if (recomendaciones.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text("No hay recomendaciones generadas aún. ¡Registra más transacciones!"),
                      ),
                    )
                  else
                    ...recomendaciones.map((r) {
                      IconData icon = Icons.lightbulb;
                      Color color = Colors.orange;
                      
                      if (r.prioridad == "ALTA") {
                        icon = Icons.warning;
                        color = Colors.red;
                      } else if (r.prioridad == "BAJA") {
                        icon = Icons.info;
                        color = Colors.blue;
                      }
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildConsejoCard(
                          r.tipo,
                          r.mensaje,
                          icon,
                          color,
                        ),
                      );
                    }).toList(),
                    
                  32.height,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: "Generar Análisis Manual",
                      color: WAPrimaryColor,
                      textStyle: boldTextStyle(color: Colors.white),
                      onTap: () async {
                        toast("Solicitando análisis a la IA...");
                        bool success = await ApiService.generarAnalisisManual();
                        if (success) {
                          toast("¡Análisis generado con éxito!");
                          setState(() => _fetchData());
                        } else {
                          toast("Error al generar el análisis.");
                        }
                      },
                    ),
                  ),
                  32.height,
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildPieChart(List<TransaccionResumen> transacciones) {
    var egresos = transacciones.where((t) => t.tipoFlujo == "EGRESO").toList();
    if (egresos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("No hay gastos registrados este mes.", textAlign: TextAlign.center)),
      );
    }

    Map<String, double> gastosPorCategoria = {};
    for (var t in egresos) {
      gastosPorCategoria[t.categoria] = (gastosPorCategoria[t.categoria] ?? 0) + t.monto;
    }

    double totalEgresos = gastosPorCategoria.values.fold(0, (sum, val) => sum + val);

    List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.pink];
    int colorIndex = 0;

    List<PieChartSectionData> sections = gastosPorCategoria.entries.map((e) {
      double percentage = (e.value / totalEgresos) * 100;
      Color c = colors[colorIndex % colors.length];
      colorIndex++;
      return PieChartSectionData(
        color: c,
        value: e.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        24.height,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: gastosPorCategoria.entries.map((e) {
            int idx = gastosPorCategoria.keys.toList().indexOf(e.key);
            Color c = colors[idx % colors.length];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16, 
                  height: 16, 
                  decoration: BoxDecoration(color: c, shape: BoxShape.circle)
                ),
                8.width,
                Text(
                  "${e.key} (\$${e.value.toStringAsFixed(0)})", 
                  style: secondaryTextStyle(size: 14)
                ),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildDebtRow(double nivelEndeudamiento) {
    Color debtColor = Colors.green;
    String debtStatus = "Saludable";
    
    if (nivelEndeudamiento > 40) {
      debtColor = Colors.red;
      debtStatus = "Peligro";
    } else if (nivelEndeudamiento > 25) {
      debtColor = Colors.orange;
      debtStatus = "Precaución";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nivel de Endeudamiento", style: primaryTextStyle()),
              Text("${nivelEndeudamiento.toStringAsFixed(1)}% ($debtStatus)", style: boldTextStyle(color: debtColor)),
            ],
          ),
          8.height,
          LinearProgressIndicator(
            value: nivelEndeudamiento / 100,
            backgroundColor: Colors.grey.withOpacity(0.2),
            color: debtColor,
            minHeight: 8,
          ).cornerRadiusWithClipRRect(4),
        ],
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: boldTextStyle(size: 16)),
              8.height,
              Text(description, style: secondaryTextStyle(size: 14)),
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
          Text(value, style: boldTextStyle(color: color, size: 16)),
        ],
      ),
    );
  }

  Widget _buildCashFlowSection(List<TransaccionResumen> transacciones) {
    double ingresos = transacciones.where((t) => t.tipoFlujo == "INGRESO").fold(0.0, (sum, t) => sum + t.monto);
    double egresos = transacciones.where((t) => t.tipoFlujo == "EGRESO").fold(0.0, (sum, t) => sum + t.monto);
    
    double maximoGasto = 0;
    String categoriaMax = "-";
    
    if (egresos > 0) {
      var mayor = transacciones.where((t) => t.tipoFlujo == "EGRESO").reduce((a, b) => a.monto > b.monto ? a : b);
      maximoGasto = mayor.monto;
      categoriaMax = mayor.categoria;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationRoundedWithShadow(12, backgroundColor: Colors.white),
      child: Column(
        children: [
          _buildSummaryRow("Total Ingresado", "\$${NumberFormat('#,##0.00', 'en_US').format(ingresos)}", Colors.green),
          const Divider(),
          _buildSummaryRow("Total Gastado", "\$${NumberFormat('#,##0.00', 'en_US').format(egresos)}", Colors.red),
          const Divider(),
          _buildSummaryRow("Mayor Gasto", "\$${NumberFormat('#,##0.00', 'en_US').format(maximoGasto)} ($categoriaMax)", Colors.orange),
          24.height,
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (ingresos > egresos ? ingresos : egresos) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Ingresos', style: style);
                            break;
                          case 1:
                            text = const Text('Egresos', style: style);
                            break;
                          default:
                            text = const Text('');
                            break;
                        }
                        return SideTitleWidget(meta: meta, child: text);
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: ingresos,
                        color: Colors.green,
                        width: 22,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: egresos,
                        color: Colors.red,
                        width: 22,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

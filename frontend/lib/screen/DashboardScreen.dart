import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/component/AppScaffold.dart';
import 'package:wallet_flutter/component/ExpenseFormModal.dart';
import 'package:wallet_flutter/services/api_service.dart';
import 'package:wallet_flutter/utils/WAColors.dart';
import 'package:wallet_flutter/models/transaction_models.dart';
import 'package:wallet_flutter/screen/InitialSetupScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      title: "Dashboard",
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
                  const Text("Error al cargar el dashboard"),
                  8.height,
                  ElevatedButton(
                    onPressed: () => setState(() => _fetchData()),
                    child: const Text("Reintentar"),
                  )
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final analisis = data.analisis;

          // Si el ingreso mensual es 0, significa que el usuario es nuevo y necesita configuración
          if (analisis.ingresoMensual == 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              const InitialSetupScreen().launch(context, isNewTask: true);
            });
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() => _fetchData());
              await _dashboardFuture;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalanceCard(analisis.dineroDisponible),
                    const SizedBox(height: 24),
                    _buildRecentTransactions(analisis.transaccionesDelMes),
                  ],
                ),
              ),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showExpenseFormModal(context);
        },
        backgroundColor: WAPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showExpenseFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ExpenseFormModal(),
    ).then((_) {
      // Recargar datos al cerrar modal por si agregó algo
      setState(() => _fetchData());
    });
  }

  Widget _buildBalanceCard(double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: WAPrimaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: WAPrimaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dinero Disponible",
            style: secondaryTextStyle(color: Colors.white70, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "\$ \${balance.toStringAsFixed(2)}",
            style: boldTextStyle(color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(List<TransaccionResumen> transacciones) {
    if (transacciones.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Transacciones Recientes", style: boldTextStyle(size: 20)),
          16.height,
          const Center(child: Text("No hay transacciones este mes.")),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Transacciones Recientes",
              style: boldTextStyle(size: 20),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Ver Todo",
                style: primaryTextStyle(color: WAPrimaryColor),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        ...transacciones.map((t) => _buildTransactionItem(
          icon: Icons.receipt_long,
          title: t.descripcion,
          date: t.fecha.split('T').first,
          amount: t.monto.toStringAsFixed(2),
          isExpense: t.tipoFlujo == "EGRESO",
        )),
      ],
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required bool isExpense,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isExpense 
                  ? Colors.red.withOpacity(0.1) 
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isExpense ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: boldTextStyle(size: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: secondaryTextStyle(size: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "\${isExpense ? '-' : '+'}\$\$amount",
            style: boldTextStyle(
              size: 16,
              color: isExpense ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
